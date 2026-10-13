-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: bus_tracking
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Bus`
--

DROP TABLE IF EXISTS `Bus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Bus` (
  `bus_id` int NOT NULL AUTO_INCREMENT,
  `reg_no` varchar(15) NOT NULL,
  `capacity` int NOT NULL,
  `status` enum('active','maintenance','retired') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`bus_id`),
  UNIQUE KEY `reg_no` (`reg_no`),
  CONSTRAINT `Bus_chk_1` CHECK ((`capacity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bus`
--

LOCK TABLES `Bus` WRITE;
/*!40000 ALTER TABLE `Bus` DISABLE KEYS */;
INSERT INTO `Bus` VALUES (1,'MH01AB1001',40,'active'),(2,'MH01AB1002',40,'active'),(3,'MH01AB1003',35,'active'),(4,'MH01AB1004',35,'maintenance');
/*!40000 ALTER TABLE `Bus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `City`
--

DROP TABLE IF EXISTS `City`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `City` (
  `city_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `state` varchar(80) NOT NULL,
  PRIMARY KEY (`city_id`),
  UNIQUE KEY `name` (`name`,`state`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `City`
--

LOCK TABLES `City` WRITE;
/*!40000 ALTER TABLE `City` DISABLE KEYS */;
INSERT INTO `City` VALUES (1,'Mumbai','Maharashtra');
/*!40000 ALTER TABLE `City` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Delay_Alert`
--

DROP TABLE IF EXISTS `Delay_Alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Delay_Alert` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `arrival_id` int NOT NULL,
  `delay_min` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`alert_id`),
  UNIQUE KEY `arrival_id` (`arrival_id`),
  CONSTRAINT `Delay_Alert_ibfk_1` FOREIGN KEY (`arrival_id`) REFERENCES `Stop_Arrival` (`arrival_id`) ON DELETE CASCADE,
  CONSTRAINT `Delay_Alert_chk_1` CHECK ((`delay_min` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Delay_Alert`
--

LOCK TABLES `Delay_Alert` WRITE;
/*!40000 ALTER TABLE `Delay_Alert` DISABLE KEYS */;
INSERT INTO `Delay_Alert` VALUES (1,2,8,'2026-10-08 20:58:56'),(2,19,5,'2026-10-08 21:33:15'),(3,20,6,'2026-10-08 21:33:30'),(4,21,8,'2026-10-08 21:33:45'),(5,33,6,'2026-10-08 21:50:50');
/*!40000 ALTER TABLE `Delay_Alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Driver`
--

DROP TABLE IF EXISTS `Driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Driver` (
  `driver_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `license_no` varchar(20) NOT NULL,
  PRIMARY KEY (`driver_id`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `license_no` (`license_no`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Driver`
--

LOCK TABLES `Driver` WRITE;
/*!40000 ALTER TABLE `Driver` DISABLE KEYS */;
INSERT INTO `Driver` VALUES (1,'Rajesh Patil','9876500001','MH0120200001'),(2,'Sunita Shinde','9876500002','MH0120200002'),(3,'Imran Shaikh','9876500003','MH0120200003'),(4,'Vikas Jadhav','9876500004','MH0120200004');
/*!40000 ALTER TABLE `Driver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GPS_Log`
--

DROP TABLE IF EXISTS `GPS_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GPS_Log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `trip_id` int NOT NULL,
  `latitude` decimal(9,6) NOT NULL,
  `longitude` decimal(9,6) NOT NULL,
  `speed_kmph` decimal(5,2) NOT NULL DEFAULT '0.00',
  `logged_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_gps_trip_time` (`trip_id`,`logged_at`),
  CONSTRAINT `GPS_Log_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `Trip` (`trip_id`) ON DELETE CASCADE,
  CONSTRAINT `GPS_Log_chk_1` CHECK ((`latitude` between -(90) and 90)),
  CONSTRAINT `GPS_Log_chk_2` CHECK ((`longitude` between -(180) and 180)),
  CONSTRAINT `GPS_Log_chk_3` CHECK ((`speed_kmph` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GPS_Log`
--

LOCK TABLES `GPS_Log` WRITE;
/*!40000 ALTER TABLE `GPS_Log` DISABLE KEYS */;
INSERT INTO `GPS_Log` VALUES (1,1,19.017800,72.843300,0.00,'2026-10-08 20:53:38'),(2,1,19.028600,72.837800,24.50,'2026-10-08 20:53:38'),(3,1,19.040700,72.841000,18.00,'2026-10-08 21:12:13'),(4,5,19.017800,72.843300,25.80,'2026-10-08 21:32:45'),(5,5,19.018880,72.842750,33.50,'2026-10-08 21:32:46'),(6,5,19.019960,72.842200,32.10,'2026-10-08 21:32:48'),(7,5,19.021040,72.841650,22.20,'2026-10-08 21:32:49'),(8,5,19.022120,72.841100,19.90,'2026-10-08 21:32:51'),(9,5,19.023200,72.840550,23.00,'2026-10-08 21:32:53'),(10,5,19.024280,72.840000,26.70,'2026-10-08 21:32:54'),(11,5,19.025360,72.839450,25.50,'2026-10-08 21:32:56'),(12,5,19.026440,72.838900,28.20,'2026-10-08 21:32:57'),(13,5,19.027520,72.838350,33.40,'2026-10-08 21:32:59'),(14,5,19.028600,72.837800,19.80,'2026-10-08 21:33:00'),(15,5,19.029810,72.838120,20.50,'2026-10-08 21:33:02'),(16,5,19.031020,72.838440,19.80,'2026-10-08 21:33:03'),(17,5,19.032230,72.838760,17.70,'2026-10-08 21:33:05'),(18,5,19.033440,72.839080,30.50,'2026-10-08 21:33:06'),(19,5,19.034650,72.839400,33.20,'2026-10-08 21:33:08'),(20,5,19.035860,72.839720,29.70,'2026-10-08 21:33:09'),(21,5,19.037070,72.840040,15.30,'2026-10-08 21:33:11'),(22,5,19.038280,72.840360,32.80,'2026-10-08 21:33:12'),(23,5,19.039490,72.840680,23.30,'2026-10-08 21:33:14'),(24,5,19.040700,72.841000,32.90,'2026-10-08 21:33:15'),(25,5,19.040830,72.840900,15.00,'2026-10-08 21:33:17'),(26,5,19.040960,72.840800,27.80,'2026-10-08 21:33:18'),(27,5,19.041090,72.840700,16.60,'2026-10-08 21:33:20'),(28,5,19.041220,72.840600,19.00,'2026-10-08 21:33:21'),(29,5,19.041350,72.840500,19.40,'2026-10-08 21:33:23'),(30,5,19.041480,72.840400,21.40,'2026-10-08 21:33:24'),(31,5,19.041610,72.840300,29.20,'2026-10-08 21:33:26'),(32,5,19.041740,72.840200,23.90,'2026-10-08 21:33:27'),(33,5,19.041870,72.840100,25.40,'2026-10-08 21:33:29'),(34,5,19.042000,72.840000,30.50,'2026-10-08 21:33:30'),(35,5,19.043240,72.840090,31.70,'2026-10-08 21:33:32'),(36,5,19.044480,72.840180,26.90,'2026-10-08 21:33:33'),(37,5,19.045720,72.840270,22.70,'2026-10-08 21:33:35'),(38,5,19.046960,72.840360,21.90,'2026-10-08 21:33:36'),(39,5,19.048200,72.840450,27.30,'2026-10-08 21:33:38'),(40,5,19.049440,72.840540,26.80,'2026-10-08 21:33:39'),(41,5,19.050680,72.840630,19.30,'2026-10-08 21:33:41'),(42,5,19.051920,72.840720,31.60,'2026-10-08 21:33:42'),(43,5,19.053160,72.840810,25.00,'2026-10-08 21:33:44'),(44,5,19.054400,72.840900,26.10,'2026-10-08 21:33:45'),(45,6,19.017800,72.843300,22.70,'2026-10-08 21:34:03'),(46,6,19.018880,72.842750,23.10,'2026-10-08 21:34:05'),(47,6,19.019960,72.842200,34.40,'2026-10-08 21:34:06'),(48,6,19.021040,72.841650,29.80,'2026-10-08 21:34:08'),(49,6,19.022120,72.841100,27.70,'2026-10-08 21:34:09'),(50,6,19.023200,72.840550,23.60,'2026-10-08 21:34:11'),(51,6,19.024280,72.840000,17.10,'2026-10-08 21:34:12'),(52,6,19.025360,72.839450,26.00,'2026-10-08 21:34:14'),(53,6,19.026440,72.838900,21.30,'2026-10-08 21:34:15'),(54,6,19.027520,72.838350,33.70,'2026-10-08 21:34:17'),(55,6,19.028600,72.837800,25.50,'2026-10-08 21:34:18'),(56,6,19.029810,72.838120,27.90,'2026-10-08 21:34:20'),(57,6,19.031020,72.838440,28.70,'2026-10-08 21:34:21'),(58,6,19.032230,72.838760,29.50,'2026-10-08 21:34:23'),(59,6,19.033440,72.839080,28.70,'2026-10-08 21:34:25'),(60,6,19.034650,72.839400,34.60,'2026-10-08 21:34:26'),(61,6,19.035860,72.839720,32.20,'2026-10-08 21:34:28'),(62,6,19.037070,72.840040,23.50,'2026-10-08 21:34:29'),(63,6,19.038280,72.840360,30.20,'2026-10-08 21:34:31'),(64,6,19.039490,72.840680,34.70,'2026-10-08 21:34:32'),(65,6,19.040700,72.841000,30.40,'2026-10-08 21:34:34'),(66,6,19.040830,72.840900,16.00,'2026-10-08 21:34:35'),(67,6,19.040960,72.840800,21.00,'2026-10-08 21:34:37'),(68,6,19.041090,72.840700,16.60,'2026-10-08 21:34:38'),(69,6,19.041220,72.840600,25.50,'2026-10-08 21:34:40'),(70,6,19.041350,72.840500,26.70,'2026-10-08 21:34:41'),(71,6,19.041480,72.840400,28.40,'2026-10-08 21:34:43'),(72,6,19.041610,72.840300,24.50,'2026-10-08 21:34:44'),(73,6,19.041740,72.840200,17.10,'2026-10-08 21:34:46'),(74,6,19.041870,72.840100,17.40,'2026-10-08 21:34:47'),(75,6,19.042000,72.840000,15.50,'2026-10-08 21:34:49'),(76,6,19.043240,72.840090,32.80,'2026-10-08 21:34:50'),(77,6,19.044480,72.840180,18.90,'2026-10-08 21:34:52'),(78,6,19.045720,72.840270,23.70,'2026-10-08 21:34:53'),(79,6,19.046960,72.840360,21.70,'2026-10-08 21:34:55'),(80,6,19.048200,72.840450,17.90,'2026-10-08 21:34:56'),(81,6,19.049440,72.840540,27.10,'2026-10-08 21:34:58'),(82,6,19.050680,72.840630,20.60,'2026-10-08 21:34:59'),(83,6,19.051920,72.840720,29.10,'2026-10-08 21:35:01'),(84,6,19.053160,72.840810,30.20,'2026-10-08 21:35:02'),(85,6,19.054400,72.840900,17.00,'2026-10-08 21:35:04'),(86,7,19.017800,72.843300,16.00,'2026-10-08 21:49:53'),(87,7,19.028600,72.837800,14.00,'2026-10-08 21:50:13'),(88,7,19.040700,72.841000,30.00,'2026-10-08 21:51:04');
/*!40000 ALTER TABLE `GPS_Log` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ghostadmin`@`%`*/ /*!50003 TRIGGER `trg_gps_before_insert` BEFORE INSERT ON `GPS_Log` FOR EACH ROW BEGIN
  IF (SELECT status FROM Trip WHERE trip_id = NEW.trip_id) <> 'running' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'GPS ping rejected: trip is not running';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Route`
--

DROP TABLE IF EXISTS `Route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Route` (
  `route_id` int NOT NULL AUTO_INCREMENT,
  `route_no` varchar(10) NOT NULL,
  `name` varchar(120) NOT NULL,
  `city_id` int NOT NULL,
  PRIMARY KEY (`route_id`),
  UNIQUE KEY `route_no` (`route_no`),
  KEY `city_id` (`city_id`),
  CONSTRAINT `Route_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `City` (`city_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Route`
--

LOCK TABLES `Route` WRITE;
/*!40000 ALTER TABLE `Route` DISABLE KEYS */;
INSERT INTO `Route` VALUES (1,'R1','Dadar Station - Bandra Station',1),(2,'R2','Sion Hospital - Bandra Kurla Complex',1);
/*!40000 ALTER TABLE `Route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Route_Stop`
--

DROP TABLE IF EXISTS `Route_Stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Route_Stop` (
  `route_id` int NOT NULL,
  `stop_id` int NOT NULL,
  `stop_seq` int NOT NULL,
  `sched_offset_min` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`route_id`,`stop_seq`),
  UNIQUE KEY `route_id` (`route_id`,`stop_id`),
  KEY `stop_id` (`stop_id`),
  CONSTRAINT `Route_Stop_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `Route` (`route_id`) ON DELETE CASCADE,
  CONSTRAINT `Route_Stop_ibfk_2` FOREIGN KEY (`stop_id`) REFERENCES `Stop` (`stop_id`) ON DELETE RESTRICT,
  CONSTRAINT `Route_Stop_chk_1` CHECK ((`stop_seq` > 0)),
  CONSTRAINT `Route_Stop_chk_2` CHECK ((`sched_offset_min` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Route_Stop`
--

LOCK TABLES `Route_Stop` WRITE;
/*!40000 ALTER TABLE `Route_Stop` DISABLE KEYS */;
INSERT INTO `Route_Stop` VALUES (1,1,1,0),(1,2,2,6),(1,3,3,11),(1,4,4,16),(1,5,5,22),(2,6,1,0),(2,1,2,10),(2,3,3,18),(2,5,4,26),(2,7,5,38);
/*!40000 ALTER TABLE `Route_Stop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stop`
--

DROP TABLE IF EXISTS `Stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stop` (
  `stop_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `latitude` decimal(9,6) NOT NULL,
  `longitude` decimal(9,6) NOT NULL,
  `city_id` int NOT NULL,
  PRIMARY KEY (`stop_id`),
  KEY `city_id` (`city_id`),
  CONSTRAINT `Stop_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `City` (`city_id`) ON DELETE RESTRICT,
  CONSTRAINT `Stop_chk_1` CHECK ((`latitude` between -(90) and 90)),
  CONSTRAINT `Stop_chk_2` CHECK ((`longitude` between -(180) and 180))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stop`
--

LOCK TABLES `Stop` WRITE;
/*!40000 ALTER TABLE `Stop` DISABLE KEYS */;
INSERT INTO `Stop` VALUES (1,'Dadar Station',19.017800,72.843300,1),(2,'Shivaji Park',19.028600,72.837800,1),(3,'Mahim Causeway',19.040700,72.841000,1),(4,'Xavier Institute of Engineering',19.042000,72.840000,1),(5,'Bandra Station',19.054400,72.840900,1),(6,'Sion Hospital',19.034400,72.861600,1),(7,'Bandra Kurla Complex',19.068000,72.870000,1);
/*!40000 ALTER TABLE `Stop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stop_Arrival`
--

DROP TABLE IF EXISTS `Stop_Arrival`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stop_Arrival` (
  `arrival_id` int NOT NULL AUTO_INCREMENT,
  `trip_id` int NOT NULL,
  `stop_id` int NOT NULL,
  `scheduled_time` datetime NOT NULL,
  `actual_time` datetime DEFAULT NULL,
  `delay_min` int DEFAULT NULL,
  PRIMARY KEY (`arrival_id`),
  UNIQUE KEY `trip_id` (`trip_id`,`stop_id`),
  KEY `stop_id` (`stop_id`),
  CONSTRAINT `Stop_Arrival_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `Trip` (`trip_id`) ON DELETE CASCADE,
  CONSTRAINT `Stop_Arrival_ibfk_2` FOREIGN KEY (`stop_id`) REFERENCES `Stop` (`stop_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stop_Arrival`
--

LOCK TABLES `Stop_Arrival` WRITE;
/*!40000 ALTER TABLE `Stop_Arrival` DISABLE KEYS */;
INSERT INTO `Stop_Arrival` VALUES (1,1,1,'2026-10-08 20:58:45','2026-10-08 21:00:45',2),(2,1,2,'2026-10-08 21:04:45','2026-10-08 21:12:45',8),(17,5,1,'2026-10-08 21:32:45','2026-10-08 21:32:45',0),(18,5,2,'2026-10-08 21:38:45','2026-10-08 21:40:45',2),(19,5,3,'2026-10-08 21:43:45','2026-10-08 21:48:45',5),(20,5,4,'2026-10-08 21:48:45','2026-10-08 21:54:45',6),(21,5,5,'2026-10-08 21:54:45','2026-10-08 22:02:45',8),(24,6,1,'2026-10-08 21:34:03','2026-10-08 21:34:03',0),(25,6,2,'2026-10-08 21:40:03','2026-10-08 21:40:03',0),(26,6,3,'2026-10-08 21:45:03','2026-10-08 21:47:03',2),(27,6,4,'2026-10-08 21:50:03','2026-10-08 21:52:03',2),(28,6,5,'2026-10-08 21:56:03','2026-10-08 21:58:03',2),(33,7,3,'2026-10-08 21:58:29','2026-10-08 22:04:29',6);
/*!40000 ALTER TABLE `Stop_Arrival` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ghostadmin`@`%`*/ /*!50003 TRIGGER `trg_arrival_before_update` BEFORE UPDATE ON `Stop_Arrival` FOR EACH ROW BEGIN
  IF NEW.actual_time IS NOT NULL THEN
    SET NEW.delay_min = TIMESTAMPDIFF(MINUTE, NEW.scheduled_time, NEW.actual_time);
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ghostadmin`@`%`*/ /*!50003 TRIGGER `trg_arrival_after_update` AFTER UPDATE ON `Stop_Arrival` FOR EACH ROW BEGIN
  IF NEW.delay_min IS NOT NULL AND NEW.delay_min >= 5 THEN
    INSERT INTO Delay_Alert (arrival_id, delay_min)
    VALUES (NEW.arrival_id, NEW.delay_min)
    ON DUPLICATE KEY UPDATE delay_min = NEW.delay_min;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Trip`
--

DROP TABLE IF EXISTS `Trip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Trip` (
  `trip_id` int NOT NULL AUTO_INCREMENT,
  `route_id` int NOT NULL,
  `bus_id` int NOT NULL,
  `driver_id` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` enum('scheduled','running','completed','cancelled') NOT NULL DEFAULT 'scheduled',
  PRIMARY KEY (`trip_id`),
  KEY `route_id` (`route_id`),
  KEY `bus_id` (`bus_id`),
  KEY `driver_id` (`driver_id`),
  CONSTRAINT `Trip_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `Route` (`route_id`) ON DELETE RESTRICT,
  CONSTRAINT `Trip_ibfk_2` FOREIGN KEY (`bus_id`) REFERENCES `Bus` (`bus_id`) ON DELETE RESTRICT,
  CONSTRAINT `Trip_ibfk_3` FOREIGN KEY (`driver_id`) REFERENCES `Driver` (`driver_id`) ON DELETE RESTRICT,
  CONSTRAINT `Trip_chk_1` CHECK (((`end_time` is null) or (`end_time` >= `start_time`)))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Trip`
--

LOCK TABLES `Trip` WRITE;
/*!40000 ALTER TABLE `Trip` DISABLE KEYS */;
INSERT INTO `Trip` VALUES (1,1,1,1,'2026-10-08 20:53:38','2026-10-08 21:30:50','completed'),(2,2,2,2,'2026-10-08 20:53:38','2026-10-08 21:30:50','completed'),(3,1,3,3,'2026-10-08 21:05:41','2026-10-08 21:06:25','completed'),(4,1,1,4,'2026-10-08 21:06:04',NULL,'scheduled'),(5,1,1,1,'2026-10-08 21:32:45','2026-10-08 21:33:47','completed'),(6,1,1,1,'2026-10-08 21:34:03','2026-10-08 21:35:05','completed'),(7,1,1,1,'2026-10-08 21:47:29','2026-10-08 21:51:39','completed'),(8,1,3,3,'2026-10-09 22:32:42',NULL,'scheduled');
/*!40000 ALTER TABLE `Trip` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ghostadmin`@`%`*/ /*!50003 TRIGGER `trg_trip_before_insert` BEFORE INSERT ON `Trip` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ghostadmin`@`%`*/ /*!50003 TRIGGER `trg_trip_before_update` BEFORE UPDATE ON `Trip` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','driver','commuter') NOT NULL,
  `driver_id` int DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `driver_id` (`driver_id`),
  CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `Driver` (`driver_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'admin','scrypt:32768:8:1$fAhLZIbXOVaGVR8e$eb2a283cb7b516ddcb181659bc66ac6ddbead5550c75a39222263f9e4e8cb0fc38cb825d36777e0c0648e198623af8e4a08821f9329e9cd353381c46e96ffa9c','admin',NULL),(2,'rajesh','scrypt:32768:8:1$e4OmXv8ulr8QSsF1$a0fe2ae64f42f3d06afa4cabba29dc06fa38506bfdca0bffec8004d12c3dc4f84f3c8f57f05b34ca232ae9143d0e1d3e4a61329dbc4f5307c9ffeb9d4fb4f13f','driver',1),(3,'sunita','scrypt:32768:8:1$UBN3jaSwDDwlLH1o$62af4bf74c05b1241abe71df42e03175794d0dcb9a3bb94dfb759392737c1e47ad4f4618469358c10e714724362bb164853f09bb46d764a1bdde21bee40ab2be','driver',2),(4,'commuter','scrypt:32768:8:1$9bfkOmUGEbVhzH42$dbfd36794693a1752de1e9604cc9bd9916e7e3fd3e686637b72da1a70896cd7490f0b5cf517d6fc051515edcb277a8aae357b22e39509cc1969e5a0b74d3665e','commuter',NULL);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_delay_report`
--

DROP TABLE IF EXISTS `v_delay_report`;
/*!50001 DROP VIEW IF EXISTS `v_delay_report`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_delay_report` AS SELECT 
 1 AS `route_no`,
 1 AS `arrivals_recorded`,
 1 AS `avg_delay_min`,
 1 AS `max_delay_min`,
 1 AS `alerts_raised`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_driver_trips`
--

DROP TABLE IF EXISTS `v_driver_trips`;
/*!50001 DROP VIEW IF EXISTS `v_driver_trips`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_driver_trips` AS SELECT 
 1 AS `trip_id`,
 1 AS `driver_id`,
 1 AS `route_no`,
 1 AS `route_name`,
 1 AS `reg_no`,
 1 AS `status`,
 1 AS `start_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_live_buses`
--

DROP TABLE IF EXISTS `v_live_buses`;
/*!50001 DROP VIEW IF EXISTS `v_live_buses`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_live_buses` AS SELECT 
 1 AS `trip_id`,
 1 AS `reg_no`,
 1 AS `route_no`,
 1 AS `route_name`,
 1 AS `driver_name`,
 1 AS `latitude`,
 1 AS `longitude`,
 1 AS `speed_kmph`,
 1 AS `logged_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_route_stops`
--

DROP TABLE IF EXISTS `v_route_stops`;
/*!50001 DROP VIEW IF EXISTS `v_route_stops`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_route_stops` AS SELECT 
 1 AS `route_no`,
 1 AS `stop_seq`,
 1 AS `stop_id`,
 1 AS `name`,
 1 AS `latitude`,
 1 AS `longitude`,
 1 AS `sched_offset_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'bus_tracking'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_end_trip` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ghostadmin`@`%` PROCEDURE `sp_end_trip`(IN p_trip_id INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_next_buses` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ghostadmin`@`%` PROCEDURE `sp_next_buses`(IN p_stop_id INT)
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
  LEFT JOIN Stop_Arrival done
         ON done.trip_id = t.trip_id AND done.stop_id = p_stop_id AND done.actual_time IS NOT NULL
  LEFT JOIN (
        SELECT sa.trip_id, sa.delay_min
        FROM Stop_Arrival sa
        WHERE sa.actual_time IS NOT NULL
          AND sa.actual_time = (SELECT MAX(x.actual_time) FROM Stop_Arrival x
                                WHERE x.trip_id = sa.trip_id AND x.actual_time IS NOT NULL)
  ) ld ON ld.trip_id = t.trip_id
  WHERE t.status = 'running'
    AND done.arrival_id IS NULL
  ORDER BY eta;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_record_arrival` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ghostadmin`@`%` PROCEDURE `sp_record_arrival`(
  IN p_trip_id INT, IN p_stop_id INT, IN p_delay_min INT)
BEGIN
  IF (SELECT status FROM Trip WHERE trip_id = p_trip_id) <> 'running' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Arrival rejected: trip is not running';
  END IF;

  UPDATE Stop_Arrival
  SET actual_time = scheduled_time + INTERVAL p_delay_min MINUTE
  WHERE trip_id = p_trip_id AND stop_id = p_stop_id AND actual_time IS NULL;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Arrival rejected: stop not expected or already recorded';
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_start_trip` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ghostadmin`@`%` PROCEDURE `sp_start_trip`(IN p_trip_id INT)
BEGIN
  DECLARE v_status VARCHAR(20);
  DECLARE v_route  INT;
  DECLARE v_start  DATETIME;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_delay_report`
--

/*!50001 DROP VIEW IF EXISTS `v_delay_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ghostadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_delay_report` AS select `r`.`route_no` AS `route_no`,count(`sa`.`arrival_id`) AS `arrivals_recorded`,round(avg(`sa`.`delay_min`),1) AS `avg_delay_min`,max(`sa`.`delay_min`) AS `max_delay_min`,count(`da`.`alert_id`) AS `alerts_raised` from (((`Route` `r` join `Trip` `t` on((`t`.`route_id` = `r`.`route_id`))) join `Stop_Arrival` `sa` on(((`sa`.`trip_id` = `t`.`trip_id`) and (`sa`.`actual_time` is not null)))) left join `Delay_Alert` `da` on((`da`.`arrival_id` = `sa`.`arrival_id`))) group by `r`.`route_id`,`r`.`route_no` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_driver_trips`
--

/*!50001 DROP VIEW IF EXISTS `v_driver_trips`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ghostadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_driver_trips` AS select `t`.`trip_id` AS `trip_id`,`t`.`driver_id` AS `driver_id`,`r`.`route_no` AS `route_no`,`r`.`name` AS `route_name`,`b`.`reg_no` AS `reg_no`,`t`.`status` AS `status`,`t`.`start_time` AS `start_time` from ((`Trip` `t` join `Route` `r` on((`r`.`route_id` = `t`.`route_id`))) join `Bus` `b` on((`b`.`bus_id` = `t`.`bus_id`))) where (`t`.`status` in ('scheduled','running')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_live_buses`
--

/*!50001 DROP VIEW IF EXISTS `v_live_buses`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ghostadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_live_buses` AS select `t`.`trip_id` AS `trip_id`,`b`.`reg_no` AS `reg_no`,`r`.`route_no` AS `route_no`,`r`.`name` AS `route_name`,`d`.`name` AS `driver_name`,`g`.`latitude` AS `latitude`,`g`.`longitude` AS `longitude`,`g`.`speed_kmph` AS `speed_kmph`,`g`.`logged_at` AS `logged_at` from ((((`Trip` `t` join `Bus` `b` on((`b`.`bus_id` = `t`.`bus_id`))) join `Route` `r` on((`r`.`route_id` = `t`.`route_id`))) join `Driver` `d` on((`d`.`driver_id` = `t`.`driver_id`))) join `GPS_Log` `g` on((`g`.`trip_id` = `t`.`trip_id`))) where ((`t`.`status` = 'running') and (`g`.`log_id` = (select max(`g2`.`log_id`) from `GPS_Log` `g2` where (`g2`.`trip_id` = `t`.`trip_id`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_route_stops`
--

/*!50001 DROP VIEW IF EXISTS `v_route_stops`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ghostadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_route_stops` AS select `r`.`route_no` AS `route_no`,`rs`.`stop_seq` AS `stop_seq`,`s`.`stop_id` AS `stop_id`,`s`.`name` AS `name`,`s`.`latitude` AS `latitude`,`s`.`longitude` AS `longitude`,`rs`.`sched_offset_min` AS `sched_offset_min` from ((`Route_Stop` `rs` join `Route` `r` on((`r`.`route_id` = `rs`.`route_id`))) join `Stop` `s` on((`s`.`stop_id` = `rs`.`stop_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-09 22:46:19
