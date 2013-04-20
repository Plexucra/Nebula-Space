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
-- Temporary table structure for view `v_grundstueck`
--

DROP TABLE IF EXISTS `v_grundstueck`;
/*!50001 DROP VIEW IF EXISTS `v_grundstueck`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_grundstueck` (
  `id` bigint(20) unsigned,
  `sektorId` bigint(20),
  `besitzerNutzerId` int(10) unsigned,
  `typId` int(10) unsigned,
  `produktId` int(11),
  `istEndprodukt` tinyint(4),
  `kapazitaet` int(10) unsigned,
  `x` int(10) unsigned,
  `y` int(10) unsigned
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_grundstueck_detail`
--

DROP TABLE IF EXISTS `v_grundstueck_detail`;
/*!50001 DROP VIEW IF EXISTS `v_grundstueck_detail`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_grundstueck_detail` (
  `id` bigint(20) unsigned,
  `x` int(10) unsigned,
  `y` int(10) unsigned,
  `sektorId` bigint(20) unsigned,
  `besitzerNutzerAlias` varchar(45),
  `besitzerNutzerId` int(10) unsigned,
  `auslastung` bigint(20) unsigned,
  `gebaeudeId` bigint(20) unsigned,
  `einnahmen` bigint(20) unsigned,
  `ausgaben` bigint(20) unsigned,
  `alter` bigint(20) unsigned,
  `effizienz` float,
  `modellId` bigint(20) unsigned,
  `modellBezeichnung` varchar(45),
  `typId` int(10) unsigned,
  `typBezeichnung` varchar(45),
  `produktBezeichnung` varchar(45),
  `produktId` int(11),
  `kapazitaet` int(10) unsigned,
  `tiefe` int(10) unsigned,
  `breite` int(10) unsigned
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_modell`
--

DROP TABLE IF EXISTS `v_modell`;
/*!50001 DROP VIEW IF EXISTS `v_modell`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_modell` (
  `id` bigint(20) unsigned,
  `bezeichnung` varchar(45),
  `typId` int(10) unsigned,
  `typBezeichnung` varchar(45),
  `produktId` int(11),
  `produktBezeichnung` varchar(45),
  `kapazitaet` int(10) unsigned,
  `tiefe` int(10) unsigned,
  `breite` int(10) unsigned,
  `besitzerNutzerId` int(10),
  `erstellerNutzerId` int(10) unsigned
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_grundstueck`
--

/*!50001 DROP TABLE IF EXISTS `v_grundstueck`*/;
/*!50001 DROP VIEW IF EXISTS `v_grundstueck`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_grundstueck` AS select `g`.`id` AS `id`,`s`.`id` AS `sektorId`,`gebaeude`.`besitzerNutzerId` AS `besitzerNutzerId`,`modell`.`typId` AS `typId`,`modell`.`produktId` AS `produktId`,`produkt`.`istEndprodukt` AS `istEndprodukt`,`modell`.`kapazitaet` AS `kapazitaet`,`g`.`x` AS `x`,`g`.`y` AS `y` from ((((`grundstueck` `g` join `sektor` `s` on((`s`.`id` = `g`.`sektorId`))) join `gebaeude` on((`gebaeude`.`id` = `g`.`gebaeudeId`))) join `modell` on((`modell`.`id` = `gebaeude`.`modellId`))) left join `produkt` on((`produkt`.`id` = `modell`.`produktId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_grundstueck_detail`
--

/*!50001 DROP TABLE IF EXISTS `v_grundstueck_detail`*/;
/*!50001 DROP VIEW IF EXISTS `v_grundstueck_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_grundstueck_detail` AS select `grundstueck`.`id` AS `id`,`grundstueck`.`x` AS `x`,`grundstueck`.`y` AS `y`,`grundstueck`.`sektorId` AS `sektorId`,`nutzer`.`alias` AS `besitzerNutzerAlias`,`nutzer`.`id` AS `besitzerNutzerId`,`gebaeude`.`auslastung` AS `auslastung`,`gebaeude`.`id` AS `gebaeudeId`,`gebaeude`.`einnahmen` AS `einnahmen`,`gebaeude`.`ausgaben` AS `ausgaben`,`gebaeude`.`alter` AS `alter`,`gebaeude`.`effizienz` AS `effizienz`,`v_modell`.`id` AS `modellId`,`v_modell`.`bezeichnung` AS `modellBezeichnung`,`v_modell`.`typId` AS `typId`,`v_modell`.`typBezeichnung` AS `typBezeichnung`,`v_modell`.`produktBezeichnung` AS `produktBezeichnung`,`v_modell`.`produktId` AS `produktId`,`v_modell`.`kapazitaet` AS `kapazitaet`,`v_modell`.`tiefe` AS `tiefe`,`v_modell`.`breite` AS `breite` from (((`grundstueck` join `gebaeude` on((`gebaeude`.`id` = `grundstueck`.`gebaeudeId`))) join `nutzer` on((`nutzer`.`id` = `gebaeude`.`besitzerNutzerId`))) join `v_modell` on((`v_modell`.`id` = `gebaeude`.`modellId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_modell`
--

/*!50001 DROP TABLE IF EXISTS `v_modell`*/;
/*!50001 DROP VIEW IF EXISTS `v_modell`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_modell` AS select `modell`.`id` AS `id`,`modell`.`bezeichnung` AS `bezeichnung`,`modell`.`typId` AS `typId`,`typ`.`bezeichnung` AS `typBezeichnung`,`modell`.`produktId` AS `produktId`,`produkt`.`bezeichnung` AS `produktBezeichnung`,`modell`.`kapazitaet` AS `kapazitaet`,`modell`.`tiefe` AS `tiefe`,`modell`.`breite` AS `breite`,`modell`.`besitzerNutzerId` AS `besitzerNutzerId`,`modell`.`erstellerNutzerId` AS `erstellerNutzerId` from ((`modell` join `typ` on((`typ`.`id` = `modell`.`typId`))) left join `produkt` on((`produkt`.`id` = `modell`.`produktId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping routines for database 'colony'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-10 18:40:26
