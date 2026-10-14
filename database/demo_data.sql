-- Demo data for the Mumbai Bus Tracker (adds to what is already in bus_tracking).
-- Safe to re-run on the same day: every insert checks for an existing row first.
-- Back up first:  sudo mysqldump --routines --triggers bus_tracking > before_demo.sql
-- Run:            sudo mysql bus_tracking < database/demo_data.sql
-- Stop coordinates are approximate; the map snaps routes to roads.
-- All demo logins use the password: driver123
SET NAMES utf8mb4;

-- Stops
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Churchgate Station', 18.932200, 72.826400, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Churchgate Station');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Chhatrapati Shivaji Terminus', 18.939800, 72.835500, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Chhatrapati Shivaji Terminus');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Haji Ali Junction', 18.982700, 72.808900, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Haji Ali Junction');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Worli Naka', 19.014500, 72.817000, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Worli Naka');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Siddhivinayak Temple Prabhadevi', 19.016900, 72.830000, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Siddhivinayak Temple Prabhadevi');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Dadar TT', 19.019700, 72.848600, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Dadar TT');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Santacruz Station', 19.081500, 72.841500, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Santacruz Station');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Andheri Station', 19.119700, 72.846800, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Andheri Station');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Kurla Station', 19.065400, 72.879300, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Kurla Station');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Ghatkopar Station', 19.086000, 72.908600, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Ghatkopar Station');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'IIT Bombay Main Gate', 19.133400, 72.913300, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'IIT Bombay Main Gate');
INSERT INTO Stop (name, latitude, longitude, city_id)
SELECT 'Chembur Station', 19.062300, 72.899700, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Stop WHERE name = 'Chembur Station');

-- Routes and their ordered stops
INSERT INTO Route (route_no, name, city_id)
SELECT 'R3', 'CSMT - Dadar TT via Haji Ali', 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Route WHERE route_no = 'R3');
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 1, 0 FROM Route r, Stop s
WHERE r.route_no = 'R3' AND s.name = 'Chhatrapati Shivaji Terminus';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 2, 9 FROM Route r, Stop s
WHERE r.route_no = 'R3' AND s.name = 'Churchgate Station';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 3, 23 FROM Route r, Stop s
WHERE r.route_no = 'R3' AND s.name = 'Haji Ali Junction';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 4, 33 FROM Route r, Stop s
WHERE r.route_no = 'R3' AND s.name = 'Worli Naka';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 5, 39 FROM Route r, Stop s
WHERE r.route_no = 'R3' AND s.name = 'Siddhivinayak Temple Prabhadevi';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 6, 46 FROM Route r, Stop s
WHERE r.route_no = 'R3' AND s.name = 'Dadar TT';
INSERT INTO Route (route_no, name, city_id)
SELECT 'R4', 'Dadar - Andheri', 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Route WHERE route_no = 'R4');
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 1, 0 FROM Route r, Stop s
WHERE r.route_no = 'R4' AND s.name = 'Dadar Station';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 2, 11 FROM Route r, Stop s
WHERE r.route_no = 'R4' AND s.name = 'Mahim Causeway';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 3, 22 FROM Route r, Stop s
WHERE r.route_no = 'R4' AND s.name = 'Bandra Station';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 4, 32 FROM Route r, Stop s
WHERE r.route_no = 'R4' AND s.name = 'Santacruz Station';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 5, 45 FROM Route r, Stop s
WHERE r.route_no = 'R4' AND s.name = 'Andheri Station';
INSERT INTO Route (route_no, name, city_id)
SELECT 'R5', 'Kurla - Powai', 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Route WHERE route_no = 'R5');
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 1, 0 FROM Route r, Stop s
WHERE r.route_no = 'R5' AND s.name = 'Kurla Station';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 2, 13 FROM Route r, Stop s
WHERE r.route_no = 'R5' AND s.name = 'Ghatkopar Station';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 3, 32 FROM Route r, Stop s
WHERE r.route_no = 'R5' AND s.name = 'IIT Bombay Main Gate';
INSERT INTO Route (route_no, name, city_id)
SELECT 'R6', 'Sion Hospital - Chembur', 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Route WHERE route_no = 'R6');
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 1, 0 FROM Route r, Stop s
WHERE r.route_no = 'R6' AND s.name = 'Sion Hospital';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 2, 12 FROM Route r, Stop s
WHERE r.route_no = 'R6' AND s.name = 'Kurla Station';
INSERT IGNORE INTO Route_Stop (route_id, stop_id, stop_seq, sched_offset_min)
SELECT r.route_id, s.stop_id, 3, 26 FROM Route r, Stop s
WHERE r.route_no = 'R6' AND s.name = 'Chembur Station';

-- Drivers and their logins
INSERT INTO Driver (name, phone, license_no)
SELECT 'Anil Kulkarni', '9876500011', 'MH01-DL-0011' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Driver WHERE phone = '9876500011' OR license_no = 'MH01-DL-0011');
INSERT INTO Driver (name, phone, license_no)
SELECT 'Meera Deshmukh', '9876500012', 'MH01-DL-0012' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Driver WHERE phone = '9876500012' OR license_no = 'MH01-DL-0012');
INSERT INTO Driver (name, phone, license_no)
SELECT 'Farhan Ansari', '9876500013', 'MH01-DL-0013' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Driver WHERE phone = '9876500013' OR license_no = 'MH01-DL-0013');
INSERT INTO Driver (name, phone, license_no)
SELECT 'Pooja Nair', '9876500014', 'MH01-DL-0014' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Driver WHERE phone = '9876500014' OR license_no = 'MH01-DL-0014');
INSERT INTO Driver (name, phone, license_no)
SELECT 'Sandeep More', '9876500015', 'MH01-DL-0015' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Driver WHERE phone = '9876500015' OR license_no = 'MH01-DL-0015');
INSERT INTO Driver (name, phone, license_no)
SELECT 'Kavita Rane', '9876500016', 'MH01-DL-0016' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Driver WHERE phone = '9876500016' OR license_no = 'MH01-DL-0016');
INSERT INTO Users (username, password_hash, role, driver_id)
SELECT 'anil', 'scrypt:32768:8:1$3v6o1uJh77HFR9ya$45f5ff338ece9bfe46369ff792cd1df690598d4f60dfa9a1ad8f4f31cb1bacd06af2291720d5044bcc58ab57cd118c710c43edadb6719ee1db372a079e6a9f9b', 'driver', driver_id FROM Driver
WHERE phone = '9876500011'
  AND NOT EXISTS (SELECT 1 FROM Users WHERE username = 'anil')
  AND NOT EXISTS (SELECT 1 FROM Users WHERE driver_id = (SELECT driver_id FROM Driver WHERE phone = '9876500011'));
INSERT INTO Users (username, password_hash, role, driver_id)
SELECT 'meera', 'scrypt:32768:8:1$fP5bs0EzHI12Q37k$7565863da79c334bd668086542a96d1481fae8171b8fe009f44a4ef05e6822cf39e4ee5695bf88af058a1a4f21612913f5a385131c7d0638910ef6a9024f9293', 'driver', driver_id FROM Driver
WHERE phone = '9876500012'
  AND NOT EXISTS (SELECT 1 FROM Users WHERE username = 'meera')
  AND NOT EXISTS (SELECT 1 FROM Users WHERE driver_id = (SELECT driver_id FROM Driver WHERE phone = '9876500012'));
INSERT INTO Users (username, password_hash, role, driver_id)
SELECT 'farhan', 'scrypt:32768:8:1$SR2ptwF9X5j0KAoX$bd7534370d8e1d5eefce1da1a00de0398e0e3b24b845481364634e37fb7896f0216fe30f468b6edaf9b3a6a6e85752c3add251a76147a34da9f848770b4f6268', 'driver', driver_id FROM Driver
WHERE phone = '9876500013'
  AND NOT EXISTS (SELECT 1 FROM Users WHERE username = 'farhan')
  AND NOT EXISTS (SELECT 1 FROM Users WHERE driver_id = (SELECT driver_id FROM Driver WHERE phone = '9876500013'));
INSERT INTO Users (username, password_hash, role, driver_id)
SELECT 'pooja', 'scrypt:32768:8:1$fmzU26zdLyDOKML1$f49e0606a0f99352dfefa67da2e26d934ace937de67bb192bca283e0cc2c03d098dbfc17fd721671f582674e996a951665aed7ab4711b680db80e11c30aeb75f', 'driver', driver_id FROM Driver
WHERE phone = '9876500014'
  AND NOT EXISTS (SELECT 1 FROM Users WHERE username = 'pooja')
  AND NOT EXISTS (SELECT 1 FROM Users WHERE driver_id = (SELECT driver_id FROM Driver WHERE phone = '9876500014'));
INSERT INTO Users (username, password_hash, role, driver_id)
SELECT 'sandeep', 'scrypt:32768:8:1$5IiAnEcHZZAqo1wO$b06fc7028cc40fa7b1fd3667ccbbada69f887b94dfd61cbb1630c1b72f162869583813ed65e73fc15dcd5bc893d45bd7fb4495a2305526db5a9da5574c967264', 'driver', driver_id FROM Driver
WHERE phone = '9876500015'
  AND NOT EXISTS (SELECT 1 FROM Users WHERE username = 'sandeep')
  AND NOT EXISTS (SELECT 1 FROM Users WHERE driver_id = (SELECT driver_id FROM Driver WHERE phone = '9876500015'));
INSERT INTO Users (username, password_hash, role, driver_id)
SELECT 'kavita', 'scrypt:32768:8:1$voADiBa4ZRrcMujc$89f17538e0012896f7ff4307b5df3036c4be42080ceb51a65506f96a489487e8902960afc820a2dec1164826fba4b6d6a198b09178135d9c2fd7215d66f642be', 'driver', driver_id FROM Driver
WHERE phone = '9876500016'
  AND NOT EXISTS (SELECT 1 FROM Users WHERE username = 'kavita')
  AND NOT EXISTS (SELECT 1 FROM Users WHERE driver_id = (SELECT driver_id FROM Driver WHERE phone = '9876500016'));

-- Buses (one in maintenance, one retired, so the admin screen shows every status)
INSERT INTO Bus (reg_no, capacity, status)
SELECT 'MH01CD2001', 45, 'active' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Bus WHERE reg_no = 'MH01CD2001');
INSERT INTO Bus (reg_no, capacity, status)
SELECT 'MH01CD2002', 45, 'active' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Bus WHERE reg_no = 'MH01CD2002');
INSERT INTO Bus (reg_no, capacity, status)
SELECT 'MH01CD2003', 40, 'active' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Bus WHERE reg_no = 'MH01CD2003');
INSERT INTO Bus (reg_no, capacity, status)
SELECT 'MH01CD2004', 40, 'active' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Bus WHERE reg_no = 'MH01CD2004');
INSERT INTO Bus (reg_no, capacity, status)
SELECT 'MH01CD2005', 50, 'active' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Bus WHERE reg_no = 'MH01CD2005');
INSERT INTO Bus (reg_no, capacity, status)
SELECT 'MH01CD2006', 35, 'active' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Bus WHERE reg_no = 'MH01CD2006');
INSERT INTO Bus (reg_no, capacity, status)
SELECT 'MH01CD2007', 40, 'maintenance' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Bus WHERE reg_no = 'MH01CD2007');
INSERT INTO Bus (reg_no, capacity, status)
SELECT 'MH01CD2008', 35, 'retired' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Bus WHERE reg_no = 'MH01CD2008');

-- Completed trips from yesterday (two per route) with recorded arrivals.
-- The triggers compute each delay and raise a Delay_Alert when it is 5 minutes or more.
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) + INTERVAL 26 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND d.phone = '9876500001'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 4 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 5 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) + INTERVAL 26 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND d.phone = '9876500001'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 7 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 5 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 7 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 4 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 4 MINUTE
WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 5 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) + INTERVAL 42 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND d.phone = '9876500002'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 2 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 4 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 4 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 5 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) + INTERVAL 42 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND d.phone = '9876500002'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 5 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 4 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 2 MINUTE
WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 5 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) + INTERVAL 50 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND d.phone = '9876500011'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 4 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 5 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 6 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) + INTERVAL 50 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND d.phone = '9876500011'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 10 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 5 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 8 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 4 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 5 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 6 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) + INTERVAL 49 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND d.phone = '9876500012'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 4 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 2 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 4 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 5 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) + INTERVAL 49 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND d.phone = '9876500012'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 2 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 8 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 4 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 4 MINUTE
WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 5 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) + INTERVAL 36 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND d.phone = '9876500013'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 2 MINUTE
WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) + INTERVAL 36 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND d.phone = '9876500013'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 8 MINUTE
WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 2 MINUTE
WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) + INTERVAL 30 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND d.phone = '9876500014'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 1 MINUTE
WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 8 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, end_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR), (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) + INTERVAL 30 MINUTE, 'completed'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND d.phone = '9876500014'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR));
INSERT IGNORE INTO Stop_Arrival (trip_id, stop_id, scheduled_time)
SELECT t.trip_id, rs.stop_id, t.start_time + INTERVAL rs.sched_offset_min MINUTE
FROM Trip t JOIN Route r ON r.route_id = t.route_id JOIN Bus b ON b.bus_id = t.bus_id
JOIN Route_Stop rs ON rs.route_id = t.route_id
WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR);
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 3 MINUTE
WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 1 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 0 MINUTE
WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 2 AND sa.actual_time IS NULL;
UPDATE Stop_Arrival sa JOIN Trip t ON t.trip_id = sa.trip_id JOIN Bus b ON b.bus_id = t.bus_id JOIN Route r ON r.route_id = t.route_id
JOIN Route_Stop rs ON rs.route_id = t.route_id AND rs.stop_id = sa.stop_id
SET sa.actual_time = sa.scheduled_time + INTERVAL 6 MINUTE
WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND t.start_time = (CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR) AND rs.stop_seq = 3 AND sa.actual_time IS NULL;

-- Scheduled trips for today: every driver has one to start from the driver console.
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() + INTERVAL 9 HOUR), 'scheduled'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R1' AND b.reg_no = 'MH01AB1003' AND d.phone = '9876500003'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.driver_id = d.driver_id AND t.start_time = (CURDATE() + INTERVAL 9 HOUR));
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() + INTERVAL 10 HOUR), 'scheduled'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R2' AND b.reg_no = 'MH01AB1002' AND d.phone = '9876500002'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.driver_id = d.driver_id AND t.start_time = (CURDATE() + INTERVAL 10 HOUR));
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() + INTERVAL 11 HOUR), 'scheduled'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2001' AND d.phone = '9876500011'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.driver_id = d.driver_id AND t.start_time = (CURDATE() + INTERVAL 11 HOUR));
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() + INTERVAL 12 HOUR), 'scheduled'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2002' AND d.phone = '9876500012'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.driver_id = d.driver_id AND t.start_time = (CURDATE() + INTERVAL 12 HOUR));
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() + INTERVAL 13 HOUR), 'scheduled'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R5' AND b.reg_no = 'MH01CD2003' AND d.phone = '9876500013'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.driver_id = d.driver_id AND t.start_time = (CURDATE() + INTERVAL 13 HOUR));
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() + INTERVAL 14 HOUR), 'scheduled'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R6' AND b.reg_no = 'MH01CD2004' AND d.phone = '9876500014'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.driver_id = d.driver_id AND t.start_time = (CURDATE() + INTERVAL 14 HOUR));
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() + INTERVAL 15 HOUR), 'scheduled'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R3' AND b.reg_no = 'MH01CD2005' AND d.phone = '9876500015'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.driver_id = d.driver_id AND t.start_time = (CURDATE() + INTERVAL 15 HOUR));
INSERT INTO Trip (route_id, bus_id, driver_id, start_time, status)
SELECT r.route_id, b.bus_id, d.driver_id, (CURDATE() + INTERVAL 16 HOUR), 'scheduled'
FROM Route r, Bus b, Driver d WHERE r.route_no = 'R4' AND b.reg_no = 'MH01CD2006' AND d.phone = '9876500016'
  AND NOT EXISTS (SELECT 1 FROM Trip t WHERE t.route_id = r.route_id AND t.bus_id = b.bus_id AND t.driver_id = d.driver_id AND t.start_time = (CURDATE() + INTERVAL 16 HOUR));
