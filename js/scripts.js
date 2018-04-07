var app = angular.module('app', ['ngRoute', 'ngCookies']);
// Funciones globales
{
    JSON.clone = function (obj) {
        return JSON.parse(JSON.stringify(obj));
    };

    function focus(eName) {
        window.setTimeout('document.getElementById("' + eName + '").focus()', 100);
    }

    function formatearFloat(n) {
        return parseFloat(n.toFixed(3));
    }

    function log(o) {
        console.log(o);
    }

    function setEditable(e) {
        e.readOnly = false;
    }

}
// host localhost (xampp)
host = "/ProyectoSIEQ/";
rootHost = "https://sieq.000webhostapp.com/"

/*
//host webHost
host = "";
rootHost = "/"

// host pinacr
host = "sieq/";
rootHost = "https://sieq.000webhostapp.com/"
*/
/* LOGIN CONTROLLER */
app.controller("login", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if ($rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = host + "index.html";
    } else {
        log("login");

        $scope.ingresar = function (obj) {
            $rootScope.solicitudHttp(rootHost + "API/VerificarLogin.php", obj, "Los datos de inicio de sesión son incorrectos", function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Los datos de inicio de sesión son incorrectos");
                } else {

                    var usuario = listaDatos[0];
                    log(usuario);

                    // guardar la sesion en una cookie
                    var sesion = {};
                    sesion.nombreUsuarioActivo = usuario.Nombre;
                    sesion.rolUsuarioActivo = usuario.Rol;
                    sesion.idUsuarioActivo = usuario.UsuarioID
                    var tiempo = new Date();
                    tiempo.setHours(tiempo.getHours() + 12); // guardamos la sesion por 12 horas
                    $cookies.putObject("fdsfsdfgsfg5vbv", sesion, {
                        expires: tiempo
                    });
                    window.location.pathname = host + "index.html"
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

    }
});

/* REGISTRARSE CONTROLLER */
app.controller("registrarse", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if ($rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = "login.html";
    } else {
        log("registrarse");
        //$scope.roles = "";

        $scope.registrarse = function (obj) {
            $rootScope.solicitudHttp(rootHost + "API/AgregarUsuario.php", obj, function () {
                $rootScope.agregarAlerta("Nombre de usuario no disponible");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Error desconocido");
                } else {
                    log("Solicitud agregada con éxito");

                    window.location.pathname = host + "login.html";
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.verRolesUsuario = function () {
            $rootScope.solicitudHttp(rootHost + "API/VerRolesUsuario.php", {}, function () {
                $rootScope.agregarAlerta("Respuesta desconocida");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No se encontraron roles de usuario");
                } else {
                    log("Roles de usuario consultados con éxito");

                    $scope.roles = listaDatos;
                    $scope.l.RolID = $scope.roles[0].RolID;
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.verRolesUsuario();

    }
});

/* ADMIN USUARIOS CONTROLLER */
app.controller("adminUsuarios", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = host + "login.html";
    } else {
        log("adminUsuarios");
        $scope.usuarios = [];

        $scope.verListaUsuarios = function (UsuarioID) {
            var obj = {};
            obj.UsuarioID = UsuarioID;
            $rootScope.solicitudHttp(rootHost + "API/VerListaUsuarios.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida (Sin lista de usuarios)");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No hay usuarios en el sistema");
                } else {
                    log("Lista de usuarios consultada con éxito");
                    $scope.usuarios = listaDatos;
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.verRolesUsuario = function () {
            $rootScope.solicitudHttp(rootHost + "API/VerRolesUsuario.php", {}, function () {
                $rootScope.agregarAlerta("Respuesta desconocida");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No se encontraron roles de usuario");
                } else {
                    log("Roles de usuario consultados con éxito");

                    $scope.roles = listaDatos;
                    //$scope.rolID = $scope.roles[0].RolID;
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.actualizarEstadoUsuario = function (usuarioID, tipo) {
            var obj = {}
            obj.EstadoID = tipo;
            obj.UsuarioID = usuarioID;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarEstadoUsuario.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida (Sin lista de usuarios)");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Lista Tamaño 0");
                } else {
                    log("Lista con datos");
                    log(listaDatos);
                    $scope.verListaUsuarios($rootScope.idUsuarioActivo);
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.cambiarEstadoBloqueo = function (UsuarioID, Estado) {
            if (Estado == "1") {
                $scope.actualizarEstadoUsuario(UsuarioID, 2);
            } else {
                $scope.actualizarEstadoUsuario(UsuarioID, 1);
            }
        };

        $scope.actualizarRolUsuario = function (UsuarioID, rolSeleccionado) {
            var obj = {}
            obj.UsuarioID = UsuarioID;
            obj.RolID = rolSeleccionado;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarRolUsuario.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida (Sin lista de datos)");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Lista Tamaño 0");
                } else {
                    log("Lista con datos - cambiando rol de usuario");
                    log(listaDatos);
                    $scope.verListaUsuarios($rootScope.idUsuarioActivo);
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.verListaUsuarios($rootScope.idUsuarioActivo);
        $scope.verRolesUsuario();

    }
});

/* ADMIN DE SOLICITUDES CONTROLLER */
app.controller("adminSolicitudes", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = host + "login.html";
    } else {
        log("adminSolicitudes");
        $scope.solicitudesCuenta = [];

        $scope.verUsuariosPendientes = function () {
            $rootScope.solicitudHttp(rootHost + "API/VerUsuariosPendientes.php", {}, function () {
                $rootScope.agregarAlerta("Respuesta desconocida (Sin lista de usuarios)");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No hay solicitudes de cuentas");
                } else {
                    log("Solicitudes consultadas con éxito");
                    $scope.solicitudesCuenta = listaDatos;
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.actualizarEstadoUsuario = function (usuarioID, tipo) {
            var obj = {}
            obj.EstadoID = tipo;
            obj.UsuarioID = usuarioID;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarEstadoUsuario.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida (Sin lista de usuarios)");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Lista Tamaño 0");
                } else {
                    log("Lista con datos");
                    log(listaDatos);
                    $scope.verUsuariosPendientes();
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };


        $scope.verUsuariosPendientes();
    }
});

/* ADMINFLOTILLAS CONTROLLER */
app.controller("reportes", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = host + "login.html";
    } else {
        log("reportes");

        /*INICIO REPORTE CRACK*/
        function formatearFecha(fecha) {
            return fecha.getFullYear() + "-" + (fecha.getMonth() + 1) + "-" + fecha.getDate();
        }

        function hoy() {
            var objReporteP = {
                FechaDesde: formatearFecha(new Date()),
                FechaHasta: formatearFecha(new Date()),
                CategoriaID: $scope.objReporteParam.CategoriaID
            }
            cargarReporte(objReporteP);
        }

        function ayer() {
            var fecha = new Date();
            fecha.setDate(fecha.getDate() - 1);
            var objReporteP = {
                FechaDesde: formatearFecha(fecha),
                FechaHasta: formatearFecha(fecha),
                CategoriaID: $scope.objReporteParam.CategoriaID
            }
            cargarReporte(objReporteP);
        }

        function u7Dias() {
            var fecha1 = new Date();
            fecha1.setDate(fecha1.getDate() - 7);
            var fecha2 = new Date();
            fecha2.setDate(fecha2.getDate() - 1);
            var objReporteP = {
                FechaDesde: formatearFecha(fecha1),
                FechaHasta: formatearFecha(fecha2),
                CategoriaID: $scope.objReporteParam.CategoriaID
            }
            cargarReporte(objReporteP);
        }

        function u30Dias() {
            var fecha1 = new Date();
            fecha1.setDate(fecha1.getDate() - 30);
            var fecha2 = new Date();
            fecha2.setDate(fecha2.getDate() - 1);
            var objReporteP = {
                FechaDesde: formatearFecha(fecha1),
                FechaHasta: formatearFecha(fecha2),
                CategoriaID: $scope.objReporteParam.CategoriaID
            }
            cargarReporte(objReporteP);
        }

        function personalizado() {
            if ($scope.objReporteParam.FechaDesde && $scope.objReporteParam.FechaHasta) {
                var objReporteP = {
                    FechaDesde: formatearFecha($scope.objReporteParam.FechaDesde),
                    FechaHasta: formatearFecha($scope.objReporteParam.FechaHasta),
                    CategoriaID: $scope.objReporteParam.CategoriaID
                }
                cargarReporte(objReporteP);
            } else {
                $rootScope.agregarAlerta("Debe seleccionar una fecha válida");
            }
        }

        function allRegistros() {
            /* solicitamos las registros desde el año 2000 */
            var objReporteP = {
                FechaDesde: formatearFecha(new Date("2000-01-02")),
                FechaHasta: formatearFecha(new Date()),
                CategoriaID: $scope.objReporteParam.CategoriaID
            }
            cargarReporte(objReporteP);
        }
        $scope.opciones = [
            {
                nombre: "Hoy",
                seleccionarCantidad: false,
                seleccionarFecha: false,
                funcion: hoy
            }
            , {
                nombre: "Ayer",
                seleccionarCantidad: false,
                seleccionarFecha: false,
                funcion: ayer
            }
            , {
                nombre: "Últimos 7 dias",
                seleccionarCantidad: false,
                seleccionarFecha: false,
                funcion: u7Dias
            }
            , {
                nombre: "Últimos 30 dias",
                seleccionarCantidad: false,
                seleccionarFecha: false,
                funcion: u30Dias
            }
            , {
                nombre: "Fecha personalizada",
                seleccionarCantidad: false,
                seleccionarFecha: true,
                funcion: personalizado
            }
            , {
                nombre: "Todos los registros",
                seleccionarCantidad: false,
                seleccionarFecha: false,
                funcion: allRegistros
            }
            ];
        $scope.buscarReporte = function (opcion, tipoReporte) {
            if (opcion) {
                opcion.funcion();
                $scope.tipoReporte = tipoReporte;
            } else {
                $rootScope.agregarAlerta("Debe seleccionar una opción");
            }
            $scope.filtroFacturas = "";
        };

        function cargarReporte(objReporteParam) {
            if ($scope.tipoReporte == 'movReact') {
                $rootScope.solicitudHttp(rootHost + "API/VerMovimientosReactivos.php", objReporteParam, function () {
                    $rootScope.agregarAlerta("Ha ocurrido un Error");
                }, function (listaDatos) {
                    $scope.listaMovimientosReactivos = listaDatos;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            } else if ($scope.tipoReporte == 'movCrist') {
                $rootScope.solicitudHttp(rootHost + "API/VerMovimientosCristaleria.php", objReporteParam, function () {
                    $rootScope.agregarAlerta("Ha ocurrido un Error");
                }, function (listaDatos) {
                    $scope.listaMovimientosCristaleria = listaDatos;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            }

        }
        /*FIN REPORTE CRACK*/
        function cargarCategorias() {
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.solicitudHttp(rootHost + "API/VerCategorias.php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                $scope.categorias = listaDatos;
                $scope.categorias.forEach(function (c) {
                    c.CategoriaReactivoID = parseInt(c.CategoriaReactivoID);
                })
                $scope.categorias.unshift({
                    CategoriaReactivoID: 0,
                    Nombre: "Todas"
                });
                $scope.objReporteParam.CategoriaID = $scope.categorias[0].CategoriaReactivoID;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        if (!$scope.categorias) {
            cargarCategorias();
        };
    }
});
/* ADMINGIRAS CONTROLLER */
app.controller("adminInventarioCristaleria", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = host + "login.html";
    } else {
        $scope.cargarListaCristaleria = function () {
            cargarListaCristaleria();
        }

        function cargarListaCristaleria() {
            $rootScope.solicitudHttp(rootHost + "API/VerListaCristaleria.php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                $scope.listaCristaleria = listaDatos;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        $scope.agregarCristaleria = function () {
            $scope.objCristaleria.UsuarioID = $rootScope.idUsuarioActivo;
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.solicitudHttp(rootHost + "API/AgregarCristaleria.php", $scope.objCristaleria, function () {
                $rootScope.agregarAlerta("No se ha podido ingresar el activo de cristalería");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha agregado el activo de cristalería");
                cargarListaCristaleria();
                $scope.popupCrearCristaleria = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.preEditarCristaleria = function (c) {
            $scope.cristaleriaEditar.ArticuloID = c.ArticuloID;
            $scope.cristaleriaEditar.Nombre = c.NombreArticulo;
            $scope.cristaleriaEditar.Ubicacion = c.Ubicacion;
            $scope.cristaleriaEditar.PuntoReorden = parseFloat(c.PuntoReorden);
            $scope.cristaleriaEditar.Descripcion = c.Descripcion;
            $scope.popupEditarCristaleria = true;
            log($scope.cristaleriaEditar);
        }

        $scope.editarCristaleria = function () {
            log($scope.cristaleriaEditar);
            $rootScope.solicitudHttp(rootHost + "API/ActualizarCristaleria.php", $scope.cristaleriaEditar, function () {
                $rootScope.agregarAlerta("No se ha podido actualizar el activo de cristalería");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha modificado el activo de cristalería");
                cargarListaCristaleria();
                $scope.popupEditarCristaleria = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }
        $scope.preBorrarCristaleria = function (c) {
            $scope.panelPregunta = true;
            $scope.mensaje = "¿Está seguro que desea borrar el activo: " + c.NombreArticulo + "?"
            $scope.cristaleriaABorrar = {
                ArticuloID: c.ArticuloID
            }
        }
        $scope.borrarCristaleria = function () {
            $rootScope.solicitudHttp(rootHost + "API/EliminarCristaleria.php", $scope.cristaleriaABorrar, function () {
                $rootScope.agregarAlerta("No se ha podido borrar el activo de cristalería");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha eliminado el activo de cristalería");
                cargarListaCristaleria();
                $scope.panelPregunta = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }
        $scope.cargarListaCristaleria();
    }
});
/* ADMINSITIOS CONTROLLER */
app.controller("adminInventarioReactivos", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = host + "login.html";
    } else {
        $scope.editarReactivo = function (r) {
            $scope.reactivoEditar = JSON.clone(r);
            $scope.popupEditarReactivo = true;
        }
        $scope.mostrarPanelUnidades = function () {
            cargarUnidades();
            $scope.panelUnidades = true;
        }
        $scope.mostrarPanelCategorias = function () {
            cargarCategorias();
            $scope.panelCategorias = true;
        }
        $scope.mostrarPanelCrearReactivo = function () {
            $scope.popupCrearReactivo = true;
            if (!$scope.unidades) {
                cargarUnidades();
            }
            $scope.objReactivo.UnidadMetricaID = $scope.unidades[0].UnidadMetricaID;
            $scope.objReactivo.CategoriaID = $scope.categorias[0].CategoriaReactivoID;
            $scope.objReactivo.EsPrecursor = false;
            $scope.objReactivo.Descripcion = '';
            $scope.objReactivo.URLHojaSeguridad = '';
            $scope.objReactivo.UsuarioID = $rootScope.idUsuarioActivo;
        }

        $scope.cargarListaReactivos = function () {
            cargarListaReactivos();
        }

        $scope.preEditarReactivo = function (r) {
            $scope.reactivoEditar = JSON.clone(r);
            $scope.reactivoEditar.CantidadActual = parseFloat($scope.reactivoEditar.CantidadActual);
            $scope.reactivoEditar.PuntoReorden = parseFloat($scope.reactivoEditar.PuntoReorden);
            $scope.reactivoEditar.CategoriaID = parseInt($scope.reactivoEditar.CategoriaReactivoID);
            $scope.reactivoEditar.UnidadMetricaID = parseInt($scope.reactivoEditar.UnidadMetricaID);
            $scope.reactivoEditar.TipoArticulo = parseInt($scope.reactivoEditar.TipoArticulo);
            $scope.popupEditarReactivo = true;
            if ($scope.reactivoEditar.EsPrecursor == 1) {
                $scope.precursor = true;
            } else {
                $scope.precursor = false;
            }
        }

        $scope.editarReactivo = function () {
            var objEnviar = {
                ReactivoID: parseInt($scope.reactivoEditar.ReactivoID),
                Nombre: $scope.reactivoEditar.nombreReactivo,
                Ubicacion: $scope.reactivoEditar.Ubicacion,
                PuntoReorden: parseFloat($scope.reactivoEditar.PuntoReorden),
                Descripcion: $scope.reactivoEditar.Descripcion,
                EsPrecursor: parseInt($scope.reactivoEditar.EsPrecursor),
                UnidadMetricaID: parseInt($scope.reactivoEditar.UnidadMetricaID),
                CategoriaID: parseInt($scope.reactivoEditar.CategoriaID),
                URLHojaSeguridad: $scope.reactivoEditar.URLHojaSeguridad,
                TipoArticuloID: parseInt($scope.reactivoEditar.TipoArticulo),
            }
            if ($scope.precursor) {
                objEnviar.EsPrecursor = 1
            } else {
                objEnviar.EsPrecursor = 0
            }
            $rootScope.solicitudHttp(rootHost + "API/ActualizarReactivo.php", objEnviar, function () {
                $rootScope.agregarAlerta("No se ha podido actualizar el reactivo");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha modificado el reactivo");
                $scope.popupEditarReactivo = false;
                cargarListaReactivos();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }

        $scope.preBorrarReactivo = function (r) {
            $scope.panelPregunta = true;
            $scope.mensaje = "¿Está seguro que desea borrar el reactivo " + r.nombreReactivo + "?"
            $scope.reactivoABorrar = {
                ReactivoID: r.ReactivoID
            }
        }
        $scope.borrarReactivo = function () {
            $rootScope.solicitudHttp(rootHost + "API/EliminarReactivo.php", $scope.reactivoABorrar, function () {
                $rootScope.agregarAlerta("No se ha podido borrar el reactivo");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha eliminado el reactivo");
                $scope.panelPregunta = false;
                cargarListaReactivos();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }
        $scope.agregarReactivo = function () {
            if ($scope.objReactivo.EsPrecursor == false) {
                $scope.objReactivo.EsPrecursor = 0;
            };
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.solicitudHttp(rootHost + "API/AgregarReactivo.php", $scope.objReactivo, function () {
                $rootScope.agregarAlerta("No se ha podido ingresar el reactivo");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha agregado el reactivo");
                $scope.popupCrearReactivo = false;
                cargarListaReactivos();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };


        $scope.editarUnidad = function (u) {
            if (u.Nombre != "" && u.Siglas != "") {

                $rootScope.solicitudHttp(rootHost + "API/ActualizarUnidad.php", u, function () {
                    $rootScope.agregarAlerta("No se ha podido modificar la unidad");
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha modificado la unidad");
                    cargarUnidades();
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            } else {
                $rootScope.agregarAlerta("No deben haber parámetros vacíos");
            }
        }

        $scope.agregarUnidad = function (u) {
            if (u.Nombre != "" && u.Siglas != "") {

                $rootScope.solicitudHttp(rootHost + "API/AgregarUnidadMetrica.php", u, function () {
                    $rootScope.agregarAlerta("La unidad no puede tener valores idénticos a otras unidades");
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha agregado la unidad");
                    u.Nombre = "";
                    u.Siglas = "";
                    cargarUnidades();
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            } else {
                $rootScope.agregarAlerta("No deben haber parámetros vacíos");
            }
        }
        $scope.agregarCategoria = function (c) {

            if (c.Nombre != "") {

                $rootScope.solicitudHttp(rootHost + "API/agregarCategoria.php", c, function () {
                    $rootScope.agregarAlerta("La categoría no puede tener valores idénticos a otras unidades");
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha agregado la categoría");
                    c.Nombre = "";
                    cargarCategorias();
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            } else {
                $rootScope.agregarAlerta("No deben haber parámetros vacíos");
            }
        }
        $scope.borrarUnidad = function (u) {
            var obj = {
                UnidadMetricaID: u.UnidadMetricaID
            }
            $rootScope.solicitudHttp(rootHost + "API/borrarUnidadMetrica.php", obj, function () {
                $rootScope.agregarAlerta("No se puede borrar la unidad ya que está siendo utilizada");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha borrado la unidad");
                cargarUnidades();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }

        $scope.borrarCategoria = function (c) {
            var obj = {
                CategoriaReactivoID: c.CategoriaReactivoID
            }
            $rootScope.solicitudHttp(rootHost + "API/borrarCategoria.php", obj, function () {
                $rootScope.agregarAlerta("No se puede borrar la categoría ya que está siendo utilizada");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha borrado la categoría");
                cargarCategorias();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }

        $scope.editarCategoria = function (c) {
            if (c.Nombre != "") {
                $rootScope.solicitudHttp(rootHost + "API/ActualizarCategoria.php", c, function () {
                    $rootScope.agregarAlerta("No se ha podido modificar la categoría");
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha modificado la categoría");
                    cargarCategorias();
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            } else {
                $rootScope.agregarAlerta("No deben haber parámetros vacíos");
            }
        }

        function cargarListaReactivos() {
            $rootScope.solicitudHttp(rootHost + "API/VerListaReactivos.php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                $scope.listaReactivos = listaDatos;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        function cargarUnidades() {
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.solicitudHttp(rootHost + "API/VerUnidadesMetricas.php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                $scope.unidades = listaDatos;
                $scope.unidades.forEach(function (u) {
                    u.UnidadMetricaID = parseInt(u.UnidadMetricaID);
                })
                $scope.preUnidades = listaDatos;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        function cargarCategorias() {
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.solicitudHttp(rootHost + "API/VerCategorias.php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                $scope.categorias = listaDatos;
                $scope.categorias.forEach(function (c) {
                    c.CategoriaReactivoID = parseInt(c.CategoriaReactivoID);
                })
                $scope.preCategorias = listaDatos;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        /*Variables definidas del Scope y llamados a funciones */
        if (!$scope.categorias) {
            cargarCategorias();
        };
        if (!$scope.unidades) {
            cargarUnidades();
        };
        if (!$scope.listaReactivos) {
            cargarListaReactivos();
        };
    }
});

/* CONTROLADOR PRINCIPAL */
app.controller("mainController", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    //*********************************************
    // Sistema de alertas personalizados
    $rootScope.listaAlerts = [];
    $rootScope.agregarAlerta = function (texto) {
        var alerta = {
            texto: texto
        };
        alerta.eliminarAlerta = function () {
            $rootScope.listaAlerts.splice($rootScope.listaAlerts.indexOf(alerta), 1);
            //log("Alerta eliminada");
        }
        alerta.ocultarAlerta = function () {
            alerta.classAlert = "ocultarAlert";
            setTimeout(alerta.eliminarAlerta, 1100);
            //log("Alerta ocultada");
        }
        setTimeout(alerta.ocultarAlerta, 2000);
        $rootScope.listaAlerts.push(alerta);
    };
    // ----------------------------------------
    $rootScope.formatearFloat = function (n) {
        // parsea el string n a float y lo limita a 2 decimales
        return parseFloat(parseFloat(n).toFixed(2));
    };
    // include de un archivo de la carpeta popup
    $rootScope.cargarPopup = function (nombreArchivo) {
        if (nombreArchivo != "") {
            $scope.templateSubPopup = "";
            $scope.templateUrl = "popups/" + nombreArchivo;
        } else {
            $scope.templateUrl = "";
        }
    };
    // **** Datos de Usuario ****
    $rootScope.nombreUsuarioActivo = "";
    $rootScope.rolUsuarioActivo = "";
    $rootScope.idUsuarioActivo = "";

    // PARA CONTROLAR LA SESION
    $rootScope.sesionIniciada = false;
    $rootScope.sesionActiva = function () {
        if ($rootScope.sesionIniciada) {
            return true;
        } else if ($cookies.getObject("fdsfsdfgsfg5vbv")) {
            // carga las variables necesarias para garantizar el correcto funcionamiento de la aplicacioegn
            var sesion = $cookies.getObject("fdsfsdfgsfg5vbv");
            $rootScope.nombreUsuarioActivo = sesion.nombreUsuarioActivo;
            $rootScope.rolUsuarioActivo = sesion.rolUsuarioActivo;
            $rootScope.idUsuarioActivo = sesion.idUsuarioActivo;
            $rootScope.sesionIniciada = true;
            var tiempo = new Date();
            tiempo.setHours(tiempo.getHours() + 12); // guardamos la sesion por 12 horas
            $cookies.putObject("fdsfsdfgsfg5vbv", sesion, {
                expires: tiempo
            });
            return true;
        } else {
            return false;
        }
    };
    $rootScope.cerrarSesion = function () {
        $cookies.remove("fdsfsdfgsfg5vbv");
        $rootScope.nombreUsuarioActivo = "";
        $rootScope.rolUsuarioActivo = "";
        $rootScope.idUsuarioActivo = "";
        $rootScope.sesionIniciada = false;
        window.location.pathname = host + "login.html";
    };
    /* Funcion generica para solicitudes http */
    $rootScope.debugMode = false;
    $rootScope.solicitudHttp = function (url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch) {
        // solicitud post
        var fd = new FormData();
        fd.append("obj", JSON.stringify(objEnviar));
        var config = {
            headers: {
                'Content-Type': undefined
            }
        }
        $http.post(url, fd, config).then(function (respuesta) {
            if ($rootScope.debugMode || forzarDebug) {
                log("Solicitud " + url + " | " + respuesta.data.message);
            }
            if (respuesta.data.message === "OK") {
                if (respuesta.data.listaDatos != undefined) {
                    if (typeof (casoOKconLista) == "function") {
                        casoOKconLista(respuesta.data.listaDatos);
                    } else if (typeof (casoOKconLista) == "string" && casoOKconLista != "") {
                        $rootScope.agregarAlerta(casoOKconLista)
                    }
                } else {
                    if (typeof (casoSoloOK) == "function") {
                        casoSoloOK();
                    } else if (typeof (casoSoloOK) == "string" && casoSoloOK != "") {
                        $rootScope.agregarAlerta(casoSoloOK)
                    }
                }
            } else {
                if (typeof (casoFallo) == "function") {
                    casoFallo(respuesta.data)
                } else {
                    if (typeof (casoFallo) == "string" && casoFallo != "") {
                        $rootScope.agregarAlerta(casoFallo)
                    }
                };
            }
        }).catch(function (respuesta) {
            if ($rootScope.debugMode || forzarDebug) {
                log("Solicitud " + url + " | ERROR FATAL - CATCH");
                log(respuesta);
            }
            if (typeof (casoCatch) == "function") {
                casoCatch(respuesta)
            } else {
                if (typeof (casoCatch) == "string" && casoCatch != "") {
                    $rootScope.agregarAlerta(casoCatch)
                }
            };
        });
    };

    $rootScope.esCoordinador = function () {
        if ($rootScope.rolUsuarioActivo == 'Coordinador') {
            return true;
        } else {
            return false;
        }
    };

    $rootScope.limpiarTxt = function (txtId) {
        var txt = document.getElementById(txtId);
        txt.value = "/";
    };
    $rootScope.formatearFecha = function (fecha) {
        return $filter('date')(new Date(fecha), "dd/MM/yyyy hh:mm:ss a", "-0600")
    };
});

/* Eventos */
window.onkeydown = function (e) {
    var key = e.keyCode ? e.keyCode : e.which;
    if (key == 122) {
        pantallaCompleta();
        e.preventDefault();
    } else if (key == 116) {
        // si se pesiona f5 no hace nada
        e.preventDefault();
    }
};
document.oncontextmenu = function () {
    return false;
}
