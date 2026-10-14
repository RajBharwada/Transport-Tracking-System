-- 1. DATABASE 
CREATE DATABASE IF NOT EXISTS bus_tracking;
USE bus_tracking;


/* 
  2. TABLES
  Creation order follows the foreign keys: parents first, children after.
*/

-- City: the cities served by the system (the demo uses only Mumbai).
CREATE TABLE City (
  city_id INT AUTO_INCREMENT PRIMARY KEY,
  name    VARCHAR(80) NOT NULL,
  state   VARCHAR(80) NOT NULL,
  UNIQUE (name, state)                          -- same city cannot be added twice
);

-- Route: a named bus line (R1, R2 ...) belonging to one city.
CREATE TABLE Route (
  route_id INT AUTO_INCREMENT PRIMARY KEY,
  route_no VARCHAR(10)  NOT NULL UNIQUE,        -- e.g. 'R1'
  name     VARCHAR(120) NOT NULL,
  city_id  INT NOT NULL,
  FOREIGN KEY (city_id) REFERENCES City(city_id) ON DELETE RESTRICT
);

-- Bus Stop
CREATE TABLE Stop (
  stop_id   INT AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(100) NOT NULL,
  latitude  DECIMAL(9,6) NOT NULL,
  longitude DECIMAL(9,6) NOT NULL,
  city_id   INT NOT NULL,
  CHECK (latitude  BETWEEN -90  AND 90),        -- valid GPS range
  CHECK (longitude BETWEEN -180 AND 180),
  FOREIGN KEY (city_id) REFERENCES City(city_id) ON DELETE RESTRICT
);

-- Route_Stop: resolves the many-to-many link between Route and Stop.
-- stop_seq gives the order of stops; sched_offset_min is the planned number
-- of minutes after the trip starts at which the bus should reach that stop.
CREATE TABLE Route_Stop (
  route_id         INT NOT NULL,
  stop_id          INT NOT NULL,
  stop_seq         INT NOT NULL,
  sched_offset_min INT NOT NULL DEFAULT 0,
  PRIMARY KEY (route_id, stop_seq),             -- one stop per position
  UNIQUE (route_id, stop_id),                   -- a stop appears once per route
  CHECK (stop_seq > 0),
  CHECK (sched_offset_min >= 0),
  FOREIGN KEY (route_id) REFERENCES Route(route_id) ON DELETE CASCADE,
  FOREIGN KEY (stop_id)  REFERENCES Stop(stop_id)   ON DELETE RESTRICT
);

-- Driver
CREATE TABLE Driver (
  driver_id  INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  phone      VARCHAR(15)  NOT NULL UNIQUE,
  license_no VARCHAR(20)  NOT NULL UNIQUE
);

-- Bus: Only 'active' buses may be put on a trip 
CREATE TABLE Bus (
  bus_id   INT AUTO_INCREMENT PRIMARY KEY,
  reg_no   VARCHAR(15) NOT NULL UNIQUE,        
  capacity INT NOT NULL,
  status   ENUM('active','maintenance','retired') NOT NULL DEFAULT 'active',
  CHECK (capacity > 0)
);

-- Trip: one run of a bus, by a driver, on a route.
-- Life cycle: scheduled -> running -> completed (or cancelled).
CREATE TABLE Trip (
  trip_id    INT AUTO_INCREMENT PRIMARY KEY,
  route_id   INT NOT NULL,
  bus_id     INT NOT NULL,
  driver_id  INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time   DATETIME NULL,                     -- NULL until the trip ends
  status     ENUM('scheduled','running','completed','cancelled') NOT NULL DEFAULT 'scheduled',
  CHECK (end_time IS NULL OR end_time >= start_time),
  FOREIGN KEY (route_id)  REFERENCES Route(route_id)   ON DELETE RESTRICT,
  FOREIGN KEY (bus_id)    REFERENCES Bus(bus_id)       ON DELETE RESTRICT,
  FOREIGN KEY (driver_id) REFERENCES Driver(driver_id) ON DELETE RESTRICT
);

-- GPS_Log: location pings sent by the driver's device during a trip.
CREATE TABLE GPS_Log (
  log_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
  trip_id    INT NOT NULL,
  latitude   DECIMAL(9,6) NOT NULL,
  longitude  DECIMAL(9,6) NOT NULL,
  speed_kmph DECIMAL(5,2) NOT NULL DEFAULT 0,
  logged_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (latitude  BETWEEN -90  AND 90),
  CHECK (longitude BETWEEN -180 AND 180),
  CHECK (speed_kmph >= 0),
  FOREIGN KEY (trip_id) REFERENCES Trip(trip_id) ON DELETE CASCADE,
  INDEX idx_gps_trip_time (trip_id, logged_at)
);

-- Stop_Arrival: planned vs actual arrival of a trip at each stop.
-- delay_min is filled automatically by a trigger when actual_time is set.
CREATE TABLE Stop_Arrival (
  arrival_id     INT AUTO_INCREMENT PRIMARY KEY,
  trip_id        INT NOT NULL,
  stop_id        INT NOT NULL,
  scheduled_time DATETIME NOT NULL,
  actual_time    DATETIME NULL,                 -- NULL = bus has not reached the stop yet
  delay_min      INT NULL,
  UNIQUE (trip_id, stop_id),                    -- one arrival record per stop per trip
  FOREIGN KEY (trip_id) REFERENCES Trip(trip_id) ON DELETE CASCADE,
  FOREIGN KEY (stop_id) REFERENCES Stop(stop_id) ON DELETE RESTRICT
);

-- Delay_Alert: one alert row for each arrival that was 5 or more minutes late.
-- Created automatically by a trigger; arrival_id is UNIQUE so there is never
-- more than one alert per arrival.
CREATE TABLE Delay_Alert (
  alert_id   INT AUTO_INCREMENT PRIMARY KEY,
  arrival_id INT NOT NULL UNIQUE,
  delay_min  INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (delay_min > 0),
  FOREIGN KEY (arrival_id) REFERENCES Stop_Arrival(arrival_id) ON DELETE CASCADE
);

-- Users
-- A driver login is linked to its Driver row through driver_id.
CREATE TABLE Users (
  user_id       INT AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(50)  NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role          ENUM('admin','driver','commuter') NOT NULL,
  driver_id     INT NULL UNIQUE,
  FOREIGN KEY (driver_id) REFERENCES Driver(driver_id) ON DELETE SET NULL
);

SHOW TABLES;


/*
  3. SEED DATA  (Mumbai demo city)
*/

INSERT INTO City (city_id, name, state) VALUES
(1, 'Mumbai', 'Maharashtra');

INSERT INTO Stop (stop_id, name, latitude, longitude, city_id) VALUES
(1, 'Dadar Station',                   19.017800, 72.843300, 1),
(2, 'Shivaji Park',                    19.028600, 72.837800, 1),
(3, 'Mahim Causeway',                  19.040700, 72.841000, 1),
(4, 'Xavier Institute of Engineering', 19.042000, 72.840000, 1),
(5, 'Bandra Station',                  19.054400, 72.840900, 1),
(6, 'Sion Hospital',                   19.034400, 72.861600, 1),
(7, 'Bandra Kurla Complex',            19.068000, 72.870000, 1);

INSERT INTO Route (route_id, route_no, name, city_id) VALUES
(1, 'R1', 'Dadar Station - Bandra Station',        1),
(2, 'R2', 'Sion Hospital - Bandra Kurla Complex',  1);

INSERT INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min) VALUES
(1, 1, 1,  0),    -- R1: Dadar -> Shivaji Park -> Mahim -> Xavier -> Bandra
(1, 2, 2,  6),
(1, 3, 3, 11),
(1, 4, 4, 16),
(1, 5, 5, 22),

(2, 6, 1,  0),    -- R2: Sion -> Dadar -> Mahim -> Bandra -> BKC
(2, 1, 2, 10),
(2, 3, 3, 18),
(2, 5, 4, 26),
(2, 7, 5, 38);

INSERT INTO Driver (driver_id, name, phone, license_no) VALUES
(1, 'Rajesh Patil',  '9876500001', 'MH0120200001'),
(2, 'Sunita Shinde', '9876500002', 'MH0120200002'),
(3, 'Imran Shaikh',  '9876500003', 'MH0120200003'),
(4, 'Vikas Jadhav',  '9876500004', 'MH0120200004');

INSERT INTO Bus (bus_id, reg_no, capacity, status) VALUES
(1, 'MH01AB1001', 40, 'active'),
(2, 'MH01AB1002', 40, 'active'),
(3, 'MH01AB1003', 35, 'active'),
(4, 'MH01AB1004', 35, 'maintenance');         -- not allowed on trips

-- Check: every route with its stops in order.
SELECT r.route_no, rs.stop_seq, s.name, rs.sched_offset_min
FROM Route_Stop rs
JOIN Route r ON r.route_id = rs.route_id
JOIN Stop  s ON s.stop_id  = rs.stop_id
ORDER BY r.route_no, rs.stop_seq;


/*
  4. TRIGGERS
*/
DELIMITER $$

-- Rule 1 (on INSERT): a scheduled/running trip needs an ACTIVE bus; a RUNNING
-- trip additionally needs a bus and a driver that are not already running.
CREATE TRIGGER trg_trip_before_insert
BEFORE INSERT ON Trip
FOR EACH ROW
BEGIN
  IF NEW.status IN ('scheduled','running') THEN
    IF (SELECT status FROM Bus WHERE bus_id = NEW.bus_id) <> 'active' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trip rejected: bus is not active';
    END IF;
  END IF;
  IF NEW.status = 'running' THEN
    IF EXISTS (SELECT 1 FROM Trip WHERE bus_id = NEW.bus_id AND status = 'running') THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trip rejected: bus is already on a running trip';
    END IF;
    IF EXISTS (SELECT 1 FROM Trip WHERE driver_id = NEW.driver_id AND status = 'running') THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trip rejected: driver is already on a running trip';
    END IF;
  END IF;
END$$

-- Rule 1 (on UPDATE): same checks when an existing trip changes status.
-- "trip_id <> NEW.trip_id" stops a trip from clashing with itself.
CREATE TRIGGER trg_trip_before_update
BEFORE UPDATE ON Trip
FOR EACH ROW
BEGIN
  IF NEW.status IN ('scheduled','running') THEN
    IF (SELECT status FROM Bus WHERE bus_id = NEW.bus_id) <> 'active' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trip rejected: bus is not active';
    END IF;
  END IF;
  IF NEW.status = 'running' THEN
    IF EXISTS (SELECT 1 FROM Trip
               WHERE bus_id = NEW.bus_id AND status = 'running' AND trip_id <> NEW.trip_id) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trip rejected: bus is already on a running trip';
    END IF;
    IF EXISTS (SELECT 1 FROM Trip
               WHERE driver_id = NEW.driver_id AND status = 'running' AND trip_id <> NEW.trip_id) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trip rejected: driver is already on a running trip';
    END IF;
  END IF;
END$$

-- Rule 2: GPS pings are accepted only for a trip that is currently running.
CREATE TRIGGER trg_gps_before_insert
BEFORE INSERT ON GPS_Log
FOR EACH ROW
BEGIN
  IF (SELECT status FROM Trip WHERE trip_id = NEW.trip_id) <> 'running' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'GPS ping rejected: trip is not running';
  END IF;
END$$

-- Rule 3: delay is derived. When actual_time is recorded the
-- delay (in minutes) is calculated from the scheduled time.
CREATE TRIGGER trg_arrival_before_update
BEFORE UPDATE ON Stop_Arrival
FOR EACH ROW
BEGIN
  IF NEW.actual_time IS NOT NULL THEN
    SET NEW.delay_min = TIMESTAMPDIFF(MINUTE, NEW.scheduled_time, NEW.actual_time);
  END IF;
END$$

-- Rule 4: a delay of 5 minutes or more raises (or refreshes) a Delay_Alert.
CREATE TRIGGER trg_arrival_after_update
AFTER UPDATE ON Stop_Arrival
FOR EACH ROW
BEGIN
  IF NEW.delay_min IS NOT NULL AND NEW.delay_min >= 5 THEN
    INSERT INTO Delay_Alert (arrival_id, delay_min)
    VALUES (NEW.arrival_id, NEW.delay_min)
    ON DUPLICATE KEY UPDATE delay_min = NEW.delay_min;
  END IF;
END$$

DELIMITER ;

SHOW TRIGGERS FROM bus_tracking;


/*
  5. VIEWS
  This is what commuters and drivers are allowed to read.
*/

-- v_live_buses: the latest GPS position of every RUNNING trip (map data).
-- The sub-query picks the newest log row (highest log_id) for each trip.
CREATE VIEW v_live_buses AS
SELECT t.trip_id, b.reg_no, r.route_no, r.name AS route_name,
       d.name AS driver_name, g.latitude, g.longitude,
       g.speed_kmph, g.logged_at
FROM Trip t
JOIN Bus b    ON b.bus_id    = t.bus_id
JOIN Route r  ON r.route_id  = t.route_id
JOIN Driver d ON d.driver_id = t.driver_id
JOIN GPS_Log g ON g.trip_id  = t.trip_id
WHERE t.status = 'running'
  AND g.log_id = (SELECT MAX(g2.log_id) FROM GPS_Log g2 WHERE g2.trip_id = t.trip_id);

-- v_delay_report
-- (arrivals recorded, average delay, worst delay, alerts raised).
CREATE VIEW v_delay_report AS
SELECT r.route_no,
       COUNT(sa.arrival_id)       AS arrivals_recorded,
       ROUND(AVG(sa.delay_min),1) AS avg_delay_min,
       MAX(sa.delay_min)          AS max_delay_min,
       COUNT(da.alert_id)         AS alerts_raised
FROM Route r
JOIN Trip t          ON t.route_id = r.route_id
JOIN Stop_Arrival sa ON sa.trip_id = t.trip_id AND sa.actual_time IS NOT NULL
LEFT JOIN Delay_Alert da ON da.arrival_id = sa.arrival_id
GROUP BY r.route_id, r.route_no;

-- v_route_stops
CREATE VIEW v_route_stops AS
SELECT r.route_no, rs.stop_seq, s.stop_id, s.name,
       s.latitude, s.longitude, rs.sched_offset_min
FROM Route_Stop rs
JOIN Route r ON r.route_id = rs.route_id
JOIN Stop  s ON s.stop_id  = rs.stop_id;

-- v_driver_trips
-- Feeds the trip drop-down on the driver console.
CREATE VIEW v_driver_trips AS
SELECT t.trip_id, t.driver_id, r.route_no, r.name AS route_name,
       b.reg_no, t.status, t.start_time
FROM Trip t
JOIN Route r ON r.route_id = t.route_id
JOIN Bus b   ON b.bus_id   = t.bus_id
WHERE t.status IN ('scheduled','running');


/*
  6. STORED PROCEDURES
*/
DELIMITER $$

-- sp_next_buses(stop): upcoming buses for one stop (the commuter's question
-- "when is my bus coming?").
-- ETA = trip start + planned offset of this stop + delay seen at the bus's
-- most recent recorded stop. Only RUNNING trips that have not yet passed the
-- stop are listed, soonest first.
CREATE PROCEDURE sp_next_buses(IN p_stop_id INT)
BEGIN
  SELECT r.route_no,
         b.reg_no,
         COALESCE(ld.delay_min, 0) AS current_delay_min,
         t.start_time + INTERVAL (rs.sched_offset_min + COALESCE(ld.delay_min, 0)) MINUTE AS eta,
         TIMESTAMPDIFF(MINUTE, NOW(),
           t.start_time + INTERVAL (rs.sched_offset_min + COALESCE(ld.delay_min, 0)) MINUTE) AS minutes_away
  FROM Trip t
  JOIN Route r       ON r.route_id = t.route_id
  JOIN Bus b         ON b.bus_id   = t.bus_id
  JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = p_stop_id
  -- "done" finds an arrival already recorded at this stop (bus has passed it)
  LEFT JOIN Stop_Arrival done
         ON done.trip_id = t.trip_id AND done.stop_id = p_stop_id AND done.actual_time IS NOT NULL
  -- "ld" = latest known delay of each trip (from its newest recorded arrival)
  LEFT JOIN (
        SELECT sa.trip_id, sa.delay_min
        FROM Stop_Arrival sa
        WHERE sa.actual_time IS NOT NULL
          AND sa.actual_time = (SELECT MAX(x.actual_time) FROM Stop_Arrival x
                                WHERE x.trip_id = sa.trip_id AND x.actual_time IS NOT NULL)
  ) ld ON ld.trip_id = t.trip_id
  WHERE t.status = 'running'
    AND done.arrival_id IS NULL                 -- bus has not passed this stop yet
  ORDER BY eta;
END$$

-- sp_start_trip(trip): moves a SCHEDULED trip to RUNNING and creates one
-- Stop_Arrival row per stop of the route (scheduled time = now + offset).
-- Runs as one transaction
CREATE PROCEDURE sp_start_trip(IN p_trip_id INT)
BEGIN
  DECLARE v_status VARCHAR(20);
  DECLARE v_route  INT;
  DECLARE v_start  DATETIME;

  -- On any error: undo the transaction and re-raise the error to the caller.
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

  -- FOR UPDATE locks the trip row so two users cannot start it at once.
  SELECT status, route_id INTO v_status, v_route
  FROM Trip WHERE trip_id = p_trip_id FOR UPDATE;

  IF v_status IS NULL OR v_status <> 'scheduled' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot start: trip not found or not in scheduled state';
  END IF;

  SET v_start = NOW();

  INSERT INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
  SELECT p_trip_id, rs.stop_id, v_start + INTERVAL rs.sched_offset_min MINUTE
  FROM Route_Stop rs
  WHERE rs.route_id = v_route;

  UPDATE Trip SET status = 'running', start_time = v_start
  WHERE trip_id = p_trip_id;

  COMMIT;
END$$

-- sp_end_trip(trip): moves a RUNNING trip to COMPLETED, stamps end_time and
-- removes arrival rows for stops the bus never reached.
CREATE PROCEDURE sp_end_trip(IN p_trip_id INT)
BEGIN
  DECLARE v_status VARCHAR(20);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT status INTO v_status
  FROM Trip WHERE trip_id = p_trip_id FOR UPDATE;

  IF v_status IS NULL OR v_status <> 'running' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot end: trip not found or not running';
  END IF;

  DELETE FROM Stop_Arrival
  WHERE trip_id = p_trip_id AND actual_time IS NULL;

  UPDATE Trip SET status = 'completed', end_time = NOW()
  WHERE trip_id = p_trip_id;

  COMMIT;
END$$

-- sp_record_arrival(trip, stop, delay): the driver reports reaching a stop.
-- actual_time = scheduled_time + delay. The BEFORE UPDATE trigger then fills
-- delay_min and the AFTER UPDATE trigger raises an alert when delay >= 5.
CREATE PROCEDURE sp_record_arrival(
  IN p_trip_id INT, IN p_stop_id INT, IN p_delay_min INT)
BEGIN
  IF (SELECT status FROM Trip WHERE trip_id = p_trip_id) <> 'running' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Arrival rejected: trip is not running';
  END IF;

  UPDATE Stop_Arrival
  SET actual_time = scheduled_time + INTERVAL p_delay_min MINUTE
  WHERE trip_id = p_trip_id AND stop_id = p_stop_id AND actual_time IS NULL;

  -- Nothing updated => the stop is not on this trip or was already recorded.
  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Arrival rejected: stop not expected or already recorded';
  END IF;
END$$

DELIMITER ;


/*
  7. ROLES, ACCOUNTS AND PRIVILEGES  (least privilege)
  Four roles; each demo account gets exactly one role.
    bus_admin    - full control of the bus_tracking database
    bus_driver   - read live data, send GPS, start/end trips, record arrivals
    bus_commuter - read-only: live buses, route stops, next-bus lookup
    bus_auth     - may only read Users (used by the login page)
*/

CREATE ROLE IF NOT EXISTS 'bus_admin', 'bus_driver', 'bus_commuter', 'bus_auth';

-- Admin: everything in this database.
GRANT ALL PRIVILEGES ON bus_tracking.* TO 'bus_admin';

-- Commuter: views + the next-bus procedure only. No table access at all.
GRANT SELECT ON bus_tracking.v_live_buses TO 'bus_commuter';
GRANT SELECT ON bus_tracking.v_route_stops TO 'bus_commuter';
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_next_buses TO 'bus_commuter';

-- Driver: can only INSERT into GPS_Log (never read/modify other tables
-- directly) and operates trips through procedures.
GRANT SELECT ON bus_tracking.v_live_buses TO 'bus_driver';
GRANT SELECT ON bus_tracking.v_route_stops TO 'bus_driver';
GRANT SELECT ON bus_tracking.v_driver_trips TO 'bus_driver';
GRANT INSERT ON bus_tracking.GPS_Log TO 'bus_driver';
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_start_trip TO 'bus_driver';
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_end_trip TO 'bus_driver';
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_record_arrival TO 'bus_driver';
GRANT EXECUTE ON PROCEDURE bus_tracking.sp_next_buses TO 'bus_driver';

-- Auth: the login page may read the Users table, nothing else.
GRANT SELECT ON bus_tracking.Users TO 'bus_auth';

-- One demo account per role.
CREATE USER IF NOT EXISTS 'admin1'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER IF NOT EXISTS 'driver1'@'localhost' IDENTIFIED BY 'Driver@123';
CREATE USER IF NOT EXISTS 'commuter1'@'localhost' IDENTIFIED BY 'Commuter@123';
CREATE USER IF NOT EXISTS 'auth1'@'localhost' IDENTIFIED BY 'Auth@123';

GRANT 'bus_admin' TO 'admin1'@'localhost';
GRANT 'bus_driver' TO 'driver1'@'localhost';
GRANT 'bus_commuter' TO 'commuter1'@'localhost';
GRANT 'bus_auth' TO 'auth1'@'localhost';

SET DEFAULT ROLE ALL TO 'admin1'@'localhost', 'driver1'@'localhost',
                        'commuter1'@'localhost', 'auth1'@'localhost';

SHOW GRANTS FOR 'commuter1'@'localhost' USING 'bus_commuter';

-- Privilege demo: REVOKE removes a privilege, GRANT gives it back.
REVOKE INSERT ON bus_tracking.GPS_Log FROM 'bus_driver';
GRANT  INSERT ON bus_tracking.GPS_Log TO   'bus_driver';
SHOW GRANTS FOR 'bus_driver';





































































































































































































































































/* ============================================================================
   7b. APPLICATION LOGINS  (Users table, used by the Flask login page)
   Passwords are stored as scrypt hashes, never as plain text.
   Demo passwords: admin -> admin123, drivers -> driver123, commuter -> commuter123.
   driver_id links a driver login to its Driver row (1-4 above).
   ============================================================================ */
INSERT INTO Users (username, password_hash, role, driver_id) VALUES
('admin', 'scrypt:32768:8:1$fAhLZIbXOVaGVR8e$eb2a283cb7b516ddcb181659bc66ac6ddbead5550c75a39222263f9e4e8cb0fc38cb825d36777e0c0648e198623af8e4a08821f9329e9cd353381c46e96ffa9c', 'admin', NULL),
('rajesh', 'scrypt:32768:8:1$e4OmXv8ulr8QSsF1$a0fe2ae64f42f3d06afa4cabba29dc06fa38506bfdca0bffec8004d12c3dc4f84f3c8f57f05b34ca232ae9143d0e1d3e4a61329dbc4f5307c9ffeb9d4fb4f13f', 'driver', 1),
('sunita', 'scrypt:32768:8:1$UBN3jaSwDDwlLH1o$62af4bf74c05b1241abe71df42e03175794d0dcb9a3bb94dfb759392737c1e47ad4f4618469358c10e714724362bb164853f09bb46d764a1bdde21bee40ab2be', 'driver', 2),
('commuter', 'scrypt:32768:8:1$9bfkOmUGEbVhzH42$dbfd36794693a1752de1e9604cc9bd9916e7e3fd3e686637b72da1a70896cd7490f0b5cf517d6fc051515edcb277a8aae357b22e39509cc1969e5a0b74d3665e', 'commuter', NULL);


/* ============================================================================
   8. SAMPLE ACTIVITY AND REPORTS
   Creates a few trips, runs the procedures, and shows the views, exactly as
   used for the report screenshots. Safe to run once on a fresh database.
   ============================================================================ */

-- Two running trips (R1 and R2) and one scheduled trip.
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, status) VALUES
(1, 1, 1, 1, NOW(), 'running'),
(2, 2, 2, 2, NOW(), 'running'),
(3, 1, 3, 3, NOW(), 'scheduled');

-- Two GPS pings for trip 1 (Dadar, then Shivaji Park).
INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph) VALUES
(1, 19.017800, 72.843300, 0),
(1, 19.028600, 72.837800, 24.5);

SELECT * FROM Trip;
SELECT * FROM GPS_Log;

-- Arrivals + automatic delay and alert: 2 min late (no alert), 8 min late (alert).
INSERT INTO Stop_Arrival (trip_id, stop_id, scheduled_time, actual_time) VALUES
(1, 1, NOW(),                     NULL),
(1, 2, NOW() + INTERVAL 6 MINUTE, NULL);

UPDATE Stop_Arrival SET actual_time = scheduled_time + INTERVAL 2 MINUTE
WHERE trip_id = 1 AND stop_id = 1;

UPDATE Stop_Arrival SET actual_time = scheduled_time + INTERVAL 8 MINUTE
WHERE trip_id = 1 AND stop_id = 2;

SELECT * FROM Stop_Arrival;
SELECT * FROM Delay_Alert;

-- Trip procedures: start the scheduled trip 3, then end it again.
CALL sp_start_trip(3);
SELECT trip_id, status, start_time FROM Trip WHERE trip_id = 3;
SELECT * FROM Stop_Arrival WHERE trip_id = 3;

CALL sp_end_trip(3);
SELECT trip_id, status, end_time FROM Trip WHERE trip_id = 3;
SELECT COUNT(*) AS remaining_arrivals FROM Stop_Arrival WHERE trip_id = 3;

-- Transaction + SAVEPOINT demo: change is undone in two steps, nothing is kept.
START TRANSACTION;
UPDATE Bus SET capacity = 50 WHERE bus_id = 3;
SAVEPOINT after_capacity;
UPDATE Bus SET status = 'retired' WHERE bus_id = 3;
SELECT bus_id, capacity, status FROM Bus WHERE bus_id = 3;   -- 50, retired
ROLLBACK TO after_capacity;
SELECT bus_id, capacity, status FROM Bus WHERE bus_id = 3;   -- 50, active
ROLLBACK;
SELECT bus_id, capacity, status FROM Bus WHERE bus_id = 3;   -- 35, active (original)

-- Reports: live map data, punctuality summary, next buses at two stops.
SELECT * FROM v_live_buses;
SELECT * FROM v_delay_report;
CALL sp_next_buses(5);      -- Bandra Station
CALL sp_next_buses(1);      -- Dadar Station

-- Driver console list (works because the driver view lists scheduled/running).
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
VALUES (1, 1, 1, NOW(), 'scheduled');
SELECT * FROM v_driver_trips;

-- Finish the demo trips; the delay report and alerts are final after this.
CALL sp_end_trip(1);
CALL sp_end_trip(2);
SELECT * FROM Delay_Alert;
SELECT * FROM v_delay_report;


/* ============================================================================
   9. TEST CASES  (OPTIONAL - every statement below is MEANT TO FAIL or to be
   destructive, so they are commented out. Copy one at a time into the mysql
   prompt after section 8 to demonstrate each rule. Expected result in the
   comment after each case.)
   ============================================================================ */

/*
-- Set-up for T2, T3, T5, T6, T10: trip 4 (bus 1, driver 1) becomes the running trip.
CALL sp_start_trip(4);

-- T1 Bus in maintenance cannot be used.
--    ERROR 1644: Trip rejected: bus is not active
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, status)
VALUES (10, 1, 4, 4, NOW(), 'running');

-- T2 A bus already running trip 4 cannot start a second running trip.
--    ERROR 1644: Trip rejected: bus is already on a running trip
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, status)
VALUES (11, 1, 1, 4, NOW(), 'running');

-- T3 A driver already running a trip cannot start another.
--    ERROR 1644: Trip rejected: driver is already on a running trip
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, status)
VALUES (12, 1, 3, 1, NOW(), 'running');

-- T4 GPS ping for a trip that is not running (trip 3 is completed).
--    ERROR 1644: GPS ping rejected: trip is not running
INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph)
VALUES (3, 19.0178, 72.8433, 10);

-- T5 Latitude out of range (trip 4 is running, so the trigger passes and the CHECK fires).
--    ERROR 3819: Check constraint 'gps_log_chk_1' is violated.
INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph)
VALUES (4, 100, 72.8433, 10);

-- T6 Negative speed.
--    ERROR 3819: Check constraint violated.
INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph)
VALUES (4, 19.0178, 72.8433, -5);

-- T7 Trip that ends before it starts.
--    ERROR 3819: Check constraint 'trip_chk_1' is violated.
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, end_time, status)
VALUES (13, 1, 3, 4, NOW(), NOW() - INTERVAL 1 HOUR, 'completed');

-- T8 Deleting a route that has trips is blocked (ON DELETE RESTRICT).
--    ERROR 1451: Cannot delete or update a parent row
DELETE FROM Route WHERE route_id = 1;

-- T9 Duplicate phone number.
--    ERROR 1062: Duplicate entry '9876500001' for key 'driver.phone'
INSERT INTO Driver (name, phone, license_no)
VALUES ('Test Driver', '9876500001', 'MH0120209999');

-- T10 Starting a trip that is not scheduled (trip 4 is already running).
--     ERROR 1644: Cannot start: trip not found or not in scheduled state
CALL sp_start_trip(4);
*/

-- ============================== END OF FILE ================================
