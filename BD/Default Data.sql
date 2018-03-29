INSERT INTO EstadoUsuario VALUES(DEFAULT, 'Activo', 'El usuario puede acceder normalmente a su cuenta');
INSERT INTO EstadoUsuario VALUES(DEFAULT, 'Inactivo', 'El usuario no puede acceder normalmente a su cuenta');
INSERT INTO EstadoUsuario VALUES(DEFAULT, 'Pendiente', 'El usuario no ha sido aprobado por el cliente');


INSERT INTO Rol VALUES(DEFAULT, 'Coordinador', 'Tiene permisos de todo menos administrar cuentas');
INSERT INTO Rol VALUES(DEFAULT, 'Administrador', 'Tiene permisos de todo');