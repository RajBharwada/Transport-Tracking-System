from decimal import Decimal
from datetime import datetime
from flask import Flask, jsonify, render_template, request, session, redirect, url_for
from functools import wraps
from werkzeug.security import check_password_hash
import mysql.connector

app = Flask(__name__)

app.secret_key = "demo-secret-change-later"

DB_USERS = {
    "commuter": {"user": "commuter1", "password": "Commuter@123"},
    "driver":   {"user": "driver1",   "password": "Driver@123"},
    "admin":    {"user": "admin1",    "password": "Admin@123"},
    "auth":     {"user": "auth1",     "password": "Auth@123"},
}


def get_conn(role):
    return mysql.connector.connect(
        host="localhost", database="bus_tracking", **DB_USERS[role]
    )


def clean(row):
    out = {}
    for k, v in row.items():
        if isinstance(v, Decimal):
            out[k] = float(v)
        elif isinstance(v, datetime):
            out[k] = v.strftime("%Y-%m-%d %H:%M:%S")
        else:
            out[k] = v
    return out


def run_query(role, sql, params=()):
    conn = get_conn(role)
    try:
        cur = conn.cursor(dictionary=True)
        cur.execute(sql, params)
        return [clean(r) for r in cur.fetchall()]
    finally:
        conn.close()


def run_proc(role, name, args=()):
    conn = get_conn(role)
    try:
        cur = conn.cursor(dictionary=True)
        cur.callproc(name, args)
        rows = []
        for result in cur.stored_results():
            rows.extend(result.fetchall())
        conn.commit()
        return [clean(r) for r in rows]
    finally:
        conn.close()


def run_write(role, sql, params=()):
    conn = get_conn(role)
    try:
        cur = conn.cursor()
        cur.execute(sql, params)
        conn.commit()
    finally:
        conn.close()

def login_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if "user_id" not in session:
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return wrapper


@app.route("/login", methods=["GET", "POST"])
def login():
    error = None
    if request.method == "POST":
        rows = run_query(
            "auth",
            "SELECT user_id, username, password_hash, role, driver_id "
            "FROM Users WHERE username = %s",
            (request.form.get("username", ""),),
        )
        if rows and check_password_hash(rows[0]["password_hash"],
                                        request.form.get("password", "")):
            session["user_id"] = rows[0]["user_id"]
            session["username"] = rows[0]["username"]
            session["role"] = rows[0]["role"]
            session["driver_id"] = rows[0]["driver_id"]
            if rows[0]["role"] == "driver":
                return redirect(url_for("driver_page"))
            if rows[0]["role"] == "admin":
                return redirect(url_for("admin_page"))
            return redirect(url_for("home"))
        error = "Invalid username or password"
    return render_template("login.html", error=error)


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


@app.route("/api/live")
@login_required
def api_live():
    return jsonify(run_query("commuter", "SELECT * FROM v_live_buses"))


@app.route("/api/route/<route_no>/stops")
def api_route_stops(route_no):
    rows = run_query(
        "commuter",
        "SELECT * FROM v_route_stops WHERE route_no = %s ORDER BY stop_seq",
        (route_no,),
    )
    return jsonify(rows)


@app.route("/api/eta/<int:stop_id>")
def api_eta(stop_id):
    return jsonify(run_proc("commuter", "sp_next_buses", (stop_id,)))

@app.route("/")
@login_required
def home():
    return render_template("index.html",
                           username=session["username"], role=session["role"])


@app.route("/api/routes")
def api_routes():
    return jsonify(run_query(
        "commuter",
        "SELECT DISTINCT route_no FROM v_route_stops ORDER BY route_no"
    ))

def driver_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if session.get("role") != "driver":
            return jsonify({"error": "Drivers only"}), 403
        return f(*args, **kwargs)
    return wrapper


def own_trip(trip_id):
    rows = run_query(
        "driver",
        "SELECT trip_id, status FROM v_driver_trips "
        "WHERE trip_id = %s AND driver_id = %s",
        (trip_id, session.get("driver_id")),
    )
    return rows[0] if rows else None


def driver_action(fn):
    data = request.get_json(force=True)
    try:
        trip_id = int(data.get("trip_id", 0))
        if not own_trip(trip_id):
            return jsonify({"error": "Trip not found for this driver"}), 404
        return jsonify({"message": fn(data, trip_id)})
    except mysql.connector.Error as e:
        return jsonify({"error": e.msg}), 400
    except (KeyError, ValueError):
        return jsonify({"error": "Invalid input"}), 400


@app.route("/driver")
def driver_page():
    if "user_id" not in session:
        return redirect(url_for("login"))
    if session["role"] != "driver":
        return redirect(url_for("home"))
    return render_template("driver.html", username=session["username"])


@app.route("/api/driver/trips")
@driver_required
def api_driver_trips():
    return jsonify(run_query(
        "driver",
        "SELECT trip_id, route_no, route_name, reg_no, status "
        "FROM v_driver_trips WHERE driver_id = %s ORDER BY trip_id",
        (session["driver_id"],),
    ))


@app.route("/api/driver/start", methods=["POST"])
@driver_required
def api_driver_start():
    def go(d, t):
        run_proc("driver", "sp_start_trip", (t,))
        return "Trip %d started" % t
    return driver_action(go)


@app.route("/api/driver/end", methods=["POST"])
@driver_required
def api_driver_end():
    def go(d, t):
        run_proc("driver", "sp_end_trip", (t,))
        return "Trip %d completed" % t
    return driver_action(go)


@app.route("/api/driver/ping", methods=["POST"])
@driver_required
def api_driver_ping():
    def go(d, t):
        run_write(
            "driver",
            "INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph) "
            "VALUES (%s, %s, %s, %s)",
            (t, float(d["lat"]), float(d["lon"]), float(d.get("speed", 0))),
        )
        return "Ping sent"
    return driver_action(go)


@app.route("/api/driver/arrive", methods=["POST"])
@driver_required
def api_driver_arrive():
    def go(d, t):
        run_proc("driver", "sp_record_arrival",
                 (t, int(d["stop_id"]), int(d.get("delay", 0))))
        return "Arrival recorded"
    return driver_action(go)

def admin_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if session.get("role") != "admin":
            return jsonify({"error": "Admins only"}), 403
        return f(*args, **kwargs)
    return wrapper


def admin_action(fn):
    data = request.get_json(force=True)
    try:
        return jsonify({"message": fn(data)})
    except mysql.connector.Error as e:
        return jsonify({"error": e.msg}), 400
    except (KeyError, ValueError, TypeError):
        return jsonify({"error": "Invalid input"}), 400


@app.route("/admin")
def admin_page():
    if "user_id" not in session:
        return redirect(url_for("login"))
    if session["role"] == "driver":
        return redirect(url_for("driver_page"))
    if session["role"] != "admin":
        return redirect(url_for("home"))
    return render_template("admin.html", username=session["username"])


@app.route("/api/admin/overview")
@admin_required
def api_admin_overview():
    return jsonify({
        "buses": run_query(
            "admin", "SELECT bus_id, reg_no, capacity, status FROM Bus ORDER BY bus_id"),
        "drivers": run_query(
            "admin", "SELECT driver_id, name, phone, license_no FROM Driver ORDER BY driver_id"),
        "trips": run_query(
            "admin",
            "SELECT t.trip_id, r.route_no, b.reg_no, d.name AS driver_name, t.status "
            "FROM Trip t JOIN Route r ON r.route_id = t.route_id "
            "JOIN Bus b ON b.bus_id = t.bus_id "
            "JOIN Driver d ON d.driver_id = t.driver_id "
            "ORDER BY t.trip_id DESC LIMIT 10"),
        "report": run_query("admin", "SELECT * FROM v_delay_report"),
        "alerts": run_query(
            "admin",
            "SELECT da.alert_id, r.route_no, b.reg_no, s.name AS stop_name, "
            "da.delay_min, da.created_at "
            "FROM Delay_Alert da "
            "JOIN Stop_Arrival sa ON sa.arrival_id = da.arrival_id "
            "JOIN Trip t ON t.trip_id = sa.trip_id "
            "JOIN Route r ON r.route_id = t.route_id "
            "JOIN Bus b ON b.bus_id = t.bus_id "
            "JOIN Stop s ON s.stop_id = sa.stop_id "
            "ORDER BY da.alert_id DESC LIMIT 10"),
    })


@app.route("/api/admin/bus", methods=["POST"])
@admin_required
def api_admin_add_bus():
    def go(d):
        run_write(
            "admin",
            "INSERT INTO Bus (reg_no, capacity, status) VALUES (%s, %s, %s)",
            (d["reg_no"], int(d["capacity"]), d.get("status", "active")),
        )
        return "Bus added"
    return admin_action(go)


@app.route("/api/admin/driver", methods=["POST"])
@admin_required
def api_admin_add_driver():
    def go(d):
        run_write(
            "admin",
            "INSERT INTO Driver (name, phone, license_no) VALUES (%s, %s, %s)",
            (d["name"], d["phone"], d["license_no"]),
        )
        return "Driver added"
    return admin_action(go)


@app.route("/api/admin/trip", methods=["POST"])
@admin_required
def api_admin_add_trip():
    def go(d):
        rows = run_query(
            "admin", "SELECT route_id FROM Route WHERE route_no = %s", (d["route_no"],))
        if not rows:
            raise ValueError("No such route")
        run_write(
            "admin",
            "INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status) "
            "VALUES (%s, %s, %s, NOW(), 'scheduled')",
            (rows[0]["route_id"], int(d["bus_id"]), int(d["driver_id"])),
        )
        return "Trip scheduled"
    return admin_action(go)


@app.route("/api/admin/bus/status", methods=["POST"])
@admin_required
def api_admin_bus_status():
    def go(d):
        run_write(
            "admin",
            "UPDATE Bus SET status = %s WHERE bus_id = %s",
            (d["status"], int(d["bus_id"])),
        )
        return "Bus status updated"
    return admin_action(go)


@app.route("/api/admin/bus/delete", methods=["POST"])
@admin_required
def api_admin_bus_delete():
    def go(d):
        run_write("admin", "DELETE FROM Bus WHERE bus_id = %s", (int(d["bus_id"]),))
        return "Bus deleted"
    return admin_action(go)

if __name__ == "__main__":
    app.run(debug=True)