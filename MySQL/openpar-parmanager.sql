-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: parmanager
-- ------------------------------------------------------
-- Server version	5.7.17-log

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
-- Temporary view structure for view `action`
--

DROP TABLE IF EXISTS `action`;
/*!50001 DROP VIEW IF EXISTS `action`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `action` AS SELECT 
 1 AS `act_id`,
 1 AS `act_name`,
 1 AS `act_obj_num`,
 1 AS `parent_id`,
 1 AS `wordnet_sense`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `assertions`
--

DROP TABLE IF EXISTS `assertions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assertions` (
  `act_id` int(11) NOT NULL,
  `cond_id` int(11) NOT NULL DEFAULT '0',
  `cond_pos` int(11) NOT NULL,
  `predicate` varchar(45) DEFAULT NULL,
  `arg1` varchar(45) DEFAULT NULL,
  `arg2` varchar(45) DEFAULT NULL,
  `argres` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`act_id`,`cond_id`,`cond_pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assertions`
--

LOCK TABLES `assertions` WRITE;
/*!40000 ALTER TABLE `assertions` DISABLE KEYS */;
INSERT INTO `assertions` VALUES (5,2,0,'setProperty','door','\"lock\"','\"locked\"'),(10,4,1,'changeContents','agent','key',NULL),(10,4,2,'setProperty','guard','\"status\"','\"trapped\"'),(10,4,3,'setProperty','door','\"look\"','\"locked\"'),(10,4,4,'setProperty','door','\"open\"','\"closed\"'),(16,3,0,'setProperty','door','\"status\"','\"guarded\"'),(19,0,1,'setProperty','agent','\"status\"','\"trapped\"'),(20,10,1,'setProperty','guard1','\"status\"','\"trapped\"'),(20,10,2,'setProperty','guard2','\"status\"','\"trapped\"'),(20,10,3,'setProperty','guard3','\"status\"','\"trapped\"'),(20,10,4,'setProperty','guard4','\"status\"','\"trapped\"'),(20,10,5,'setProperty','trap','\"status\"','\"active\"'),(20,10,6,'setProperty','button','\"status\"','\"active\"'),(21,8,1,'setProperty','guard1','\"status\"','\"trapped\"'),(21,8,2,'setProperty','guard2','\"status\"','\"trapped\"'),(21,8,3,'setProperty','guard3','\"status\"','\"trapped\"'),(21,8,4,'setProperty','guard4','\"status\"','\"trapped\"'),(21,8,5,'setProperty','trap','\"status\"','\"active\"'),(26,1,0,'setProperty','guard','status','\"dazed\"'),(38,1,0,'setReach','agent','entity',NULL),(38,1,1,'canReach','agent','entity',NULL),(41,2,0,'changeContents','Prisoner','Key',NULL),(43,3,1,'setProperty','door','\"open\"','\"open\"'),(44,4,1,'setProperty','door','\"lock\"','\"unlocked\"'),(47,4,1,'changeContents','agent','key',NULL),(54,3,1,'setProperty','alarm','\"status\"','\"active\"'),(55,2,0,'setProperty','door','\"open\"','\"closed\"'),(62,4,0,'guard','door','False',NULL);
/*!40000 ALTER TABLE `assertions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cond_assert`
--

DROP TABLE IF EXISTS `cond_assert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cond_assert` (
  `act_id` int(11) NOT NULL,
  `cond_id` int(11) NOT NULL,
  `is_every` int(11) DEFAULT '0',
  `retval` int(11) DEFAULT '2' COMMENT 'In PAR, 1 is SUCCESS, 2 is FAILURE, and 0 is INCOMPLETE',
  PRIMARY KEY (`act_id`,`cond_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cond_assert`
--

LOCK TABLES `cond_assert` WRITE;
/*!40000 ALTER TABLE `cond_assert` DISABLE KEYS */;
INSERT INTO `cond_assert` VALUES (1,0,1,1),(1,1,0,2),(5,0,0,2),(5,1,0,2),(5,2,1,1),(10,0,0,2),(10,1,0,2),(10,2,0,2),(10,3,0,2),(10,4,1,1),(12,0,1,1),(12,1,0,2),(16,0,0,2),(16,1,0,2),(16,2,0,2),(16,3,0,1),(19,0,1,1),(19,1,0,2),(20,0,0,2),(20,1,0,2),(20,2,0,2),(20,3,0,2),(20,4,0,2),(20,5,0,2),(20,6,0,2),(20,7,0,2),(20,8,0,2),(20,9,0,2),(20,10,1,1),(21,0,0,2),(21,1,0,2),(21,2,0,2),(21,3,0,2),(21,4,0,2),(21,5,0,2),(21,6,0,2),(21,7,0,2),(21,8,1,1),(24,0,1,1),(26,0,0,2),(26,1,1,1),(35,0,1,1),(38,0,1,1),(40,0,1,1),(40,1,0,2),(40,2,0,2),(41,0,0,2),(41,1,0,2),(41,2,0,2),(41,3,1,1),(43,0,0,2),(43,1,0,2),(43,2,0,2),(43,3,1,1),(44,0,0,2),(44,1,0,2),(44,2,0,2),(44,3,0,2),(44,4,1,1),(45,0,1,1),(45,1,0,2),(45,2,0,2),(47,0,0,2),(47,1,0,2),(47,2,0,2),(47,3,0,2),(47,4,1,1),(54,0,0,2),(54,1,0,2),(54,2,0,2),(54,3,1,1),(55,0,0,2),(55,1,0,2),(55,2,0,1),(62,0,0,1),(62,1,0,2),(62,2,0,2),(62,3,0,2);
/*!40000 ALTER TABLE `cond_assert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conditions`
--

DROP TABLE IF EXISTS `conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conditions` (
  `act_id` int(11) NOT NULL,
  `cond_id` int(11) NOT NULL DEFAULT '0',
  `cond_pos` int(11) NOT NULL,
  `predicate` varchar(45) DEFAULT NULL,
  `arg1` varchar(45) DEFAULT NULL,
  `arg2` varchar(45) DEFAULT NULL,
  `argres` varchar(45) DEFAULT NULL,
  `result` int(11) DEFAULT '1' COMMENT '0=True\n1=False (if not)',
  PRIMARY KEY (`act_id`,`cond_id`,`cond_pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conditions`
--

LOCK TABLES `conditions` WRITE;
/*!40000 ALTER TABLE `conditions` DISABLE KEYS */;
INSERT INTO `conditions` VALUES (1,0,0,'finishedAction','self.id',NULL,NULL,0),(1,1,0,'canReach','agent','waypoint','',1),(5,0,0,'canReach','agent','door',NULL,1),(5,1,0,'getProperty','door','\"open\"','\"closed\"',1),(5,2,0,'finishedAction','self.id',NULL,NULL,0),(10,0,0,'canReach','guard','door',NULL,1),(10,1,0,'contains','guard','key',NULL,1),(10,2,0,'getProperty','door','\"open\"','\"closed\"',1),(10,3,0,'getProperty','door','\"lock\"','\"locked\"',1),(10,4,0,'finishedAction','self.id',NULL,NULL,0),(12,0,0,'finishedAction','self.id',NULL,NULL,0),(12,1,0,'canReach','agent','button',NULL,1),(16,0,0,'canReach','agent','guard',NULL,1),(16,1,0,'getProperty','door','\"status\"','\"guarded\"',1),(16,2,0,'getProperty','agent','\"status\"','\"dazed\"',1),(16,3,0,'finishedAction','self.id',NULL,NULL,0),(19,0,0,'finishedAction','self.id',NULL,NULL,0),(19,1,0,'canReach','agent','trap',NULL,1),(20,0,0,'canReach','agent','button1',NULL,1),(20,1,0,'hasPath','guard1','waypoint','trap',1),(20,2,0,'hasPath','guard2','waypoint','trap',1),(20,3,0,'hasPath','guard3','waypoint','trap',1),(20,4,0,'hasPath','guard4','waypoint','trap',1),(20,5,0,'hasProperty','trap','\"status\"','\"active\"',1),(20,6,0,'controls','button1','trap',NULL,1),(20,7,0,'canReach','prisoner','button2',NULL,1),(20,8,0,'controls','button2','alarm',NULL,1),(20,9,0,'hasProperty','alarm','\"status\"','\"active\"',1),(20,10,0,'finishedAction','self.id',NULL,NULL,0),(21,0,0,'canReach','agent','waypoint',NULL,1),(21,1,0,'canReach','prisoner','button',NULL,1),(21,2,0,'hasPath','guard1','waypoint','trap',1),(21,3,0,'hasPath','guard2','waypoint','trap',1),(21,4,0,'hasPath','guard3','waypoint','trap',1),(21,5,0,'hasPath','guard4','waypoint','trap',1),(21,6,0,'hasProperty','trap','\"status\"','\"active\"',1),(21,7,0,'controls','button','trap',NULL,1),(21,8,0,'finishedAction','self.id',NULL,NULL,0),(24,0,0,'finishedAction','self.id',NULL,NULL,0),(26,0,0,'canReach','agent','guard',NULL,1),(26,1,0,'finishedAction','self.id',NULL,NULL,0),(35,0,0,'finishedAction','self.id',NULL,NULL,0),(38,0,0,'finishedAction','self.id',NULL,NULL,0),(40,0,0,'finishedAction','self.id',NULL,NULL,0),(40,1,0,'canReach','agent','prisoner',NULL,1),(40,2,0,'contains','agent','key',NULL,1),(41,0,0,'canReach','agent','prisoner',NULL,1),(41,1,0,'contains','agent','key',NULL,1),(41,2,0,'contains','prisoner','key',NULL,1),(41,3,0,'finishedAction','self.id',NULL,NULL,0),(43,0,0,'canReach','agent','door',NULL,1),(43,1,0,'getProperty','door','\"open\"','\"closed\"',1),(43,2,0,'getProperty','door','\"lock\"','\"locked\"',1),(43,3,0,'finishedAction','self.id',NULL,NULL,0),(44,0,0,'canReach','agent','door',NULL,1),(44,1,0,'getProperty','door','\"open\"','\"closed\"',1),(44,2,0,'getProperty','door','\"status\"','\"guarded\"',1),(44,3,0,'getProperty','door','\"lock\"','\"locked\"',1),(44,4,0,'finishedAction','self.id',NULL,NULL,0),(45,0,0,'finishedAction','self.id',NULL,NULL,0),(45,1,0,'canReach','agent','guard',NULL,1),(45,2,0,'contains','agent','key',NULL,1),(47,0,0,'canReach','agent','guard',NULL,1),(47,1,0,'contains','guard','key',NULL,1),(47,2,0,'getProperty','guard','\"status\"','\"dazed\"',1),(47,3,0,'contains','agent','key',NULL,1),(47,4,0,'finishedAction','self.id',NULL,NULL,0),(54,0,0,'canReach','agent','button',NULL,1),(54,1,0,'control','button','alarm',NULL,1),(54,2,0,'getProperty','alarm','\"status\"','\"active\"',1),(54,3,0,'finishedAction','self.id',NULL,NULL,0),(55,0,0,'canReach','agent','door',NULL,1),(55,1,0,'getProperty','door','\"open\"','\"open\"',1),(55,2,0,'finishedAction','self.id',NULL,NULL,0),(62,0,0,'guarded','door',NULL,NULL,1),(62,1,0,'canReach','agent','guard',NULL,1),(62,2,0,'canReach','prisoner1','waypoint1',NULL,1),(62,3,0,'canReach','prisoner2','waypoint2',NULL,1),(62,4,0,'finishedAction','self.id',NULL,'True',0);
/*!40000 ALTER TABLE `conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `obj_act`
--

DROP TABLE IF EXISTS `obj_act`;
/*!50001 DROP VIEW IF EXISTS `obj_act`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `obj_act` AS SELECT 
 1 AS `obj_id`,
 1 AS `act_id`,
 1 AS `obj_num`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `object`
--

DROP TABLE IF EXISTS `object`;
/*!50001 DROP VIEW IF EXISTS `object`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `object` AS SELECT 
 1 AS `obj_id`,
 1 AS `obj_name`,
 1 AS `is_agent`,
 1 AS `parent_id`,
 1 AS `wordnet_sense`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task` (
  `action_id` int(11) NOT NULL,
  `task_string` varchar(45) DEFAULT 'p',
  `exec_steps` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (1,'p',1),(5,'p',1),(10,'pppppa2ppa2a5',1),(12,'p',1),(16,'p',1),(19,'p',1),(20,'pppppj4a2pppppj4ppppj4pppppj4a5a2',1),(21,'pppppj4ppppj4pppppj4a5',1),(24,'p',1),(26,'p',1),(35,'p',1),(38,'p',1),(40,'p',1),(41,'ppa2',1),(43,'p',1),(44,'p',1),(45,'p',1),(47,'ppa2',1),(54,'pppppj4a2',1),(55,'p',1),(62,'pppa3',1);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_actions`
--

DROP TABLE IF EXISTS `task_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_actions` (
  `action_id` int(11) NOT NULL,
  `task_position` int(11) NOT NULL,
  `task_id` int(11) DEFAULT '0',
  PRIMARY KEY (`action_id`,`task_position`),
  CONSTRAINT `task_conn` FOREIGN KEY (`action_id`) REFERENCES `task` (`action_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_actions`
--

LOCK TABLES `task_actions` WRITE;
/*!40000 ALTER TABLE `task_actions` DISABLE KEYS */;
INSERT INTO `task_actions` VALUES (1,0,1),(5,0,5),(10,0,35),(10,1,8),(10,2,26),(10,3,38),(10,4,45),(10,5,5),(10,6,5),(12,0,12),(16,0,16),(19,0,19),(20,0,12),(20,1,38),(20,2,38),(20,3,38),(20,4,38),(20,5,38),(20,6,35),(20,7,35),(20,8,35),(20,9,35),(20,10,38),(20,11,38),(20,12,38),(20,13,38),(20,14,12),(20,15,19),(20,16,19),(20,17,19),(20,18,19),(21,0,38),(21,1,35),(21,2,35),(21,3,35),(21,4,35),(21,5,38),(21,6,38),(21,7,38),(21,8,38),(21,9,12),(21,10,19),(21,11,19),(21,12,19),(21,13,19),(24,0,24),(26,0,26),(35,0,35),(38,0,38),(40,0,40),(41,0,38),(41,1,40),(43,0,43),(44,0,44),(45,0,45),(47,0,38),(47,1,45),(54,0,12),(54,1,38),(54,2,38),(54,3,38),(54,4,38),(55,0,55),(62,0,1),(62,1,1),(62,2,24);
/*!40000 ALTER TABLE `task_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_obj`
--

DROP TABLE IF EXISTS `task_obj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_obj` (
  `act_id` int(11) NOT NULL,
  `task_position` int(11) NOT NULL,
  `task_act_pos` int(11) NOT NULL,
  `role` int(11) DEFAULT NULL,
  PRIMARY KEY (`act_id`,`task_position`,`task_act_pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_obj`
--

LOCK TABLES `task_obj` WRITE;
/*!40000 ALTER TABLE `task_obj` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_obj` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'parmanager'
--

--
-- Dumping routines for database 'parmanager'
--

--
-- Final view structure for view `action`
--

/*!50001 DROP VIEW IF EXISTS `action`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `action` AS select `openpardb`.`action`.`act_id` AS `act_id`,`openpardb`.`action`.`act_name` AS `act_name`,`openpardb`.`action`.`act_obj_num` AS `act_obj_num`,ifnull(`openpardb`.`action_parent`.`parent_id`,-(1)) AS `parent_id`,`openpardb`.`action`.`wordnet_sense` AS `wordnet_sense` from (`openpardb`.`action` left join `openpardb`.`action_parent` on((`openpardb`.`action`.`act_id` = `openpardb`.`action_parent`.`act_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `obj_act`
--

/*!50001 DROP VIEW IF EXISTS `obj_act`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `obj_act` AS select `openpardb`.`obj_act`.`obj_id` AS `obj_id`,`openpardb`.`obj_act`.`act_id` AS `act_id`,`openpardb`.`obj_act`.`obj_num` AS `obj_num` from `openpardb`.`obj_act` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `object`
--

/*!50001 DROP VIEW IF EXISTS `object`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `object` AS select `openpardb`.`object`.`obj_id` AS `obj_id`,`openpardb`.`object`.`obj_name` AS `obj_name`,`openpardb`.`object`.`is_agent` AS `is_agent`,`openpardb`.`object`.`parent_id` AS `parent_id`,`openpardb`.`object`.`wordnet_sense` AS `wordnet_sense` from `openpardb`.`object` where 1 */;
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

-- Dump completed on 2018-07-28 13:48:50
-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: openpardb
-- ------------------------------------------------------
-- Server version	5.7.17-log

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
-- Table structure for table `act_prop`
--

DROP TABLE IF EXISTS `act_prop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `act_prop` (
  `act_id` int(10) unsigned NOT NULL,
  `table_id` int(10) unsigned NOT NULL,
  `prop_value` int(11) NOT NULL,
  PRIMARY KEY (`act_id`,`table_id`,`prop_value`),
  KEY `tab_idx` (`table_id`),
  CONSTRAINT `act` FOREIGN KEY (`act_id`) REFERENCES `action` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tab` FOREIGN KEY (`table_id`) REFERENCES `property_type` (`prop_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_prop`
--

LOCK TABLES `act_prop` WRITE;
/*!40000 ALTER TABLE `act_prop` DISABLE KEYS */;
INSERT INTO `act_prop` VALUES (2,16,1),(2,16,2),(2,16,3),(2,16,4),(5,16,3),(5,16,4);
/*!40000 ALTER TABLE `act_prop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action`
--

DROP TABLE IF EXISTS `action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action` (
  `act_id` int(10) unsigned NOT NULL,
  `act_name` varchar(40) NOT NULL DEFAULT '',
  `act_appl_cond` varchar(40) DEFAULT NULL,
  `act_prep_spec` varchar(40) DEFAULT NULL,
  `act_exec_steps` varchar(40) DEFAULT NULL,
  `act_term_cond` varchar(40) DEFAULT NULL,
  `act_purpose_achieve` varchar(60) DEFAULT NULL,
  `act_dur_time_id` int(11) DEFAULT '-1',
  `act_obj_num` int(11) DEFAULT '-1',
  `act_site_type_id` int(11) DEFAULT '-1',
  `wordnet_sense` smallint(6) DEFAULT '-1',
  PRIMARY KEY (`act_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action`
--

LOCK TABLES `action` WRITE;
/*!40000 ALTER TABLE `action` DISABLE KEYS */;
INSERT INTO `action` VALUES (1,'Hide',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(2,'Connect',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(3,'Attach',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(4,'Fasten',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(5,'Lock',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(6,'Leave',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(7,'Scat',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(8,'Flee',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(9,'Escape',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(10,'EscapeCell',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,-1),(11,'Touch',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(12,'Press',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(13,'Analyze',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(14,'Check',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(15,'Watch',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(16,'Guard',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(17,'Get',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(18,'Capture',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,6),(19,'Trap',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(20,'TrapGuardsAlarm',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,-1),(21,'TrapGuards',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,-1),(22,'Change',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(23,'Desensitize',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(24,'Draw',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,16),(25,'Stun',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,3),(26,'Daze',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,-1),(27,'Move',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(28,'Transfer',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(29,'Convey',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,3),(30,'Communicate',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(31,'Request',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(32,'Ask',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(33,'Request',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(34,'Order',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(35,'Call',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,5),(36,'Travel',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(37,'Come',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(38,'Approach',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(39,'Transfer',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,5),(40,'Give',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,3),(41,'Exchange',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(43,'Open',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(44,'Unlock',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(45,'Take',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,21),(46,'Steal',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(47,'StealKey',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,-1),(48,'Act',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(49,'Interact',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(50,'Communicate',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(51,'Inform',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(52,'Warn',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(53,'Alarm',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(54,'SoundAlarm',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,-1),(55,'Close',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(56,'Make',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,3),(57,'Arouse',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(58,'Upset',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,2),(59,'Embarrass',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(60,'Confuse',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,3),(61,'Distract',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,1),(62,'DistractGuard',NULL,NULL,NULL,NULL,NULL,-1,-1,-1,-1);
/*!40000 ALTER TABLE `action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_parent`
--

DROP TABLE IF EXISTS `action_parent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_parent` (
  `act_id` int(10) unsigned NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`act_id`,`parent_id`),
  KEY `act_parent_parent_id_idx` (`parent_id`),
  CONSTRAINT `act_parent_act_id` FOREIGN KEY (`act_id`) REFERENCES `action` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `act_parent_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `action` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_parent`
--

LOCK TABLES `action_parent` WRITE;
/*!40000 ALTER TABLE `action_parent` DISABLE KEYS */;
INSERT INTO `action_parent` VALUES (3,2),(4,3),(5,4),(7,6),(8,7),(9,8),(10,9),(12,11),(14,13),(15,14),(16,15),(18,17),(19,18),(20,19),(21,19),(23,22),(24,22),(25,23),(26,25),(28,27),(29,28),(30,29),(31,30),(32,31),(33,32),(34,33),(35,34),(37,36),(38,37),(40,39),(41,39),(44,43),(46,45),(47,46),(49,48),(50,49),(51,50),(52,51),(53,52),(54,53),(57,56),(58,57),(59,58),(60,59),(61,60),(62,61);
/*!40000 ALTER TABLE `action_parent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adverb_exp`
--

DROP TABLE IF EXISTS `adverb_exp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adverb_exp` (
  `act_id` int(10) unsigned NOT NULL DEFAULT '0',
  `adverb_name` varchar(20) DEFAULT NULL,
  `adverb_mod_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`act_id`),
  CONSTRAINT `adverb_action` FOREIGN KEY (`act_id`) REFERENCES `action` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adverb_exp`
--

LOCK TABLES `adverb_exp` WRITE;
/*!40000 ALTER TABLE `adverb_exp` DISABLE KEYS */;
/*!40000 ALTER TABLE `adverb_exp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locked`
--

DROP TABLE IF EXISTS `locked`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locked` (
  `id_value` int(10) unsigned NOT NULL DEFAULT '0',
  `name_value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_value`),
  UNIQUE KEY `id_value_UNIQUE` (`id_value`),
  UNIQUE KEY `name_value_UNIQUE` (`name_value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locked`
--

LOCK TABLES `locked` WRITE;
/*!40000 ALTER TABLE `locked` DISABLE KEYS */;
INSERT INTO `locked` VALUES (1,'Lock'),(2,'Unlock');
/*!40000 ALTER TABLE `locked` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obj_act`
--

DROP TABLE IF EXISTS `obj_act`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obj_act` (
  `obj_id` int(10) unsigned NOT NULL DEFAULT '0',
  `act_id` int(10) unsigned NOT NULL DEFAULT '0',
  `obj_num` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`obj_id`,`act_id`,`obj_num`),
  KEY `Action` (`act_id`),
  CONSTRAINT `act_action` FOREIGN KEY (`act_id`) REFERENCES `action` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `act_object` FOREIGN KEY (`obj_id`) REFERENCES `object` (`obj_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obj_act`
--

LOCK TABLES `obj_act` WRITE;
/*!40000 ALTER TABLE `obj_act` DISABLE KEYS */;
INSERT INTO `obj_act` VALUES (17,1,0),(29,5,0),(18,10,0),(29,10,1),(31,12,0),(29,16,0),(23,19,0),(14,20,4),(18,20,0),(18,20,1),(18,20,2),(18,20,3),(23,20,6),(31,20,5),(31,20,7),(14,21,4),(17,21,7),(18,21,0),(18,21,1),(18,21,2),(18,21,3),(23,21,6),(31,21,5),(18,24,0),(18,26,0),(18,35,0),(1,38,0),(14,40,0),(21,40,1),(14,41,0),(21,41,1),(29,43,0),(21,44,1),(29,44,0),(18,45,0),(21,45,1),(18,47,0),(21,47,1),(18,54,0),(18,54,1),(18,54,2),(18,54,3),(24,54,4),(31,54,5),(29,55,0),(14,62,2),(14,62,3),(17,62,4),(17,62,5),(18,62,0),(29,62,1);
/*!40000 ALTER TABLE `obj_act` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obj_capable`
--

DROP TABLE IF EXISTS `obj_capable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obj_capable` (
  `obj_id` int(10) unsigned NOT NULL DEFAULT '0',
  `action_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`obj_id`,`action_id`) USING BTREE,
  KEY `Action` (`action_id`),
  CONSTRAINT `capable_action` FOREIGN KEY (`action_id`) REFERENCES `action` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `capable_object` FOREIGN KEY (`obj_id`) REFERENCES `object` (`obj_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obj_capable`
--

LOCK TABLES `obj_capable` WRITE;
/*!40000 ALTER TABLE `obj_capable` DISABLE KEYS */;
/*!40000 ALTER TABLE `obj_capable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obj_prop`
--

DROP TABLE IF EXISTS `obj_prop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obj_prop` (
  `obj_id` int(10) unsigned NOT NULL,
  `table_id` int(10) unsigned NOT NULL,
  `prop_value` int(11) NOT NULL,
  PRIMARY KEY (`prop_value`,`table_id`,`obj_id`),
  KEY `obj_idx` (`obj_id`),
  KEY `tab_idx` (`table_id`),
  CONSTRAINT `prop_obj` FOREIGN KEY (`obj_id`) REFERENCES `object` (`obj_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prop_table` FOREIGN KEY (`table_id`) REFERENCES `property_type` (`prop_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obj_prop`
--

LOCK TABLES `obj_prop` WRITE;
/*!40000 ALTER TABLE `obj_prop` DISABLE KEYS */;
INSERT INTO `obj_prop` VALUES (14,1,1),(14,1,3),(14,1,4),(14,1,5),(18,1,1),(18,1,2),(18,1,3),(18,1,4),(18,1,5),(23,1,3),(23,1,4),(24,1,3),(24,1,4),(29,2,1),(29,3,1),(29,2,2),(29,3,2),(29,1,6);
/*!40000 ALTER TABLE `obj_prop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obj_status`
--

DROP TABLE IF EXISTS `obj_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obj_status` (
  `id_value` int(10) unsigned NOT NULL DEFAULT '0',
  `name_value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_value`),
  UNIQUE KEY `id_value_UNIQUE` (`id_value`),
  UNIQUE KEY `name_value_UNIQUE` (`name_value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obj_status`
--

LOCK TABLES `obj_status` WRITE;
/*!40000 ALTER TABLE `obj_status` DISABLE KEYS */;
INSERT INTO `obj_status` VALUES (4,'BROKEN'),(8,'CLEARED'),(5,'EMPTY'),(6,'FULL'),(2,'IDLE'),(9,'NUM_STATUS'),(0,'OFF'),(1,'ON'),(3,'OPERATING'),(7,'UNCLEARED');
/*!40000 ALTER TABLE `obj_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object`
--

DROP TABLE IF EXISTS `object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object` (
  `obj_id` int(10) unsigned NOT NULL,
  `obj_name` varchar(40) NOT NULL,
  `is_agent` tinyint(1) DEFAULT '0',
  `parent_id` int(11) NOT NULL,
  `wordnet_sense` smallint(6) DEFAULT '-1',
  PRIMARY KEY (`obj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object`
--

LOCK TABLES `object` WRITE;
/*!40000 ALTER TABLE `object` DISABLE KEYS */;
INSERT INTO `object` VALUES (1,'Entity',0,-1,1),(2,'Physical_Entity',0,1,1),(3,'CausalAgent',1,2,1),(4,'Object',0,2,1),(5,'Person',0,3,1),(6,'Agent',1,3,1),(7,'Whole',0,4,2),(8,'Location',0,4,1),(9,'Preserver',0,5,3),(10,'Unfortunate',0,5,1),(11,'Artifact',0,7,1),(12,'Point',0,8,2),(13,'Defender',0,9,1),(14,'Prisoner',1,10,1),(15,'Instrumentality',0,11,3),(16,'Structure',0,11,1),(17,'WayPoint',0,12,-1),(18,'Guard',1,13,1),(19,'Device',0,15,1),(20,'Obstruction',0,16,1),(21,'Key',0,19,1),(22,'Mechanism',0,19,5),(23,'Trap',0,19,1),(24,'Alarm',0,19,2),(25,'Barrier',0,20,1),(26,'Control',0,22,9),(27,'MovableBarrier',0,25,1),(28,'Switch',0,26,1),(29,'Door',0,27,1),(30,'PushButton',0,28,1),(31,'Button',0,30,-1);
/*!40000 ALTER TABLE `object` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open`
--

DROP TABLE IF EXISTS `open`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `open` (
  `id_value` int(10) unsigned NOT NULL DEFAULT '0',
  `name_value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_value`),
  UNIQUE KEY `id_value_UNIQUE` (`id_value`),
  UNIQUE KEY `name_value_UNIQUE` (`name_value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open`
--

LOCK TABLES `open` WRITE;
/*!40000 ALTER TABLE `open` DISABLE KEYS */;
INSERT INTO `open` VALUES (2,'close'),(1,'open');
/*!40000 ALTER TABLE `open` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_type`
--

DROP TABLE IF EXISTS `property_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `property_type` (
  `prop_id` int(10) unsigned NOT NULL,
  `prop_name` varchar(45) DEFAULT NULL,
  `is_int` tinyint(1) DEFAULT '1',
  `omega` int(11) DEFAULT '0' COMMENT '''Omega determines if the property is an action property, and object property, or can work for both. Values in PAR''''s system are:\n0 is object (default)\n1 is action\n2 is both''',
  PRIMARY KEY (`prop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_type`
--

LOCK TABLES `property_type` WRITE;
/*!40000 ALTER TABLE `property_type` DISABLE KEYS */;
INSERT INTO `property_type` VALUES (1,'status',0,0),(2,'open',0,0),(3,'lock',0,0);
/*!40000 ALTER TABLE `property_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site`
--

DROP TABLE IF EXISTS `site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site` (
  `obj_id` int(10) unsigned NOT NULL,
  `site_type_id` int(10) unsigned NOT NULL,
  `site_pos_x` float DEFAULT NULL,
  `site_pos_y` float DEFAULT NULL,
  `site_pos_z` float DEFAULT NULL,
  `site_orient_x` float DEFAULT NULL,
  `site_orient_y` float DEFAULT NULL,
  `site_orient_z` float DEFAULT NULL,
  `site_shape_id` int(11) DEFAULT '-1',
  PRIMARY KEY (`obj_id`,`site_type_id`),
  KEY `site_type` (`site_type_id`),
  CONSTRAINT `object_check` FOREIGN KEY (`obj_id`) REFERENCES `object` (`obj_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `site_type` FOREIGN KEY (`site_type_id`) REFERENCES `site_type` (`site_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site`
--

LOCK TABLES `site` WRITE;
/*!40000 ALTER TABLE `site` DISABLE KEYS */;
/*!40000 ALTER TABLE `site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_shape`
--

DROP TABLE IF EXISTS `site_shape`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_shape` (
  `site_shape_id` int(11) NOT NULL,
  `shape_type` varchar(45) DEFAULT 'box',
  `first_coord` float DEFAULT '0.1',
  `second_coord` float DEFAULT '0.1',
  `third_coord` float DEFAULT '0.1',
  PRIMARY KEY (`site_shape_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_shape`
--

LOCK TABLES `site_shape` WRITE;
/*!40000 ALTER TABLE `site_shape` DISABLE KEYS */;
INSERT INTO `site_shape` VALUES (1,'box',1,1,1),(2,'capsule',30,50,50);
/*!40000 ALTER TABLE `site_shape` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_type`
--

DROP TABLE IF EXISTS `site_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_type` (
  `site_type_id` int(10) unsigned NOT NULL,
  `site_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`site_type_id`),
  UNIQUE KEY `site_name_UNIQUE` (`site_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_type`
--

LOCK TABLES `site_type` WRITE;
/*!40000 ALTER TABLE `site_type` DISABLE KEYS */;
INSERT INTO `site_type` VALUES (3,'grasp'),(2,'inspect'),(0,'operate'),(1,'orient_only');
/*!40000 ALTER TABLE `site_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `status` (
  `id_value` int(10) unsigned NOT NULL DEFAULT '0',
  `name_value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_value`),
  UNIQUE KEY `id_value_UNIQUE` (`id_value`),
  UNIQUE KEY `name_value_UNIQUE` (`name_value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (4,'Active'),(2,'Dazed'),(1,'Free'),(6,'Guarded'),(3,'Idle'),(5,'Trapped');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'openpardb'
--

--
-- Dumping routines for database 'openpardb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-07-28 13:48:51
