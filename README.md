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
- `app.py`, `templates/`, `simulator.py` - web app and GPS simulator
- `database/bus_tracking_backup.sql` - schema, data, views, procedures, triggers (mysqldump)
- `database/roles_and_users.sql` - roles, per-role MySQL accounts and the `ghostadmin` definer account
- `docs/` - project report (.docx) and ER / schema / architecture / flow diagrams

## Run
```bash
sudo mysql -e "CREATE DATABASE bus_tracking CHARACTER SET utf8mb4"
sudo mysql bus_tracking < database/bus_tracking_backup.sql
sudo mysql < database/roles_and_users.sql

python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python app.py            # http://127.0.0.1:5000
python simulator.py      # optional: simulates a bus sending positions
```
Demo logins: `admin/admin123`, `rajesh/driver123`, `sunita/driver123`, `commuter/commuter123`.

## Notes
- Credentials and the Flask secret key in `app.py` are demo values (listed as a limitation in the report).
- Routes and stops are loaded by SQL only; there is no admin screen for them.
