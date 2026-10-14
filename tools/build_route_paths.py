"""Build road-following paths for every route and save them as static/routes/<route_no>.json.

Run once on a machine with internet (and again if stops change):
    python tools/build_route_paths.py

It reads the ordered stops from the v_route_stops view, asks the public OSRM
routing service for the driving path through them, and writes [lat, lon] points.
The map page loads these files first, so it works without calling OSRM at runtime.
The database is not changed.
"""
import json
import os
import urllib.request

import mysql.connector

OSRM = "https://router.project-osrm.org/route/v1/driving/{coords}?overview=full&geometries=geojson"
OUT = os.path.join(os.path.dirname(__file__), "..", "static", "routes")

conn = mysql.connector.connect(
    host="localhost", database="bus_tracking", user="commuter1", password="Commuter@123"
)
cur = conn.cursor(dictionary=True)
cur.execute("SELECT DISTINCT route_no FROM v_route_stops ORDER BY route_no")
routes = [r["route_no"] for r in cur.fetchall()]

os.makedirs(OUT, exist_ok=True)
for route_no in routes:
    cur.execute(
        "SELECT latitude, longitude FROM v_route_stops WHERE route_no = %s ORDER BY stop_seq",
        (route_no,),
    )
    stops = cur.fetchall()
    coords = ";".join("%s,%s" % (s["longitude"], s["latitude"]) for s in stops)
    req = urllib.request.Request(OSRM.format(coords=coords), headers={"User-Agent": "bus-tracker-demo"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.load(resp)
    if data.get("code") != "Ok":
        raise SystemExit("OSRM failed for %s: %s" % (route_no, data.get("code")))
    path = [[round(lat, 6), round(lon, 6)] for lon, lat in data["routes"][0]["geometry"]["coordinates"]]
    with open(os.path.join(OUT, route_no + ".json"), "w") as f:
        json.dump(path, f, separators=(",", ":"))
    print("%s: %d stops -> %d path points" % (route_no, len(stops), len(path)))
conn.close()
