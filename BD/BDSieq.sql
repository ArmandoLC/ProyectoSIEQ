-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 04, 2018 at 02:06 PM
-- Server version: 10.1.31-MariaDB
-- PHP Version: 7.0.26
DROP DATABASE SIEQ;

CREATE DATABASE  IF NOT EXISTS `SIEQ` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `SIEQ`;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id5183712_sieq`
--

DELIMITER $$
--
-- Procedures
--
CREATE PROCEDURE `ActualizarArticuloDelPedido` (`ArticuloPedidoID` INT, `ArticuloID` INT, `CantidadSolicitada` FLOAT, `Observacion` VARCHAR(100))  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT 'El formato de los datos nos es válido. Por favor, verifique.' AS 'Pedido Modificado';
	END;

	IF EXISTS ((SELECT 1 FROM ArticuloPedido ap WHERE ap.ArticuloPedidoID = ArticuloPedidoID)) THEN
    
		UPDATE ArticuloPedido ap
        SET ap.ArticuloID = ArticuloID,
			ap.CantidadSolicitada = CantidadSolicitada,
            ap.Observacion = Observacion
		WHERE ap.ArticuloPedidoID = ArticuloPedidoID;
        
		SELECT 1 AS 'Pedido Modificado';
	
    ELSE 
		SELECT 'El pedido a modificar no existe.' AS 'Pedido Modificado';
    
    END IF;

END$$

CREATE PROCEDURE `ActualizarCategoria` (`CategoriaID` INT, `Nombre` VARCHAR(45))  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SELECT 'El formato de los datos nos es válido. Por favor, verifique.' AS '1';
	END;

	IF EXISTS((SELECT 1 FROM CategoriaReactivo c WHERE c.CategoriaReactivoID= CategoriaID))THEN
		  UPDATE CategoriaReactivo c
          SET c.Nombre = Nombre
		  WHERE c.CategoriaReactivoID =  CategoriaID;
		  SELECT 1;
	ELSE 
		SELECT 'La categoria de ese reactivo no existe.' AS '1';
    
	END IF;
END$$

CREATE PROCEDURE `ActualizarCristaleria` (IN `ArticuloID` INT, IN `Nombre` VARCHAR(100), IN `Ubicacion` VARCHAR(100), IN `PuntoReorden` DOUBLE, IN `Descripcion` VARCHAR(300))  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT 'El formato de los datos no es válido. Por favor, verifique.' AS 'Modificado';	
        ROLLBACK;
	END;

	START TRANSACTION;

	IF EXISTS((SELECT 1 FROM Articulo a WHERE a.ArticuloID = ArticuloID)) THEN        
        
        -- Actualizar el Articulo
        UPDATE Articulo a
        SET a.Nombre = Nombre,
			a.Ubicacion = Ubicacion,
            a.PuntoReorden = PuntoReorden,
            a.Descripcion = Descripcion
		WHERE a.ArticuloID = ArticuloID
        AND a.TipoArticulo = 2;
              
		
		COMMIT;
		SELECT 1 AS 'Modificado';
	ELSE 
		SELECT 'El articulo a modificar no existe' AS 'Modificado';
    
	END IF;
END$$

CREATE PROCEDURE `ActualizarEstadoUsuario` (`UsuarioID` INT, `EstadoID` INT)  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT 'El formato de los datos no es válido. Por favor, verifique.' AS 'Modificado';	
	END;

	IF NOT EXISTS((SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioID AND u.Estado = EstadoID)) THEN
		  UPDATE Usuario u
          SET u.Estado = EstadoID
		  WHERE u.UsuarioID =  UsuarioID;
		  SELECT 1;
	ELSE 
		SELECT 'El usuario a modificar o el estado seleccionado no existe.' AS '1';
	END IF;
		
END$$

CREATE PROCEDURE `ActualizarReactivo` (IN `ReactivoID` INT, IN `Nombre` VARCHAR(100), IN `Ubicacion` VARCHAR(100), IN `PuntoReorden` DOUBLE, IN `Descripcion` VARCHAR(300), IN `EsPrecursor` BIT, IN `UnidadMetricaID` INT, IN `CategoriaID` INT, IN `URLHojaSeguridad` VARCHAR(300))  BEGIN
	DECLARE ArticuloID  INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT 'El formato de los datos no es válido. Por favor, verifique.' AS 'Modificado';	
        ROLLBACK;
	END;

	START TRANSACTION;

	IF EXISTS((SELECT ArticuloID FROM Reactivo r WHERE r.ReactivoID = ReactivoID)) THEN        
		
		SET ArticuloID = (	SELECT r.ArticuloID 
							FROM Reactivo r 
							WHERE r.ReactivoID = ReactivoID);
        
        -- Actualizar el Articulo
        UPDATE Articulo a
        SET a.Nombre = Nombre,
			a.Ubicacion = Ubicacion,
            a.PuntoReorden = PuntoReorden,
            a.Descripcion = Descripcion
		WHERE a.ArticuloID = ArticuloID;
        
        -- Actualizar el Reactivo
        UPDATE Reactivo r
        SET r.EsPrecursor = EsPrecursor,
			r.UnidadMetricaID = UnidadMetricaID,
            r.Categoria = CategoriaID,
            r.URLHojaSeguridad = URLHojaSeguridad
		WHERE r.ReactivoID = ReactivoID;        
		
		COMMIT;
		SELECT 1 AS 'Modificado';
	ELSE 
		SELECT 'El reactivo a modificar no existe' AS 'Modificado';
        
	END IF;

END$$

CREATE PROCEDURE `ActualizarRolUsuario` (`UsuarioID` INT, `RolID` INT)  BEGIN
	
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT 'El formato de los datos no es válido. Por favor, verifique.' AS '1';	
	END;

	IF NOT EXISTS((SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioID AND u.RolID = RolID)) THEN
		  UPDATE Usuario u
          SET u.RolID = RolID
		  WHERE u.UsuarioID =  UsuarioID;
		  SELECT 1;
	
    ELSE 
		SELECT 'El usuario a modificar o el rol seleccionado no existen.' AS '1';
        
	END IF;
END$$

CREATE PROCEDURE `ActualizarUnidad` (`UnidadMetricaID` INT, `Nombre` VARCHAR(45), `Siglas` VARCHAR(10))  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT 'El formato de los datos no es válido. Por favor, verifique.' AS 'Modificado';	
	END;

  IF EXISTS((SELECT 1 FROM UnidadMetrica u WHERE u.UnidadMetricaID = UnidadMetricaID)) THEN
		  UPDATE UnidadMetrica u
          SET u.Nombre = Nombre,
          u.Siglas = Siglas
		  WHERE u.UnidadMetricaID =  UnidadMetricaID;
		  SELECT 1;
	
    ELSE 
		SELECT 'La unidad métrica a modificar no existe' AS '1';
	END IF;
END$$

CREATE PROCEDURE `AgregarArticuloAListaNegra` (IN `UsuarioID` INT, IN `ArticuloID` INT)  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT 'El articulo o el usuario no existen. Por favor, verifique.' AS 'ListaNegraID';	
	END;

	IF NOT EXISTS ((SELECT 1 FROM ListaNegraNotificacionPorUsuario ln WHERE ln.ArticuloID = ArticuloID AND ln.UsuarioID = UsuarioID)) THEN
		
        INSERT INTO ListaNegraNotificacionPorUsuario (ArticuloID, UsuarioID)
			VALUES (ArticuloID, UsuarioID);
	
		SELECT AUTO_INCREMENT - 1 AS 'ListaNegraID' 
		FROM information_schema.tables 
		WHERE TABLE_SCHEMA LIKE '%SIEQ%' 
		AND TABLE_NAME = 'ListaNegraNotificacionPorUsuario';
        
	ELSE 
		SELECT 'El usuario ya tiene ese articulo en la lista negra.' AS 'ListaNegraID';
    END IF;

END$$

CREATE PROCEDURE `AgregarArticuloAPedido` (`PedidoID` INT, `ArticuloID` INT, `CantidadSolicitada` FLOAT, `Observacion` VARCHAR(100))  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SELECT 'El formato de los datos no es válido. Por favor, verifique.' AS 'Modificado';	
	END;

	IF EXISTS ((SELECT 1 FROM Pedido p WHERE p.PedidoID = PedidoID)) THEN
    
		INSERT INTO ArticuloPedido (PedidoID, ArticuloID, CantidadSolicitada, Observacion)
			VALUES (PedidoID, ArticuloID, CantidadSolicitada, Observacion);
            
		SELECT 1 AS 'Articulo Agregado';
	ELSE 
		SELECT 'El pedido ya existe.' AS 'Articulo Agregado';
    
    END IF;

END$$

CREATE PROCEDURE `agregarCategoria` (`Nombre` VARCHAR(45))  BEGIN
    IF NOT EXISTS ( (SELECT 1 from CategoriaReactivo c WHERE c.Nombre=Nombre) ) THEN
    	INSERT INTO CategoriaReactivo(Nombre) VALUES (Nombre);
        SELECT 1 as 'agregado';
    END IF;
END$$

CREATE PROCEDURE `AgregarCristaleria` (IN `Nombre` VARCHAR(100), IN `Ubicacion` VARCHAR(100), IN `CantidadActual` DOUBLE, IN `PuntoReorden` DOUBLE, IN `Descripcion` VARCHAR(300), IN `UsuarioID` INT)  BEGIN
	DECLARE ArticuloID  INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- ERROR	
        ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	 BEGIN
		-- WARNING
	 ROLLBACK;
	END;

	START TRANSACTION;

		IF NOT EXISTS((SELECT 1 FROM Articulo a WHERE a.Nombre = Nombre)) THEN        
        
				-- Agregar el articulo
				INSERT INTO Articulo(Nombre, Ubicacion, CantidadActual, PuntoReorden, Descripcion, TipoArticulo, Visible)
					VALUES (Nombre, Ubicacion, CantidadActual, PuntoReorden, Descripcion, 2, 1);
				
				SET ArticuloID = (	SELECT AUTO_INCREMENT - 1 AS UltimoID 
									FROM information_schema.tables 
                                    WHERE TABLE_SCHEMA LIKE '%SIEQ%' 
                                    AND TABLE_NAME = 'Articulo');
				
				INSERT INTO Movimiento(TipoMovimientoID, UsuarioAutorizadorID, ArticuloID, CantidadAntes, CantidadDespues, Destino, Observaciones)
					VALUES (1, UsuarioID, ArticuloID, 0, CantidadActual, Ubicacion, 'Ingreso del objeto al sistema.');

				COMMIT;
                SELECT 1 AS 'Insertado';
		END IF;

END$$

CREATE PROCEDURE `AgregarMensajeChat` (`UsuarioEmisorID` INT, `UsuarioReceptorID` INT, `Mensaje` TEXT)  BEGIN

	DECLARE ChatID  INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- ERROR	
        ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	 BEGIN
		-- WARNING
	 ROLLBACK;
	END;

	START TRANSACTION;
		
        -- Verificar si ya ha habido chat entre ambas personas
		IF NOT EXISTS((SELECT 1 FROM Chat c 
						WHERE (c.UsuarioAID = UsuarioEmisorID and c.UsuarioBID = UsuarioReceptorID)
                        OR (c.UsuarioAID = UsuarioReceptorID and c.UsuarioBID = UsuarioEmisorID))) THEN
		
			INSERT INTO Chat(UsuarioAID, UsuarioBID) VALUES (UsuarioEmisorID, UsuarioReceptorID);
		END IF;
        
        
        -- Tomar el ChatID   
		SET ChatID = (	SELECT c.ChatID FROM Chat c 
						WHERE (c.UsuarioAID = UsuarioEmisorID and c.UsuarioBID = UsuarioReceptorID)
                        OR (c.UsuarioAID = UsuarioReceptorID and c.UsuarioBID = UsuarioEmisorID));
		
        -- Agregar el mensaje al chat
		INSERT INTO MensajeChat(ChatID, UsuarioEmisorID, Mensaje)
			VALUES (ChatID, UsuarioEmisorID, Mensaje);
			
		SELECT 1 AS 'Agregado';

		COMMIT;

END$$

CREATE PROCEDURE `AgregarMovimiento` (`TipoMovimientoID` INT, `UsuarioAutorizadorID` INT, `ArticuloID` INT, `CantidadSolicitada` FLOAT, `Destino` VARCHAR(100), `Observaciones` VARCHAR(300))  BEGIN

    DECLARE CantidadActual FLOAT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
        ROLLBACK;
	END;

	START TRANSACTION;
	
	SET CantidadActual = (	SELECT a.CantidadActual
							FROM Articulo a
							WHERE a.ArticuloID = ArticuloID);
	
    IF (TipoMovimientoID = 2) THEN		
        SET CantidadSolicitada = -1 * CantidadSolicitada;    
    END IF;
    
	-- Verificar que la cantidad que se va a aprobar sea posible
	IF (CantidadActual + CantidadSolicitada >= 0) THEN
	
		-- Insertar el movimiento de salida del producto
		INSERT INTO Movimiento(TipoMovimientoID, UsuarioAutorizadorID, ArticuloID, CantidadAntes, CantidadDespues, Destino, Observaciones)
					VALUES (TipoMovimientoID, UsuarioAutorizadorID, ArticuloID, CantidadActual, CantidadActual + CantidadSolicitada, Destino, Observaciones);
		
		
		-- Actualizar la cantidad del articulo
		UPDATE Articulo a
		SET a.CantidadActual = CantidadActual + CantidadSolicitada
		WHERE a.ArticuloID = ArticuloID;
		
		COMMIT;
		SELECT 1 AS 'Actualizado';
        
	END IF;

END$$

CREATE PROCEDURE `AgregarPedido` (`Titulo` VARCHAR(100), `UsuarioID` INT, `Descripcion` VARCHAR(150))  BEGIN
	
    
    DECLARE PedidoID INT;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
        ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	 BEGIN
		-- WARNING
	 ROLLBACK;
	END;

	START TRANSACTION;

		IF NOT EXISTS ((SELECT 1 FROM Pedido p WHERE p.UsuarioSolicitanteID = UsuarioID AND Titulo = p.Titulo)) THEN
    
		INSERT INTO Pedido (Titulo, UsuarioSolicitanteID, Descripcion)
			VALUES (Titulo, UsuarioID, Descripcion);
            
		-- Tomar ID del pedido insertado
		SET PedidoID = (	SELECT AUTO_INCREMENT - 1 AS UltimoID 
									FROM information_schema.tables 
                                    WHERE TABLE_SCHEMA LIKE '%SIEQ%' 
                                    AND TABLE_NAME = 'Pedido');
                                    
		SELECT 1 AS 'Pedido Creado';
		COMMIT;
    END IF;

END$$

CREATE PROCEDURE `AgregarPrestamo` (`UsuarioSolicitanteID` INT, `ArticuloID` INT, `CantidadSolicitada` FLOAT, `FechaLimiteDevolucion` DATETIME, `EstadoPrestamoID` INT, `Descripcion` VARCHAR(300))  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
        ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	 BEGIN
		-- WARNING
	 ROLLBACK;
	END;

	START TRANSACTION;
	
    -- El articulo debe estar visible, haber la cantidad solicitada y la fecha de devolución mayor o igual a hoy
	IF EXISTS((SELECT 1 FROM Articulo a WHERE a.ArticuloID = ArticuloID AND a.Visible = 1 
				AND a.CantidadActual >= CantidadSolicitada AND DATE(FechaLimiteDevolucion) >= DATE(CURRENT_TIMESTAMP))) THEN    
        
		INSERT INTO Prestamo(UsuarioSolicitanteID, ArticuloID, CantidadSolicitada, FechaLimiteDevolucion, EstadoPrestamoID, Descripcion)
		VALUES (UsuarioSolicitanteID, ArticuloID, CantidadSolicitada, FechaLimiteDevolucion, EstadoPrestamoID, Descripcion);
			
		SELECT 1;

		COMMIT;
    END IF;


END$$

CREATE PROCEDURE `AgregarReactivo` (`Nombre` VARCHAR(100), `Ubicacion` VARCHAR(100), `CantidadActual` DOUBLE, `PuntoReorden` DOUBLE, `Descripcion` VARCHAR(300), `EsPrecursor` BIT, `UnidadMetricaID` INT, `CategoriaID` INT, `URLHojaSeguridad` VARCHAR(300), `UsuarioID` INT)  BEGIN
	DECLARE ArticuloID  INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- ERROR	
        ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	 BEGIN
		-- WARNING
	 ROLLBACK;
	END;

	START TRANSACTION;

		IF NOT EXISTS((SELECT 1 FROM Articulo a WHERE a.Nombre = Nombre)) THEN        
				INSERT INTO Articulo(Nombre, Ubicacion, CantidadActual, PuntoReorden, Descripcion, TipoArticulo, Visible)
				VALUES (Nombre, Ubicacion, CantidadActual, PuntoReorden, Descripcion, 1, 1);
				
				SET ArticuloID = (	SELECT AUTO_INCREMENT - 1 AS UltimoID 
									FROM information_schema.tables 
                                    WHERE TABLE_SCHEMA LIKE '%SIEQ%' 
                                    AND TABLE_NAME = 'Articulo');

				INSERT INTO Reactivo(ArticuloID, EsPrecursor, UnidadMetricaID, Categoria, URLHojaSeguridad)
					VALUES (ArticuloID, EsPrecursor, UnidadMetricaID, CategoriaID, URLHojaSeguridad);
				
				INSERT INTO Movimiento(TipoMovimientoID, UsuarioAutorizadorID, ArticuloID, CantidadAntes, CantidadDespues, Destino, Observaciones)
					VALUES (1, UsuarioID, ArticuloID, 0, CantidadActual, Ubicacion, 'Ingreso del reactivo al sistema.');
					
				SELECT 1;

		COMMIT;
    END IF;

END$$

CREATE PROCEDURE `AgregarUnidadMetrica` (`Nombre` VARCHAR(45), `Siglas` VARCHAR(10))  BEGIN
    IF NOT EXISTS ( (SELECT 1 from UnidadMetrica u WHERE u.Nombre=Nombre or u.Nombre=Siglas or u.Siglas=Siglas or u.Siglas=Nombre) ) THEN
    	INSERT INTO UnidadMetrica(Nombre,Siglas) VALUES (Nombre,Siglas);
        SELECT 1 as 'agregado';
    END IF;
END$$

CREATE PROCEDURE `AgregarUsuario` (`Nombre` VARCHAR(100), `Usuario` VARCHAR(45), `Contrasenha` VARCHAR(45), `Correo` VARCHAR(100), `RolID` INT)  BEGIN
	IF NOT EXISTS (SELECT 1 FROM Usuario u WHERE u.Usuario = Usuario) THEN
		INSERT INTO Usuario (Nombre, Usuario, Contrasenha, Correo, RolID, Estado)
			VALUES (Nombre, Usuario, SHA2(Contrasenha, 256), Correo, RolID, 3);
		SELECT 1;
	END IF;
END$$

CREATE PROCEDURE `AprobarPrestamo` (`UsuarioAutorizadorID` INT, `PrestamoID` INT, `Comentario` VARCHAR(300))  BEGIN

	DECLARE ArticuloID INT;
    DECLARE CantidadActual FLOAT;
    DECLARE CantidadSolicitada FLOAT;
    DECLARE MovimientoID INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
        ROLLBACK;
	END;

	START TRANSACTION;
	
    -- Si el prestamo existe y no está autorizado y ademas el usuario autorizador es coordinador
	IF EXISTS((SELECT 1 FROM Prestamo p WHERE p.PrestamoID = PrestamoID AND p.EstadoPrestamoID = 1)) AND 
		EXISTS(SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioAutorizadorID AND u.RolID = 1) THEN        
		
		SELECT 	p.ArticuloID, a.CantidadActual, p.CantidadSolicitada
        INTO 	ArticuloID, CantidadActual, CantidadSolicitada
        FROM Prestamo p	JOIN Articulo a ON a.ArticuloID = p.ArticuloID
        WHERE p.PrestamoID = PrestamoID;
        
        -- Verificar que la cantidad que se va a aprobar sea posible
        IF (CantidadActual - CantidadSolicitada >= 0) THEN
        
			-- Actualizar el prestamo
			UPDATE Prestamo p
			SET p.UsuarioAutorizadorID = UsuarioAutorizadorID,
				p.FechaAutorizacion = CURRENT_TIMESTAMP,
                p.MovimientoEntregaID = MovimientoID,
                p.EstadoPrestamoID = 2 -- Aceptado
			WHERE p.PrestamoID = PrestamoID;
                        
			COMMIT;
			SELECT 1 AS 'Aprobado';
        
        END IF;
        
	END IF;

END$$

CREATE PROCEDURE `borrarCategoria` (`pCategoriaReactivoID` INT)  BEGIN
  IF not EXISTS((SELECT 1 FROM Reactivo r WHERE r.Categoria = pCategoriaReactivoID))THEN
  	DELETE FROM CategoriaReactivo WHERE CategoriaReactivoID = pCategoriaReactivoID;
    SELECT 1 as 'borrado';
  END IF;
END$$

CREATE PROCEDURE `borrarUnidadMetrica` (`UnidadID` INT)  BEGIN
  IF not EXISTS((SELECT 1 FROM Reactivo r WHERE r.UnidadMetricaID = UnidadID))THEN
  	DELETE FROM UnidadMetrica WHERE UnidadMetricaID = UnidadID;
    SELECT 1 as 'borrado';
  END IF;
END$$

CREATE PROCEDURE `DespacharPrestamo` (IN `UsuarioAutorizadorID` INT, IN `PrestamoID` INT, IN `Comentario` VARCHAR(300))  BEGIN

	DECLARE ArticuloID INT;
    DECLARE CantidadActual FLOAT;
    DECLARE CantidadSolicitada FLOAT;
    DECLARE MovimientoID INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
        ROLLBACK;
	END;

	START TRANSACTION;
	
    -- Si el prestamo existe y no está autorizado y ademas el usuario autorizador es coordinador
	IF EXISTS((SELECT 1 FROM Prestamo p WHERE p.PrestamoID = PrestamoID AND p.EstadoPrestamoID = 2)) AND 
		EXISTS(SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioAutorizadorID AND u.RolID = 1) THEN        
		
		SELECT 	p.ArticuloID, a.CantidadActual, p.CantidadSolicitada
        INTO 	ArticuloID, CantidadActual, CantidadSolicitada
        FROM Prestamo p	JOIN Articulo a ON a.ArticuloID = p.ArticuloID
        WHERE p.PrestamoID = PrestamoID;
        
        -- Verificar que la cantidad que se va a aprobar sea posible
        IF (CantidadActual - CantidadSolicitada >= 0) THEN
        
			-- Insertar el movimiento de salida del producto
			INSERT INTO Movimiento(TipoMovimientoID, UsuarioAutorizadorID, ArticuloID, CantidadAntes, CantidadDespues, Destino, Observaciones)
						VALUES (2, UsuarioAutorizadorID, ArticuloID, CantidadActual, CantidadActual - CantidadSolicitada, 'Prestamo', Comentario);
			
            -- Tomar el ID del movimiento insertado
            SET MovimientoID = (	SELECT AUTO_INCREMENT - 1 AS UltimoID 
									FROM information_schema.tables 
                                    WHERE TABLE_SCHEMA LIKE '%SIEQ%' 
                                    AND TABLE_NAME = 'Movimiento');
                       
			-- Actualizar el prestamo
			UPDATE Prestamo p
			SET p.UsuarioAutorizadorID = UsuarioAutorizadorID,
				p.FechaAutorizacion = CURRENT_TIMESTAMP,
                p.MovimientoEntregaID = MovimientoID,
                p.EstadoPrestamoID = 6 -- Despachado
			WHERE p.PrestamoID = PrestamoID;
            
            
            -- Actualizar la cantidad del articulo
			UPDATE Articulo a
			SET a.CantidadActual = CantidadActual - CantidadSolicitada
			WHERE a.ArticuloID = ArticuloID;
            
			COMMIT;
			SELECT 1 AS 'Despachado';
        
        END IF;
     
	END IF;

END$$

CREATE PROCEDURE `DevolverPrestamo` (IN `UsuarioAutorizadorID` INT, IN `PrestamoID` INT, IN `Comentario` VARCHAR(300), IN `CantidadDevuelta` FLOAT)  BEGIN

	DECLARE ArticuloID INT;
    DECLARE CantidadActual FLOAT;
    DECLARE MovimientoID INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
        ROLLBACK;
	END;

	START TRANSACTION;
	
    -- Si el prestamo existe y no está autorizado y ademas el usuario autorizador es coordinador
	IF EXISTS((SELECT 1 FROM Prestamo p WHERE p.PrestamoID = PrestamoID AND (p.EstadoPrestamoID = 6 or p.EstadoPrestamoID = 5))) AND 
		EXISTS(SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioAutorizadorID AND u.RolID = 1) THEN        
		
		SELECT 	p.ArticuloID, a.CantidadActual
        INTO 	ArticuloID, CantidadActual
        FROM Prestamo p	JOIN Articulo a ON a.ArticuloID = p.ArticuloID
        WHERE p.PrestamoID = PrestamoID;
        
        
		-- Insertar el movimiento de salida del producto
		INSERT INTO Movimiento(TipoMovimientoID, UsuarioAutorizadorID, ArticuloID, CantidadAntes, CantidadDespues, Destino, Observaciones)
					VALUES (1, UsuarioAutorizadorID, ArticuloID, CantidadActual, CantidadActual + CantidadDevuelta, 'Devolución de Préstamo', Comentario);
		
		-- Tomar el ID del movimiento insertado
		SET MovimientoID = (	SELECT AUTO_INCREMENT - 1 AS UltimoID 
								FROM information_schema.tables 
								WHERE TABLE_SCHEMA LIKE '%SIEQ%' 
								AND TABLE_NAME = 'Movimiento');
				   
		-- Actualizar el prestamo
		UPDATE Prestamo p
		SET	p.MovimientoDevolucionID = MovimientoID,
			p.EstadoPrestamoID = 4 -- Devuelto
		WHERE p.PrestamoID = PrestamoID;
		
		-- Actualizar la cantidad del articulo
		UPDATE Articulo a
		SET a.CantidadActual = CantidadActual + CantidadDevuelta
        WHERE a.ArticuloID = ArticuloID;
		
		COMMIT;
		SELECT 1 AS 'Devuelto';

        
	END IF;
END$$

CREATE PROCEDURE `EliminarArticuloDelPedido` (`sArticuloPedidoID` INT)  BEGIN
	
    IF EXISTS ((SELECT 1 FROM ArticuloPedido ap WHERE ap.ArticuloPedidoID = sArticuloPedidoID)) THEN
    
		DELETE FROM ArticuloPedido WHERE ArticuloPedidoID = sArticuloPedidoID;
        
        SELECT 1 AS 'Eliminado';
    
    END IF;

END$$

CREATE PROCEDURE `EliminarArticuloListaNegra` (`ListaNegraID` INT)  BEGIN

	IF EXISTS ((SELECT 1 FROM ListaNegraNotificacionPorUsuario ln WHERE ln.ListaNegraNotificacionPorUsuarioID = ListaNegraID)) THEN
		
        DELETE FROM ListaNegraNotificacionPorUsuario 
        WHERE ListaNegraNotificacionPorUsuarioID = ListaNegraID;
	
		SELECT 1 AS 'Eliminado';
    END IF;

END$$

CREATE PROCEDURE `EliminarCristaleria` (`ArticuloID` INT)  BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- ERROR	
        ROLLBACK;
	END;

	START TRANSACTION;

	IF EXISTS((SELECT 1 FROM Articulo a WHERE a.ArticuloID = ArticuloID AND a.Visible = 1 AND a.TipoArticulo = 2)) THEN        
                            
        -- Actualizar el Articulo
        UPDATE Articulo a
        SET a.Visible = 0
		WHERE a.ArticuloID = ArticuloID
        AND a.Visible = 1;
             
		COMMIT;
		SELECT 1 AS 'Eliminado';
        
	END IF;

END$$

CREATE PROCEDURE `EliminarMensajeChat` (`sMensajeChatID` INT)  BEGIN

	IF EXISTS ((SELECT 1 FROM MensajeChat mj WHERE mj.MensajeChatID = sMensajeChatID)) THEN
    
		DELETE FROM MensajeChat WHERE MensajeChatID = sMensajeChatID;
        
        SELECT 1 AS 'Eliminado';    
    ELSE 		
        SELECT 0 AS 'Eliminado';        
    END IF;
    
    

END$$

CREATE PROCEDURE `EliminarPedido` (`sPedidoID` INT)  BEGIN
	
    IF EXISTS (SELECT 1 FROM Pedido WHERE PedidoID = sPedidoID) THEN
    
		DELETE FROM Pedido WHERE PedidoID = sPedidoID;
		
		SELECT 1 AS 'Eliminado';
    
    END IF;
    
END$$

CREATE PROCEDURE `EliminarReactivo` (IN `ReactivoID` INT)  BEGIN
	DECLARE ArticuloID  INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- ERROR	
        ROLLBACK;
	END;

	START TRANSACTION;

	IF EXISTS((SELECT 1 FROM Reactivo r JOIN Articulo a ON r.ArticuloID = a.ArticuloID WHERE r.ReactivoID = ReactivoID AND a.Visible = 1)) THEN        
		
		SET ArticuloID = (	SELECT r.ArticuloID 
							FROM Reactivo r 
							WHERE r.ReactivoID = ReactivoID);
        
        -- Actualizar el Articulo
        UPDATE Articulo a
        SET a.Visible = 0
		WHERE a.ArticuloID = ArticuloID
        AND a.Visible = 1;
             
		
		COMMIT;
		SELECT 1 AS 'Eliminado';
        
	END IF;

END$$

CREATE PROCEDURE `PrestamoTardio` (`UsuarioAutorizadorID` INT, `PrestamoID` INT, `Comentario` VARCHAR(300))  BEGIN

	DECLARE ArticuloID INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
        ROLLBACK;
	END;

	START TRANSACTION;
	
    -- Si el prestamo existe y no está autorizado y ademas el usuario autorizador es coordinador
	IF EXISTS((SELECT 1 FROM Prestamo p WHERE p.PrestamoID = PrestamoID AND p.EstadoPrestamoID = 1)) AND 
		EXISTS(SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioAutorizadorID AND u.RolID = 1) THEN        
        
			-- Actualizar el prestamo
			UPDATE Prestamo p
			SET p.UsuarioAutorizadorID = UsuarioAutorizadorID,
				p.FechaAutorizacion = CURRENT_TIMESTAMP,
                p.EstadoPrestamoID = 5 -- Tardio
			WHERE p.PrestamoID = PrestamoID;
            
			COMMIT;
			SELECT 1 AS 'Tarde';
        
	END IF;

END$$

CREATE PROCEDURE `RechazarPrestamo` (`UsuarioAutorizadorID` INT, `PrestamoID` INT, `Comentario` VARCHAR(300))  BEGIN

	DECLARE ArticuloID INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
        ROLLBACK;
	END;

	START TRANSACTION;
	
    -- Si el prestamo existe y no está autorizado y ademas el usuario autorizador es coordinador
	IF EXISTS((SELECT 1 FROM Prestamo p WHERE p.PrestamoID = PrestamoID AND p.EstadoPrestamoID = 1)) AND 
		EXISTS(SELECT 1 FROM Usuario u WHERE u.UsuarioID = UsuarioAutorizadorID AND u.RolID = 1) THEN        
        
			-- Actualizar el prestamo
			UPDATE Prestamo p
			SET p.UsuarioAutorizadorID = UsuarioAutorizadorID,
				p.FechaAutorizacion = CURRENT_TIMESTAMP,
                p.EstadoPrestamoID = 3 -- Rechazado
			WHERE p.PrestamoID = PrestamoID;
            
			COMMIT;
			SELECT 1 AS 'Rechazado';
        
	END IF;

END$$

CREATE PROCEDURE `VerArticuloDelPedido` (`ArticuloPedidoID` INT)  BEGIN

	SELECT	ap.ArticuloPedidoID,
			a.Nombre AS 'Articulo',
			ta.Nombre AS 'TipoArticulo',
			(CASE 'En alerta' WHEN a.CantidadActual <= a.PuntoReorden THEN 1 ELSE 0 END) AS 'En Alerta',
			a.CantidadActual,
			ap.CantidadSolicitada,
            a.Descripcion,
			ap.Observacion,
            a.PuntoReorden
	FROM ArticuloPedido ap 	JOIN Articulo a ON ap.ArticuloID = a.ArticuloID
							JOIN TipoArticulo ta ON ta.TipoArticuloID = a.TipoArticulo
	WHERE ap.ArticuloPedidoID = ArticuloPedidoID;

END$$

CREATE PROCEDURE `VerArticulosDelPedido` (`PedidoID` INT)  BEGIN

	SELECT	ap.ArticuloPedidoID,
			a.ArticuloID,
			a.Nombre AS 'Articulo',
			ta.Nombre AS 'TipoArticulo',
			(CASE 'En alerta' WHEN a.CantidadActual <= a.PuntoReorden THEN 1 ELSE 0 END) AS 'EsAlerta',
			a.CantidadActual,
			ap.CantidadSolicitada,
			ap.Observacion,
            a.PuntoReorden,
            a.Ubicacion
	FROM Pedido p 	JOIN ArticuloPedido ap ON p.PedidoID = ap.PedidoID
					JOIN Articulo a ON ap.ArticuloID = a.ArticuloID
					JOIN TipoArticulo ta ON ta.TipoArticuloID = a.TipoArticulo
	WHERE p.PedidoID = PedidoID;

END$$

CREATE PROCEDURE `VerCategorias` ()  BEGIN
    SELECT * from CategoriaReactivo;
END$$

CREATE PROCEDURE `VerChat` (`UsuarioAID` INT, `UsuarioBID` INT)  BEGIN

	DECLARE ChatID  INT;
    
	-- Tomar el ChatID 
	SET ChatID = (	SELECT c.ChatID FROM Chat c 
					WHERE (c.UsuarioAID = UsuarioAID and c.UsuarioBID = UsuarioBID)
					OR (c.UsuarioAID = UsuarioBID and c.UsuarioBID = UsuarioAID));
                    
	SELECT 	j.MensajeChatID,
			j.FechaHora,
			j.Mensaje,
			j.UsuarioEmisorID, 
			j.NombreEmisor,
            us.Nombre AS 'NombreReceptor'
    FROM(SELECT mj.MensajeChatID,
		mj.FechaHora,
		mj.Mensaje,
        mj.UsuarioEmisorID, 
        u.Nombre AS 'NombreEmisor',
        CASE 
			WHEN c.UsuarioAID = mj.UsuarioEmisorID THEN c.UsuarioBID
            ELSE c.UsuarioAID
		END AS 'ReceptorID'
	FROM MensajeChat mj JOIN Chat c ON c.ChatID = mj.ChatID
						JOIN Usuario u ON u.UsuarioID = mj.UsuarioEmisorID
	WHERE mj.ChatID = ChatID
	ORDER BY mj.FechaHora ASC) AS j JOIN Usuario us ON us.UsuarioID = j.ReceptorID;

END$$

CREATE PROCEDURE `VerCristaleria` (`ArticuloID` INT)  BEGIN

	SELECT 
		a.ArticuloID,
		a.Nombre AS 'NombreArticulo',
		a.Ubicacion,
		a.CantidadActual,
		a.PuntoReorden,
		a.Descripcion
	FROM Articulo a
	WHERE a.Visible = TRUE
    AND a.TipoArticulo = 2
    AND a.ArticuloID = ArticuloID;

END$$

CREATE PROCEDURE `VerCristaleriaDebajoDelMinimo` (IN `UsuarioID` INT)  BEGIN

	SELECT 
		a.ArticuloID,
		a.Nombre AS 'NombreArticulo',
		a.Ubicacion,
		a.CantidadActual,
		a.PuntoReorden,
		a.Descripcion
	FROM Articulo a 
	WHERE a.Visible = TRUE
	AND a.TipoArticulo = 2
	AND a.CantidadActual <= a.PuntoReorden
        AND a.ArticuloID NOT IN (SELECT ln.ArticuloID FROM ListaNegraNotificacionPorUsuario ln WHERE ln.UsuarioID = UsuarioID);

END$$

CREATE PROCEDURE `VerEstadosPrestamo` ()  BEGIN
	SELECT * FROM EstadoPrestamo;
END$$

CREATE PROCEDURE `VerEstadosUsuario` ()  BEGIN

	SELECT *
    FROM EstadoUsuario;

END$$

CREATE PROCEDURE `VerificarLogin` (IN `Usuario` VARCHAR(100), IN `Contrasenha` VARCHAR(100))  BEGIN
	SELECT u.UsuarioID,u.Nombre, eu.Nombre AS 'Estado', r.Nombre AS 'Rol'
    FROM Usuario u 	JOIN EstadoUsuario eu 	ON u.Estado = eu.EstadoUsuarioID
					JOIN Rol r 				ON r.RolID = u.RolID
    WHERE u.Usuario = Usuario 
    AND u.Contrasenha = sha2(Contrasenha, 256)
    AND u.Estado = 1;
END$$

CREATE PROCEDURE `VerListaArticulos` ()  BEGIN

	SELECT	a.ArticuloID,
			a.Nombre AS 'Articulo',
            ta.Nombre AS 'TipoArticulo',
            a.CantidadActual,
            a.PuntoReorden
    FROM Articulo a JOIN TipoArticulo ta ON a.TipoArticulo = ta.TipoArticuloID
    WHERE a.Visible = 1;
    
END$$

CREATE PROCEDURE `VerListaCristaleria` ()  BEGIN
	
	SELECT 
		a.ArticuloID,
		a.Nombre AS 'NombreArticulo',
		a.Ubicacion,
		a.CantidadActual,
		a.PuntoReorden,
		a.Descripcion
	FROM Articulo a
	WHERE a.Visible = TRUE
    AND a.TipoArticulo = 2;
    
END$$

CREATE PROCEDURE `VerListaNegraDeUsuario` (IN `UsuarioID` INT)  BEGIN

	SELECT	ln.ListaNegraNotificacionPorUsuarioID AS 'ListaNegraID',
			a.Nombre AS 'Articulo',
            a.PuntoReorden,a.ArticuloID
    FROM ListaNegraNotificacionPorUsuario ln JOIN Articulo a ON ln.ArticuloID = a.ArticuloID
    WHERE ln.UsuarioID = UsuarioID;

END$$

CREATE PROCEDURE `VerListaReactivos` ()  BEGIN
  SELECT r.ReactivoID,r.EsPrecursor,u.UnidadMetricaID,c.CategoriaReactivoID,r.URLHojaSeguridad,a.Nombre as 'nombreReactivo',a.Ubicacion,a.CantidadActual,a.PuntoReorden,a.Descripcion,a.TipoArticulo,a.ArticuloID, u.Nombre as 'nombreUnidad',u.Siglas,c.Nombre as 'NombreCategoria' FROM Reactivo r JOIN Articulo a ON r.ArticuloID = a.ArticuloID JOIN UnidadMetrica u ON r.UnidadMetricaID = u.UnidadMetricaID JOIN CategoriaReactivo c on r.Categoria = c.CategoriaReactivoID WHERE a.Visible = true;
END$$

CREATE PROCEDURE `VerListaUsuarios` (IN `UsuarioID` INT)  BEGIN
    SELECT u.UsuarioID,u.Nombre,u.Usuario,u.Correo,u.RolID,u.Estado
    FROM Usuario u
    WHERE u.UsuarioID <> UsuarioID
    AND u.Estado IN (1, 2)
    AND u.Usuario <> 'admin';
END$$

CREATE PROCEDURE `VerMovimientosCristaleria` (IN `FechaDesde` DATETIME, IN `FechaHasta` DATETIME)  BEGIN

	-- Consulto desde 2000 hasta la actualidad para sacar el historico
	IF (FechaDesde = '2000-01-01' AND FechaHasta = '2000-01-01') THEN
		SET FechaHasta = (SELECT NOW());
	END IF;
    
    SELECT 	a.Nombre AS 'Articulo',
			tm.Nombre AS 'Tipo de Movimiento',
			m.CantidadAntes AS 'Antes',
			m.CantidadDespues AS 'Despues',
			m.CantidadDespues - m.CantidadAntes AS 'Movido',
			m.Fecha,
			m.Destino,
			m.Observaciones,
			u.Nombre AS 'Firma'
	FROM Articulo a JOIN Movimiento m 	ON a.ArticuloID = m.ArticuloID
					JOIN Usuario u		ON u.UsuarioID = m.UsuarioAutorizadorID
					JOIN TipoMovimiento tm		ON tm.TipoMovimientoID = m.TipoMovimientoID
	WHERE a.TipoArticulo = 2
    AND m.Fecha BETWEEN FechaDesde AND FechaHasta;

END$$

CREATE PROCEDURE `VerMovimientosPrecursores` (IN `FechaDesde` DATETIME, IN `FechaHasta` DATETIME, IN `CategoriaID` INT)  BEGIN
-- Consulto desde 2000 hasta la actualidad para sacar el historico
	IF (FechaDesde = '2000-01-01' AND FechaHasta = '2000-01-01') THEN
		SET FechaHasta = (SELECT NOW());
	END IF;
    
	
    IF (CategoriaID = 0) THEN
    
		SELECT 	a.Nombre AS 'Reactivo',
			tm.Nombre AS 'Tipo de Movimiento',
			CONCAT(CAST(m.CantidadAntes AS CHAR), ' ', um.Nombre, 's') AS 'Antes',
			CONCAT(CAST(m.CantidadDespues AS CHAR), ' ', um.Nombre, 's') AS 'Despues',
			m.CantidadDespues - m.CantidadAntes AS 'Movido',
			cr.Nombre AS 'Categoria',
			m.Fecha,
			m.Destino,
			m.Observaciones,
			u.Nombre AS 'Firma'
		FROM Reactivo r JOIN Movimiento m 	ON r.ArticuloID = m.ArticuloID
						JOIN Articulo a		ON a.ArticuloID = m.ArticuloID
						JOIN Usuario u		ON u.UsuarioID = m.UsuarioAutorizadorID
						JOIN CategoriaReactivo cr 	ON cr.CategoriaReactivoID = r.Categoria
						JOIN TipoMovimiento tm		ON tm.TipoMovimientoID = m.TipoMovimientoID
						JOIN UnidadMetrica um		ON um.UnidadMetricaID = r.UnidadMetricaID
		WHERE m.Fecha BETWEEN FechaDesde AND FechaHasta
		AND a.TipoArticulo = 1
		AND r.EsPrecursor = 1;
    
    ELSE
		
        SELECT 	a.Nombre AS 'Reactivo',
		tm.Nombre AS 'Tipo de Movimiento',
		CONCAT(CAST(m.CantidadAntes AS CHAR), ' ', um.Nombre, 's') AS 'Antes',
		CONCAT(CAST(m.CantidadDespues AS CHAR), ' ', um.Nombre, 's') AS 'Despues',
		m.CantidadDespues - m.CantidadAntes AS 'Movido',
		cr.Nombre AS 'Categoria',
		m.Fecha,
		m.Destino,
		m.Observaciones,
		u.Nombre AS 'Firma'
		FROM Reactivo r JOIN Movimiento m 	ON r.ArticuloID = m.ArticuloID
						JOIN Articulo a		ON a.ArticuloID = m.ArticuloID
						JOIN Usuario u		ON u.UsuarioID = m.UsuarioAutorizadorID
						JOIN CategoriaReactivo cr 	ON cr.CategoriaReactivoID = r.Categoria
						JOIN TipoMovimiento tm		ON tm.TipoMovimientoID = m.TipoMovimientoID
						JOIN UnidadMetrica um		ON um.UnidadMetricaID = r.UnidadMetricaID
		WHERE m.Fecha BETWEEN FechaDesde AND FechaHasta
		AND a.TipoArticulo = 1
		AND r.EsPrecursor = 1
		AND cr.CategoriaReactivoID = CategoriaID;
        
    END IF;

END$$

CREATE PROCEDURE `VerMovimientosReactivos` (IN `FechaDesde` DATETIME, IN `FechaHasta` DATETIME, IN `CategoriaID` INT)  BEGIN
-- Consulto desde 2000 hasta la actualidad para sacar el historico
	IF (FechaDesde = '2000-01-01' AND FechaHasta = '2000-01-01') THEN
		SET FechaHasta = (SELECT NOW());
	END IF;
    
	
    IF (CategoriaID = 0) THEN
    
		SELECT 	a.Nombre AS 'Reactivo',
			tm.Nombre AS 'Tipo de Movimiento',
			CONCAT(CAST(m.CantidadAntes AS CHAR), ' ', um.Nombre, 's') AS 'Antes',
			CONCAT(CAST(m.CantidadDespues AS CHAR), ' ', um.Nombre, 's') AS 'Despues',
			m.CantidadDespues - m.CantidadAntes AS 'Movido',
			cr.Nombre AS 'Categoria',
			m.Fecha,
			m.Destino,
			m.Observaciones,
			u.Nombre AS 'Firma'
		FROM Reactivo r JOIN Movimiento m 	ON r.ArticuloID = m.ArticuloID
						JOIN Articulo a		ON a.ArticuloID = m.ArticuloID
						JOIN Usuario u		ON u.UsuarioID = m.UsuarioAutorizadorID
						JOIN CategoriaReactivo cr 	ON cr.CategoriaReactivoID = r.Categoria
						JOIN TipoMovimiento tm		ON tm.TipoMovimientoID = m.TipoMovimientoID
						JOIN UnidadMetrica um		ON um.UnidadMetricaID = r.UnidadMetricaID
		WHERE m.Fecha BETWEEN FechaDesde AND FechaHasta
		AND a.TipoArticulo = 1;
    
    ELSE
		
        SELECT 	a.Nombre AS 'Reactivo',
		tm.Nombre AS 'Tipo de Movimiento',
		CONCAT(CAST(m.CantidadAntes AS CHAR), ' ', um.Nombre, 's') AS 'Antes',
		CONCAT(CAST(m.CantidadDespues AS CHAR), ' ', um.Nombre, 's') AS 'Despues',
		m.CantidadDespues - m.CantidadAntes AS 'Movido',
		cr.Nombre AS 'Categoria',
		m.Fecha,
		m.Destino,
		m.Observaciones,
		u.Nombre AS 'Firma'
		FROM Reactivo r JOIN Movimiento m 	ON r.ArticuloID = m.ArticuloID
						JOIN Articulo a		ON a.ArticuloID = m.ArticuloID
						JOIN Usuario u		ON u.UsuarioID = m.UsuarioAutorizadorID
						JOIN CategoriaReactivo cr 	ON cr.CategoriaReactivoID = r.Categoria
						JOIN TipoMovimiento tm		ON tm.TipoMovimientoID = m.TipoMovimientoID
						JOIN UnidadMetrica um		ON um.UnidadMetricaID = r.UnidadMetricaID
		WHERE m.Fecha BETWEEN FechaDesde AND FechaHasta
		AND a.TipoArticulo = 1
		AND cr.CategoriaReactivoID = CategoriaID;
        
    END IF;

END$$

CREATE PROCEDURE `VerPedidos` ()  BEGIN

	SELECT	p.PedidoID,
			u.UsuarioID AS 'PropietarioID',
            u.Nombre AS 'NombrePropietario',
			p.Titulo,
            COUNT(ap.PedidoID) AS 'CantidadLineas',
            p.Descripcion
    FROM Pedido p 	LEFT JOIN ArticuloPedido ap 	
    					ON ap.PedidoID = p.PedidoID
					JOIN Usuario u			
                    	ON u.UsuarioID = p.UsuarioSolicitanteID	
    GROUP BY p.PedidoID;

END$$

CREATE PROCEDURE `VerPrestamos` ()  BEGIN

SELECT	j.PrestamoID,
		j.FechaSolicitud,
        j.UsuarioSolicitante,
        j.Articulo,
        j.CantidadSolicitada,
        j.Descripcion,
        u2.Nombre AS 'UsuarioAutorizador',
        j.FechaAutorizacion AS 'FechaAutorizacion',
        m2.Fecha AS 'FechaDevolucion',
        j.Estado,
        j.EstadoPrestamoID
FROM	(SELECT	p.PrestamoID,
				p.FechaSolicitud,
				u.Nombre AS 'UsuarioSolicitante',
				a.Nombre AS 'Articulo',
				p.CantidadSolicitada AS 'CantidadSolicitada',
				p.Descripcion,
				p.UsuarioAutorizadorID,
				m.Fecha AS 'FechaAutorizacion',
				p.MovimientoDevolucionID,
				ep.Nombre AS 'Estado',
         		ep.EstadoPrestamoID
		 FROM Prestamo p LEFT JOIN Usuario u 
						ON u.UsuarioID = p.UsuarioSolicitanteID
					JOIN Articulo a 
						ON a.ArticuloID = p.ArticuloID 
					JOIN EstadoPrestamo ep
						ON ep.EstadoPrestamoID = p.EstadoPrestamoID
					LEFT JOIN Movimiento m 
						ON m.MovimientoID = p.MovimientoEntregaID
		) j LEFT JOIN Movimiento m2
				ON m2.MovimientoID = j.MovimientoDevolucionID
			LEFT JOIN Usuario u2
				ON u2.UsuarioID = j.UsuarioAutorizadorID
            ORDER BY j.FechaSolicitud DESC;
END$$

CREATE PROCEDURE `VerReactivo` (IN `ReactivoID` INT)  BEGIN

	SELECT 
		r.ReactivoID,
		r.EsPrecursor,
		u.UnidadMetricaID,
		c.CategoriaReactivoID,
		r.URLHojaSeguridad,
		a.Nombre AS 'nombreReactivo',
		a.Ubicacion,
		a.CantidadActual,
		a.PuntoReorden,
		a.Descripcion,
		a.TipoArticulo, 
		u.Nombre AS 'nombreUnidad',
		u.Siglas,c.Nombre AS 'NombreCategoria' 
	FROM Reactivo r JOIN Articulo a ON r.ArticuloID = a.ArticuloID 
					JOIN UnidadMetrica u ON r.UnidadMetricaID = u.UnidadMetricaID 
					JOIN CategoriaReactivo c ON r.Categoria = c.CategoriaReactivoID 
	WHERE a.Visible = TRUE
    AND r.ReactivoID = ReactivoID;

END$$

CREATE PROCEDURE `VerReactivosDebajoDelMinimo` (IN `UsuarioID` INT, IN `CategoriaID` INT)  BEGIN

	IF (CategoriaID = 0) THEN
    
		SELECT 
			r.ReactivoID,
			r.EsPrecursor,
			u.UnidadMetricaID,
			c.CategoriaReactivoID,
			r.URLHojaSeguridad,
			a.Nombre AS 'nombreReactivo',
			a.Ubicacion,
			a.CantidadActual,
			a.PuntoReorden,
			a.Descripcion,
			a.TipoArticulo, 
			u.Nombre AS 'nombreUnidad',
			u.Siglas,c.Nombre AS 'NombreCategoria'
		FROM Reactivo r JOIN Articulo a ON r.ArticuloID = a.ArticuloID 
						JOIN UnidadMetrica u ON r.UnidadMetricaID = u.UnidadMetricaID 
						JOIN CategoriaReactivo c ON r.Categoria = c.CategoriaReactivoID 
		WHERE a.Visible = TRUE
		AND a.CantidadActual <= a.PuntoReorden
		AND a.TipoArticulo = 1
        AND a.ArticuloID NOT IN (SELECT ln.ArticuloID FROM ListaNegraNotificacionPorUsuario ln WHERE ln.UsuarioID = UsuarioID);
    
    ELSE 
    
		SELECT 
			r.ReactivoID,
			r.EsPrecursor,
			u.UnidadMetricaID,
			c.CategoriaReactivoID,
			r.URLHojaSeguridad,
			a.Nombre AS 'nombreReactivo',
			a.Ubicacion,
			a.CantidadActual,
			a.PuntoReorden,
			a.Descripcion,
			a.TipoArticulo, 
			u.Nombre AS 'nombreUnidad',
			u.Siglas,c.Nombre AS 'NombreCategoria'
		FROM Reactivo r JOIN Articulo a ON r.ArticuloID = a.ArticuloID 
						JOIN UnidadMetrica u ON r.UnidadMetricaID = u.UnidadMetricaID 
						JOIN CategoriaReactivo c ON r.Categoria = c.CategoriaReactivoID 
		WHERE a.Visible = TRUE
		AND a.CantidadActual <= a.PuntoReorden
		AND a.TipoArticulo = 1
        AND r.Categoria = CategoriaID
        AND a.ArticuloID NOT IN (SELECT ln.ArticuloID FROM ListaNegraNotificacionPorUsuario ln WHERE ln.UsuarioID = UsuarioID);
        
	END IF;
END$$

CREATE PROCEDURE `VerRolesUsuario` ()  BEGIN

	SELECT *
    FROM Rol;

END$$

CREATE PROCEDURE `VerUnidadesMetricas` ()  BEGIN
  SELECT * FROM UnidadMetrica;
END$$

CREATE PROCEDURE `VerUsuariosPendientes` ()  BEGIN
	SELECT 	u.UsuarioID, 
			u.Nombre, 
			u.Usuario, 
			u.Correo,
			r.Nombre AS 'Rol'        
    FROM Usuario u 	JOIN EstadoUsuario e 	ON u.Estado = e.EstadoUsuarioID
					JOIN Rol r				ON u.RolID = r.RolID
    WHERE e.Nombre = 'Pendiente';
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Articulo`
--

CREATE TABLE `Articulo` (
  `ArticuloID` int(11) NOT NULL,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Ubicacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CantidadActual` double NOT NULL,
  `PuntoReorden` double NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TipoArticulo` int(11) NOT NULL,
  `Visible` bit(1) NOT NULL DEFAULT b'1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Articulo`
--

INSERT INTO `Articulo` (`ArticuloID`, `Nombre`, `Ubicacion`, `CantidadActual`, `PuntoReorden`, `Descripcion`, `TipoArticulo`, `Visible`) VALUES
(1, 'ACIDO ACETICO GLACIAL', 'estante metalico', 17, 0, '', 1, b'1'),
(2, 'ACIDO CLORHIDRICO GR. 36.5-38.0%', 'estante metalico', 35, 0, '', 1, b'1'),
(3, 'ACIDO NITRICO 69-70%', 'estante metalico', 7.5, 0, '', 1, b'1'),
(4, 'ACIDO PERCLORICO 79%', 'D-6', 11, 0, '', 1, b'1'),
(5, 'ACIDO SULFURICO CONC', 'estante metalico', 0, 0, '', 1, b'1'),
(6, 'ACIDO SULFURICO TECNICO', 'E-7', 0, 0, '', 1, b'1'),
(7, 'ACIDO YODICO', 'D-4', 400, 0, '', 1, b'1'),
(8, 'acido adipico', 'bodega laborio', 0.5, 0, '', 1, b'1'),
(9, 'aceite de linaza', 'lab organica', 240, 0, '', 1, b'1'),
(10, 'ACIDO PERCLORICO AL 20%', 'D-2', 250, 0, '', 1, b'1'),
(11, 'ACIDO PERCLORICO 30%', 'ESTANT MET', 11.5, 0, '', 1, b'1'),
(12, 'ACIDO PERCLORICO 70%', 'ESTANT MET', 7.5, 0, '', 1, b'1'),
(13, 'BROMATO DE POTASIO', 'D-1', 245, 0, '', 1, b'1'),
(14, 'Fenantreno', 'D-1', 40, 0, '', 1, b'1'),
(15, 'Fenol', 'F-2', 6, 0, '', 1, b'1'),
(16, 'Fenoltaleína', 'B-1', 900, 0, '', 1, b'1'),
(17, 'Ferrocianuro de Potasio/Hexacianoferrato (III) de potasio', 'L-2', 400, 0, '', 1, b'1'),
(18, 'Florixil', 'F-1', 400, 0, '', 1, b'1'),
(19, 'Fluoruro de Potasio', 'L-3', 750, 0, '', 1, b'1'),
(20, 'Fosfato  monoacido de sodio y potasio', 'laboratorio', 1.5, 0, '', 1, b'1'),
(21, 'Fosfato dibasico de POTASIO', 'L-3', 9400, 0, '', 1, b'1'),
(22, 'Fosfato  monobásico de Potasio', 'L-3', 6.5, 0, '', 1, b'1'),
(23, 'Fosfato dibasico de sodio anhidro', 'P-2', 7.2, 0, '', 1, b'1'),
(24, 'Fosfato diácido de Amonio', 'J-2', 500, 0, '', 1, b'1'),
(25, 'Fósforo test reactivo-2', 'A-1', 50, 0, '', 1, b'1'),
(26, 'Fructuosa', 'E-1', 2.25, 0, '', 1, b'1'),
(27, 'Flalato ácido de Potasio', 'L-3', 5.1, 0, '', 1, b'1'),
(28, 'Flalimida', 'I-4', 1, 0, '', 1, b'1'),
(29, 'Fusina Cristal', 'A-2', 400, 0, '', 1, b'1'),
(30, 'Fusina para microscopía', 'A-2', 100, 0, '', 1, b'1'),
(31, 'HIDRATO CLORAL', 'B-1', 250, 0, '', 1, b'1'),
(32, 'IODATO DE SODIO', 'D-1', 425, 0, '', 1, b'1'),
(33, 'YODO', 'B-3', 500, 0, '', 1, b'1'),
(34, 'OXIDO DE CROMO (III)', 'C-3', 1.5, 0, '', 1, b'1'),
(35, 'OXIDO DE MANGANESO (IV)', 'B-2', 3.6, 0, '', 1, b'1'),
(36, 'ACIDO PERCLORICO AL 20%', 'D-2', 250, 0, '', 1, b'1'),
(37, 'ACIDO PERCLORICO 30%', 'ESTANT MET', 11.5, 0, '', 1, b'1'),
(38, 'ACIDO PERCLORICO 70%', 'ESTANT MET', 7.5, 0, '', 1, b'1'),
(39, 'Aceite mineral', 'G', 6.5, 0, '', 1, b'1'),
(40, 'Acetanilida', 'I-4', 2, 0, '', 1, b'1'),
(41, 'Acetanimida', 'I-4', 2.5, 0, '', 1, b'1'),
(42, 'Acetato de Amonio', 'J-3', 2, 0, '', 1, b'1'),
(43, 'Acetato de Calcio', 'K-2', 1.5, 0, '', 1, b'1'),
(44, 'Acetato de Cobre (II)', 'K-5', 239, 0, '', 1, b'1'),
(45, 'Acetato de Magnesio', 'L-5', 1.75, 0, '', 1, b'1'),
(46, 'Acetato de Plata', 'K-5', 0, 0, '', 1, b'1'),
(47, 'Acetato de Plomo (II) trihidratado', 'M-2', 2.5, 0, '', 1, b'1'),
(48, 'Acetato de Sodio', 'O-1', 6.3, 0, '', 1, b'1'),
(49, 'Acetato de Sodio trihidratado', 'O-1', 2, 0, '', 1, b'1'),
(50, 'Acetaminofen  (4-hidroxiacetanilidad)', 'laboratorio 3', 100, 0, '', 1, b'1'),
(51, 'Ácido  Fosfomolíbdico', 'H-2', 200, 0, '', 1, b'1'),
(52, 'Ácido 3-5 Dinitrobenzoico', 'H-2', 100, 0, '', 1, b'1'),
(53, 'Acido 3-metlbenzoico', 'lab. 3 estante 3', 500, 0, '', 1, b'1'),
(54, 'Ácido Benzoico', 'H-1', 11, 0, '', 1, b'1'),
(55, 'Ácido Bórico', 'H-1', 0, 0, '', 1, b'1'),
(56, 'Ácido Butírico', 'H-1', 1, 0, '', 1, b'1'),
(57, 'Ácido Cílico', 'H-2', 0, 0, '', 1, b'1'),
(58, 'Ácido Cinámico', 'H-1', 100, 0, '', 1, b'1'),
(59, 'Ácido Cítrico', 'H-1', 0, 0, '', 1, b'1'),
(60, 'Ácido Esteárico', 'H-2', 0, 0, '', 1, b'1'),
(61, 'Ácido Fluorhídrico', 'Q-1', 9, 0, '', 1, b'1'),
(62, 'Ácido Fosforico 30%', 'Q-1', 3.5, 0, '', 1, b'1'),
(63, 'Ácido Fosfórico 85%', 'Q-2', 4, 0, '', 1, b'1'),
(64, 'Ácido Fosfotúnstico', 'H-2', 400, 0, '', 1, b'1'),
(65, 'Ácido Flalico', 'H-3', 2.5, 0, '', 1, b'1'),
(66, 'Ácido Ftálico Anhidro', 'D-2', 0, 0, '', 1, b'1'),
(67, 'Ácido Láctico', 'H-3', 900, 0, '', 1, b'1'),
(68, 'Ácido Maleico', 'H-1', 500, 0, '', 1, b'1'),
(69, 'Ácido Molibdofosfórico', 'H-2', 0, 0, '', 1, b'1'),
(70, 'Ácido Oleico', 'H-3', 1, 0, '', 1, b'1'),
(71, 'Acido oxalico', 'laboratorio', 1, 0, '', 1, b'1'),
(72, 'Ácido Propanoico', 'Q-3', 4, 0, '', 1, b'1'),
(73, 'Ácido Salícilico', 'G-3', 4, 0, '', 1, b'1'),
(74, 'Ácido Selenoso', 'H-3', 400, 0, '', 1, b'1'),
(75, 'Ácido Sulfanílico', 'H-3', 100, 0, '', 1, b'1'),
(76, 'Ácido Tánico', 'H-3', 250, 0, '', 1, b'1'),
(77, 'Ácido Tioglicólico', 'Q-1', 2.5, 0, '', 1, b'1'),
(78, 'Ácido Tricloroacético', 'Q-3', 400, 0, '', 1, b'1'),
(79, 'Ácido Úrico', 'H-2', 200, 0, '', 1, b'1'),
(80, 'Agar Agar', 'E-2', 3, 0, '', 1, b'1'),
(81, 'Alcanfor', 'C-2', 1, 0, '', 1, b'1'),
(82, 'Alizarina Indicador', 'A-2', 200, 0, '', 1, b'1'),
(83, 'Alizarina Sodio Monosulfato', 'A-2', 100, 0, '', 1, b'1'),
(84, 'Almidón', 'E-2', 2.5, 0, '', 1, b'1'),
(85, 'Anaranjado de Metilo', 'B-1', 50, 0, '', 1, b'1'),
(86, 'Anaranjado G', 'B-1', 360, 0, '', 1, b'1'),
(87, 'Anhidro ftálico', 'D-2', 500, 0, '', 1, b'1'),
(88, 'Antraceno', 'D-1', 300, 0, '', 1, b'1'),
(89, 'Antraquinona Violeta R', 'A-1', 300, 0, '', 1, b'1'),
(90, 'Azul de bromofenol', 'B-2', 165, 0, '', 1, b'1'),
(91, 'Azul de metileno', 'B-1', 50, 0, '', 1, b'1'),
(92, 'Aspirina  (Acido acetilsalicilico)', 'laboratorio 3', 150, 0, '', 1, b'1'),
(93, 'azul bromotimol EN BODEG LABORATORIO HAY 15 G', 'B-1', 0, 0, '', 1, b'1'),
(94, 'aceite de bacalao', 'bodega lab organica', 600, 0, '', 1, b'1'),
(95, 'algodón', 'bodega  lab', 1.6, 0, '', 1, b'1'),
(96, 'AZUL DE TIMOL', 'D-2', 50, 0, '', 1, b'1'),
(97, 'ANIZALDEHIDO', 'F-1', 100, 0, '', 1, b'1'),
(98, 'ARENA DE MAR', 'F-2', 500, 0, '', 1, b'1'),
(99, 'ACIDO FOSFOWOLFRAMICO', 'H-2', 75, 0, '', 1, b'1'),
(100, 'ACIDO ORTOFOSFORICO', 'Q-2', 2, 0, '', 1, b'1'),
(101, 'ANIXIDINA', 'I-4', 700, 0, '', 1, b'1'),
(102, 'ACETATO DE MAGNESIO 3H2O', 'L-3', 1750, 0, '', 1, b'1'),
(103, 'ACIDO ACETICO DE POTASIO', 'L-4', 100, 0, '', 1, b'1'),
(104, 'AMONIO', 'Q-6', 2.5, 0, '', 1, b'1'),
(105, 'ANHIDROMOLIBDIC', 'M-1', 500, 0, '', 1, b'1'),
(106, 'ACETATO DE PLOMO DIHIDRATADO', 'M-2', 700, 0, '', 1, b'1'),
(107, 'ACETATO DE BARIO', 'N-2', 500, 0, '', 1, b'1'),
(108, 'Benzofenona', 'D-1', 300, 0, '', 1, b'1'),
(109, 'Borato de Sodio 10H2O', 'P-2', 800, 0, '', 1, b'1'),
(110, 'Bromuro de Potasio', 'L-4', 2.5, 0, '', 1, b'1'),
(111, 'Bromuro de Potasio (comercial)', 'Q-5', 50, 0, '', 1, b'1'),
(112, 'Bromuro de Sodio', 'P-1', 2, 0, '', 1, b'1'),
(113, 'Bronce en polvo', 'I-3', 500, 0, '', 1, b'1'),
(114, 'Bicarbonato de sodio', 'H-2', 5, 0, '', 1, b'1'),
(115, '\"Buffer pH 7,01\"', 'Bodega laboratorio', 5, 0, '', 1, b'1'),
(116, '\"Buffer pH 4,01\"', 'Bodega laboratorio', 1, 0, '', 1, b'1'),
(117, 'buffer ph 10', 'Bodega laboratorio', 0.5, 0, '', 1, b'1'),
(118, 'benzoato de sodio', 'P-1', 1, 0, '', 1, b'1'),
(119, 'Carbón Activado', 'G I-3', 4, 0, '', 1, b'1'),
(120, 'Carbonato de Amonio', 'J-3', 300, 0, '', 1, b'1'),
(121, 'Carbonato de Calcio', 'K-2', 1.25, 0, '', 1, b'1'),
(122, 'Carbonato de Cobre (II)', 'K-5', 50, 0, '', 1, b'1'),
(123, 'Carbonato de Magnesio', 'I-2', 1, 0, '', 1, b'1'),
(124, 'Carbonato de Níquel', 'L-1', 0.5, 0, '', 1, b'1'),
(125, 'Carbonato de Potasio', 'L-2', 500, 0, '', 1, b'1'),
(126, 'Carbonato de Sodio', 'O-3', 500, 0, '', 1, b'1'),
(127, 'Carburo de Calcio', 'K-3', 3.5, 0, '', 1, b'1'),
(128, 'Celulosa Microcristalina', 'E-1', 5, 0, '', 1, b'1'),
(129, 'Celulosa Nativa', 'E-1', 1.5, 0, '', 1, b'1'),
(130, 'Cianato de Potasio', 'L-4', 1, 0, '', 1, b'1'),
(131, 'Cintas de Magnesio', 'L-2', 0.5, 0, '', 1, b'1'),
(132, 'Citrato de Sodio 2H2O', 'P-1', 500, 0, '', 1, b'1'),
(133, 'Clorancotil Cloride', 'D-1', 50, 0, '', 1, b'1'),
(134, '\"CLORURO DE 2.3.5 TRIFENILTRAZOLIO\"', 'A-1', 0, 0, '', 1, b'1'),
(135, 'Cloruro de Aluminio', 'J-4', 1.5, 0, '', 1, b'1'),
(136, 'Cloruro de Amonio', 'J-3', 8, 0, '', 1, b'1'),
(137, 'Cloruro de Bario anhidro', 'M-3', 0.5, 0, '', 1, b'1'),
(138, 'Cloruro de Bario dihidratado', 'M-3', 3, 0, '', 1, b'1'),
(139, 'Cloruro de Cadmio', 'BODEGA LAB', 0, 0, '', 1, b'1'),
(140, 'Cloruro de Calcio', 'K-3', 6, 0, '', 1, b'1'),
(141, 'Cloruro de Calcio dihidratado', 'K-3', 2.5, 0, '', 1, b'1'),
(142, 'Cloruro de Calcio granulado', 'K-3', 1, 0, '', 1, b'1'),
(143, 'Cloruro de Cobre (II) dihidratado', 'K-5', 1750, 0, '', 1, b'1'),
(144, 'Cloruro de estaño', 'L-5', 4, 0, '', 1, b'1'),
(145, 'Cloruro de estroncio', 'Laboratorio', 2, 0, '', 1, b'1'),
(146, 'Cloruro de Hierro (III) hexahidratado', 'N-2', 1, 0, '', 1, b'1'),
(147, 'Cloruro de litio', 'Laboratorio', 0.1, 0, '', 1, b'1'),
(148, 'Cloruro de Magnesio 6 H2O', 'I-1', 1.5, 0, '', 1, b'1'),
(149, 'Cloruro de Mercurio (II)', 'M-3', 1.4, 0, '', 1, b'1'),
(150, 'Cloruro de Níquel (II)', 'L-1', 1, 0, '', 1, b'1'),
(151, 'Cloruro de Plomo', 'M-2', 250, 0, '', 1, b'1'),
(152, 'Cloruro de Potasio', 'L-4', 3.5, 0, '', 1, b'1'),
(153, 'Cloruro de Sodio', 'N-3', 2900, 0, '', 1, b'1'),
(154, 'Cloruro de Zinc', 'N-3', 1, 0, '', 1, b'1'),
(155, 'Cobre en lámina', 'K-4', 10, 0, '', 1, b'1'),
(156, 'Cobre en polvo', 'K-4', 6, 0, '', 1, b'1'),
(157, 'Coloidal de Plata', 'L-5', 20, 0, '', 1, b'1'),
(158, 'caseina', 'labor 3', 0.5, 0, '', 1, b'1'),
(159, 'CAL', 'I-3', 1, 0, '', 1, b'1'),
(160, 'CLORURO DE COBRE (cristales )', 'K-4', 300, 0, '', 1, b'1'),
(161, 'CLORURO DE HIERRO 2 CUATRO AGUAS', 'N-1', 1250, 0, '', 1, b'1'),
(162, 'CLORURO DE NIQUEL 6 H2O', 'BODEGA DE LAB', 125, 0, '', 1, b'1'),
(163, 'NIQUEL METAL', 'BODEGA DE LAB', 500, 0, '', 1, b'1'),
(164, 'COBRE EN TROZOS ( ALAMBRE ) LO TRAE JC', 'BODEGA DE LAB', 5452, 0, '', 1, b'1'),
(165, 'cloruro sodio no reactivo', 'BODEGA DE LAB', 7.5, 0, '', 1, b'1'),
(166, 'clavos de hierro', 'BODEGA DE LAB', 2, 0, '', 1, b'1'),
(167, 'DIOXIDO DE SILICIO', 'I-3', 2, 0, '', 1, b'1'),
(168, 'DIOXIDO DE TITANIO', 'I-5', 1, 0, '', 1, b'1'),
(169, 'DIOFTALATO DE POTASIO', 'L-3', 400, 0, '', 1, b'1'),
(170, 'DIOXIDO DE PLOMO', 'M-2', 500, 0, '', 1, b'1'),
(171, 'DIFENIL-4-SULFONICO', 'M-3', 55, 0, '', 1, b'1'),
(172, 'EDTA', 'C-2', 0.1, 0, '', 1, b'1'),
(173, 'EDTA (sal disodica)', 'C-1', 5.5, 0, '', 1, b'1'),
(174, 'eosina amarilla', 'laboratorio', 75, 0, '', 1, b'1'),
(175, 'Eriocromo Negro T', 'B-1', 175, 0, '', 1, b'1'),
(176, 'Estaño en polvo', 'L-5', 500, 0, '', 1, b'1'),
(177, 'Estaño Granulado', 'BODEGA LAB', 2, 0, '', 1, b'1'),
(178, 'eosina y', 'generales', 0.25, 0, '', 1, b'1'),
(179, 'Gelatina', 'E-2', 0, 0, '', 1, b'1'),
(180, 'Glicerina', 'G-2', 2, 0, '', 1, b'1'),
(181, 'Glucosa monohidratada', 'F-1', 3.05, 0, '', 1, b'1'),
(182, 'Goma arabiga', 'F-1', 250, 0, '', 1, b'1'),
(183, 'GRASA VEGETAL ( MANTECA )', 'BODEGA LAB 3', 1.3, 0, '', 1, b'1'),
(184, 'HIERRO REACTIVO', 'A-1', 10, 0, '', 1, b'1'),
(185, 'Hematoxilina', 'B-2', 200, 0, '', 1, b'1'),
(186, 'Heptamolibdato de Amonio tetrahidratado', 'J-2', 1.25, 0, '', 1, b'1'),
(187, 'Hexaciano Ferrato (II) de Potasio trihidratado', 'L-2', 2, 0, '', 1, b'1'),
(188, 'Hidrocloruro de Hidroxilamina', 'I-5', 0, 0, '', 1, b'1'),
(189, 'Hidroquinona', 'I-5', 1, 0, '', 1, b'1'),
(190, 'Hidroxicarbonato de Niquel', 'L-1', 1.5, 0, '', 1, b'1'),
(191, 'Hidróxido de Amonio 33%', 'Q-6', 16.5, 0, '', 1, b'1'),
(192, 'Hidróxido de Bario 8 H2O', 'M-3', 4.5, 0, '', 1, b'1'),
(193, 'Hidróxido de Calcio', 'K-1', 1, 0, '', 1, b'1'),
(194, 'Hidróxido de Potasio', 'L-2', 2.5, 0, '', 1, b'1'),
(195, 'Hidróxido de Sodio', 'O-2', 31.1, 0, '', 1, b'1'),
(196, 'Hiposulfito de Sodio', 'P-3', 100, 0, '', 1, b'1'),
(197, 'Hidrogenoftalato de potasio', 'L-2', 1400, 0, '', 1, b'1'),
(198, 'HIDROGENOFOSFATO DIPOTASIO', 'L-3', 7, 0, '', 1, b'1'),
(199, 'HIERRO POLVO', 'N-2', 4000, 0, '', 1, b'1'),
(200, 'HIPERCLORATO DE CALCIO', 'K-2', 0.15, 0, '', 1, b'1'),
(201, 'HYDROFLUORICACID 48-51%', 'G-3', 500, 0, '', 1, b'1'),
(202, 'HIPOCLORITO DE CALCIO (68-72%)Cl2', 'K-2', 6, 0, '', 1, b'1'),
(203, 'HYDROQUINONE', 'H-1', 6, 0, '', 1, b'1'),
(204, 'HIDROXIDO DE SODIO (análisis)', 'O-3', 2, 0, '', 1, b'1'),
(205, 'HIERRO METAL ( TUERCAS Y ARANDELAS )', 'BODEGA LAB', 9301, 0, '', 1, b'1'),
(206, 'Indole 3 Acetic Potasio Sal', 'L-4', 100, 0, '', 1, b'1'),
(207, 'Iodoformo', 'G-2', 500, 0, '', 1, b'1'),
(208, 'Ioduro de Mercurio (II)', 'M-3', 150, 0, '', 1, b'1'),
(209, 'Ioduro de Plata', 'L-5', 35, 0, '', 1, b'1'),
(210, 'Ioduro de Potasio', 'L-2', 1000, 0, '', 1, b'1'),
(211, 'Ioduro de Sodio', 'P-3', 3450, 0, '', 1, b'1'),
(212, 'jabon liquido ( lavar cristaleria)', 'bodega laboratorio', 41.6, 0, '', 1, b'1'),
(213, 'Lactosa', 'E-1', 6, 0, '', 1, b'1'),
(214, 'Manganeso Test Solución 1', 'K-1', 50, 0, '', 1, b'1'),
(215, 'Manganeso y Magnesio Test Solución 2', 'K-1', 50, 0, '', 1, b'1'),
(216, 'm-Cresol', 'M-1', 250, 0, '', 1, b'1'),
(217, 'Mercurio metalico', 'M-3', 0, 0, '', 1, b'1'),
(218, 'Metabisulfito de Sodio', 'O-2', 500, 0, '', 1, b'1'),
(219, 'Metoxi-4-benzaldehído', 'G-2', 2, 0, '', 1, b'1'),
(220, 'Molibdato de Amonio', 'J-2', 1.1, 0, '', 1, b'1'),
(221, 'Monovanadato de Amonio', 'J-1', 0, 0, '', 1, b'1'),
(222, 'Murexida', 'A-1', 600, 0, '', 1, b'1'),
(223, 'maltosa', 'bod lab 3', 100, 0, '', 1, b'1'),
(224, '2-Naftol', 'F-3', 0, 0, '', 1, b'1'),
(225, 'Naftaleno', 'C-2', 2, 0, '', 1, b'1'),
(226, 'Nitrato de aluminio 9 H2O', 'P-3', 500, 0, '', 1, b'1'),
(227, 'Nitrato de bismuto (III) 5H2O', 'P-3', 500, 0, '', 1, b'1'),
(228, 'Nitrato de Calcio tetrahidratado', 'Q-8', 4, 0, '', 1, b'1'),
(229, 'Nitrato de Calcio trihidratado', 'Q-8', 1, 0, '', 1, b'1'),
(230, 'Nitrato de cobre (II) 3 H2O', 'P-3', 2.6, 0, '', 1, b'1'),
(231, 'Nitrato de hierro (III) 9 H2O', 'N-1', 1, 0, '', 1, b'1'),
(232, 'Nitrato de Mercurio (I) dihidratado', 'Q-7', 0, 0, '', 1, b'1'),
(233, 'Nitrato de Mercurio (II) monohidratado', 'Q-7', 250, 0, '', 1, b'1'),
(234, 'Nitrato de Níquel II 6H2O', 'P-3', 0, 0, '', 1, b'1'),
(235, 'Nitrato de Plata', 'L-5', 0, 0, '', 1, b'1'),
(236, 'Nitrato de Plomo (II)', 'Q-7', 8, 0, '', 1, b'1'),
(237, 'Nitrato de Potasio', 'Q-8', 5, 0, '', 1, b'1'),
(238, 'Nitrato de Sodio', 'P-3', 3, 0, '', 1, b'1'),
(239, 'Nitrato reactivo-1', 'A-1', 50, 0, '', 1, b'1'),
(240, 'Nitrito de Sodio', 'Q-7', 1.5, 0, '', 1, b'1'),
(241, 'o-Anisidina', 'I-4', 800, 0, '', 1, b'1'),
(242, 'o-Anizaldehído', 'F-1', 100, 0, '', 1, b'1'),
(243, 'Oxalato de Amonio', 'J-1', 1, 0, '', 1, b'1'),
(244, 'Oxalato de Potasio monohidratado', 'L-4', 1, 0, '', 1, b'1'),
(245, 'Oxalato de Sodio', 'O-1', 1, 0, '', 1, b'1'),
(246, 'Óxido de Aluminio', 'J-4', 1.5, 0, '', 1, b'1'),
(247, 'Óxido de Aluminio 150 básico', 'J-5', 1.8, 0, '', 1, b'1'),
(248, 'Óxido de Aluminio 150 G neutro 150', 'J-5', 150, 0, '', 1, b'1'),
(249, 'Óxido de Aluminio 60 básico', 'J-5', 1, 0, '', 1, b'1'),
(250, 'Óxido de Aluminio 60 neutro', 'J-4', 2.5, 0, '', 1, b'1'),
(251, 'Óxido de Aluminio 90 activi ácido', 'J-4', 900, 0, '', 1, b'1'),
(252, 'Óxido de Aluminio 90 neutro', 'J-4', 0, 0, '', 1, b'1'),
(253, 'Óxido de Aluminio para Metalografía', 'J-5', 1, 0, '', 1, b'1'),
(254, 'Óxido de Calcio', 'K-2', 2, 0, '', 1, b'1'),
(255, 'Óxido de Cobre (II)', 'K-5', 1, 0, '', 1, b'1'),
(256, 'Óxido de Hierro (III)', 'N-2', 8.8, 0, '', 1, b'1'),
(257, 'Óxido de Magnesio', 'I-1', 4.9, 0, '', 1, b'1'),
(258, 'Óxido de Manganeso IV', 'M-2', 143, 0, '', 1, b'1'),
(259, 'Óxido de Molibdeno (VI)', 'M-2', 550, 0, '', 1, b'1'),
(260, 'Óxido de Plomo (IV)', 'M-2', 250, 0, '', 1, b'1'),
(261, 'Óxido de Silicio (IV)', 'I-3', 1.4, 0, '', 1, b'1'),
(262, 'Óxido de Titanio (IV)', 'I-3', 1, 0, '', 1, b'1'),
(263, 'Óxido de Zinc', 'N-3', 2, 0, '', 1, b'1'),
(264, 'OFTALEMINA', 'I-5', 1, 0, '', 1, b'1'),
(265, 'Parafina', 'F-1', 1, 0, '', 1, b'1'),
(266, 'Penta Clorofenol', 'M-1', 2.25, 0, '', 1, b'1'),
(267, 'Pentaclorofenol', 'F-3', 500, 0, '', 1, b'1'),
(268, 'Plomo en lámina', 'M-2', 300, 0, '', 1, b'1'),
(269, 'Plomo Granulado', 'M-2', 0, 0, '', 1, b'1'),
(270, 'Polvora negra', 'P-3', 50, 0, '', 1, b'1'),
(271, 'P-CLOROANILINA', 'LAB. 3', 3.5, 0, '', 1, b'1'),
(272, 'PLATA COLOIDAL', 'L-5', 20, 0, '', 1, b'1'),
(273, 'PLOMO METAL ( ARANDELAS )', 'BODEGA LAB', 8200, 0, '', 1, b'1'),
(274, 'Resorcina', 'F-3', 250, 0, '', 1, b'1'),
(275, 'Rojo Congo', 'B-2', 250, 0, '', 1, b'1'),
(276, 'Rojo de Metilo', 'B-1', 135, 0, '', 1, b'1'),
(277, 'rojo cresol', 'bodega lab', 0.25, 0, '', 1, b'1'),
(278, 'rojo clorofenol', 'bodega lab', 0.5, 0, '', 1, b'1'),
(279, 'rojo fenol', 'bodega lab', 0.1, 0, '', 1, b'1'),
(280, 'rojo brofenol', 'bodega lab', 0, 0, '', 1, b'1'),
(281, 'ROJO METILO', 'D-2', 10, 0, '', 1, b'1'),
(282, 'Sacarina Sódica', 'P-3', 50, 0, '', 1, b'1'),
(283, 'Sacarosa', 'E-1', 12, 0, '', 1, b'1'),
(284, 'Safranina', 'A-1', 50, 0, '', 1, b'1'),
(285, 'Safranina O', 'A-2', 400, 0, '', 1, b'1'),
(286, 'Sal de bario de difenilamina 4 sulfonico', 'M-3', 0, 0, '', 1, b'1'),
(287, 'Selenito de Sodio Pentahidratado', 'O-3', 300, 0, '', 1, b'1'),
(288, 'Sílica gel', 'I-3', 5100, 0, '', 1, b'1'),
(289, 'Sulfato de Aluminio', 'J-4', 0, 0, '', 1, b'1'),
(290, 'Sulfato de Amonio', 'J-3', 1, 0, '', 1, b'1'),
(291, 'Sulfato de Amonio y Cerio dihidratado', 'J-3', 100, 0, '', 1, b'1'),
(292, 'Sulfato de Amonio y Hierro (III) dodecahidratado', 'J-1', 0, 0, '', 1, b'1'),
(293, 'Sulfato de Calcio dihidratado', 'K-3', 1, 0, '', 1, b'1'),
(294, 'Sulfato de cerio (IV) tetrahidratado', 'J-3', 2, 0, '', 1, b'1'),
(295, 'Sulfato de Cobre (II)', 'K-4', 4, 0, '', 1, b'1'),
(296, 'Sulfato de Cobre (II) pentahidratado', 'K-5', 9.5, 0, '', 1, b'1'),
(297, 'Sulfato de Hierro (II) heptahidratado', 'N-1', 2.5, 0, '', 1, b'1'),
(298, 'Sulfato de Hierro (III) hidratado', 'N-1', 0.5, 0, '', 1, b'1'),
(299, 'Sulfato de hierro II y amonio', 'O-3', 1.5, 0, '', 1, b'1'),
(300, 'Sulfato de Magnesio', 'I-1', 1, 0, '', 1, b'1'),
(301, 'Sulfato de Magnesio - 7H2O', 'I-1', 1.8, 0, '', 1, b'1'),
(302, 'Sulfato de Manganeso (II)', 'K-1', 4, 0, '', 1, b'1'),
(303, 'Sulfato de Níquel hexahidratado', 'L-4', 400, 0, '', 1, b'1'),
(304, 'Sulfato de Sodio Anhidro', 'O-3', 3.5, 0, '', 1, b'1'),
(305, 'Sulfato de Sodio decahidratado', 'O-3', 10, 0, '', 1, b'1'),
(306, 'Sulfato de Zinc heptahidratado', 'N-3', 0, 0, '', 1, b'1'),
(307, 'Sulfito acido de sodio', 'P-3', 1, 0, '', 1, b'1'),
(308, 'Sulfito de sodio', 'O-3', 2, 0, '', 1, b'1'),
(309, 'Sulfuro de Hierro (II)', 'N-1', 750, 0, '', 1, b'1'),
(310, 'Sulfuro de Sodio x hidratado', 'P-1', 750, 0, '', 1, b'1'),
(311, 'SACAROSA NO REACTIVO ( AZUCAR COMUN)', 'BODEGA LAB', 4, 0, '', 1, b'1'),
(312, 'INDIGO CARMIN', 'BODEG LABO', 25, 0, '', 1, b'1'),
(313, 'Talco', 'Q-4', 3, 0, '', 1, b'1'),
(314, 'Tartrato de Antimonio y Potasio', 'L-3', 500, 0, '', 1, b'1'),
(315, 'Tartrato de Potasio hemihidratado', 'L-3', 1, 0, '', 1, b'1'),
(316, 'Tartrato de Sodio dihidratado', 'O-3', 1, 0, '', 1, b'1'),
(317, 'Tartrato de Sodio y Potasio', 'O-3', 5, 0, '', 1, b'1'),
(318, 'Tetraborato de Sodio 10 H2O', 'P-2', 0.2, 0, '', 1, b'1'),
(319, 'Tetracloruro de carbono', 'lab. Organica', 3, 0, '', 1, b'1'),
(320, 'Tierra Silicia', 'I-3', 600, 0, '', 1, b'1'),
(321, 'Timol cristal', 'B-1', 400, 0, '', 1, b'1'),
(322, 'Tiocianato de Amonio', 'J-1', 4, 0, '', 1, b'1'),
(323, 'Tiocianato de Potasio', 'L-3', 1, 0, '', 1, b'1'),
(324, 'Tiocianato de Sodio', 'O-3', 0.5, 0, '', 1, b'1'),
(325, 'Tiosulfato de Sodio 5 H2O', 'O-2', 3.75, 0, '', 1, b'1'),
(326, 'Tricloroetileno', 'M-1', 1, 0, '', 1, b'1'),
(327, 'Trietanolamina', 'M-1', 3, 0, '', 1, b'1'),
(328, 'timolftaleina', 'bodega lab', 0.15, 0, '', 1, b'1'),
(329, 'Urea', 'D-1', 0, 0, '', 1, b'1'),
(330, 'Vanadato de Amonio', 'J-1', 25, 0, '', 1, b'1'),
(331, 'Vaselina líquida', 'Q-4', 0, 0, '', 1, b'1'),
(332, 'Verde de Bromocresol', 'B-2', 25, 0, '', 1, b'1'),
(333, 'Verde de Malaquita', 'B-2', 400, 0, '', 1, b'1'),
(334, 'Violeta Cristal', 'Ubicación General', 175, 0, '', 1, b'1'),
(335, 'VERDE METILO', 'D-2', 25, 0, '', 1, b'1'),
(336, 'Wolfranato de Sodio dihidratado', 'P-3', 250, 0, '', 1, b'1'),
(337, 'XILOSA', 'F-1', 10, 0, '', 1, b'1'),
(338, 'Zinc granular', 'bodega labor.', 2735, 0, '', 1, b'1'),
(339, 'ACETALDEHIDO', 'G-2', 1.5, 0, '', 1, b'1'),
(340, 'ACETATO DE ETILO', 'ESTA MET', 8, 0, '', 1, b'1'),
(341, 'ACETONA', 'I-4', 32, 0, '', 1, b'1'),
(342, 'ALCOHOL BENCILICO', 'B-3', 1.6, 0, '', 1, b'1'),
(343, 'ACIDO FORMICO', 'A-1', 2, 0, '', 1, b'1'),
(344, 'ALCOHOL ISOPROPILICO', 'B-2', 0, 0, '', 1, b'1'),
(345, 'ALCOHOL Amilico', 'B-1', 11, 0, '', 1, b'1'),
(346, 'ALUMINIO EN ALAMBRE', 'H-4', 0, 0, '', 1, b'1'),
(347, 'Aluminio EN COLOCHOS', 'H-4', 0, 0, '', 1, b'1'),
(348, 'ALUMINIO EN LAMINA', 'H-4', 1, 0, '', 1, b'1'),
(349, 'ALUMINIO EN POLVO', 'H-4', 0, 0, '', 1, b'1'),
(350, 'ANIHIDRIDO ACETICO', 'F-1', 3, 0, '', 1, b'1'),
(351, 'ANILINA', 'G-1', 22.5, 0, '', 1, b'1'),
(352, 'AZUFRE', 'D-1', 2500, 0, '', 1, b'1'),
(353, 'AZUFRE EN POLVO', 'D-1', 32, 0, '', 1, b'1'),
(354, 'ALCOHOL ISOAMILICO', 'B-1', 6, 0, '', 1, b'1'),
(355, 'ALCOHOL N-PROPILICO', 'B-1', 7, 0, '', 1, b'1'),
(356, 'ALUMBRE DE POTASIO', 'F-1', 1, 0, '', 1, b'1'),
(357, '1-BROMOBUTANO', 'C-2', 1.5, 0, '', 1, b'1'),
(358, '1-BUTANOL', 'C-1', 2, 0, '', 1, b'1'),
(359, '2- BUTANOL', 'C-2', 3.5, 0, '', 1, b'1'),
(360, 'BENCENO', 'I-1', 0, 0, '', 1, b'1'),
(361, 'BENZALDEHIDO', 'G-2', 0.5, 0, '', 1, b'1'),
(362, 'BROMO', 'J-3', 0, 0, '', 1, b'1'),
(363, 'BROMOBENCENO', 'F-3', 2.5, 0, '', 1, b'1'),
(364, 'MONO-BROMO-BENCENO', 'F-3', 0.5, 0, '', 1, b'1'),
(365, '1-CLORO-2-METIL-2-PROPANOL', 'C-2', 20, 0, '', 1, b'1'),
(366, '1-CLOROBUTANO', 'C-2', 5, 0, '', 1, b'1'),
(367, '2-CLOROBUTANO', 'C-2', 0.5, 0, '', 1, b'1'),
(368, 'Canfin', 'laboratorio', 6, 0, '', 1, b'1'),
(369, 'CICLOHEXANO', 'H-3', 6, 0, '', 1, b'1'),
(370, 'CICLOHEXANOL', 'C-1', 6, 0, '', 1, b'1'),
(371, 'CLOROBENCENO', 'F-3', 2, 0, '', 1, b'1'),
(372, 'CLORURO DE ACETILO', 'G-2', 2.75, 0, '', 1, b'1'),
(373, 'CICLOHEXENO', 'H-1', 2, 0, '', 1, b'1'),
(374, 'Cloroformo*', 'I-2', 16, 0, '', 1, b'1'),
(375, '1-4 DIOXANO', 'A-2', 1.4, 0, '', 1, b'1'),
(376, '\"2,2-DIETIL PROPANEDIOL\"', 'C-1', 2, 0, '', 1, b'1'),
(377, 'DEKALIN (C10H18)', 'F-1', 600, 0, '', 1, b'1'),
(378, 'DISULFURO DE CARBONO', 'H-4', 12, 0, '', 1, b'1'),
(379, 'Diclorometano', 'ESTANT META', 18, 0, '', 1, b'1'),
(380, '2-ETIL BUTIRALDEHIDO', 'd-3', 4, 0, '', 1, b'1'),
(381, 'ETANOL', 'E-1', 0, 0, '', 1, b'1'),
(382, 'ETANOL ABSOLUTO', 'B-3', 1, 0, '', 1, b'1'),
(383, 'ETANOLAMINA', 'A-3', 2, 0, '', 1, b'1'),
(384, 'ETER DE PETROLEO', 'ESTANT MET', 31, 0, '', 1, b'1'),
(385, 'ETER ETILICO', 'G-4', 3, 0, '', 1, b'1'),
(386, 'ETOXY ETANOL', 'C-2', 2, 0, '', 1, b'1'),
(387, 'Eter butilico', 'H-1', 4, 0, '', 1, b'1'),
(388, 'FORMALDEHIDO', 'H-2', 34, 0, '', 1, b'1'),
(389, 'FOSFORO AMORFO', 'F-4', 2.5, 0, '', 1, b'1'),
(390, 'FOSFORO BLANCO', 'F-4', 700, 0, '', 1, b'1'),
(391, 'FURANO', 'I-2', 200, 0, '', 1, b'1'),
(392, 'FURFURAL', 'D-2', 0, 0, '', 1, b'1'),
(393, '1.10 fenantrolina', 'Bod lab3', 0.25, 0, '', 1, b'1'),
(394, '1-HEXENO', 'F-2', 2.1, 0, '', 1, b'1'),
(395, '2-HEXANONA', 'F-2', 100, 0, '', 1, b'1'),
(396, 'HEPTANAL', 'G-4', 0, 0, '', 1, b'1'),
(397, 'HEXANAL', 'C-1', 2, 0, '', 1, b'1'),
(398, 'HEXANO', 'ESTANTE MET', 53.34, 0, '', 1, b'1'),
(399, 'LANA DE ACERO', 'F-1', 5, 0, '', 1, b'1'),
(400, '2-METIL 2 PROPANOL', 'ESTANT MET', 5, 0, '', 1, b'1'),
(401, 'METANOL', 'ESTANT MET', 9, 0, '', 1, b'1'),
(402, 'METHYL ISOBUTYL CETONA', 'C-1', 0, 0, '', 1, b'1'),
(403, 'M-XILENO', 'G-3', 5, 0, '', 1, b'1'),
(404, 'METIL - PROPIL-CETONA', 'B-2', 6, 0, '', 1, b'1'),
(405, 'N-HEPTANO', 'H-4', 2, 0, '', 1, b'1'),
(406, 'NIQUEL EN POLVO', 'B-4', 0, 0, '', 1, b'1'),
(407, 'O-XILENO', 'G-3', 900, 0, '', 1, b'1'),
(408, '1-OCTANOL', 'LAB DOC  3', 1500, 0, '', 1, b'1'),
(409, '1-PENTANOL', 'I-H2', 1500, 0, '', 1, b'1'),
(410, '1-PENTENO', 'F-2', 0, 0, '', 1, b'1'),
(411, '1-PROPANOL', 'C-3', 1500, 0, '', 1, b'1'),
(412, '2-PENTANOL', 'I-2', 1, 0, '', 1, b'1'),
(413, '2-PENTANONA', 'B-2', 6, 0, '', 1, b'1'),
(414, '2-PROPANOL', 'ESTANT MET', 8, 0, '', 1, b'1'),
(415, 'PIRIDINA', 'F-2', 1.5, 0, '', 1, b'1'),
(416, 'POTASIO METALICO', 'F-1', 500, 0, '', 1, b'1'),
(417, 'P-XILENO', 'G-3', 500, 0, '', 1, b'1'),
(418, 'SODIO METALICO', 'G-3', 3, 0, '', 1, b'1'),
(419, 'SULFATO DE ALUMINIO Y POTASIO', 'H-4', 1, 0, '', 1, b'1'),
(420, 'SILICILATO DE METILO', 'G-4', 1, 0, '', 1, b'1'),
(421, 'SULFURO DE CARBONO', 'H-3', 9.5, 0, '', 1, b'1'),
(422, 'TETRAHYDROFURANO', 'A-1', 16, 0, '', 1, b'1'),
(423, 'TOLUENO', 'ESTANT MET', 12, 0, '', 1, b'1'),
(424, '2.3.5 TRIFENILTETRASOLIO CLORADO', 'A-1', 20, 0, '', 1, b'1'),
(425, 'XILENO', 'G-2', 16, 0, '', 1, b'1'),
(426, 'CLORATO DE POTASIO', 'C-4', 1.5, 0, '', 1, b'1'),
(427, 'AZUL DE BROMOTIMOL', 'B-1', 165, 0, '', 1, b'1'),
(428, 'CROMATO DE POTASIO', 'C-4', 0, 0, '', 1, b'1'),
(429, 'DICROMATO DE POTASIO', 'D-2', 2, 0, '', 1, b'1'),
(430, 'DICROMATO DE SODIO DIHIDRATADO', 'C-3', 1, 0, '', 1, b'1'),
(431, 'CROMATO DE SODIO', 'C-2', 2, 0, '', 1, b'1'),
(432, 'DICROMATO DE POTASIO 99.9%', 'D-2', 2, 0, '', 1, b'1'),
(433, 'DICROMATO DE SODIO DIHIDRATADO', 'C-3', 1, 0, '', 1, b'1'),
(434, 'NITRATO DE AMONIO', 'B-3', 3, 0, '', 1, b'1'),
(435, 'PENTACLORURO DE ANTIMONIO', 'D-2', 200, 0, '', 1, b'1'),
(436, 'PERIODATO DE POTASIO', 'D-2', 150, 0, '', 1, b'1'),
(437, 'PERMANGANATO DE POTASIO', 'D-2', 1.5, 0, '', 1, b'1'),
(438, 'PEROXIDO DE HIDROGENO 3%', 'ESTANTE MET', 10, 0, '', 1, b'1'),
(439, 'PEROXIDO DE HIDROGENO 33%', 'ESTANTE MET', 7.4, 0, '', 1, b'1'),
(440, 'PEROXIDO DE HIDROGENO 20 %', 'ESTANTE MET', 2, 0, '', 1, b'1'),
(441, 'PERSULFATO DE POTASIO', 'C-2', 1.5, 0, '', 1, b'1'),
(442, 'SULFATO DE AMONIO Y CERIO 2 AGUAS', 'B-2', 600, 0, '', 1, b'1'),
(443, 'Revision 3', 'Virtual', 10, 0, 'Probando Unidad métrica', 1, b'0'),
(444, 'prueba #2', 'das', 1000, 11, 'asdf', 1, b'0'),
(445, 'Desde el cel', 'Ks', 100, 200, 'Djs', 1, b'0'),
(446, 'Nada 12', 'Su', 10, 10, 'D', 1, b'0');

-- --------------------------------------------------------

--
-- Table structure for table `ArticuloPedido`
--

CREATE TABLE `ArticuloPedido` (
  `ArticuloPedidoID` int(11) NOT NULL,
  `PedidoID` int(11) NOT NULL,
  `ArticuloID` int(11) NOT NULL,
  `CantidadSolicitada` float NOT NULL,
  `Observacion` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `ArticuloPedido`
--

INSERT INTO `ArticuloPedido` (`ArticuloPedidoID`, `PedidoID`, `ArticuloID`, `CantidadSolicitada`, `Observacion`) VALUES
(1, 1, 1, 10, 'Revision'),
(2, 1, 7, 10, 'Revisión'),
(3, 1, 341, 10, 'Pedido para el mes de octubre, Escuela de Química.');

-- --------------------------------------------------------

--
-- Table structure for table `CategoriaReactivo`
--

CREATE TABLE `CategoriaReactivo` (
  `CategoriaReactivoID` int(11) NOT NULL,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `CategoriaReactivo`
--

INSERT INTO `CategoriaReactivo` (`CategoriaReactivoID`, `Nombre`) VALUES
(1, 'OXIDANTES'),
(2, 'GENERAL'),
(3, 'INFLAMABLES'),
(4, 'CORROSIVOS');

-- --------------------------------------------------------

--
-- Table structure for table `Chat`
--

CREATE TABLE `Chat` (
  `ChatID` int(11) NOT NULL,
  `UsuarioAID` int(11) NOT NULL,
  `UsuarioBID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Chat`
--

INSERT INTO `Chat` (`ChatID`, `UsuarioAID`, `UsuarioBID`) VALUES
(2, 21, 7),
(3, 21, 29),
(7, 56, 7);

-- --------------------------------------------------------

--
-- Table structure for table `EstadoNotificacion`
--

CREATE TABLE `EstadoNotificacion` (
  `EstadoNotifiacionID` int(11) NOT NULL,
  `NotificacionGeneralID` int(11) NOT NULL,
  `UsuarioID` int(11) NOT NULL,
  `Visible` bit(1) NOT NULL DEFAULT b'1',
  `Leida` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `EstadoPrestamo`
--

CREATE TABLE `EstadoPrestamo` (
  `EstadoPrestamoID` int(11) NOT NULL,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Descripcion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `EstadoPrestamo`
--

INSERT INTO `EstadoPrestamo` (`EstadoPrestamoID`, `Nombre`, `Descripcion`) VALUES
(1, 'Pendiente', 'Se ingresó la solicitud de un préstamo'),
(2, 'Aprobado', 'La solicitud de préstamo se aprobó'),
(3, 'Rechazado', 'La solicitud de préstamo se rechazó'),
(4, 'Devuelto', 'El artículo fue devuelto.'),
(5, 'Tardío', 'El artículo no se devolvió a tiempo.'),
(6, 'Despachado', 'El artículo se despachó');

-- --------------------------------------------------------

--
-- Table structure for table `EstadoUsuario`
--

CREATE TABLE `EstadoUsuario` (
  `EstadoUsuarioID` int(11) NOT NULL,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `EstadoUsuario`
--

INSERT INTO `EstadoUsuario` (`EstadoUsuarioID`, `Nombre`, `Descripcion`) VALUES
(1, 'Activo', 'El usuario puede acceder normalmente a su cuenta'),
(2, 'Inactivo', 'El usuario no puede acceder normalmente a su cuenta'),
(3, 'Pendiente', 'El usuario no ha sido aprobado por el cliente'),
(4, 'Eliminado', 'El usuario fue rechazado por el coordinador');

-- --------------------------------------------------------

--
-- Table structure for table `ListaNegraNotificacionPorUsuario`
--

CREATE TABLE `ListaNegraNotificacionPorUsuario` (
  `ListaNegraNotificacionPorUsuarioID` int(11) NOT NULL,
  `ArticuloID` int(11) NOT NULL,
  `UsuarioID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `MensajeChat`
--

CREATE TABLE `MensajeChat` (
  `MensajeChatID` int(11) NOT NULL,
  `ChatID` int(11) NOT NULL,
  `UsuarioEmisorID` int(11) NOT NULL,
  `FechaHora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Mensaje` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `MensajeChat`
--

INSERT INTO `MensajeChat` (`MensajeChatID`, `ChatID`, `UsuarioEmisorID`, `FechaHora`, `Mensaje`) VALUES
(4, 2, 21, '2018-05-18 16:34:46', 'hola'),
(5, 3, 21, '2018-05-18 16:35:47', 'hola'),
(13, 7, 56, '2018-06-04 06:04:35', 'Hola Andrey, cómo está?');

-- --------------------------------------------------------

--
-- Table structure for table `Movimiento`
--

CREATE TABLE `Movimiento` (
  `MovimientoID` int(11) NOT NULL,
  `Fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TipoMovimientoID` int(11) NOT NULL,
  `UsuarioAutorizadorID` int(11) NOT NULL,
  `ArticuloID` int(11) NOT NULL,
  `CantidadAntes` float NOT NULL,
  `CantidadDespues` float NOT NULL,
  `Destino` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Observaciones` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `NotificacionGeneral`
--

CREATE TABLE `NotificacionGeneral` (
  `NotificacionGeneralID` int(11) NOT NULL,
  `TipoNotificacionID` int(11) NOT NULL,
  `Texto` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Pedido`
--

CREATE TABLE `Pedido` (
  `PedidoID` int(11) NOT NULL,
  `Titulo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UsuarioSolicitanteID` int(11) NOT NULL,
  `Descripcion` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Pedido`
--

INSERT INTO `Pedido` (`PedidoID`, `Titulo`, `UsuarioSolicitanteID`, `Descripcion`) VALUES
(1, 'Pedido Revisión', 7, 'Revisión');

-- --------------------------------------------------------

--
-- Table structure for table `Prestamo`
--

CREATE TABLE `Prestamo` (
  `PrestamoID` int(11) NOT NULL,
  `UsuarioSolicitanteID` int(11) NOT NULL,
  `ArticuloID` int(11) NOT NULL,
  `UsuarioAutorizadorID` int(11) DEFAULT NULL,
  `CantidadSolicitada` float NOT NULL,
  `FechaSolicitud` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `FechaAutorizacion` datetime DEFAULT NULL,
  `MovimientoEntregaID` int(11) DEFAULT NULL,
  `MovimientoDevolucionID` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FechaLimiteDevolucion` datetime NOT NULL,
  `EstadoPrestamoID` int(11) NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Reactivo`
--

CREATE TABLE `Reactivo` (
  `ReactivoID` int(11) NOT NULL,
  `ArticuloID` int(11) NOT NULL,
  `EsPrecursor` bit(1) NOT NULL,
  `UnidadMetricaID` int(11) NOT NULL,
  `Categoria` int(11) NOT NULL,
  `URLHojaSeguridad` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Reactivo`
--

INSERT INTO `Reactivo` (`ReactivoID`, `ArticuloID`, `EsPrecursor`, `UnidadMetricaID`, `Categoria`, `URLHojaSeguridad`) VALUES
(1, 1, b'0', 1, 1, ''),
(2, 2, b'0', 1, 1, ''),
(3, 3, b'0', 2, 1, ''),
(4, 4, b'0', 2, 1, ''),
(5, 5, b'0', 1, 1, ''),
(6, 6, b'0', 1, 1, ''),
(7, 7, b'0', 4, 1, ''),
(8, 8, b'0', 2, 1, ''),
(9, 9, b'0', 3, 1, ''),
(10, 10, b'0', 3, 1, ''),
(11, 11, b'0', 2, 1, ''),
(12, 12, b'0', 1, 1, ''),
(13, 13, b'0', 4, 1, ''),
(14, 14, b'0', 4, 1, ''),
(15, 15, b'0', 2, 1, ''),
(16, 16, b'0', 4, 1, ''),
(17, 17, b'0', 4, 1, ''),
(18, 18, b'0', 4, 1, ''),
(19, 19, b'0', 4, 1, ''),
(20, 20, b'0', 2, 1, ''),
(21, 21, b'0', 4, 1, ''),
(22, 22, b'0', 2, 1, ''),
(23, 23, b'0', 2, 1, ''),
(24, 24, b'0', 4, 1, ''),
(25, 25, b'0', 3, 1, ''),
(26, 26, b'0', 2, 1, ''),
(27, 27, b'0', 2, 1, ''),
(28, 28, b'0', 2, 1, ''),
(29, 29, b'0', 2, 1, ''),
(30, 30, b'0', 4, 1, ''),
(31, 31, b'0', 4, 1, ''),
(32, 32, b'0', 4, 1, ''),
(33, 33, b'0', 4, 1, ''),
(34, 34, b'0', 2, 1, ''),
(35, 35, b'0', 2, 1, ''),
(36, 36, b'0', 3, 1, ''),
(37, 37, b'0', 2, 1, ''),
(38, 38, b'0', 1, 1, ''),
(39, 39, b'0', 1, 2, ''),
(40, 40, b'0', 2, 2, ''),
(41, 41, b'0', 2, 2, ''),
(42, 42, b'0', 2, 2, ''),
(43, 43, b'0', 2, 2, ''),
(44, 44, b'0', 4, 2, ''),
(45, 45, b'0', 2, 2, ''),
(46, 46, b'0', 4, 2, ''),
(47, 47, b'0', 2, 2, ''),
(48, 48, b'0', 2, 2, ''),
(49, 49, b'0', 2, 2, ''),
(50, 50, b'0', 4, 2, ''),
(51, 51, b'0', 4, 2, ''),
(52, 52, b'0', 4, 2, ''),
(53, 53, b'0', 4, 2, ''),
(54, 54, b'0', 2, 2, ''),
(55, 55, b'0', 2, 2, ''),
(56, 56, b'0', 1, 2, ''),
(57, 57, b'0', 4, 2, ''),
(58, 58, b'0', 4, 2, ''),
(59, 59, b'0', 2, 2, ''),
(60, 60, b'0', 2, 2, ''),
(61, 61, b'0', 1, 2, ''),
(62, 62, b'0', 1, 2, ''),
(63, 63, b'0', 1, 2, ''),
(64, 64, b'0', 4, 2, ''),
(65, 65, b'0', 2, 2, ''),
(66, 66, b'0', 2, 2, ''),
(67, 67, b'0', 3, 2, ''),
(68, 68, b'0', 4, 2, ''),
(69, 69, b'0', 4, 2, ''),
(70, 70, b'0', 1, 2, ''),
(71, 71, b'0', 2, 2, ''),
(72, 72, b'0', 1, 2, ''),
(73, 73, b'0', 2, 2, ''),
(74, 74, b'0', 4, 2, ''),
(75, 75, b'0', 2, 2, ''),
(76, 76, b'0', 4, 2, ''),
(77, 77, b'0', 1, 2, ''),
(78, 78, b'0', 3, 2, ''),
(79, 79, b'0', 4, 2, ''),
(80, 80, b'0', 2, 2, ''),
(81, 81, b'0', 2, 2, ''),
(82, 82, b'0', 4, 2, ''),
(83, 83, b'0', 4, 2, ''),
(84, 84, b'0', 2, 2, ''),
(85, 85, b'0', 4, 2, ''),
(86, 86, b'0', 4, 2, ''),
(87, 87, b'0', 4, 2, ''),
(88, 88, b'0', 4, 2, ''),
(89, 89, b'0', 2, 2, ''),
(90, 90, b'0', 4, 2, ''),
(91, 91, b'0', 4, 2, ''),
(92, 92, b'0', 4, 2, ''),
(93, 93, b'0', 4, 2, ''),
(94, 94, b'0', 3, 2, ''),
(95, 95, b'0', 2, 2, ''),
(96, 96, b'0', 4, 2, ''),
(97, 97, b'0', 4, 2, ''),
(98, 98, b'0', 4, 2, ''),
(99, 99, b'0', 4, 2, ''),
(100, 100, b'0', 1, 2, ''),
(101, 101, b'0', 1, 2, ''),
(102, 102, b'0', 2, 2, ''),
(103, 103, b'0', 4, 2, ''),
(104, 104, b'0', 1, 2, ''),
(105, 105, b'0', 4, 2, ''),
(106, 106, b'0', 4, 2, ''),
(107, 107, b'0', 4, 2, ''),
(108, 108, b'0', 4, 2, ''),
(109, 109, b'0', 4, 2, ''),
(110, 110, b'0', 2, 2, ''),
(111, 111, b'0', 2, 2, ''),
(112, 112, b'0', 2, 2, ''),
(113, 113, b'0', 4, 2, ''),
(114, 114, b'0', 2, 2, ''),
(115, 115, b'0', 1, 2, ''),
(116, 116, b'0', 1, 2, ''),
(117, 117, b'0', 2, 2, ''),
(118, 118, b'0', 1, 2, ''),
(119, 119, b'0', 2, 2, ''),
(120, 120, b'0', 4, 2, ''),
(121, 121, b'0', 2, 2, ''),
(122, 122, b'0', 4, 2, ''),
(123, 123, b'0', 2, 2, ''),
(124, 124, b'0', 2, 2, ''),
(125, 125, b'0', 4, 2, ''),
(126, 126, b'0', 2, 2, ''),
(127, 127, b'0', 2, 2, ''),
(128, 128, b'0', 2, 2, ''),
(129, 129, b'0', 2, 2, ''),
(130, 130, b'0', 2, 2, ''),
(131, 131, b'0', 5, 2, ''),
(132, 132, b'0', 2, 2, ''),
(133, 133, b'0', 3, 2, ''),
(134, 134, b'0', 3, 2, ''),
(135, 135, b'0', 2, 2, ''),
(136, 136, b'0', 2, 2, ''),
(137, 137, b'0', 2, 2, ''),
(138, 138, b'0', 2, 2, ''),
(139, 139, b'0', 2, 2, ''),
(140, 140, b'0', 2, 2, ''),
(141, 141, b'0', 2, 2, ''),
(142, 142, b'0', 2, 2, ''),
(143, 143, b'0', 2, 2, ''),
(144, 144, b'0', 2, 2, ''),
(145, 145, b'0', 4, 2, ''),
(146, 146, b'0', 2, 2, ''),
(147, 147, b'0', 2, 2, ''),
(148, 148, b'0', 2, 2, ''),
(149, 149, b'0', 2, 2, ''),
(150, 150, b'0', 2, 2, ''),
(151, 151, b'0', 4, 2, ''),
(152, 152, b'0', 2, 2, ''),
(153, 153, b'0', 4, 2, ''),
(154, 154, b'0', 2, 2, ''),
(155, 155, b'0', 2, 2, ''),
(156, 156, b'0', 2, 2, ''),
(157, 157, b'0', 4, 2, ''),
(158, 158, b'0', 2, 2, ''),
(159, 159, b'0', 2, 2, ''),
(160, 160, b'0', 4, 2, ''),
(161, 161, b'0', 4, 2, ''),
(162, 162, b'0', 4, 2, ''),
(163, 163, b'0', 4, 2, ''),
(164, 164, b'0', 2, 2, ''),
(165, 165, b'0', 2, 2, ''),
(166, 166, b'0', 2, 2, ''),
(167, 167, b'0', 2, 2, ''),
(168, 168, b'0', 2, 2, ''),
(169, 169, b'0', 4, 2, ''),
(170, 170, b'0', 4, 2, ''),
(171, 171, b'0', 4, 2, ''),
(172, 172, b'0', 2, 2, ''),
(173, 173, b'0', 2, 2, ''),
(174, 174, b'0', 4, 2, ''),
(175, 175, b'0', 4, 2, ''),
(176, 176, b'0', 4, 2, ''),
(177, 177, b'0', 2, 2, ''),
(178, 178, b'0', 2, 2, ''),
(179, 179, b'0', 4, 2, ''),
(180, 180, b'0', 1, 2, ''),
(181, 181, b'0', 2, 2, ''),
(182, 182, b'0', 4, 2, ''),
(183, 183, b'0', 2, 2, ''),
(184, 184, b'0', 4, 2, ''),
(185, 185, b'0', 4, 2, ''),
(186, 186, b'0', 4, 2, ''),
(187, 187, b'0', 2, 2, ''),
(188, 188, b'0', 2, 2, ''),
(189, 189, b'0', 2, 2, ''),
(190, 190, b'0', 2, 2, ''),
(191, 191, b'0', 1, 2, ''),
(192, 192, b'0', 2, 2, ''),
(193, 193, b'0', 2, 2, ''),
(194, 194, b'0', 2, 2, ''),
(195, 195, b'0', 2, 2, ''),
(196, 196, b'0', 4, 2, ''),
(197, 197, b'0', 2, 2, ''),
(198, 198, b'0', 2, 2, ''),
(199, 199, b'0', 4, 2, ''),
(200, 200, b'0', 2, 2, ''),
(201, 201, b'0', 4, 2, ''),
(202, 202, b'0', 2, 2, ''),
(203, 203, b'0', 2, 2, ''),
(204, 204, b'0', 4, 2, ''),
(205, 205, b'0', 2, 2, ''),
(206, 206, b'0', 4, 2, ''),
(207, 207, b'0', 4, 2, ''),
(208, 208, b'0', 4, 2, ''),
(209, 209, b'0', 4, 2, ''),
(210, 210, b'0', 2, 2, ''),
(211, 211, b'0', 4, 2, ''),
(212, 212, b'0', 1, 2, ''),
(213, 213, b'0', 2, 2, ''),
(214, 214, b'0', 3, 2, ''),
(215, 215, b'0', 6, 2, ''),
(216, 216, b'0', 3, 2, ''),
(217, 217, b'0', 4, 2, ''),
(218, 218, b'0', 4, 2, ''),
(219, 219, b'0', 1, 2, ''),
(220, 220, b'0', 2, 2, ''),
(221, 221, b'0', 4, 2, ''),
(222, 222, b'0', 4, 2, ''),
(223, 223, b'0', 4, 2, ''),
(224, 224, b'0', 4, 2, ''),
(225, 225, b'0', 2, 2, ''),
(226, 226, b'0', 4, 2, ''),
(227, 227, b'0', 4, 2, ''),
(228, 228, b'0', 2, 2, ''),
(229, 229, b'0', 2, 2, ''),
(230, 230, b'0', 2, 2, ''),
(231, 231, b'0', 2, 2, ''),
(232, 232, b'0', 4, 2, ''),
(233, 233, b'0', 4, 2, ''),
(234, 234, b'0', 2, 2, ''),
(235, 235, b'0', 2, 2, ''),
(236, 236, b'0', 2, 2, ''),
(237, 237, b'0', 2, 2, ''),
(238, 238, b'0', 2, 2, ''),
(239, 239, b'0', 3, 2, ''),
(240, 240, b'0', 2, 2, ''),
(241, 241, b'0', 3, 2, ''),
(242, 242, b'0', 4, 2, ''),
(243, 243, b'0', 2, 2, ''),
(244, 244, b'0', 2, 2, ''),
(245, 245, b'0', 2, 2, ''),
(246, 246, b'0', 4, 2, ''),
(247, 247, b'0', 2, 2, ''),
(248, 248, b'0', 4, 2, ''),
(249, 249, b'0', 2, 2, ''),
(250, 250, b'0', 2, 2, ''),
(251, 251, b'0', 4, 2, ''),
(252, 252, b'0', 4, 2, ''),
(253, 253, b'0', 2, 2, ''),
(254, 254, b'0', 2, 2, ''),
(255, 255, b'0', 2, 2, ''),
(256, 256, b'0', 2, 2, ''),
(257, 257, b'0', 2, 2, ''),
(258, 258, b'0', 4, 2, ''),
(259, 259, b'0', 4, 2, ''),
(260, 260, b'0', 4, 2, ''),
(261, 261, b'0', 2, 2, ''),
(262, 262, b'0', 2, 2, ''),
(263, 263, b'0', 2, 2, ''),
(264, 264, b'0', 2, 2, ''),
(265, 265, b'0', 2, 2, ''),
(266, 266, b'0', 2, 2, ''),
(267, 267, b'0', 4, 2, ''),
(268, 268, b'0', 2, 2, ''),
(269, 269, b'0', 2, 2, ''),
(270, 270, b'0', 4, 2, ''),
(271, 271, b'0', 2, 2, ''),
(272, 272, b'0', 4, 2, ''),
(273, 273, b'0', 2, 2, ''),
(274, 274, b'0', 4, 2, ''),
(275, 275, b'0', 4, 2, ''),
(276, 276, b'0', 4, 2, ''),
(277, 277, b'0', 2, 2, ''),
(278, 278, b'0', 2, 2, ''),
(279, 279, b'0', 2, 2, ''),
(280, 280, b'0', 2, 2, ''),
(281, 281, b'0', 2, 2, ''),
(282, 282, b'0', 4, 2, ''),
(283, 283, b'0', 2, 2, ''),
(284, 284, b'0', 4, 2, ''),
(285, 285, b'0', 4, 2, ''),
(286, 286, b'0', 4, 2, ''),
(287, 287, b'0', 4, 2, ''),
(288, 288, b'0', 4, 2, ''),
(289, 289, b'0', 4, 2, ''),
(290, 290, b'0', 2, 2, ''),
(291, 291, b'0', 4, 2, ''),
(292, 292, b'0', 2, 2, ''),
(293, 293, b'0', 4, 2, ''),
(294, 294, b'0', 4, 2, ''),
(295, 295, b'0', 2, 2, ''),
(296, 296, b'0', 2, 2, ''),
(297, 297, b'0', 2, 2, ''),
(298, 298, b'0', 2, 2, ''),
(299, 299, b'0', 2, 2, ''),
(300, 300, b'0', 2, 2, ''),
(301, 301, b'0', 2, 2, ''),
(302, 302, b'0', 2, 2, ''),
(303, 303, b'0', 4, 2, ''),
(304, 304, b'0', 2, 2, ''),
(305, 305, b'0', 4, 2, ''),
(306, 306, b'0', 2, 2, ''),
(307, 307, b'0', 1, 2, ''),
(308, 308, b'0', 2, 2, ''),
(309, 309, b'0', 4, 2, ''),
(310, 310, b'0', 2, 2, ''),
(311, 311, b'0', 1, 2, ''),
(312, 312, b'0', 4, 2, ''),
(313, 313, b'0', 2, 2, ''),
(314, 314, b'0', 4, 2, ''),
(315, 315, b'0', 2, 2, ''),
(316, 316, b'0', 2, 2, ''),
(317, 317, b'0', 4, 2, ''),
(318, 318, b'0', 4, 2, ''),
(319, 319, b'0', 1, 2, ''),
(320, 320, b'0', 4, 2, ''),
(321, 321, b'0', 4, 2, ''),
(322, 322, b'0', 2, 2, ''),
(323, 323, b'0', 2, 2, ''),
(324, 324, b'0', 2, 2, ''),
(325, 325, b'0', 2, 2, ''),
(326, 326, b'0', 1, 2, ''),
(327, 327, b'0', 1, 2, ''),
(328, 328, b'0', 2, 2, ''),
(329, 329, b'0', 2, 2, ''),
(330, 330, b'0', 4, 2, ''),
(331, 331, b'0', 1, 2, ''),
(332, 332, b'0', 4, 2, ''),
(333, 333, b'0', 4, 2, ''),
(334, 334, b'0', 4, 2, ''),
(335, 335, b'0', 4, 2, ''),
(336, 336, b'0', 4, 2, ''),
(337, 337, b'0', 4, 2, ''),
(338, 338, b'0', 2, 2, ''),
(339, 339, b'0', 1, 3, 'http://www.acetium.com/es/el-acetaldehido-es-un-carcinogeno-humano-del-grupo-i-al-que-estamos-expuestos-diario'),
(340, 340, b'0', 1, 3, ''),
(341, 341, b'0', 2, 3, ''),
(342, 342, b'0', 1, 3, ''),
(343, 343, b'0', 1, 3, ''),
(344, 344, b'1', 1, 3, ''),
(345, 345, b'0', 1, 3, ''),
(346, 346, b'0', 4, 3, ''),
(347, 347, b'0', 2, 3, ''),
(348, 348, b'0', 2, 3, ''),
(349, 349, b'0', 2, 3, ''),
(350, 350, b'0', 1, 3, ''),
(351, 351, b'0', 1, 3, ''),
(352, 352, b'0', 4, 3, ''),
(353, 353, b'0', 2, 3, ''),
(354, 354, b'0', 2, 3, ''),
(355, 355, b'0', 2, 3, ''),
(356, 356, b'0', 2, 3, ''),
(357, 357, b'0', 1, 3, ''),
(358, 358, b'0', 1, 3, ''),
(359, 359, b'0', 1, 3, ''),
(360, 360, b'0', 1, 3, ''),
(361, 361, b'0', 1, 3, ''),
(362, 362, b'0', 3, 3, ''),
(363, 363, b'0', 1, 3, ''),
(364, 364, b'0', 2, 3, ''),
(365, 365, b'0', 2, 3, ''),
(366, 366, b'0', 1, 3, ''),
(367, 367, b'0', 1, 3, ''),
(368, 368, b'0', 1, 3, ''),
(369, 369, b'0', 1, 3, ''),
(370, 370, b'0', 1, 3, ''),
(371, 371, b'0', 1, 3, ''),
(372, 372, b'0', 1, 3, ''),
(373, 373, b'0', 1, 3, ''),
(374, 374, b'0', 1, 3, ''),
(375, 375, b'0', 1, 3, ''),
(376, 376, b'0', 2, 3, ''),
(377, 377, b'0', 3, 3, ''),
(378, 378, b'0', 1, 3, ''),
(379, 379, b'0', 2, 3, ''),
(380, 380, b'0', 1, 3, ''),
(381, 381, b'0', 1, 3, ''),
(382, 382, b'0', 1, 3, ''),
(383, 383, b'0', 1, 3, ''),
(384, 384, b'0', 1, 3, ''),
(385, 385, b'0', 1, 3, ''),
(386, 386, b'0', 1, 3, ''),
(387, 387, b'0', 2, 3, ''),
(388, 388, b'0', 1, 3, ''),
(389, 389, b'0', 2, 3, ''),
(390, 390, b'0', 4, 3, ''),
(391, 391, b'0', 3, 3, ''),
(392, 392, b'0', 3, 3, ''),
(393, 393, b'0', 2, 3, ''),
(394, 394, b'0', 4, 3, ''),
(395, 395, b'0', 3, 3, ''),
(396, 396, b'0', 3, 3, ''),
(397, 397, b'0', 1, 3, ''),
(398, 398, b'0', 1, 3, ''),
(399, 399, b'0', 2, 3, ''),
(400, 400, b'0', 2, 3, ''),
(401, 401, b'0', 1, 3, ''),
(402, 402, b'0', 2, 3, ''),
(403, 403, b'0', 1, 3, ''),
(404, 404, b'0', 2, 3, ''),
(405, 405, b'0', 2, 3, ''),
(406, 406, b'0', 4, 3, ''),
(407, 407, b'0', 3, 3, ''),
(408, 408, b'0', 3, 3, ''),
(409, 409, b'0', 3, 3, ''),
(410, 410, b'0', 1, 3, ''),
(411, 411, b'0', 1, 3, ''),
(412, 412, b'0', 1, 3, ''),
(413, 413, b'0', 2, 3, ''),
(414, 414, b'0', 1, 3, ''),
(415, 415, b'0', 1, 3, ''),
(416, 416, b'0', 4, 3, ''),
(417, 417, b'0', 3, 3, ''),
(418, 418, b'0', 2, 3, ''),
(419, 419, b'0', 2, 3, ''),
(420, 420, b'0', 2, 3, ''),
(421, 421, b'0', 2, 3, ''),
(422, 422, b'0', 1, 3, ''),
(423, 423, b'0', 1, 3, ''),
(424, 424, b'0', 4, 3, ''),
(425, 425, b'0', 1, 3, ''),
(426, 426, b'0', 2, 4, ''),
(427, 427, b'0', 4, 4, ''),
(428, 428, b'0', 4, 4, ''),
(429, 429, b'0', 2, 4, ''),
(430, 430, b'0', 2, 4, ''),
(431, 431, b'0', 2, 4, ''),
(432, 432, b'0', 2, 4, ''),
(433, 433, b'0', 2, 4, ''),
(434, 434, b'0', 2, 4, ''),
(435, 435, b'0', 3, 4, ''),
(436, 436, b'0', 3, 4, ''),
(437, 437, b'0', 2, 4, ''),
(438, 438, b'0', 1, 4, ''),
(439, 439, b'0', 1, 4, ''),
(440, 440, b'0', 1, 4, ''),
(441, 441, b'0', 2, 4, ''),
(442, 442, b'0', 4, 4, ''),
(443, 443, b'0', 7, 2, 'Link'),
(444, 444, b'1', 1, 1, ''),
(445, 445, b'0', 1, 1, ''),
(446, 446, b'1', 1, 1, '');

-- --------------------------------------------------------

--
-- Table structure for table `Rol`
--

CREATE TABLE `Rol` (
  `RolID` int(11) NOT NULL,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Rol`
--

INSERT INTO `Rol` (`RolID`, `Nombre`, `Descripcion`) VALUES
(1, 'Coordinador', 'Tiene permisos de todo menos administrar cuentas'),
(2, 'Administrador', 'Tiene permisos de todo');

-- --------------------------------------------------------

--
-- Table structure for table `TipoArticulo`
--

CREATE TABLE `TipoArticulo` (
  `TipoArticuloID` int(11) NOT NULL,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `TipoArticulo`
--

INSERT INTO `TipoArticulo` (`TipoArticuloID`, `Nombre`, `Descripcion`) VALUES
(1, 'Reactivo', 'Artículo del inventario relacionado a químicos.'),
(2, 'Cristalería', 'Artículo que no está relacionado a algún químico.');

-- --------------------------------------------------------

--
-- Table structure for table `TipoMovimiento`
--

CREATE TABLE `TipoMovimiento` (
  `TipoMovimientoID` int(11) NOT NULL,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `TipoMovimiento`
--

INSERT INTO `TipoMovimiento` (`TipoMovimientoID`, `Nombre`, `Descripcion`) VALUES
(1, 'Ingreso', 'Se le suma al total de un reactivo.'),
(2, 'Salida', 'Se extrae del total de un reactivo.');

-- --------------------------------------------------------

--
-- Table structure for table `TipoNotificacion`
--

CREATE TABLE `TipoNotificacion` (
  `TipoNotificacionID` int(11) NOT NULL,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `UnidadMetrica`
--

CREATE TABLE `UnidadMetrica` (
  `UnidadMetricaID` int(11) NOT NULL,
  `Nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Siglas` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `UnidadMetrica`
--

INSERT INTO `UnidadMetrica` (`UnidadMetricaID`, `Nombre`, `Siglas`) VALUES
(1, 'Litro', 'L'),
(2, 'Kilogramo', 'KG'),
(3, 'Mililitro', 'ML'),
(4, 'Gramo', 'G'),
(5, 'Rollo', 'R'),
(6, 'KML', 'KML'),
(7, 'Revisión Iteración 30', 'Rev03');

-- --------------------------------------------------------

--
-- Table structure for table `Usuario`
--

CREATE TABLE `Usuario` (
  `UsuarioID` int(11) NOT NULL,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Usuario` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Contrasenha` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Correo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RolID` int(11) NOT NULL,
  `Estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Usuario`
--

INSERT INTO `Usuario` (`UsuarioID`, `Nombre`, `Usuario`, `Contrasenha`, `Correo`, `RolID`, `Estado`) VALUES
(7, 'Andrey Mendoza', 'amendoza', 'f951e387cc37c469f1f61c08e46d0420e166ab18717f70a802c6456e198ef71f', 'amendoza.test@gmail.com', 1, 1),
(9, 'Armando Lopez', 'alopez', 'a4f3a30c5da7daa4ebae3f37796bce35c93ce02b743928ec362aaa07064dba29', 'alopez@mail.com', 2, 4),
(14, 'Pablo Navarro', 'pablo', 'f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b', 'qwr@sdf', 2, 1),
(21, 'Silvia Soto', 'ssoto', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'ssoto@itcr.ac.cr', 1, 1),
(26, 'Silvia Soto', 'silvia', '2d51a3b3ca1cdf790485938566c720527b2ebbe5a1f0326316ce63aafbc385d4', 's@m.com', 1, 2),
(27, 'Demo', 'Demo', '2a97516c354b68848cdbd8f54a226a0a55b21ed138e207ad6c5cbb9c00aa5aea', 'demo@demi.com', 1, 1),
(29, 'Marvín', 'Mmarín', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'mmarin@itcr.ac.cr', 2, 1),
(49, 'Appmovil', 'Appmovil', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'Email@gmail.com', 1, 1),
(52, 'Probandoapp', 'Ja', 'ab8f46084b4fa0fc8261328a5a71af267b1d1f8fe229c63c751d02a2e996e0ec', 'Email', 2, 3),
(54, '', '', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '', 1, 4),
(56, 'ionicv2', 'ionicv2', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'ionic@hotmail.com', 2, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Articulo`
--
ALTER TABLE `Articulo`
  ADD PRIMARY KEY (`ArticuloID`),
  ADD UNIQUE KEY `ArticuloID_UNIQUE` (`ArticuloID`),
  ADD KEY `FK_TipoArticulo_idx` (`TipoArticulo`);

--
-- Indexes for table `ArticuloPedido`
--
ALTER TABLE `ArticuloPedido`
  ADD PRIMARY KEY (`ArticuloPedidoID`),
  ADD UNIQUE KEY `ArticuloPedidoID_UNIQUE` (`ArticuloPedidoID`),
  ADD KEY `FK_ArticuloPedido_idx` (`ArticuloID`),
  ADD KEY `FK_Pedido_idx` (`PedidoID`);

--
-- Indexes for table `CategoriaReactivo`
--
ALTER TABLE `CategoriaReactivo`
  ADD PRIMARY KEY (`CategoriaReactivoID`),
  ADD UNIQUE KEY `CategoriaReactivoID_UNIQUE` (`CategoriaReactivoID`);

--
-- Indexes for table `Chat`
--
ALTER TABLE `Chat`
  ADD PRIMARY KEY (`ChatID`),
  ADD UNIQUE KEY `ChatID_UNIQUE` (`ChatID`),
  ADD UNIQUE KEY `UK_Usuarios` (`UsuarioAID`,`UsuarioBID`),
  ADD KEY `FK_UsuarioA_idx` (`UsuarioAID`),
  ADD KEY `FK_UsuarioB_idx` (`UsuarioBID`);

--
-- Indexes for table `EstadoNotificacion`
--
ALTER TABLE `EstadoNotificacion`
  ADD PRIMARY KEY (`EstadoNotifiacionID`),
  ADD UNIQUE KEY `EstadoNotifiacionID_UNIQUE` (`EstadoNotifiacionID`),
  ADD KEY `FK_UsuarioNotificado_idx` (`UsuarioID`),
  ADD KEY `FK_NotificacionGeneral_idx` (`NotificacionGeneralID`);

--
-- Indexes for table `EstadoPrestamo`
--
ALTER TABLE `EstadoPrestamo`
  ADD PRIMARY KEY (`EstadoPrestamoID`),
  ADD UNIQUE KEY `EstadoPrestamoID_UNIQUE` (`EstadoPrestamoID`),
  ADD UNIQUE KEY `Descripcion_UNIQUE` (`Descripcion`),
  ADD UNIQUE KEY `Nombre_UNIQUE` (`Nombre`);

--
-- Indexes for table `EstadoUsuario`
--
ALTER TABLE `EstadoUsuario`
  ADD PRIMARY KEY (`EstadoUsuarioID`),
  ADD UNIQUE KEY `EstadoUsuarioID_UNIQUE` (`EstadoUsuarioID`);

--
-- Indexes for table `ListaNegraNotificacionPorUsuario`
--
ALTER TABLE `ListaNegraNotificacionPorUsuario`
  ADD PRIMARY KEY (`ListaNegraNotificacionPorUsuarioID`),
  ADD UNIQUE KEY `NotificacionDesactivadaID_UNIQUE` (`ListaNegraNotificacionPorUsuarioID`),
  ADD UNIQUE KEY `UK_UnRegistroXUsuario` (`ArticuloID`,`UsuarioID`),
  ADD KEY `FK_Usuario_idx` (`UsuarioID`),
  ADD KEY `FK_Usuario_idx1` (`ArticuloID`);

--
-- Indexes for table `MensajeChat`
--
ALTER TABLE `MensajeChat`
  ADD PRIMARY KEY (`MensajeChatID`),
  ADD UNIQUE KEY `MensajeChatID_UNIQUE` (`MensajeChatID`),
  ADD KEY `FK_UsuarioEmisor_idx` (`UsuarioEmisorID`),
  ADD KEY `FK_Chat_idx` (`ChatID`);

--
-- Indexes for table `Movimiento`
--
ALTER TABLE `Movimiento`
  ADD PRIMARY KEY (`MovimientoID`),
  ADD UNIQUE KEY `MovimientoID_UNIQUE` (`MovimientoID`),
  ADD KEY `FK_TipoMovimiento_idx` (`TipoMovimientoID`),
  ADD KEY `FK_UsuarioAutorizador_idx` (`UsuarioAutorizadorID`);

--
-- Indexes for table `NotificacionGeneral`
--
ALTER TABLE `NotificacionGeneral`
  ADD PRIMARY KEY (`NotificacionGeneralID`),
  ADD UNIQUE KEY `NotificacionGeneral_UNIQUE` (`NotificacionGeneralID`),
  ADD KEY `FK_TipoNotificacion_idx` (`TipoNotificacionID`);

--
-- Indexes for table `Pedido`
--
ALTER TABLE `Pedido`
  ADD PRIMARY KEY (`PedidoID`),
  ADD UNIQUE KEY `PedidoID_UNIQUE` (`PedidoID`),
  ADD KEY `FK_UsuarioSolicitante_idx` (`UsuarioSolicitanteID`);

--
-- Indexes for table `Prestamo`
--
ALTER TABLE `Prestamo`
  ADD PRIMARY KEY (`PrestamoID`),
  ADD UNIQUE KEY `PrestamoID_UNIQUE` (`PrestamoID`),
  ADD KEY `FK_UsuarioSolicitante_idx` (`UsuarioSolicitanteID`),
  ADD KEY `FK_Articulo_idx` (`ArticuloID`),
  ADD KEY `FK_UsuarioAutorizador_idx` (`UsuarioAutorizadorID`),
  ADD KEY `FK_EstadoPrestamo_idx` (`EstadoPrestamoID`);

--
-- Indexes for table `Reactivo`
--
ALTER TABLE `Reactivo`
  ADD PRIMARY KEY (`ReactivoID`),
  ADD UNIQUE KEY `ReactivoID_UNIQUE` (`ReactivoID`),
  ADD KEY `FK_Articulo_idx` (`ArticuloID`),
  ADD KEY `FK_UnidadMetrica_idx` (`UnidadMetricaID`),
  ADD KEY `FK_Categoria_idx` (`Categoria`);

--
-- Indexes for table `Rol`
--
ALTER TABLE `Rol`
  ADD PRIMARY KEY (`RolID`),
  ADD UNIQUE KEY `RolID_UNIQUE` (`RolID`);

--
-- Indexes for table `TipoArticulo`
--
ALTER TABLE `TipoArticulo`
  ADD PRIMARY KEY (`TipoArticuloID`);

--
-- Indexes for table `TipoMovimiento`
--
ALTER TABLE `TipoMovimiento`
  ADD PRIMARY KEY (`TipoMovimientoID`),
  ADD UNIQUE KEY `TipoPrestamoID_UNIQUE` (`TipoMovimientoID`);

--
-- Indexes for table `TipoNotificacion`
--
ALTER TABLE `TipoNotificacion`
  ADD PRIMARY KEY (`TipoNotificacionID`),
  ADD UNIQUE KEY `TipoNotificacionID_UNIQUE` (`TipoNotificacionID`);

--
-- Indexes for table `UnidadMetrica`
--
ALTER TABLE `UnidadMetrica`
  ADD PRIMARY KEY (`UnidadMetricaID`),
  ADD UNIQUE KEY `UnidadesMetricasID_UNIQUE` (`UnidadMetricaID`);

--
-- Indexes for table `Usuario`
--
ALTER TABLE `Usuario`
  ADD PRIMARY KEY (`UsuarioID`),
  ADD UNIQUE KEY `UsuarioID_UNIQUE` (`UsuarioID`),
  ADD KEY `FK_RolID_idx` (`RolID`),
  ADD KEY `FK_EstadoID_idx` (`Estado`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Articulo`
--
ALTER TABLE `Articulo`
  MODIFY `ArticuloID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=447;

--
-- AUTO_INCREMENT for table `ArticuloPedido`
--
ALTER TABLE `ArticuloPedido`
  MODIFY `ArticuloPedidoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `CategoriaReactivo`
--
ALTER TABLE `CategoriaReactivo`
  MODIFY `CategoriaReactivoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Chat`
--
ALTER TABLE `Chat`
  MODIFY `ChatID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `EstadoNotificacion`
--
ALTER TABLE `EstadoNotificacion`
  MODIFY `EstadoNotifiacionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `EstadoPrestamo`
--
ALTER TABLE `EstadoPrestamo`
  MODIFY `EstadoPrestamoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `EstadoUsuario`
--
ALTER TABLE `EstadoUsuario`
  MODIFY `EstadoUsuarioID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `ListaNegraNotificacionPorUsuario`
--
ALTER TABLE `ListaNegraNotificacionPorUsuario`
  MODIFY `ListaNegraNotificacionPorUsuarioID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `MensajeChat`
--
ALTER TABLE `MensajeChat`
  MODIFY `MensajeChatID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `Movimiento`
--
ALTER TABLE `Movimiento`
  MODIFY `MovimientoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `NotificacionGeneral`
--
ALTER TABLE `NotificacionGeneral`
  MODIFY `NotificacionGeneralID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Pedido`
--
ALTER TABLE `Pedido`
  MODIFY `PedidoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Prestamo`
--
ALTER TABLE `Prestamo`
  MODIFY `PrestamoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Reactivo`
--
ALTER TABLE `Reactivo`
  MODIFY `ReactivoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=447;

--
-- AUTO_INCREMENT for table `Rol`
--
ALTER TABLE `Rol`
  MODIFY `RolID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `TipoArticulo`
--
ALTER TABLE `TipoArticulo`
  MODIFY `TipoArticuloID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `TipoMovimiento`
--
ALTER TABLE `TipoMovimiento`
  MODIFY `TipoMovimientoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `TipoNotificacion`
--
ALTER TABLE `TipoNotificacion`
  MODIFY `TipoNotificacionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `UnidadMetrica`
--
ALTER TABLE `UnidadMetrica`
  MODIFY `UnidadMetricaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Usuario`
--
ALTER TABLE `Usuario`
  MODIFY `UsuarioID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Articulo`
--
ALTER TABLE `Articulo`
  ADD CONSTRAINT `FK_TipoArticulo` FOREIGN KEY (`TipoArticulo`) REFERENCES `TipoArticulo` (`TipoArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ArticuloPedido`
--
ALTER TABLE `ArticuloPedido`
  ADD CONSTRAINT `FK_ArticuloPedidoID` FOREIGN KEY (`ArticuloID`) REFERENCES `Articulo` (`ArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_PedidoID` FOREIGN KEY (`PedidoID`) REFERENCES `Pedido` (`PedidoID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Chat`
--
ALTER TABLE `Chat`
  ADD CONSTRAINT `FK_UsuarioA` FOREIGN KEY (`UsuarioAID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_UsuarioB` FOREIGN KEY (`UsuarioBID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `EstadoNotificacion`
--
ALTER TABLE `EstadoNotificacion`
  ADD CONSTRAINT `FK_NotificacionGeneral` FOREIGN KEY (`NotificacionGeneralID`) REFERENCES `NotificacionGeneral` (`NotificacionGeneralID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_UsuarioNotificado` FOREIGN KEY (`UsuarioID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ListaNegraNotificacionPorUsuario`
--
ALTER TABLE `ListaNegraNotificacionPorUsuario`
  ADD CONSTRAINT `FK_ArticuloNotificado` FOREIGN KEY (`ArticuloID`) REFERENCES `Articulo` (`ArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Usuario` FOREIGN KEY (`UsuarioID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `MensajeChat`
--
ALTER TABLE `MensajeChat`
  ADD CONSTRAINT `FK_Chat` FOREIGN KEY (`ChatID`) REFERENCES `Chat` (`ChatID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_UsuarioEmisor` FOREIGN KEY (`UsuarioEmisorID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Movimiento`
--
ALTER TABLE `Movimiento`
  ADD CONSTRAINT `FK_TipoMovimiento` FOREIGN KEY (`TipoMovimientoID`) REFERENCES `TipoMovimiento` (`TipoMovimientoID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_UsuarioAutorizadorID` FOREIGN KEY (`UsuarioAutorizadorID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `NotificacionGeneral`
--
ALTER TABLE `NotificacionGeneral`
  ADD CONSTRAINT `FK_TipoNotificacion` FOREIGN KEY (`TipoNotificacionID`) REFERENCES `TipoNotificacion` (`TipoNotificacionID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Pedido`
--
ALTER TABLE `Pedido`
  ADD CONSTRAINT `FK_UsuarioSolicitantePedido` FOREIGN KEY (`UsuarioSolicitanteID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Prestamo`
--
ALTER TABLE `Prestamo`
  ADD CONSTRAINT `FK_ArticuloAsociado` FOREIGN KEY (`ArticuloID`) REFERENCES `Articulo` (`ArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_EstadoPrestamo` FOREIGN KEY (`EstadoPrestamoID`) REFERENCES `EstadoPrestamo` (`EstadoPrestamoID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_UsuarioAutorizador` FOREIGN KEY (`UsuarioAutorizadorID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_UsuarioSolicitante` FOREIGN KEY (`UsuarioSolicitanteID`) REFERENCES `Usuario` (`UsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Reactivo`
--
ALTER TABLE `Reactivo`
  ADD CONSTRAINT `FK_Articulo` FOREIGN KEY (`ArticuloID`) REFERENCES `Articulo` (`ArticuloID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Categoria` FOREIGN KEY (`Categoria`) REFERENCES `CategoriaReactivo` (`CategoriaReactivoID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_UnidadMetrica` FOREIGN KEY (`UnidadMetricaID`) REFERENCES `UnidadMetrica` (`UnidadMetricaID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Usuario`
--
ALTER TABLE `Usuario`
  ADD CONSTRAINT `FK_EstadoID` FOREIGN KEY (`Estado`) REFERENCES `EstadoUsuario` (`EstadoUsuarioID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_RolID` FOREIGN KEY (`RolID`) REFERENCES `Rol` (`RolID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
