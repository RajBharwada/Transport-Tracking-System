-- Test cases for the rules of the database (each T-case is MEANT to fail).
-- Run AFTER a fresh build of bus_tracking_full.sql:
--   sudo mysql --force --table bus_tracking < database/test_cases.sql
-- --force keeps going after each expected error so every case is shown.

USE bus_tracking;

-- Set-up for T2, T3, T5, T6, T10: trip 4 (bus 1, driver 1) becomes the running trip.
CALL sp_start_trip(4);

SELECT 'T1: Bus in maintenance cannot be used.' AS test_case;
-- T1 Bus in maintenance cannot be used.
--    ERROR 1644: Trip rejected: bus is not active
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, status)
VALUES (10, 1, 4, 4, NOW(), 'running');

SELECT 'T2: A bus already running trip 4 cannot start a second running trip.' AS test_case;
-- T2 A bus already running trip 4 cannot start a second running trip.
--    ERROR 1644: Trip rejected: bus is already on a running trip
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, status)
VALUES (11, 1, 1, 4, NOW(), 'running');

SELECT 'T3: A driver already running a trip cannot start another.' AS test_case;
-- T3 A driver already running a trip cannot start another.
--    ERROR 1644: Trip rejected: driver is already on a running trip
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, status)
VALUES (12, 1, 3, 1, NOW(), 'running');

SELECT 'T4: GPS ping for a trip that is not running (trip 3 is completed).' AS test_case;
-- T4 GPS ping for a trip that is not running (trip 3 is completed).
--    ERROR 1644: GPS ping rejected: trip is not running
INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph)
VALUES (3, 19.0178, 72.8433, 10);

SELECT 'T5: Latitude out of range (trip 4 is running, so the trigger passes and the CHECK fires).' AS test_case;
-- T5 Latitude out of range (trip 4 is running, so the trigger passes and the CHECK fires).
--    ERROR 3819: Check constraint 'gps_log_chk_1' is violated.
INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph)
VALUES (4, 100, 72.8433, 10);

SELECT 'T6: Negative speed.' AS test_case;
-- T6 Negative speed.
--    ERROR 3819: Check constraint violated.
INSERT INTO GPS_Log (trip_id, latitude, longitude, speed_kmph)
VALUES (4, 19.0178, 72.8433, -5);

SELECT 'T7: Trip that ends before it starts.' AS test_case;
-- T7 Trip that ends before it starts.
--    ERROR 3819: Check constraint 'trip_chk_1' is violated.
INSERT INTO Trip (trip_id, route_id, bus_id, driver_id, start_time, end_time, status)
VALUES (13, 1, 3, 4, NOW(), NOW() - INTERVAL 1 HOUR, 'completed');

SELECT 'T8: Deleting a route that has trips is blocked (ON DELETE RESTRICT).' AS test_case;
-- T8 Deleting a route that has trips is blocked (ON DELETE RESTRICT).
--    ERROR 1451: Cannot delete or update a parent row
DELETE FROM Route WHERE route_id = 1;

SELECT 'T9: Duplicate phone number.' AS test_case;
-- T9 Duplicate phone number.
--    ERROR 1062: Duplicate entry '9876500001' for key 'driver.phone'
INSERT INTO Driver (name, phone, license_no)
VALUES ('Test Driver', '9876500001', 'MH0120209999');

SELECT 'T10: Starting a trip that is not scheduled (trip 4 is already running).' AS test_case;
-- T10 Starting a trip that is not scheduled (trip 4 is already running).
--     ERROR 1644: Cannot start: trip not found or not in scheduled state
CALL sp_start_trip(4);
