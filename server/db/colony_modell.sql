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
-- Table structure for table `modell`
--

DROP TABLE IF EXISTS `modell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modell` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `typId` int(10) unsigned NOT NULL,
  `bezeichnung` varchar(45) DEFAULT NULL,
  `stockwerke` int(10) unsigned NOT NULL,
  `tiefe` int(10) unsigned NOT NULL,
  `breite` int(10) unsigned NOT NULL,
  `anzahlBewertungen` int(10) unsigned NOT NULL DEFAULT '0',
  `bewertung` bigint(20) unsigned NOT NULL DEFAULT '0',
  `erstellerNutzerId` int(10) unsigned NOT NULL,
  `produktId` int(11) DEFAULT NULL,
  `kapazitaet` int(10) unsigned NOT NULL DEFAULT '0',
  `besitzerNutzerId` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modell`
--

LOCK TABLES `modell` WRITE;
/*!40000 ALTER TABLE `modell` DISABLE KEYS */;
INSERT INTO `modell` VALUES (1,3,'Wohnhaus',5,1,1,0,0,2,NULL,100,1),(2,2,'automatisierte Weizenfarm',4,1,1,0,0,2,5,30,1),(3,1,'Verwaltung',9,1,1,0,0,2,NULL,9,1);
/*!40000 ALTER TABLE `modell` ENABLE KEYS */;
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
