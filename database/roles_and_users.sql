-- Run as MySQL root AFTER restoring bus_tracking_backup.sql.
-- Views, procedures and triggers in the dump are defined by `ghostadmin`@`%`,
-- so that account must exist or every view/procedure call fails with error 1045.
CREATE USER IF NOT EXISTS 'ghostadmin'@'%' IDENTIFIED BY 'Ghost@Admin123';
GRANT ALL PRIVILEGES ON bus_tracking.* TO 'ghostadmin'@'%';

CREATE ROLE IF NOT EXISTS bus_admin, bus_driver, bus_commuter, bus_auth;

GRANT ALL PRIVILEGES ON bus_tracking.* TO bus_admin;

GRANT SELECT ON bus_tracking.v_live_buses   TO bus_driver, bus_commuter;
GRANT SELECT ON bus_tracking.v_route_stops  TO bus_driver, bus_commuter;
GRANT SELECT ON bus_tracking.v_driver_trips TO bus_driver;
GRANT INSERT ON bus_tracking.GPS_Log        TO bus_driver;
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_start_trip     TO bus_driver;
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_end_trip       TO bus_driver;
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_record_arrival TO bus_driver;
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_next_buses     TO bus_driver, bus_commuter;
GRANT SELECT ON bus_tracking.Users TO bus_auth;

-- Demo-only passwords (the same ones are in app.py). Change them for any real use.
CREATE USER IF NOT EXISTS 'admin1'@'localhost'    IDENTIFIED BY 'Admin@123';
CREATE USER IF NOT EXISTS 'driver1'@'localhost'   IDENTIFIED BY 'Driver@123';
CREATE USER IF NOT EXISTS 'commuter1'@'localhost' IDENTIFIED BY 'Commuter@123';
CREATE USER IF NOT EXISTS 'auth1'@'localhost'     IDENTIFIED BY 'Auth@123';
GRANT bus_admin    TO 'admin1'@'localhost';
GRANT bus_driver   TO 'driver1'@'localhost';
GRANT bus_commuter TO 'commuter1'@'localhost';
GRANT bus_auth     TO 'auth1'@'localhost';
SET DEFAULT ROLE ALL TO 'admin1'@'localhost', 'driver1'@'localhost',
                        'commuter1'@'localhost', 'auth1'@'localhost';
