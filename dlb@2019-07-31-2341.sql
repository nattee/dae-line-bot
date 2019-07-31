-- MySQL dump 10.13  Distrib 5.7.27, for Linux (x86_64)
--
-- Host: localhost    Database: dae_line_bot
-- ------------------------------------------------------
-- Server version	5.7.27-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2019-04-27 13:54:06','2019-04-27 13:54:06');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `athletes`
--

DROP TABLE IF EXISTS `athletes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `athletes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `line_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `line_name` varchar(250) COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `athletes`
--

LOCK TABLES `athletes` WRITE;
/*!40000 ALTER TABLE `athletes` DISABLE KEYS */;
INSERT INTO `athletes` VALUES (1,NULL,'U65f059fab471514d0e1c35006d0846c7','Nattee','2019-07-31 11:51:09','2019-07-31 11:51:09'),(2,NULL,'Udd97865cf75abc7525b8fa7e3755b662','Krit (115)','2019-07-31 12:05:02','2019-07-31 12:05:02'),(3,NULL,'U24511b8a8b7356f12d10705fe5cca13b','วารี - ไร่ ๓ สลึง','2019-07-31 12:05:25','2019-07-31 12:46:45'),(4,NULL,'Ufcd60dec1492755f59f75cb717881b7b','B?Y99','2019-07-31 12:06:54','2019-07-31 12:49:08'),(5,NULL,'Ua226793cbb1bab5608040a47da21b99c','Chanat','2019-07-31 12:11:06','2019-07-31 12:11:06'),(6,NULL,'Ud30d17e95de0ffd38b093317531f4d67','Tengosk','2019-07-31 12:11:23','2019-07-31 12:11:23'),(7,NULL,'Ucede538e27f8a8d11fdacf614c98dd36','akk','2019-07-31 12:17:04','2019-07-31 12:17:04'),(8,NULL,'U9bf15a62126cfea746d7a2e257c9b00b','Jira','2019-07-31 12:19:45','2019-07-31 12:19:45'),(9,NULL,'U812224723c45400a3fd2eb585baf1bf4','Ekkarin JOJO','2019-07-31 12:22:40','2019-07-31 12:22:40'),(10,NULL,'U87c5edbab46aa585051594a695224c31','north simplify','2019-07-31 12:24:29','2019-07-31 12:24:29'),(11,NULL,'Uf2fc8dfe70da6935a4e9f84a66034fe9','Jirapong Amn','2019-07-31 12:37:19','2019-07-31 12:37:19'),(12,NULL,'Uaf22788b80f3b316a4a6c8898f071c75','Chalermpun Punjamapi','2019-07-31 12:38:46','2019-07-31 12:38:46'),(13,NULL,'U7ad7ea15ac2e134054a68d35dea42ab6','chaleampong joop','2019-07-31 12:49:33','2019-07-31 12:49:33'),(14,NULL,'Ucc2b2e3b4b4d408f6b6f44cfa0838829','Ae115','2019-07-31 13:02:33','2019-07-31 13:02:33'),(15,NULL,'Ucc7ddeb6a4f3317f2c4514e7e4cbc9c0','t@ro','2019-07-31 13:29:49','2019-07-31 13:29:49'),(16,NULL,'U24c4a75ea13d927d5f0044e45299353d','Nattopancho','2019-07-31 13:32:21','2019-07-31 13:32:21'),(17,NULL,'Ub903adde1326aa21e606f5f2998233c4','??♂️Beam115@P.?✨','2019-07-31 13:54:05','2019-07-31 13:54:05'),(18,NULL,'U5d720138e63452617b2186b0ea45d82e','Chonmapoom/Samathi','2019-07-31 14:47:22','2019-07-31 14:47:22'),(19,NULL,'Ub5e0f740a2b6e3a16c5c43cdae5c0471','Sorasak T.','2019-07-31 15:42:40','2019-07-31 15:42:40'),(20,NULL,'Ufb69998a9e24c9a2eb45a6a7a55dea3b','Bank','2019-07-31 16:01:08','2019-07-31 16:01:08'),(21,NULL,'Ubef6d7d9b820afdbce70d40b966913ea','Tor','2019-07-31 16:02:50','2019-07-31 16:02:50');
/*!40000 ALTER TABLE `athletes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkins`
--

DROP TABLE IF EXISTS `checkins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checkins` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `run_id` bigint(20) DEFAULT NULL,
  `distance` float DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_checkins_on_run_id` (`run_id`),
  CONSTRAINT `fk_rails_942811f9a6` FOREIGN KEY (`run_id`) REFERENCES `runs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkins`
--

LOCK TABLES `checkins` WRITE;
/*!40000 ALTER TABLE `checkins` DISABLE KEYS */;
/*!40000 ALTER TABLE `checkins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `race_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `distance` float DEFAULT NULL,
  `start` datetime DEFAULT NULL,
  `stop` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `gain` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_courses_on_race_id` (`race_id`),
  CONSTRAINT `fk_rails_3509ac4d41` FOREIGN KEY (`race_id`) REFERENCES `races` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,1,'CM1',19.7,'2019-09-04 00:00:00','2019-09-04 07:00:00','2019-07-31 11:50:02','2019-07-31 11:50:02',1355),(2,1,'CM2',43.7,'2019-09-03 23:00:00','2019-09-04 12:00:00','2019-07-31 11:50:02','2019-07-31 11:50:02',2290),(3,1,'CM3',60.1,'2019-09-02 23:00:00','2019-09-03 15:00:00','2019-07-31 11:50:02','2019-07-31 11:50:02',3590),(4,1,'CM4',77.1,'2019-09-02 21:00:00','2019-09-03 19:00:00','2019-07-31 11:50:02','2019-07-31 11:50:02',5060),(5,1,'CM5',104.3,'2019-09-03 00:00:00','2019-09-04 06:00:00','2019-07-31 11:50:02','2019-07-31 11:50:02',6380),(6,1,'CM6',143.5,'2019-09-02 20:00:00','2019-09-04 15:00:00','2019-07-31 11:50:02','2019-07-31 11:50:02',9000);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parameters`
--

DROP TABLE IF EXISTS `parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parameters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parameters`
--

LOCK TABLES `parameters` WRITE;
/*!40000 ALTER TABLE `parameters` DISABLE KEYS */;
INSERT INTO `parameters` VALUES (1,NULL,'2019-04-28 16:00:00 +0700','2019-04-27 13:54:30','2019-04-27 14:10:30');
/*!40000 ALTER TABLE `parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `races`
--

DROP TABLE IF EXISTS `races`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `races` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `races`
--

LOCK TABLES `races` WRITE;
/*!40000 ALTER TABLE `races` DISABLE KEYS */;
INSERT INTO `races` VALUES (1,'CM6 2019','2019-07-31 11:50:02','2019-07-31 11:50:02');
/*!40000 ALTER TABLE `races` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `runs`
--

DROP TABLE IF EXISTS `runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `runs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `athlete_id` bigint(20) DEFAULT NULL,
  `bib` varchar(255) DEFAULT NULL,
  `course_id` bigint(20) DEFAULT NULL,
  `current_dist` float DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_runs_on_athlete_id` (`athlete_id`),
  KEY `index_runs_on_course_id` (`course_id`),
  CONSTRAINT `fk_rails_48f540848f` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `fk_rails_a20b718273` FOREIGN KEY (`athlete_id`) REFERENCES `athletes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `runs`
--

LOCK TABLES `runs` WRITE;
/*!40000 ALTER TABLE `runs` DISABLE KEYS */;
INSERT INTO `runs` VALUES (1,1,'9779',6,NULL,NULL,'2019-07-31 11:51:09','2019-07-31 11:51:09'),(2,2,'4084',4,NULL,NULL,'2019-07-31 12:05:02','2019-07-31 12:05:02'),(3,5,'5032',5,NULL,NULL,'2019-07-31 12:11:06','2019-07-31 12:16:07'),(4,6,'4077',4,NULL,NULL,'2019-07-31 12:11:23','2019-07-31 12:11:23'),(5,7,'5006',5,NULL,NULL,'2019-07-31 12:17:04','2019-07-31 12:17:04'),(6,8,'5058',5,NULL,NULL,'2019-07-31 12:19:45','2019-07-31 12:19:45'),(7,1,'3346',3,NULL,NULL,'2019-07-31 12:21:52','2019-07-31 12:21:52'),(8,9,'4044',4,NULL,NULL,'2019-07-31 12:22:40','2019-07-31 12:22:40'),(9,10,'5071',5,NULL,NULL,'2019-07-31 12:24:29','2019-07-31 12:24:29'),(10,11,'4056',4,NULL,NULL,'2019-07-31 12:37:19','2019-07-31 12:37:19'),(11,12,'4258',4,NULL,NULL,'2019-07-31 12:38:46','2019-07-31 12:38:46'),(12,3,'3346',3,NULL,NULL,'2019-07-31 12:46:45','2019-07-31 12:46:45'),(13,4,'4238',4,NULL,NULL,'2019-07-31 12:49:08','2019-07-31 12:49:08'),(14,13,'6029',6,NULL,NULL,'2019-07-31 12:49:33','2019-07-31 12:49:33'),(15,14,'4041',4,NULL,NULL,'2019-07-31 13:02:33','2019-07-31 13:02:33'),(16,15,'4217',4,NULL,NULL,'2019-07-31 13:29:49','2019-07-31 13:29:49'),(17,16,'4181',4,NULL,NULL,'2019-07-31 13:32:21','2019-07-31 13:32:21'),(18,17,'4139',4,NULL,NULL,'2019-07-31 13:54:05','2019-07-31 13:54:05'),(19,18,'3049',3,NULL,NULL,'2019-07-31 14:47:22','2019-07-31 14:47:22'),(20,19,'4196',4,NULL,NULL,'2019-07-31 15:42:40','2019-07-31 15:42:40'),(21,20,'4191',4,NULL,NULL,'2019-07-31 16:01:08','2019-07-31 16:01:08'),(22,21,'5062',5,NULL,NULL,'2019-07-31 16:02:50','2019-07-31 16:02:50');
/*!40000 ALTER TABLE `runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20190427133738'),('20190724124017'),('20190724124353'),('20190724124528'),('20190724124949'),('20190724125011'),('20190731105606');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-31 16:41:34
