import random
import sys
import time
import mysql.connector

route_no = sys.argv[1] if len(sys.argv) > 1 else "R1"
bus_id = int(sys.argv[2]) if len(sys.argv) > 2 else 1
driver_id = int(sys.argv[3]) if len(sys.argv) > 3 else 1

STEPS = 10
PAUSE = 1.5


def connect(user, password):
    return mysql.connector.connect(
        host="localhost", database="bus_tracking", user=user, password=password
    )


admin = connect("admin1", "Admin@123")
driver = connect("driver1", "Driver@123")
acur = admin.cursor()
dcur = driver.cursor(dictionary=True)

# Admin creates a scheduled trip
acur.execute("SELECT route_id FROM Route WHERE route_no = %s", (route_no,))
route_id = acur.fetchone()[0]
acur.execute(
    "INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status) "
    "VALUES (%s, %s, %s, NOW(), 'scheduled')",
    (route_id, bus_id, driver_id),
)
admin.commit()
trip_id = acur.lastrowid
print("Created trip", trip_id)

# Driver starts it (transaction inside the procedure)
dcur.callproc("sp_start_trip", (trip_id,))
driver.commit()
print("Trip started")

dcur.execute(
    "SELECT stop_id, name, latitude, longitude FROM v_route_stops "
    "WHERE route_no = %s ORDER BY stop_seq",
    (route_no,),
)
stops = dcur.fetchall()


def ping(lat, lon):
    speed = round(random.uniform(15, 35), 1)
    dcur.execute(
        "INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph) "
        "VALUES (%s, %s, %s, %s)",
        (trip_id, lat, lon, speed),
    )
    driver.commit()
    print("ping", round(lat, 5), round(lon, 5), speed, "km/h")


delay = 0
for i, stop in enumerate(stops):
    lat = float(stop["latitude"])
    lon = float(stop["longitude"])
    if i > 0:
        prev = stops[i - 1]
        plat = float(prev["latitude"])
        plon = float(prev["longitude"])
        for step in range(1, STEPS):
            f = step / STEPS
            ping(plat + (lat - plat) * f, plon + (lon - plon) * f)
            time.sleep(PAUSE)
        delay += random.choice([0, 1, 2, 3])
    ping(lat, lon)
    dcur.callproc("sp_record_arrival", (trip_id, stop["stop_id"], delay))
    driver.commit()
    print("Arrived at", stop["name"], "| delay", delay, "min")
    time.sleep(PAUSE)

dcur.callproc("sp_end_trip", (trip_id,))
driver.commit()
print("Trip completed")
admin.close()
driver.close()