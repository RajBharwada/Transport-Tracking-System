# Real-Time Public Transport Tracking System for Small Cities

DBMS mini project, Xavier Institute of Engineering (Mumbai University, autonomous),
based on Smart India Hackathon 2025 problem statement SIH25013.
Mumbai is the demo city; the schema itself is city-independent.

Authors: Raj Bharwada (Roll No. 13), Shaantanu Barao (Roll No. 8)
Guide: Prof. Lalita Moharkar

## What it is
A MySQL 8.0 database (11 tables in BCNF/3NF, 5 triggers, 4 views, 4 stored procedures,
role-based accounts) with a light Flask + Leaflet/OpenStreetMap web app:
live bus map (5 s refresh), driver console, admin console with delay report,
and a GPS simulator.

## Layout
- `database/bus_tracking_full.sql` - the whole database in one commented file: tables, seed data,
  triggers, views, procedures, roles/accounts, application logins and optional test cases
- `database/demo_data.sql` - optional extra Mumbai data for demos (routes R3-R6, drivers, buses)
- `app.py`, `templates/`, `static/` - Flask web app (map, driver console, admin console)
- `simulator.py` - GPS simulator for a running bus
- `tools/build_route_paths.py` - saves road-following paths for the map (needs internet once)

## Run
```bash
sudo mysql < database/bus_tracking_full.sql      # builds everything (drops nothing)

python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python app.py            # http://127.0.0.1:5000
python simulator.py      # optional: simulates a bus sending positions
```
To rebuild from scratch first run `sudo mysql -e "DROP DATABASE IF EXISTS bus_tracking;"`.
Demo logins: `admin/admin123`, `rajesh/driver123`, `sunita/driver123`, `commuter/commuter123`.

## Notes
- Credentials and the Flask secret key in `app.py` are demo values (listed as a limitation in the report).
- Routes and stops are loaded by SQL only; there is no admin screen for them.

## Demo data
`database/demo_data.sql` adds more Mumbai routes (R3-R6), stops, buses, drivers (logins `anil`, `meera`,
`farhan`, `pooja`, `sandeep`, `kavita`, password `driver123`), two completed trips per route from yesterday
(with delays and alerts) and one scheduled trip per driver for today.
```bash
sudo mysqldump --routines --triggers bus_tracking > before_demo.sql   # backup first
sudo mysql bus_tracking < database/demo_data.sql
python tools/build_route_paths.py                                     # road paths for the new routes
```
Start several buses at once by running the simulator in separate terminals, for example
`python simulator.py R3 5 5` (route, bus id, driver id; ids are shown on the admin console).
