/* create database girasbd; */

  use girasbd;

  /* TABLAS */

  # ---------- Tabla Flotilla  ------------
DROP TABLE IF EXISTS flotilla ;
  create table flotilla (
id smallint auto_increment not null primary key,
placa varchar(100) not null,
capacidad INT,
estado BOOL DEFAULT  1 # 0 no en mal estado
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla ServiciosFlotilla  ------------
DROP TABLE IF EXISTS servicioFlotilla ;
create table servicioFlotilla (
id smallint auto_increment not null primary key,
nombre varchar(100) not null
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla ServiciosXFlotilla  ------------
DROP TABLE IF EXISTS servicioXFlotilla ;
create table servicioXFlotilla (
  Fk_IdFlotilla smallint not null,
  Fk_ServicioFlotilla smallint not null,
  FOREIGN KEY (Fk_IdFlotilla) references flotilla(id),
  FOREIGN KEY (Fk_ServicioFlotilla) references servicioFlotilla(id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla Rol  ------------
DROP TABLE IF EXISTS rol ;
create table rol (
  id smallint auto_increment not null primary key,
  nombre varchar(100) not null #Chofer o guía
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla Persona  ------------
DROP TABLE IF EXISTS persona ;
create table persona (
  id smallint auto_increment not null primary key,
  nombre varchar(200) not null,
  celular varchar(100) not null,
  eliminado BOOLEAN DEFAULT FALSE,
  Fk_Rol smallint not null,
  FOREIGN KEY (Fk_Rol) references rol(id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla servicioGira  ------------
DROP TABLE IF EXISTS servicioGira ;
create table servicioGira (
  id smallint auto_increment not null primary key,
  nombre varchar(100) not null #Desayuno, almuerzo y cena
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla sitioTuristico  ------------
DROP TABLE IF EXISTS sitioTuristico ;
create table sitioTuristico (
  id smallint auto_increment not null primary key,
  nombre varchar(100) not null,
  descripcion varchar(600) not null,
  eliminado BOOLEAN DEFAULT FALSE  NOT NULL
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla imagenXsitio  ------------
DROP TABLE IF EXISTS imagenXsitio ;
create table imagenXsitio (
  id smallint auto_increment not null primary key,
  img LONGBLOB,
  Fk_Sitio smallint not null,
  eliminada BOOLEAN DEFAULT FALSE  NOT NULL,
  FOREIGN KEY (Fk_Sitio) references sitioTuristico(id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla Gira  ------------
DROP TABLE IF EXISTS gira ;
create table gira (
  id smallint auto_increment not null primary key,
  lugarSalida varchar(100) not null,
  lugarDestino varchar(100) not null,
  fechaPartida timestamp not null,
  limitePersonas SMALLINT,
  precioAdulto FLOAT not null,
  precioNino FLOAT not null,
  precioAdultoMayor FLOAT not null,
  disponible BOOLEAN DEFAULT 1 NOT NULL ,
  fechaLimDepo timestamp not null,
  fechaLimPago timestamp not null,
  Fk_SitioTuristico smallint not null,
  Fk_Chofer smallint not null,
  Fk_Guia smallint not null,
  FOREIGN KEY (Fk_Chofer) references persona(id),
  FOREIGN KEY (Fk_Guia) references persona(id),
  FOREIGN KEY (Fk_SitioTuristico) references sitioTuristico(id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla reservacion  ------------
DROP TABLE IF EXISTS reservacion ;
create table reservacion (
  id smallint auto_increment not null primary key,
  cliente varchar(100) not null,
  celularCliente varchar(100) not null,
  cantNinos smallint not null,
  cantAdultos smallint not null,
  cantAdultosMayores smallint not null,
  depositado BOOL DEFAULT FALSE,
  pagado BOOL DEFAULT FALSE,
  imgDeposito LONGBLOB,
  imgPagoTotal LONGBLOB,
  cancelado BOOL DEFAULT FALSE,
  Fk_Gira smallint not null,
  FOREIGN KEY (Fk_Gira) references gira(id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;


# ---------- Tabla imagen  ------------
DROP TABLE IF EXISTS imagen ;
create table imagen (
  imgDeposito LONGBLOB,
  nombre VARCHAR(50)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla servicioXGira ------------
DROP TABLE IF EXISTS servicioXGira ;
create table servicioXGira (
  Fk_Gira smallint not null,
  Fk_ServicioGira smallint not null,
  costoAsociado FLOAT not null,
  FOREIGN KEY (Fk_Gira) references gira(id),
  FOREIGN KEY (Fk_ServicioGira) references servicioGira(id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla flotillaXGira ------------
DROP TABLE IF EXISTS flotillaXGira ;
create table flotillaXGira (
  Fk_Gira smallint not null,
  Fk_Flotilla smallint not null,
  FOREIGN KEY (Fk_Gira) references gira(id),
  FOREIGN KEY (Fk_Flotilla) references flotilla(id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla paradaXGira ------------
DROP TABLE IF EXISTS paradaXGira ;
create table paradaXGira (
  Fk_Gira smallint not null,
  nombreParada VARCHAR(100),
  FOREIGN KEY (Fk_Gira) references gira(id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

# ---------- Tabla administrador  ------------
DROP TABLE IF EXISTS administrador ;
create table administrador (
  id smallint auto_increment not null primary key,
  user varchar(500) not null,
  pass varchar(500) not null
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------------------------------------
-- -----------------------------------STORE PROCEDURES---------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------
-- procedure iniciarSesion
-- -----------------------------------------------------

DROP procedure IF EXISTS iniciarSesion;
DELIMITER $$
CREATE  PROCEDURE iniciarSesion (IN pUser VARCHAR(500), IN pPass VARCHAR(500))
BEGIN
    SELECT a.user FROM administrador a WHERE a.user = pUser and sha2(pPass,256) = a.pass;
END $$
DELIMITER ;
#call iniciarSesion('Jimmy Fallas','asdf');


-- -----------------------------------------------------
-- procedure insertarAdministrador
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarAdministrador;
DELIMITER $$
CREATE  PROCEDURE insertarAdministrador (
  pUser VARCHAR(500),
  pPass VARCHAR(500)
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM administrador a where a.user = pUser)) THEN
      INSERT INTO administrador(user, pass)
        VALUES (pUser,sha2(pPass,256));
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarAdministrador('pablo','asdf');

-- -----------------------------------------------------
-- Procedure borrarAdministrador
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarAdministrador;
DELIMITER $$
CREATE  PROCEDURE borrarAdministrador (pUser VARCHAR(500))
BEGIN
  DELETE FROM administrador WHERE user = pUser;
  SELECT 1;
END $$
DELIMITER ;
#CALL borrarAdministrador('jimmy');

-- -----------------------------------------------------
-- Procedure insertarFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarFlotilla;
DELIMITER $$
CREATE  PROCEDURE insertarFlotilla (
  pPlaca VARCHAR(100),
  pCapacidad int
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM flotilla f where f.placa = pPlaca)) THEN
      INSERT INTO flotilla(placa,capacidad)
        VALUES (pPlaca,pCapacidad);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#CALL insertarFlotilla('106044',10);

-- -----------------------------------------------------
-- Procedure eliminarFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarFlotilla;
DELIMITER $$
CREATE  PROCEDURE borrarFlotilla (
  pIdFlotilla SMALLINT(100)
)
  BEGIN
    IF NOT EXISTS((SELECT 1 FROM flotillaXGira fxg where fxg.Fk_Flotilla = pIdFlotilla)) THEN
      DELETE FROM flotilla WHERE id = pIdFlotilla;
      SELECT 1;
    END IF;
  END $$
DELIMITER ;
#CALL borrarFlotilla(1);


-- -----------------------------------------------------
-- Procedure modificarFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS modificarFlotilla;
DELIMITER $$
CREATE  PROCEDURE modificarFlotilla (
  pIdFlotilla INT,
  pPlaca VARCHAR(100),
  pCapacidad int,
  pEstado BOOLEAN
)
BEGIN
  IF NOT EXISTS((SELECT 1 FROM flotillaXGira fxg where fxg.Fk_Flotilla = pIdFlotilla)) THEN
      UPDATE flotilla SET
        placa = pPlaca,
        capacidad = pCapacidad,
        estado = pEstado
      WHERE id =  pIdFlotilla;
      SELECT 1;
  END IF;
END $$
DELIMITER ;
#call modificarFlotilla(2,'446010',FALSE );

-- -----------------------------------------------------
-- procedure getFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS getFlotilla;
DELIMITER $$
CREATE  PROCEDURE getFlotilla()
BEGIN
  SELECT id as "idFlotilla", placa, estado from flotilla;
END $$
DELIMITER ;
#call getFlotilla();

-- -----------------------------------------------------
-- procedure insertarServicioFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarServicioFlotilla;
DELIMITER $$
CREATE  PROCEDURE insertarServicioFlotilla (
  pNombre VARCHAR(100)
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM servicioFlotilla sf where sf.nombre = pNombre)) THEN
      INSERT INTO servicioFlotilla(nombre)
        VALUES (pNombre);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarServicioFlotilla('aire acondicionado');

-- -----------------------------------------------------
-- Procedure borrarServicioFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarServicioFlotilla;
DELIMITER $$
CREATE  PROCEDURE borrarServicioFlotilla (pIdServicio SMALLINT)
BEGIN
    DELETE FROM servicioXFlotilla WHERE Fk_ServicioFlotilla = pIdServicio;
    DELETE FROM servicioFlotilla WHERE id = pIdServicio;
  SELECT 1;
END $$
DELIMITER ;
#CALL borrarServicioFlotilla(1);

-- -----------------------------------------------------
-- procedure getServiciosFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS getServiciosFlotilla;
DELIMITER $$
CREATE  PROCEDURE getServiciosFlotilla()
BEGIN
  SELECT * FROM servicioFlotilla;
END $$
DELIMITER ;
#call getServiciosFlotilla();

-- -----------------------------------------------------
-- procedure insertarServicioXFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarServicioXFlotilla;
DELIMITER $$
CREATE  PROCEDURE insertarServicioXFlotilla (
  pFk_IdFlotilla SMALLINT,
  pFk_ServicioFlotilla SMALLINT
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM servicioXFlotilla sxf where sxf.Fk_IdFlotilla = pFk_IdFlotilla AND sxf.Fk_ServicioFlotilla = pFk_ServicioFlotilla)) THEN
      INSERT INTO servicioXFlotilla(Fk_IdFlotilla, Fk_ServicioFlotilla)
        VALUES (pFk_IdFlotilla,pFk_ServicioFlotilla);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarServicioXFlotilla(3,2);

-- -----------------------------------------------------
-- Procedure borrarServicioXFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarServicioXFlotilla;
DELIMITER $$
CREATE  PROCEDURE borrarServicioXFlotilla (
  pFk_IdFlotilla SMALLINT,
  pFk_ServicioFlotilla SMALLINT
)
BEGIN
    DELETE FROM servicioXFlotilla WHERE Fk_IdFlotilla = pFk_IdFlotilla and Fk_ServicioFlotilla = pFk_ServicioFlotilla;
    SELECT 1;
END $$
DELIMITER ;
#CALL borrarServicioXFlotilla(3,2);

-- -----------------------------------------------------
-- procedure getServiciosXFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS getServiciosXFlotilla;
DELIMITER $$
CREATE  PROCEDURE getServiciosXFlotilla(pFk_IdFlotilla SMALLINT)
BEGIN
  SELECT id,nombre FROM servicioFlotilla JOIN servicioXFlotilla sxf WHERE sxf.Fk_IdFlotilla = pFk_IdFlotilla;
END $$
DELIMITER ;
#call getServiciosXFlotilla(3);


-- -----------------------------------------------------
-- procedure getServiciosXFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS getServiciosXFlotilla;
DELIMITER $$
CREATE  PROCEDURE getServiciosXFlotilla(pFk_IdFlotilla SMALLINT)
BEGIN
  SELECT id,nombre FROM servicioFlotilla JOIN servicioXFlotilla sxf WHERE sxf.Fk_IdFlotilla = pFk_IdFlotilla;
END $$
DELIMITER ;
#call getServiciosXFlotilla(3);


-- -----------------------------------------------------
-- procedure getRoles
-- -----------------------------------------------------
DROP procedure IF EXISTS getRoles;
DELIMITER $$
CREATE  PROCEDURE getRoles()
BEGIN
  SELECT id,nombre as 'nombreRol' FROM rol;
END $$
DELIMITER ;
#call getRoles();

-- -----------------------------------------------------
-- procedure insertarPersona
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarPersona;
DELIMITER $$
CREATE  PROCEDURE insertarPersona (
  pNombre VARCHAR(200),
  pCelular VARCHAR(100),
  pFk_Rol SMALLINT
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM persona p where p.nombre=pNombre)) THEN
      INSERT INTO persona(nombre,celular,Fk_Rol)
        VALUES (pNombre,pCelular,pFk_Rol);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarPersona('JulianGUIA','70700755',2);


-- -----------------------------------------------------
-- Procedure modificarPersona
-- -----------------------------------------------------
DROP procedure IF EXISTS modificarPersona;
DELIMITER $$
CREATE  PROCEDURE modificarPersona (
  pIdPersona SMALLINT,
  pNombre VARCHAR(200),
  pCelular VARCHAR(100),
  pFk_Rol SMALLINT
)
BEGIN
      UPDATE persona SET
        nombre = pNombre,
        celular = pCelular,
        Fk_Rol = pFk_Rol
      WHERE id =  pIdPersona;
      SELECT 1;
END $$
DELIMITER ;
#call modificarPersona(3,'HectorGUIA',"424424424", 1);

-- -----------------------------------------------------
-- Procedure borrarPersona
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarPersona;
DELIMITER $$
CREATE  PROCEDURE borrarPersona (
  pIdPersona SMALLINT
)
  BEGIN
      UPDATE persona SET
        eliminado = TRUE
      WHERE id = pIdPersona;
      SELECT 1;
  END $$
DELIMITER ;
#CALL borrarPersona(1);

-- -----------------------------------------------------
-- procedure getPersonas
-- -----------------------------------------------------
DROP procedure IF EXISTS getPersonas;
DELIMITER $$
CREATE  PROCEDURE getPersonas()
BEGIN
  SELECT * FROM persona WHERE eliminado=FALSE ;
END $$
DELIMITER ;
#call getPersonas();

-- -----------------------------------------------------
-- procedure getChoferes
-- -----------------------------------------------------
DROP procedure IF EXISTS getChoferes;
DELIMITER $$
CREATE  PROCEDURE getChoferes()
BEGIN
  SELECT * FROM persona WHERE Fk_Rol = 1 and eliminado=FALSE ;
END $$
DELIMITER ;
#call getChoferes();

-- -----------------------------------------------------
-- procedure getGuias
-- -----------------------------------------------------
DROP procedure IF EXISTS getGuias;
DELIMITER $$
CREATE  PROCEDURE getGuias()
BEGIN
  SELECT * FROM persona WHERE Fk_Rol = 2 and eliminado=FALSE ;
END $$
DELIMITER ;
#call getGuias();

-- -----------------------------------------------------
-- procedure insertarServicioGira
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarServicioGira;
DELIMITER $$
CREATE  PROCEDURE insertarServicioGira (
  pNombre VARCHAR(100)
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM servicioGira sg where sg.nombre = pNombre)) THEN
      INSERT INTO servicioGira(nombre)
        VALUES (pNombre);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarServicioGira('Desayuno');


-- -----------------------------------------------------
-- Procedure borrarServicioGira
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarServicioGira;
DELIMITER $$
CREATE  PROCEDURE borrarServicioGira (pIdServicio SMALLINT)
BEGIN
    DELETE FROM servicioXGira WHERE Fk_ServicioGira = pIdServicio;
    DELETE FROM servicioGira WHERE id = pIdServicio;
    SELECT 1;
END $$
DELIMITER ;
#CALL borrarServicioGira(2);

-- -----------------------------------------------------
-- procedure getServiciosGira
-- -----------------------------------------------------
DROP procedure IF EXISTS getServiciosGira;
DELIMITER $$
CREATE  PROCEDURE getServiciosGira()
BEGIN
  SELECT * FROM servicioGira;
END $$
DELIMITER ;
#call getServiciosGira();

-- -----------------------------------------------------
-- procedure insertarServicioXFlotilla
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarServicioXGira;
DELIMITER $$
CREATE  PROCEDURE insertarServicioXGira (
  pFk_IdGira SMALLINT,
  pFk_ServicioGira SMALLINT,
  pCostoAsociado FLOAT
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM servicioXGira sxg where sxg.Fk_Gira = pFk_IdGira AND sxg.Fk_ServicioGira = pFk_ServicioGira)) THEN
      INSERT INTO servicioXGira(Fk_Gira,Fk_ServicioGira,costoAsociado)
        VALUES (pFk_IdGira,pFk_ServicioGira,pCostoAsociado);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarServicioXGira(1,4,1000);

-- -----------------------------------------------------
-- Procedure borrarServicioXGira
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarServicioXGira;
DELIMITER $$
CREATE  PROCEDURE borrarServicioXGira (
  pFk_IdGira SMALLINT,
  pFk_ServicioGira SMALLINT
)
BEGIN
    DELETE FROM servicioXGira WHERE Fk_Gira = pFk_IdGira and Fk_ServicioGira = pFk_ServicioGira;
    SELECT 1;
END $$
DELIMITER ;
#CALL borrarServicioXGira(1,4);

-- -----------------------------------------------------
-- procedure getServiciosXGira
-- -----------------------------------------------------
DROP procedure IF EXISTS getServiciosXGira;
DELIMITER $$
CREATE  PROCEDURE getServiciosXGira(pFk_IdGira SMALLINT)
BEGIN
  SELECT * FROM servicioGira JOIN servicioXGira ON serviciogira.id = servicioxgira.Fk_ServicioGira WHERE Fk_Gira = pFk_IdGira;
END $$
DELIMITER ;
#call getServiciosXGira(2);


-- -----------------------------------------------------
-- procedure insertarFlotillaXGira
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarFlotillaXGira;
DELIMITER $$
CREATE  PROCEDURE insertarFlotillaXGira (
  pFk_Flotilla SMALLINT,
  pFk_IdGira SMALLINT
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM flotillaXGira fxg where fxg.Fk_Gira = pFk_IdGira AND fxg.Fk_Flotilla= pFk_Flotilla)) THEN
      INSERT INTO flotillaXGira(Fk_Gira,Fk_Flotilla)
        VALUES (pFk_IdGira,pFk_Flotilla);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarFlotillaXGira(2,1);

-- -----------------------------------------------------
-- Procedure borrarFlotillaXGira
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarFlotillaXGira;
DELIMITER $$
CREATE  PROCEDURE borrarFlotillaXGira (
  pFk_Flotilla SMALLINT,
  pFk_IdGira SMALLINT
)
BEGIN
    DELETE FROM flotillaXGira WHERE Fk_Flotilla = pFk_Flotilla and Fk_Gira= pFk_IdGira;
    SELECT 1;
END $$
DELIMITER ;
#CALL borrarFlotillaXGira(2,1);

-- -----------------------------------------------------
-- procedure getFlotillaXGira
-- -----------------------------------------------------
DROP procedure IF EXISTS getFlotillaXGira;
DELIMITER $$
CREATE  PROCEDURE getFlotillaXGira(pFk_IdGira SMALLINT)
BEGIN
  SELECT * FROM flotilla JOIN flotillaXGira ON flotilla.id = flotillaXGira.Fk_Flotilla WHERE Fk_Gira = pFk_IdGira;
END $$
DELIMITER ;
#call getFlotillaXGira(1);


-- -----------------------------------------------------
-- procedure insertarParadaXGira
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarParadaXGira;
DELIMITER $$
CREATE  PROCEDURE insertarParadaXGira (
  pFk_IdGira SMALLINT,
  pNombreParada VARCHAR(100)
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM paradaXGira pxg where pxg.Fk_Gira = pFk_IdGira AND pxg.nombreParada = pNombreParada)) THEN
      INSERT INTO paradaXGira(Fk_Gira,nombreParada)
        VALUES (pFk_IdGira,pNombreParada);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarParadaXGira(1,'BA');

-- -----------------------------------------------------
-- Procedure borrarParadaXGira
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarParadaXGira;
DELIMITER $$
CREATE  PROCEDURE borrarParadaXGira (
  pFk_IdGira SMALLINT,
  pNombreParada VARCHAR(100)
)
BEGIN
    DELETE FROM paradaXGira WHERE nombreParada = pNombreParada and Fk_Gira= pFk_IdGira;
    SELECT 1;
END $$
DELIMITER ;
#CALL borrarParadaXGira(1,'BA');

-- -----------------------------------------------------
-- procedure getParadaXGira
-- -----------------------------------------------------
DROP procedure IF EXISTS getParadasXGira;
DELIMITER $$
CREATE  PROCEDURE getParadasXGira(pFk_IdGira SMALLINT)
BEGIN
  SELECT * FROM paradaXGira WHERE Fk_Gira = pFk_IdGira;
END $$
DELIMITER ;
#call getParadasXGira(1);

-- -----------------------------------------------------
-- procedure getGirasXSitio
-- -----------------------------------------------------
DROP procedure IF EXISTS getGirasXSitio;
DELIMITER $$
CREATE  PROCEDURE getGirasXSitio(pFk_Sitio SMALLINT)
BEGIN
  SELECT * FROM gira WHERE Fk_SitioTuristico = pFk_Sitio;
END $$
DELIMITER ;
#call getGirasXSitio(1);


-- -----------------------------------------------------
-- procedure insertarSitioTuristico
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarSitioTuristico;
DELIMITER $$
CREATE  PROCEDURE insertarSitioTuristico (
  pNombre VARCHAR(100),
  pDescripcion VARCHAR(600)
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM sitioTuristico WHERE nombre=pNombre)) THEN
      INSERT INTO sitioTuristico(nombre,descripcion)
        VALUES (pNombre,pDescripcion);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarSitioTutistico('Terraluna', 'piscina y cancha de futbol');

-- -----------------------------------------------------
-- Procedure borrarSitioTutistico
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarSitioTutistico;
DELIMITER $$
CREATE  PROCEDURE borrarSitioTutistico (
  pFk_Sitio SMALLINT
)
BEGIN
      UPDATE sitioTuristico SET
        eliminado = TRUE
      WHERE id=pFk_Sitio;
      SELECT 1;
END $$
DELIMITER ;
#CALL borrarSitioTutistico(1);

-- -----------------------------------------------------
-- Procedure modificarSitioTuristico
-- -----------------------------------------------------
DROP procedure IF EXISTS modificarSitioTuristico;
DELIMITER $$
CREATE  PROCEDURE modificarSitioTuristico (
  pIdSitio INT,
  pNombre VARCHAR(100),
  pDescripcion VARCHAR(600)
)
BEGIN
  IF NOT EXISTS((SELECT 1 FROM sitioTuristico s where s.nombre = pNombre)) THEN
      UPDATE sitioTuristico SET
        nombre = pNombre,
        descripcion = pDescripcion
      WHERE id =  pIdSitio;
      SELECT 1;
  END IF;
END $$
DELIMITER ;
#call modificarSitioTuristico(1,'Los Santos','Lo bayas y los homies');

-- -----------------------------------------------------
-- procedure getSitiosTuristicos
-- -----------------------------------------------------
DROP procedure IF EXISTS getSitiosTuristicos;
DELIMITER $$
CREATE  PROCEDURE getSitiosTuristicos()
BEGIN
  SELECT * FROM sitioTuristico WHERE eliminado=FALSE;
END $$
DELIMITER ;
#call getSitiosTuristicos();


-- -----------------------------------------------------
-- procedure insertarImagenXSitio
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarImagenXSitio;
DELIMITER $$
CREATE  PROCEDURE insertarImagenXSitio (
  pFk_Sitio SMALLINT,
  pImg LONGBLOB
)
BEGIN
    IF NOT EXISTS((SELECT 1 FROM imagenXsitio WHERE Fk_Sitio = pFk_Sitio and img = pImg)) THEN
      INSERT INTO imagenXsitio(Fk_Sitio,img)
        VALUES (pFk_Sitio,pImg);
      SELECT 1;
    END IF;
END $$
DELIMITER ;
#call insertarSitioTutistico('Terraluna', 'piscina y cancha de futbol');

-- -----------------------------------------------------
-- Procedure borrarImagenXSitio
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarImagenXSitio;
DELIMITER $$
CREATE  PROCEDURE borrarImagenXSitio (
  pIdImagen SMALLINT
)
BEGIN
    UPDATE imagenXsitio SET
      eliminada = TRUE
    WHERE id = pIdImagen;
    SELECT 1;
END $$
DELIMITER ;
#CALL borrarImagenXSitio(1);

-- -----------------------------------------------------
-- procedure getImagenesXSitio
-- -----------------------------------------------------
DROP procedure IF EXISTS getImagenesXSitio;
DELIMITER $$
CREATE  PROCEDURE getImagenesXSitio(
  pFk_Sitio SMALLINT
)
BEGIN
  SELECT id,img FROM imagenXsitio WHERE Fk_Sitio = pFk_Sitio AND eliminada=FALSE;
END $$
DELIMITER ;
#call getImagenesXSitio(1);

-- -----------------------------------------------------
-- procedure insertarGira
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarGira;
DELIMITER $$
CREATE  PROCEDURE insertarGira (
  pLugarSalida varchar(100),
	pLugarDestino varchar(100),
	pFechaPartida timestamp,
	pLimitePersonas smallint,
	pPrecioAdulto float,
	pPrecioNino float,
	pPrecioAdultoMayor float,
	pFechaLimDepo timestamp,
	pFechaLimPago timestamp,
	pFk_SitioTuristico smallint,
	pFk_Chofer smallint,
	pFk_Guia smallint
)
BEGIN

      INSERT INTO gira(lugarSalida, lugarDestino, fechaPartida, limitePersonas, precioAdulto, precioNino, precioAdultoMayor, fechaLimDepo, fechaLimPago, Fk_SitioTuristico, Fk_Chofer, Fk_Guia)
        VALUES (pLugarSalida,pLugarDestino,pFechaPartida,pLimitePersonas,pPrecioAdulto,pPrecioNino,pPrecioAdultoMayor,pFechaLimDepo,pFechaLimPago,pFk_SitioTuristico,pFk_Chofer,pFk_Guia);
      SELECT 1;
END $$
DELIMITER ;
#call insertarGira('Terraluna', 'piscina y cancha de futbol');

-- -----------------------------------------------------
-- Procedure borrarGira
-- -----------------------------------------------------
DROP procedure IF EXISTS borrarGira;
DELIMITER $$
CREATE  PROCEDURE borrarGira (
  pFk_IdGira SMALLINT
)
BEGIN
      UPDATE gira SET
        disponible = FALSE
      WHERE id=pFk_IdGira;
      SELECT 1;
END $$
DELIMITER ;
#CALL borrarGira(1);

-- -----------------------------------------------------
-- Procedure modificarGira
-- -----------------------------------------------------
DROP procedure IF EXISTS modificarGira;
DELIMITER $$
CREATE  PROCEDURE modificarGira (
  pFk_IdGira SMALLINT,
  pLugarSalida varchar(100),
	pLugarDestino varchar(100),
	pFechaPartida timestamp,
	pLimitePersonas smallint,
	pPrecioAdulto float,
	pPrecioNino float,
	pPrecioAdultoMayor float,
	pFechaLimDepo timestamp,
	pFechaLimPago timestamp,
	pFk_SitioTuristico smallint,
	pFk_Chofer smallint,
	pFk_Guia smallint
)
BEGIN
      UPDATE gira SET
        lugarSalida=pLugarSalida,
        LugarDestino=pLugarDestino,
        FechaPartida=pFechaPartida,
        LimitePersonas=pLimitePersonas,
        PrecioAdulto=pPrecioAdulto,
        PrecioNino=pPrecioNino,
        PrecioAdultoMayor=pPrecioAdultoMayor,
        FechaLimDepo=pFechaLimDepo,
        FechaLimPago=pFechaLimPago,
        Fk_SitioTuristico=pFk_SitioTuristico,
        Fk_Chofer=pFk_Chofer,
        Fk_Guia=pFk_Guia
      WHERE id =  pFk_IdGira;
      SELECT 1;
END $$
DELIMITER ;
#call modificarGira(1,'Los Santos','Lo bayas y los homies');

-- -----------------------------------------------------
-- procedure getGiras
-- -----------------------------------------------------
DROP procedure IF EXISTS getGiras;
DELIMITER $$
CREATE  PROCEDURE getGiras()
BEGIN
  SELECT * FROM gira WHERE disponible = TRUE;
END $$
DELIMITER ;
#call getGiras();


-- -----------------------------------------------------
-- procedure insertarReservacion
-- -----------------------------------------------------
DROP procedure IF EXISTS insertarReservacion;
DELIMITER $$
CREATE  PROCEDURE insertarReservacion (
	pCliente varchar(100),
	pCelularCliente varchar(100),
	pCantNinos smallint,
	pCantAdultos smallint,
	pCantAdultosMayores smallint,
# 	pDepositado BOOLEAN,
# 	pPagado BOOLEAN,
# 	pImgDeposito LONGBLOB,
# 	pImgPagoTotal LONGBLOB,
# 	pCancelado BOOLEAN,
	pFk_Gira smallint
)
BEGIN
      INSERT INTO reservacion(cliente, celularCliente, cantNinos, cantAdultos, cantAdultosMayores, Fk_Gira)
        VALUES (pCliente,pCelularCliente,pCantNinos,pCantAdultos,pCantAdultosMayores,pFk_Gira);
      SELECT 1;
END $$
DELIMITER ;
#call insertarReservacion();

-- -----------------------------------------------------
-- Procedure cancelarReservacion
-- -----------------------------------------------------
DROP procedure IF EXISTS cancelarReservacion;
DELIMITER $$
CREATE  PROCEDURE cancelarReservacion (
  pIdReservacion SMALLINT
)
BEGIN
      UPDATE reservacion SET
        cancelado = TRUE
      WHERE id=pIdReservacion;
      SELECT 1;
END $$
DELIMITER ;
#CALL cancelarReservacion(1);

-- -----------------------------------------------------
-- Procedure modificarReservacion
-- -----------------------------------------------------
DROP procedure IF EXISTS modificarReservacion;
DELIMITER $$
CREATE  PROCEDURE modificarReservacion (
  pIdReservacion SMALLINT,
	pDepositado BOOLEAN,
	pPagado BOOLEAN,
	pCancelado BOOLEAN
)
BEGIN
      UPDATE reservacion SET
        depositado = pDepositado,
        pagado = pPagado,
        cancelado = pCancelado
      WHERE id=pIdReservacion;
      SELECT 1;
END $$
DELIMITER ;
#CALL modificarReservacion(1);

-- -----------------------------------------------------
-- procedure getReservaciones
-- -----------------------------------------------------
DROP procedure IF EXISTS getReservaciones;
DELIMITER $$
CREATE  PROCEDURE getReservaciones()
BEGIN
  SELECT * FROM reservacion WHERE cancelado=FALSE ;
END $$
DELIMITER ;
#call getReservaciones();


-- -----------------------------------------------------
-- procedure consultarReservacion
-- -----------------------------------------------------
DROP procedure IF EXISTS consultarReservacion;
DELIMITER $$
CREATE  PROCEDURE consultarReservacion(pIdReservacion SMALLINT)
BEGIN
  SELECT depositado,pagado,cancelado FROM reservacion WHERE id = pIdReservacion;
END $$
DELIMITER ;
#call consultarReservacion(1);


-- -----------------------------------------------------
-- procedure adjuntarDepositoRes
-- -----------------------------------------------------
DROP procedure IF EXISTS adjuntarDepositoRes;
DELIMITER $$
CREATE  PROCEDURE adjuntarDepositoRes(pIdReservacion SMALLINT, pimgDep LONGBLOB)
BEGIN
  UPDATE reservacion set
    imgDeposito = pimgDep
  WHERE id = pIdReservacion;
  SELECT 1;
END $$
DELIMITER ;
#call consultarReservacion(1);

-- -----------------------------------------------------
-- procedure adjuntarPagoFinalRes
-- -----------------------------------------------------
DROP procedure IF EXISTS adjuntarPagoFinalRes;
DELIMITER $$
CREATE  PROCEDURE adjuntarPagoFinalRes(pIdReservacion SMALLINT, pimgPagoFin LONGBLOB)
BEGIN
  UPDATE reservacion set
    imgPagoTotal = pimgPagoFin
  WHERE id = pIdReservacion;
  SELECT 1;
END $$
DELIMITER ;
#call adjuntarPagoFinalRes(1);

