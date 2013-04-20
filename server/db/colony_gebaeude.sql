CREATE DATABASE  IF NOT EXISTS `colony` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `colony`;
-- MySQL dump 10.13  Distrib 5.1.40, for Win32 (ia32)
--
-- Host: localhost    Database: colony
-- ------------------------------------------------------
-- Server version	5.5.9

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
-- Table structure for table `gebaeude`
--

DROP TABLE IF EXISTS `gebaeude`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gebaeude` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `modellId` bigint(20) unsigned NOT NULL,
  `besitzerNutzerId` int(10) unsigned NOT NULL DEFAULT '0',
  `alter` bigint(20) unsigned NOT NULL DEFAULT '0',
  `einnahmen` bigint(20) unsigned NOT NULL DEFAULT '0',
  `ausgaben` bigint(20) unsigned NOT NULL DEFAULT '0',
  `auslastung` bigint(20) unsigned NOT NULL DEFAULT '0',
  `effizienz` float NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gebaeude`
--

LOCK TABLES `gebaeude` WRITE;
/*!40000 ALTER TABLE `gebaeude` DISABLE KEYS */;
INSERT INTO `gebaeude` VALUES (1,1,1,0,0,0,100,1),(2,2,2,1,0,0,0,1),(3,3,1,1,0,0,0,1),(5,1,1,0,0,0,100,1),(6,2,1,0,0,0,0,1),(7,3,1,0,0,0,0,1),(8,1,1,0,0,0,100,1),(9,1,1,0,0,0,100,1),(10,2,1,0,0,0,0,1);
/*!40000 ALTER TABLE `gebaeude` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-10 18:40:25
