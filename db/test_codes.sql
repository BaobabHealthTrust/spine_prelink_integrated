-- MySQL dump 10.13  Distrib 5.5.28, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: prelink_gateway
-- ------------------------------------------------------
-- Server version	5.5.28-0ubuntu0.12.10.1

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
-- Table structure for table `test_codes`
--

DROP TABLE IF EXISTS `test_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_codes` (
  `test_code` varchar(255) DEFAULT NULL,
  `test_name` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_codes`
--

LOCK TABLES `test_codes` WRITE;
/*!40000 ALTER TABLE `test_codes` DISABLE KEYS */;
INSERT INTO `test_codes` VALUES ('08B','Albumin',1),('35A','Alkaline Phosphatase',2),('31A','ALT',3),('30A','AST',4),('BA#','Basophils#',5),('BA%','Basophils%',6),('12A','Bilirubin Direct',7),('','Bilirubin Indirect',8),('11A','Bilirubin Total',9),('','Blood parasite (non-Malaria)',10),('','BM BCULT',11),('44A','Cholesterol',12),('','Ciprofloxacin Etest',13),('','Comment',14),('MCA','CRAG Test',15),('03F','Creatinine',16),('89A','CRP',17),('','Cryptosporidium oocysts',18),('','CSF Indian Ink',19),('','CTXT',20),('EO#','Eosinophils#',21),('EO%','Eosinophils%',22),('','Gene Xpert MTB Blood',23),('','Gene Xpert MTB sputum',24),('','Gene Xpert Rif blood',25),('','Gene Xpert Rif sputum',26),('36A','GGT',27),('06A','Glucose random',28),('06A','Glucose random (serum)',29),('HCT','Haematocrit',30),('','Haematology blood film made?',31),('HB','Haemoglobin',32),('A1c','Haemoglobin A1c (CX5)',33),('Hb','Haemoglobin Hb (CX5)',34),('83D','HDL Cholesterol',35),('','Hepatitis B Surface Antigen (RT)',36),('','Hepatitis C  (RT)',37),('','HIV Abbott Viral Load 0.2ml CSF',38),('HIV0.2ml','HIV Abbott Viral Load 0.2ml PLASMA',39),('HIVAMPLICORPCRQUAL','HIV DNA PCR',40),('','HIV DNA PCR cell processing',41),('HIVAMPLICORPCRQUAL','HIV DNA PCR Confirmatory',42),('HIVD','HIV Rapid Test',43),('','HIV Vironostika Elisa',44),('HSV2KALON','HSV-2 KALON ELISA',45),('','HTXT',46),('83D','LDH',47),('34B','LDL Cholesterol',48),('LY#','Lymphocytes#',49),('LY%','Lymphocytes%',50),('48A','Magnesium',51),('','Mal P falciparum trophs/500 RBCs',52),('MALTHICK','Malaria Thick Film',53),('','malaria thick parasitaemia',54),('MCH','MCH',55),('MCHC','MCHC',56),('MCV','MCV',57),('MRETVol','Mean Reticulocyte Volume',58),('MO#','Monocytes#',59),('MO%','Monocytes%',60),('MPV','MPV',61),('01A','NA',62),('NE#','Neutrophils#',63),('NE%','Neutrophils%',64),('','PCV',65),('PLT','Platelets',66),('','Pneumococcus Isolation',67),('01B','Potassium',68),('07A','Protein Pleural',69),('','RCC',70),('RDW','RDW',71),('RBC','Red Cell Count',72),('RET%','Retic',73),('','Rotavirus ELISA',74),('','Specimen rejection',75),('','Stool Appearance',76),('','Stool Microscopy',77),('','Stool RBC',78),('','Stool WBC',79),('','Store Aliquot',80),('','Streptococcus pneumoniae, BAL',81),('','Streptococcus Pneumoniae, PNS',82),('','TB culture blood',83),('','TB Culture Identification',84),('','TB Culture Sputum',85),('','TB Culture Sterile fluid',86),('','TB LJ Culture',87),('','TB MGIT Culture',88),('','TB Rapid Test',89),('','TB Smear Microscopy(AFB) other',90),('','TB Smear Microscopy(AFB) pf',91),('','TB Smear Microscopy(AFB) sputum',92),('','TB Smear Microscopy(AFB) sterile fluid',93),('','TB TLA Culture',94),('TIBC','TIBC',95),('TPPA','TPPA FUJIREBIO',96),('42B','Triglycerides',97),('UREA','Urea',98),('','Urine ACR',99),('08M','Urine albumin',100),('03F','Urine Creatinine ',101),('','Urine pregnancy test',102),('WBC','WCC ',103);
/*!40000 ALTER TABLE `test_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-11-23 16:47:33
