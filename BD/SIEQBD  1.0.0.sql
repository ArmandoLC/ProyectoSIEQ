CREATE DATABASE  IF NOT EXISTS `SIEQ` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `SIEQ`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: SIEQ
-- ------------------------------------------------------
-- Server version	5.7.21-log

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
-- Table structure for table `Articulo`
--

DROP TABLE IF EXISTS `Articulo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Articulo` (
  `ArticuloID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Ubicacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CantidadActual` double NOT NULL,
  `PuntoReorden` double NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TipoArticulo` int(11) NOT NULL,
  `Visible` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ArticuloID`),
  UNIQUE KEY `ArticuloID_UNIQUE` (`ArticuloID`),
  KEY `FK_TipoArticulo_idx` (`TipoArticulo`),
  CONSTRAINT `FK_TipoArticulo` FOREIGN KEY (`TipoArticulo`) REFERENCES `TipoArticulo` (`TipoArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Articulo`
--

LOCK TABLES `Articulo` WRITE;
/*!40000 ALTER TABLE `Articulo` DISABLE KEYS */;
/*!40000 ALTER TABLE `Articulo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CategoriaReactivo`
--

DROP TABLE IF EXISTS `CategoriaReactivo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CategoriaReactivo` (
  `CategoriaReactivoID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CategoriaReactivoID`),
  UNIQUE KEY `CategoriaReactivoID_UNIQUE` (`CategoriaReactivoID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CategoriaReactivo`
--

LOCK TABLES `CategoriaReactivo` WRITE;
/*!40000 ALTER TABLE `CategoriaReactivo` DISABLE KEYS */;
INSERT INTO `CategoriaReactivo` VALUES (1,'General'),(2,'Oxidante'),(3,'Infalmable'),(4,'Corrosivo');
/*!40000 ALTER TABLE `CategoriaReactivo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Chat`
--

DROP TABLE IF EXISTS `Chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Chat` (
  `ChatID` int(11) NOT NULL AUTO_INCREMENT,
  `UsuarioAID` int(11) NOT NULL,
  `UsuarioBID` int(11) NOT NULL,
  PRIMARY KEY (`ChatID`),
  UNIQUE KEY `ChatID_UNIQUE` (`ChatID`),
  UNIQUE KEY `UK_Usuarios` (`UsuarioAID`,`UsuarioBID`),
  KEY `FK_UsuarioA_idx` (`UsuarioAID`),
  KEY `FK_UsuarioB_idx` (`UsuarioBID`),
  CONSTRAINT `FK_UsuarioA` FOREIGN KEY (`UsuarioAID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UsuarioB` FOREIGN KEY (`UsuarioBID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Chat`
--

LOCK TABLES `Chat` WRITE;
/*!40000 ALTER TABLE `Chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `Chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EstadoNotificacion`
--

DROP TABLE IF EXISTS `EstadoNotificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EstadoNotificacion` (
  `EstadoNotifiacionID` int(11) NOT NULL AUTO_INCREMENT,
  `NotificacionGeneralID` int(11) NOT NULL,
  `UsuarioID` int(11) NOT NULL,
  `Visible` bit(1) NOT NULL DEFAULT b'1',
  `Leida` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`EstadoNotifiacionID`),
  UNIQUE KEY `EstadoNotifiacionID_UNIQUE` (`EstadoNotifiacionID`),
  KEY `FK_UsuarioNotificado_idx` (`UsuarioID`),
  KEY `FK_NotificacionGeneral_idx` (`NotificacionGeneralID`),
  CONSTRAINT `FK_NotificacionGeneral` FOREIGN KEY (`NotificacionGeneralID`) REFERENCES `NotificacionGeneral` (`NotificacionGeneralID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UsuarioNotificado` FOREIGN KEY (`UsuarioID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EstadoNotificacion`
--

LOCK TABLES `EstadoNotificacion` WRITE;
/*!40000 ALTER TABLE `EstadoNotificacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `EstadoNotificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EstadoUsuario`
--

DROP TABLE IF EXISTS `EstadoUsuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EstadoUsuario` (
  `EstadoUsuarioID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`EstadoUsuarioID`),
  UNIQUE KEY `EstadoUsuarioID_UNIQUE` (`EstadoUsuarioID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EstadoUsuario`
--

LOCK TABLES `EstadoUsuario` WRITE;
/*!40000 ALTER TABLE `EstadoUsuario` DISABLE KEYS */;
INSERT INTO `EstadoUsuario` VALUES (1,'Activo','El usuario puede acceder normalmente a su cuenta'),(2,'Inactivo','El usuario no puede acceder normalmente a su cuenta'),(3,'Pendiente','El usuario no ha sido aprobado por el cliente');
/*!40000 ALTER TABLE `EstadoUsuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ListaNegraNotificacionPorUsuario`
--

DROP TABLE IF EXISTS `ListaNegraNotificacionPorUsuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ListaNegraNotificacionPorUsuario` (
  `ListaNegraNotificacionPorUsuarioID` int(11) NOT NULL AUTO_INCREMENT,
  `ArticuloID` int(11) NOT NULL,
  `UsuarioID` int(11) NOT NULL,
  PRIMARY KEY (`ListaNegraNotificacionPorUsuarioID`),
  UNIQUE KEY `NotificacionDesactivadaID_UNIQUE` (`ListaNegraNotificacionPorUsuarioID`),
  KEY `FK_Usuario_idx` (`UsuarioID`),
  KEY `FK_Usuario_idx1` (`ArticuloID`),
  CONSTRAINT `FK_ArticuloNotificado` FOREIGN KEY (`ArticuloID`) REFERENCES `Articulo` (`ArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Usuario` FOREIGN KEY (`UsuarioID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ListaNegraNotificacionPorUsuario`
--

LOCK TABLES `ListaNegraNotificacionPorUsuario` WRITE;
/*!40000 ALTER TABLE `ListaNegraNotificacionPorUsuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `ListaNegraNotificacionPorUsuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MensajeChat`
--

DROP TABLE IF EXISTS `MensajeChat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MensajeChat` (
  `MensajeChatID` int(11) NOT NULL AUTO_INCREMENT,
  `ChatID` int(11) NOT NULL,
  `UsuarioEmisorID` int(11) NOT NULL,
  `FechaHora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`MensajeChatID`),
  UNIQUE KEY `MensajeChatID_UNIQUE` (`MensajeChatID`),
  KEY `FK_UsuarioEmisor_idx` (`UsuarioEmisorID`),
  KEY `FK_Chat_idx` (`ChatID`),
  CONSTRAINT `FK_Chat` FOREIGN KEY (`ChatID`) REFERENCES `Chat` (`ChatID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UsuarioEmisor` FOREIGN KEY (`UsuarioEmisorID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MensajeChat`
--

LOCK TABLES `MensajeChat` WRITE;
/*!40000 ALTER TABLE `MensajeChat` DISABLE KEYS */;
/*!40000 ALTER TABLE `MensajeChat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Movimiento`
--

DROP TABLE IF EXISTS `Movimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Movimiento` (
  `MovimientoID` int(11) NOT NULL AUTO_INCREMENT,
  `Fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TipoMovimientoID` int(11) NOT NULL,
  `UsuarioAutorizadorID` int(11) NOT NULL,
  `CantidadAntes` float NOT NULL,
  `CantidadDespues` float NOT NULL,
  `Destino` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Observaciones` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`MovimientoID`),
  UNIQUE KEY `MovimientoID_UNIQUE` (`MovimientoID`),
  KEY `FK_TipoMovimiento_idx` (`TipoMovimientoID`),
  KEY `FK_UsuarioAutorizador_idx` (`UsuarioAutorizadorID`),
  CONSTRAINT `FK_TipoMovimiento` FOREIGN KEY (`TipoMovimientoID`) REFERENCES `TipoMovimiento` (`TipoMovimientoID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UsuarioAutorizadorID` FOREIGN KEY (`UsuarioAutorizadorID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Movimiento`
--

LOCK TABLES `Movimiento` WRITE;
/*!40000 ALTER TABLE `Movimiento` DISABLE KEYS */;
/*!40000 ALTER TABLE `Movimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NotificacionGeneral`
--

DROP TABLE IF EXISTS `NotificacionGeneral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NotificacionGeneral` (
  `NotificacionGeneralID` int(11) NOT NULL AUTO_INCREMENT,
  `TipoNotificacionID` int(11) NOT NULL,
  `Texto` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`NotificacionGeneralID`),
  UNIQUE KEY `NotificacionGeneral_UNIQUE` (`NotificacionGeneralID`),
  KEY `FK_TipoNotificacion_idx` (`TipoNotificacionID`),
  CONSTRAINT `FK_TipoNotificacion` FOREIGN KEY (`TipoNotificacionID`) REFERENCES `TipoNotificacion` (`TipoNotificacionID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NotificacionGeneral`
--

LOCK TABLES `NotificacionGeneral` WRITE;
/*!40000 ALTER TABLE `NotificacionGeneral` DISABLE KEYS */;
/*!40000 ALTER TABLE `NotificacionGeneral` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pedido`
--

DROP TABLE IF EXISTS `Pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Pedido` (
  `PedidoID` int(11) NOT NULL AUTO_INCREMENT,
  `Titulo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ArticuloID` int(11) NOT NULL,
  `UsuarioSolicitanteID` int(11) NOT NULL,
  `CantidadSolicitada` float NOT NULL,
  `Observacion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`PedidoID`),
  UNIQUE KEY `PedidoID_UNIQUE` (`PedidoID`),
  KEY `FK_Articulo_idx` (`ArticuloID`),
  KEY `FK_UsuarioSolicitante_idx` (`UsuarioSolicitanteID`),
  CONSTRAINT `FK_ArticuloPedido` FOREIGN KEY (`ArticuloID`) REFERENCES `Articulo` (`ArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UsuarioSolicitantePedido` FOREIGN KEY (`UsuarioSolicitanteID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pedido`
--

LOCK TABLES `Pedido` WRITE;
/*!40000 ALTER TABLE `Pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Prestamo`
--

DROP TABLE IF EXISTS `Prestamo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Prestamo` (
  `PrestamoID` int(11) NOT NULL AUTO_INCREMENT,
  `UsuarioSolicitanteID` int(11) NOT NULL,
  `ArticuloID` int(11) NOT NULL,
  `UsuarioAutorizadorID` int(11) NOT NULL,
  `CantidadSolicitada` float NOT NULL,
  `FechaSolicitud` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `FechaAutorizacion` datetime DEFAULT NULL,
  `MovimientoEntregaID` int(11) DEFAULT NULL,
  `MovimientoDevolucionID` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`PrestamoID`),
  UNIQUE KEY `PrestamoID_UNIQUE` (`PrestamoID`),
  KEY `FK_UsuarioSolicitante_idx` (`UsuarioSolicitanteID`),
  KEY `FK_Articulo_idx` (`ArticuloID`),
  KEY `FK_UsuarioAutorizador_idx` (`UsuarioAutorizadorID`),
  CONSTRAINT `FK_ArticuloAsociado` FOREIGN KEY (`ArticuloID`) REFERENCES `Articulo` (`ArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UsuarioAutorizador` FOREIGN KEY (`UsuarioAutorizadorID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UsuarioSolicitante` FOREIGN KEY (`UsuarioSolicitanteID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Prestamo`
--

LOCK TABLES `Prestamo` WRITE;
/*!40000 ALTER TABLE `Prestamo` DISABLE KEYS */;
/*!40000 ALTER TABLE `Prestamo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reactivo`
--

DROP TABLE IF EXISTS `Reactivo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Reactivo` (
  `ReactivoID` int(11) NOT NULL AUTO_INCREMENT,
  `ArticuloID` int(11) NOT NULL,
  `EsPrecursor` bit(1) NOT NULL,
  `UnidadMetricaID` int(11) NOT NULL,
  `Categoria` int(11) NOT NULL,
  `URLHojaSeguridad` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ReactivoID`),
  UNIQUE KEY `ReactivoID_UNIQUE` (`ReactivoID`),
  KEY `FK_Articulo_idx` (`ArticuloID`),
  KEY `FK_UnidadMetrica_idx` (`UnidadMetricaID`),
  KEY `FK_Categoria_idx` (`Categoria`),
  CONSTRAINT `FK_Articulo` FOREIGN KEY (`ArticuloID`) REFERENCES `Articulo` (`ArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Categoria` FOREIGN KEY (`Categoria`) REFERENCES `CategoriaReactivo` (`CategoriaReactivoID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UnidadMetrica` FOREIGN KEY (`UnidadMetricaID`) REFERENCES `UnidadMetrica` (`UnidadMetricaID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reactivo`
--

LOCK TABLES `Reactivo` WRITE;
/*!40000 ALTER TABLE `Reactivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `Reactivo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rol`
--

DROP TABLE IF EXISTS `Rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Rol` (
  `RolID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`RolID`),
  UNIQUE KEY `RolID_UNIQUE` (`RolID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rol`
--

LOCK TABLES `Rol` WRITE;
/*!40000 ALTER TABLE `Rol` DISABLE KEYS */;
INSERT INTO `Rol` VALUES (1,'Coordinador','Tiene permisos de todo menos administrar cuentas'),(2,'Administrador','Tiene permisos de todo');
/*!40000 ALTER TABLE `Rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoArticulo`
--

DROP TABLE IF EXISTS `TipoArticulo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TipoArticulo` (
  `TipoArticuloID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`TipoArticuloID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoArticulo`
--

LOCK TABLES `TipoArticulo` WRITE;
/*!40000 ALTER TABLE `TipoArticulo` DISABLE KEYS */;
INSERT INTO `TipoArticulo` VALUES (1,'Reactivo','Artículo del inventario relacionado a químicos.'),(2,'Cristalería','Artículo que no está relacionado a algún químico.');
/*!40000 ALTER TABLE `TipoArticulo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoMovimiento`
--

DROP TABLE IF EXISTS `TipoMovimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TipoMovimiento` (
  `TipoMovimientoID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`TipoMovimientoID`),
  UNIQUE KEY `TipoPrestamoID_UNIQUE` (`TipoMovimientoID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoMovimiento`
--

LOCK TABLES `TipoMovimiento` WRITE;
/*!40000 ALTER TABLE `TipoMovimiento` DISABLE KEYS */;
INSERT INTO `TipoMovimiento` VALUES (1,'Ingreso','Se le suma al total de un reactivo.'),(2,'Salida','Se extrae del total de un reactivo.');
/*!40000 ALTER TABLE `TipoMovimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoNotificacion`
--

DROP TABLE IF EXISTS `TipoNotificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TipoNotificacion` (
  `TipoNotificacionID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`TipoNotificacionID`),
  UNIQUE KEY `TipoNotificacionID_UNIQUE` (`TipoNotificacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoNotificacion`
--

LOCK TABLES `TipoNotificacion` WRITE;
/*!40000 ALTER TABLE `TipoNotificacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `TipoNotificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UnidadMetrica`
--

DROP TABLE IF EXISTS `UnidadMetrica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UnidadMetrica` (
  `UnidadMetricaID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Siglas` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`UnidadMetricaID`),
  UNIQUE KEY `UnidadesMetricasID_UNIQUE` (`UnidadMetricaID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UnidadMetrica`
--

LOCK TABLES `UnidadMetrica` WRITE;
/*!40000 ALTER TABLE `UnidadMetrica` DISABLE KEYS */;
INSERT INTO `UnidadMetrica` VALUES (1,'gramo','g'),(2,'litro','l'),(3,'metro','m'),(4,'metro cuadrado','m2'),(5,'metro cúbico','m3');
/*!40000 ALTER TABLE `UnidadMetrica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Usuario` (
  `UsuarioID` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Usuario` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Contrasenha` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Correo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RolID` int(11) NOT NULL,
  `Estado` int(11) NOT NULL,
  PRIMARY KEY (`UsuarioID`),
  UNIQUE KEY `UsuarioID_UNIQUE` (`UsuarioID`),
  KEY `FK_RolID_idx` (`RolID`),
  KEY `FK_EstadoID_idx` (`Estado`),
  CONSTRAINT `FK_EstadoID` FOREIGN KEY (`Estado`) REFERENCES `EstadoUsuario` (`EstadoUsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RolID` FOREIGN KEY (`RolID`) REFERENCES `Rol` (`RolID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES (7,'Andrey Mendoza','amendoza','f951e387cc37c469f1f61c08e46d0420e166ab18717f70a802c6456e198ef71f','amendoza.test@gmail.com',2,1),(9,'Armando Lopez','alopez','a4f3a30c5da7daa4ebae3f37796bce35c93ce02b743928ec362aaa07064dba29','alopez@mail.com',2,1),(11,'Andrey Mendoza','amendoza2','f951e387cc37c469f1f61c08e46d0420e166ab18717f70a802c6456e198ef71f','amendoza@gmail.com',2,3);
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'SIEQ'
--
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarEstadoUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarEstadoUsuario`(
	UsuarioID INT,
    EstadoID INT)
BEGIN

	IF NOT EXISTS((SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioID AND u.Estado = EstadoID)) THEN
		  UPDATE Usuario u
          SET u.Estado = EstadoID
		  WHERE u.UsuarioID =  UsuarioID;
		  SELECT 1;
	END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarRolUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarRolUsuario`(
	UsuarioID INT,
    RolID INT)
BEGIN

	IF NOT EXISTS((SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioID AND u.RolID = RolID)) THEN
		  UPDATE Usuario u
          SET u.RolID = RolID
		  WHERE u.UsuarioID =  UsuarioID;
		  SELECT 1;
	END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AgregarUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AgregarUsuario`(
	Nombre VARCHAR(100),
    Usuario VARCHAR(45),
    Contrasenha VARCHAR(45),
    Correo VARCHAR(100),
    RolID INT)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Usuario u WHERE u.Usuario = Usuario) THEN
		INSERT INTO Usuario (Nombre, Usuario, Contrasenha, Correo, RolID, Estado)
			VALUES (Nombre, Usuario, SHA2(Contrasenha, 256), Correo, RolID, 3);
		SELECT 1;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `VerificarLogin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `VerificarLogin`(Usuario VARCHAR(100), Contrasenha VARCHAR(100))
BEGIN
	SELECT u.Nombre, eu.Nombre AS 'Estado', r.Nombre AS 'Rol'
    FROM Usuario u 	JOIN EstadoUsuario eu 	ON u.Estado = eu.EstadoUsuarioID
					JOIN Rol r 				ON r.RolID = u.RolID
    WHERE u.Usuario = Usuario 
    AND u.Contrasenha = sha2(Contrasenha, 256)
    AND eu.Nombre LIKE '%Activo%';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `VerUsuariosPendientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `VerUsuariosPendientes`()
BEGIN
	SELECT 	u.UsuarioID, 
			u.Nombre, 
			u.Usuario, 
			u.correo,
			r.Nombre AS 'Rol'        
    FROM Usuario u 	JOIN EstadoUsuario e 	ON u.Estado = e.EstadoUsuarioID
					JOIN Rol r				ON u.RolID = r.RolID
    WHERE e.Nombre = 'Pendiente';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-03-29 10:23:30
