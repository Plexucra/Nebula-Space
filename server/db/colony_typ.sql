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
-- Table structure for table `typ`
--

DROP TABLE IF EXISTS `typ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `typ` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(45) NOT NULL,
  `beschreibung` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `typ`
--

LOCK TABLES `typ` WRITE;
/*!40000 ALTER TABLE `typ` DISABLE KEYS */;
INSERT INTO `typ` VALUES (1,'Sektorverwaltung','Jeder Sektor benötigt ein staatliches Verwaltungsgebäude. Ein Neubau kann auf staatliche Kosten neu ausgeschrieben werden.'),(2,'Konsumgebäude','Produktion, Weiterentwicklung und Erforschung von Konsumgütern oder Dienstleistungen'),(3,'Wohngebäude','Wird zur Miete von N- vielen Mietern bewohnt.'),(4,'Firmenzentrale','Wird bei großen Firmen zur Verwaltung benötigt. Für jeweils etwa 30 Gebäude die im Firmenbesitz sind, wird eine Firmenzentrale benötigt.'),(5,'Bildungseinrichtung','Beeinhaltet je nach Bedarf vom Kindergarten bis zur Universität alles was mit Bildung zu tun hat'),(6,'öffentliche Daseinsführsorge','Alle unkommerziellen staatlich betriebenen Gebäude die für die Lebensgestaltung der Menschen nötig sind. (Z.B. Parks, Theater..)');
/*!40000 ALTER TABLE `typ` ENABLE KEYS */;
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
