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
rootHost = "https://pinacr.com/sieq/"
//rootHost = "https://pinacr.com/sieq/api"


//host webHost
//host = "";
//rootHost = "/"

/*
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
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/AgregarUsuario.php", obj, function () {
                $rootScope.agregarAlerta("Nombre de usuario no disponible");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Error desconocido");
                } else {
                    log("Solicitud agregada con éxito");

                    window.location.pathname = host + "login.html";
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.verRolesUsuario = function () {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerRolesUsuario.php", {}, function () {
                $rootScope.agregarAlerta("Error al cargar los roles de usuario");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
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

/* ACERCA DE LOS AUTORES*/
app.controller("acercaDe", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = "login.html";
    } else {
        log("acercaDe");
    }
});

/* REPORTEPRECURSORES CONTROLLER */
app.controller("reportePrecursores", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = "login.html";
    } else {
        log("reportePrecursores");
    }
});


/* EDITARPEDIDO CONTROLLER */
app.controller("editarPedidos", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = "login.html";
    } else {
        log("editarPedidos");
        var urlParams = $location.search();
        $scope.listaArticulos = [];
        $scope.listaActivos = [];
        $scope.popupAgregarArticulo = false;
        $scope.activoSeleccionado = {};
        $scope.activoXAgregar = {};

        $scope.pedidoID = urlParams.PedidoID;
        $scope.tituloPedido = urlParams.Titulo;
        $scope.descripcionPedido = urlParams.Descripcion;

        $scope.cargarArticulosPedido = function () {
            var obj = {
                'PedidoID': $scope.pedidoID
            };
            log("Cargando Articulos del pedido");
            log(obj);
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerArticulosDelPedido.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida, se esperaba una lista de articulos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Pedido sin artículos");
                } else {
                    log("Artículos consultados con éxito");
                    $scope.listaArticulos = listaDatos;
                    $rootScope.agregarAlerta("Artículos consultados con éxito");
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

        };

        $scope.cargarActivos = function () {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerListaArticulos.php", {}, function () {
                $rootScope.agregarAlerta("Respuesta desconocida, se esperaba una lista de activos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No existen Activos");
                } else {
                    log("Activos consultados con éxito");
                    $scope.listaActivos = listaDatos;
                    $rootScope.agregarAlerta("Activos consultados con éxito");
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

        };


        $scope.mostrarPanelAgregarArticulo = function () {
            $scope.cargarActivos();

            $scope.activoSeleccionado = {};
            $scope.activoXAgregar = {};
            $scope.popupAgregarArticulo = true;
        };

        $scope.seleccionarActivo = function (activo) {
            $scope.activoSeleccionado = activo;
            $scope.activoXAgregar = {
                "PedidoID": $scope.pedidoID,
                "ArticuloID": activo.ArticuloID,
            };

        };

        $scope.agregarArticuloPedido = function (obj) {
            log(obj);
            log($scope.activoXAgregar);

            if ($scope.activoXAgregar.ArticuloID == undefined) {
                $rootScope.agregarAlerta("Seleccione un artículo");
            } else {
                obj.PedidoID = $scope.activoXAgregar.PedidoID;
                obj.ArticuloID = $scope.activoXAgregar.ArticuloID;

                log("Agregando artículo");
                log(obj);
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/AgregarArticuloAPedido.php", obj, function () {
                    $rootScope.agregarAlerta("Error al cargar artículos del pedido");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    $rootScope.waiting = false;
                    if (listaDatos.length == 0) {
                        $rootScope.agregarAlerta("Lista vacía");
                    } else {
                        $rootScope.agregarAlerta("Artículo agregado con éxito");

                        $scope.cargarArticulosPedido();
                        $scope.activoSeleccionado = {};
                        $scope.activoAgregar = {};
                        $scope.activoXAgregar = {};
                    }
                }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            }
        };

        $scope.preBorrarArticulo = function (articulo) {
            $scope.panelPregunta = true;
            $scope.mensaje = "¿Está seguro que desea borrar el artículo: '" + articulo.Articulo + "'?"
            $scope.articuloABorrar = {
                ArticuloPedidoID: articulo.ArticuloPedidoID
            }
        };

        $scope.borrarArticulo = function () {
            $scope.panelPregunta = false;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/EliminarArticuloDelPedido.php", $scope.articuloABorrar, function () {
                $rootScope.agregarAlerta("No se ha podido borrar el artículo");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha eliminado el artículo");
                $scope.cargarArticulosPedido();
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.verArticulo = function (articulo) {
            var obj = {
                "ArticuloPedidoID": articulo.ArticuloPedidoID
            };
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerArticuloDelPedido.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido consultar el artículo");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                log("Artículo consultado con éxito");
                $scope.articuloVisualizado = listaDatos[0];
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            $scope.popupVerArticulo = true;
        };

        $scope.preActualizarArticulo = function (articulo) {
            log("Actualizando Articulo");
            $scope.articuloXActualizar = articulo;
            log($scope.articuloXActualizar);
            $scope.popupActualizarArticulo = true;
        };

        $scope.actualizarArticulo = function (articuloActualizado) {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarArticuloDelPedido.php", articuloActualizado, function () {
                $rootScope.agregarAlerta("Respuesta desconocida");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Lista vacía");
                } else {
                    $rootScope.agregarAlerta("Artículo actualizado con éxito");

                    $scope.cargarArticulosPedido();
                    $scope.popupActualizarArticulo = false;

                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        if ($scope.listaArticulos.length == 0) {
            $scope.cargarArticulosPedido();
        };

    }
});


/* ADMINPEDIDOS CONTROLLER */
app.controller("adminPedidos", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = "login.html";
    } else {
        log("adminPedidos");

        $scope.filtroPedido = false;
        $scope.listaPedidos = [];
        $scope.popupCrearPedido = false;

        $scope.filtrarPedidos = function () {
            if ($scope.filtroPedido) {
                $scope.filtroPedido = false;
                $scope.selectClass = '';
            } else {
                $scope.filtroPedido = true;
                $scope.selectClass = 'selectClass';
            }
        };

        $scope.filtrarSegunPropietario = function (pedido) {
            if (pedido.PropietarioID != $rootScope.idUsuarioActivo & $scope.filtroPedido) {
                return true;
            }
            return false;
        };

        $scope.cargarListaPedidos = function () {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerPedidos.php", {}, function () {
                $rootScope.agregarAlerta("Respuesta desconocida, se esperaba una lista de pedidos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No se encontraron pedidos");
                } else {
                    log("Pedidos consultados con éxito");
                    $scope.listaPedidos = listaDatos;
                    $rootScope.agregarAlerta("Pedidos consultados con éxito");
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.agregarPedido = function (obj) {
            obj.UsuarioID = $rootScope.idUsuarioActivo;

            log("Agregando pedido");
            log(obj);
            $scope.popupCrearPedido = false;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/AgregarPedido.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido agregar el pedido");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Pedido Creado y listo para editarse");
                $scope.cargarListaPedidos();
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.editarPedido = function (pedido) {
            log("Editando el pedido");
            log(pedido);

            $location.path("editarPedidos").search(pedido);

        };

        $scope.preBorrarPedido = function (pedido) {
            $scope.panelPregunta = true;
            $scope.mensaje = "¿Está seguro que desea borrar el pedido: '" + pedido.Titulo + "'?"
            $scope.pedidoABorrar = {
                PedidoAEliminarID: pedido.PedidoID
            }
        };

        $scope.borrarPedido = function () {
            $scope.panelPregunta = false;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/EliminarPedido.php", $scope.pedidoABorrar, function () {
                $rootScope.agregarAlerta("No se ha podido borrar el pedido");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha eliminado el pedido");
                $scope.cargarListaPedidos();
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.mostrarPanelCrearPedido = function () {
            $scope.popupCrearPedido = true;
        };

        if ($scope.listaPedidos.length == 0) {
            $scope.cargarListaPedidos();
        };


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
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerListaUsuarios.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida (Sin lista de usuarios)");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No hay usuarios en el sistema");
                } else {
                    log("Lista de usuarios consultada con éxito");
                    $rootScope.agregarAlerta("Lista de usuarios consultada con éxito");
                    $scope.usuarios = listaDatos;
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.verRolesUsuario = function () {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerRolesUsuario.php", {}, function () {
                $rootScope.agregarAlerta("Error en la consulta de roles de usuario");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.waiting = false;
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
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarEstadoUsuario.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido actuliazar el estado del usuario");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Lista Tamaño 0");
                } else {
                    log("Lista con datos");
                    log(listaDatos);
                    $scope.verListaUsuarios($rootScope.idUsuarioActivo);
                    $rootScope.agregarAlerta("Estado del usuario actualizado");
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.cambiarEstadoBloqueo = function (UsuarioID, Estado) {
            if (Estado == "1") {
                $scope.actualizarEstadoUsuario(UsuarioID, 2);
                $rootScope.agregarAlerta("Cuenta de usuario desactivada");
            } else {
                $scope.actualizarEstadoUsuario(UsuarioID, 1);
                $rootScope.agregarAlerta("Cuenta de usuario Activada");
            }
        };

        $scope.actualizarRolUsuario = function (UsuarioID, rolSeleccionado) {
            var obj = {}
            obj.UsuarioID = UsuarioID;
            obj.RolID = rolSeleccionado;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarRolUsuario.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido actualizar el rol de usuario");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No se pudo actualizar el rol");
                } else {
                    log("Lista con datos - cambiando rol de usuario");
                    log(listaDatos);
                    $scope.verListaUsuarios($rootScope.idUsuarioActivo);
                    $rootScope.agregarAlerta("Rol actualizado");
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
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerUsuariosPendientes.php", {}, function () {
                $rootScope.agregarAlerta("No se ha podido consultar la lista de solicitudes de cuentas de usuarios pendientes");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
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
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarEstadoUsuario.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido actualizar el estado del usuario");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No se pudo actualizar el estado");
                } else {
                    log("Lista con datos");
                    log(listaDatos);
                    $scope.verUsuariosPendientes();
                    $rootScope.agregarAlerta("Estado de la solicitud actualizado");
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };


        $scope.verUsuariosPendientes();
    }
});

/* ADMIN DE PRÉSTAMOS DE ACTIVOS */
app.controller("adminPrestamos", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = host + "login.html";
    } else {
        log("adminPrestamos");
        $scope.objNuevoPrestamo = {
            tipoPrestamo: 0,
            descripcion: ''
        }
        $scope.cargarListaActivos = function () {
            var tipoActivo;
            if ($scope.objNuevoPrestamo.tipoPrestamo == 0) {
                tipoActivo = "VerListaReactivos";
            } else {
                tipoActivo = "VerListaCristaleria";
            }
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/" + tipoActivo + ".php", null, function () {
                $rootScope.agregarAlerta("No se pudo consultar la lista de activos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.listaActivos = listaDatos;
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        $scope.cargarlistaPrestamos = function () {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerPrestamos.php", null, function () {
                $rootScope.agregarAlerta("No se pudo consultar la lista de préstamos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.listaPrestamos = listaDatos;
                $rootScope.waiting = false;
                log($scope.listaPrestamos);
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        $scope.elegirActivo = function (a) {
            $scope.objNuevoPrestamo.nombreActivo = (a.nombreReactivo == undefined ? a.NombreArticulo : a.nombreReactivo);
            $scope.objNuevoPrestamo.ArticuloID = a.ArticuloID;
            log($scope.objNuevoPrestamo)
            $scope.panelEscogerActivo = false;
            $scope.filtroActivosPrestamos = '';
        }
        $scope.mostrarPanelEscogerActivo = function () {
            $scope.panelEscogerActivo = true;
            focus('idFiltroActivoPrest');
        }
        $scope.solicitarPrestamo = function (prestamo) {
            log(prestamo);
            prestamo.EstadoPrestamoID = 1;
            if ($scope.objNuevoPrestamo.ArticuloID == undefined) {
                $rootScope.agregarAlerta("Seleccione un activo");
            } else if ($scope.objNuevoPrestamo.FechaLimiteDevolucion == undefined) {
                $rootScope.agregarAlerta("Seleccione una fecha");
            } else if ($scope.objNuevoPrestamo.FechaLimiteDevolucion.getTime() < new Date().getTime()) {
                $rootScope.agregarAlerta("Seleccione una fecha posterior o igual a hoy");
            } else if ($scope.objNuevoPrestamo.Descripcion == undefined) {
                $rootScope.agregarAlerta("Agregue una descripción");
            } else {
                $rootScope.waiting = true;
                prestamo.UsuarioSolicitanteID = $rootScope.idUsuarioActivo;
                //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
                $rootScope.solicitudHttp(rootHost + "API/AgregarPrestamo.php", prestamo, function () {
                    $rootScope.agregarAlerta("No se ha podido solicitar el préstamo, verifique que hayan suficientes existencias del activo");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha registrado el préstamo correctamente");
                    $rootScope.waiting = false;
                    limpiarCamposPrestamo();
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            }
        };

        $scope.aprobarPrestamo = function (p) {
            obj = {
                UsuarioAutorizadorID: $rootScope.idUsuarioActivo,
                PrestamoID: p.PrestamoID,
                Comentario: ''
            };
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/AprobarPrestamo.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido aprobar el préstamo");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha aprobado el préstamo");
                $rootScope.waiting = false;
                $scope.cargarlistaPrestamos();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }
        $scope.despacharPrestamo = function (p) {
            obj = {
                UsuarioAutorizadorID: $rootScope.idUsuarioActivo,
                PrestamoID: p.PrestamoID,
                Comentario: ''
            };
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/DespacharPrestamo.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido despachar el préstamo, revise que hayan suficientes existencias en el inventario");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha despachado el préstamo");
                $rootScope.waiting = false;
                $scope.cargarlistaPrestamos();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }
        $scope.rechazarPrestamo = function (p) {
            obj = {
                UsuarioAutorizadorID: $rootScope.idUsuarioActivo,
                PrestamoID: p.PrestamoID,
                Comentario: ''
            };
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/RechazarPrestamo.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido rechazar el préstamo");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha rechazado el préstamo");
                $rootScope.waiting = false;
                $scope.cargarlistaPrestamos();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }
        $scope.devolverPrestamo = function (p) {
            obj = {
                UsuarioAutorizadorID: $rootScope.idUsuarioActivo,
                PrestamoID: p.PrestamoID,
                Comentario: '',
                CantidadDevuelta: p.CantidadSolicitada
            };
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/DevolverPrestamo.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido devolver el préstamo");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha registrado la devolución del préstamo");
                $rootScope.waiting = false;
                $scope.cargarlistaPrestamos();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }

        function limpiarCamposPrestamo() {
            $scope.objNuevoPrestamo = {
                tipoPrestamo: 0,
                descripcion: ''
            }
        }
        if (!$scope.listaActivos) {
            $scope.cargarListaActivos();
        };
        if (!$scope.listaPrestamos) { // NO hay APi aún
            $scope.cargarlistaPrestamos();
        };
    }
});

/* Alertas de Activos por debajo del punto de reorden*/
app.controller("alertas", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = host + "login.html";
    } else {
        log("alertas");
        $scope.verActivosBajos = function (obj, tipoActivo) {
            obj.UsuarioID = $rootScope.idUsuarioActivo;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/Ver" + tipoActivo + "DebajoDelMinimo.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido consultar los activos por debajo del mínimo");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.listaActivosBajos = listaDatos;
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        function cargarCategorias() {
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerCategorias.php", null, function () {
                $rootScope.agregarAlerta("No se ha podido consultar las categorías");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.categorias = listaDatos;
                $scope.categorias.forEach(function (c) {
                    c.CategoriaReactivoID = parseInt(c.CategoriaReactivoID);
                })
                $scope.categorias.unshift({
                    CategoriaReactivoID: 0,
                    Nombre: "Todas"
                });
                $scope.obj.CategoriaID = $scope.categorias[0].CategoriaReactivoID;
                $scope.verActivosBajos($scope.obj, 'Reactivos');
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        setTimeout(function () {
            if (!$scope.categorias && $scope.tipoReporte == 'reactivosBajos') {
                cargarCategorias();
            } else if ($scope.tipoReporte == 'cristaleriaBaja') {
                $scope.verActivosBajos({}, 'Cristaleria');
            }
        }, 100);

        function cargarLista(lista, tipoActivo) {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerLista" + tipoActivo + ".php", null, function () {
                $rootScope.agregarAlerta("No se ha podido consultar la lista de activos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (lista == 0) {
                    $scope.listaReactivos = listaDatos;
                    cargarListaNegra(lista);
                } else if (lista == 1) {
                    $scope.listaCristaleria = listaDatos;
                    cargarListaNegra(lista);
                }
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        function cargarListaNegra(modo) {
            obj = {
                UsuarioID: $rootScope.idUsuarioActivo
            }
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerListaNegraDeUsuario.php", obj, function () {
                $rootScope.agregarAlerta("No se ha podido consultar la lista negra de activos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.listaNegra = listaDatos;
                if (modo == 0) {
                    $scope.listaReactivos.forEach(function (reactivo) {
                        reactivo.enListaNegra = 0;
                        $scope.listaNegra.forEach(function (activoNegro) {
                            if (reactivo.ArticuloID == activoNegro.ArticuloID) {
                                reactivo.enListaNegra = 1;
                                reactivo.ListaNegraID = activoNegro.ListaNegraID;
                            }
                        });
                    });
                } else if (modo == 1) {
                    $scope.listaCristaleria.forEach(function (e) {
                        e.enListaNegra = 0
                        $scope.listaNegra.forEach(function (n) {
                            if (e.ArticuloID == n.ArticuloID) {
                                e.enListaNegra = 1;
                                e.ListaNegraID = n.ListaNegraID;
                            }
                        });
                    });
                }
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.agregarAListaNegra = function (a) {
            if (a.enListaNegra != 1) {
                obj = {
                    UsuarioID: $rootScope.idUsuarioActivo,
                    ArticuloID: a.ArticuloID
                };
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/AgregarArticuloAListaNegra.php", obj, function () {
                    $rootScope.agregarAlerta("No se ha podido agregar el artículo a la lista negra");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    a.enListaNegra = 1;
                    a.ListaNegraID = listaDatos[0].ListaNegraID;
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            }
        };
        $scope.removerDeListaNegra = function (a) {
            if (a.enListaNegra != 0) {
                obj = {
                    ListaNegraID: a.ListaNegraID
                };
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/EliminarArticuloListaNegra.php", obj, function () {
                    $rootScope.agregarAlerta("No se ha podido retirar el artículo de la lista negra");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    a.enListaNegra = 0;
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            }
        };

        $scope.cargarLista = function (modo) {
            setTimeout(function () {
                if (!$scope.listaReactivos && $scope.tipoLista == 'reactivos') {
                    $scope.listaReactivos = [];
                    cargarLista(0, 'Reactivos');
                };
                if (!$scope.listaCristaleria && $scope.tipoLista == 'cristaleria') {
                    $scope.listaCristaleria = [];
                    cargarLista(1, 'Cristaleria');
                };
                if (modo == 1 && $scope.tipoLista == 'reactivos') {
                    cargarLista(0, 'Reactivos');
                }
                if (modo == 1 && $scope.tipoLista == 'cristaleria') {
                    cargarLista(1, 'Cristaleria');
                }
            }, 100);
        }
        $scope.cargarLista();
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
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/VerMovimientosReactivos.php", objReporteParam, function () {
                    $rootScope.agregarAlerta("No se ha podido cargar los movimientos de reactivos");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    $scope.listaMovimientosReactivos = listaDatos;
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            } else if ($scope.tipoReporte == 'movCrist') {
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/VerMovimientosCristaleria.php", objReporteParam, function () {
                    $rootScope.agregarAlerta("No se ha podido cargar los movimientos de cristalería");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    $scope.listaMovimientosCristaleria = listaDatos;
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            } else if ($scope.tipoReporte == 'movPrecursores') {
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/VerMovimientosPrecursores.php", objReporteParam, function () {
                    $rootScope.agregarAlerta("Consulta fallida al cargar movimientos");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    $scope.listaMovimientosPrecursores = listaDatos;
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            }

        }
        /*FIN REPORTE CRACK*/
        function cargarCategorias() {
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerCategorias.php", null, function () {
                $rootScope.agregarAlerta("No se ha podido cargar las categorías de reactivos");
                $rootScope.waiting = false;
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
                $scope.buscarReporte($scope.opciones[5], $scope.tipoReporte); // carga todos los registros por defecto
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.cargarlistaPrestamos = function () {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerPrestamos.php", null, function () {
                $rootScope.agregarAlerta("No se pudo consultar la lista de préstamos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.listaPrestamos = listaDatos;
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        $scope.cargarlistaPrestamos();
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
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerListaCristaleria.php", null, function () {
                $rootScope.agregarAlerta("No se ha podido cargar la lista de cristalería");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.listaCristaleria = listaDatos;
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        $scope.agregarCristaleria = function () {
            $scope.objCristaleria.UsuarioID = $rootScope.idUsuarioActivo;
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $scope.popupCrearCristaleria = false;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/AgregarCristaleria.php", $scope.objCristaleria, function () {
                $rootScope.agregarAlerta("No se ha podido ingresar el activo de cristalería");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha agregado el activo de cristalería");
                $rootScope.waiting = false;
                cargarListaCristaleria();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.preEditarCristaleria = function (c) {
            $scope.cristaleriaEditar.ArticuloID = c.ArticuloID;
            $scope.cristaleriaEditar.Nombre = c.NombreArticulo;
            $scope.cristaleriaEditar.Ubicacion = c.Ubicacion;
            $scope.cristaleriaEditar.PuntoReorden = parseFloat(c.PuntoReorden);
            $scope.cristaleriaEditar.Descripcion = c.Descripcion;
            $scope.popupEditarCristaleria = true;
        }

        $scope.editarCristaleria = function () {
            $scope.popupEditarCristaleria = false;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarCristaleria.php", $scope.cristaleriaEditar, function () {
                $rootScope.agregarAlerta("No se ha podido actualizar el activo de cristalería");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha modificado el activo de cristalería");
                cargarListaCristaleria();
                $rootScope.waiting = false;
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
            $rootScope.waiting = true;
            $scope.panelPregunta = false;
            $rootScope.solicitudHttp(rootHost + "API/EliminarCristaleria.php", $scope.cristaleriaABorrar, function () {
                $rootScope.agregarAlerta("No se ha podido borrar el activo de cristalería");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha eliminado el activo de cristalería");
                cargarListaCristaleria();
                $rootScope.waiting = false;
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
        $scope.filtroPrecursores = false;

        $scope.filtrarPrecursores = function () {
            if ($scope.filtroPrecursores) {
                $scope.filtroPrecursores = false;
                $scope.selectClass = '';
            } else {
                $scope.filtroPrecursores = true;
                $scope.selectClass = 'selectClass';
            }
        };

        $scope.filtrarSegunPrecursor = function (r) {
            if (r.EsPrecursor == 0 & $scope.filtroPrecursores) {
                return true;
            }
            return false;
        };

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
            $scope.popupEditarReactivo = false;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/ActualizarReactivo.php", objEnviar, function () {
                $rootScope.agregarAlerta("No se ha podido actualizar el reactivo");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha modificado el reactivo");
                $rootScope.waiting = false;
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
            $scope.panelPregunta = false;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/EliminarReactivo.php", $scope.reactivoABorrar, function () {
                $rootScope.agregarAlerta("No se ha podido borrar el reactivo");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha eliminado el reactivo");
                cargarListaReactivos();
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }
        $scope.agregarReactivo = function () {
            if ($scope.objReactivo.EsPrecursor == false) {
                $scope.objReactivo.EsPrecursor = 0;
            };
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $scope.popupCrearReactivo = false;
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/AgregarReactivo.php", $scope.objReactivo, function () {
                $rootScope.agregarAlerta("No se ha podido ingresar el reactivo");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha agregado el reactivo");
                $rootScope.waiting = false;
                cargarListaReactivos();
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };


        $scope.editarUnidad = function (u) {
            if (u.Nombre != "" && u.Siglas != "") {
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/ActualizarUnidad.php", u, function () {
                    $rootScope.agregarAlerta("No se ha podido modificar la unidad");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha modificado la unidad");
                    cargarUnidades();
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            } else {
                $rootScope.agregarAlerta("No deben haber parámetros vacíos");
            }
        }

        $scope.agregarUnidad = function (u) {
            if (u.Nombre != "" && u.Siglas != "") {
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/AgregarUnidadMetrica.php", u, function () {
                    $rootScope.agregarAlerta("La unidad no puede tener valores idénticos a otras unidades");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha agregado la unidad");
                    u.Nombre = "";
                    u.Siglas = "";
                    cargarUnidades();
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            } else {
                $rootScope.agregarAlerta("No deben haber parámetros vacíos");
            }
        }
        $scope.agregarCategoria = function (c) {

            if (c.Nombre != "") {
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/agregarCategoria.php", c, function () {
                    $rootScope.waiting = false;
                    $rootScope.agregarAlerta("La categoría no puede tener valores idénticos a otras unidades");
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha agregado la categoría");
                    c.Nombre = "";
                    cargarCategorias();
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            } else {
                $rootScope.agregarAlerta("No deben haber parámetros vacíos");
            }
        }
        $scope.borrarUnidad = function (u) {
            var obj = {
                UnidadMetricaID: u.UnidadMetricaID
            }
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/borrarUnidadMetrica.php", obj, function () {
                $rootScope.agregarAlerta("No se puede borrar la unidad ya que está siendo utilizada");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha borrado la unidad");
                cargarUnidades();
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }

        $scope.borrarCategoria = function (c) {
            var obj = {
                CategoriaReactivoID: c.CategoriaReactivoID
            }
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/borrarCategoria.php", obj, function () {
                $rootScope.agregarAlerta("No se puede borrar la categoría ya que está siendo utilizada");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha borrado la categoría");
                cargarCategorias();
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        }

        $scope.editarCategoria = function (c) {
            if (c.Nombre != "") {
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/ActualizarCategoria.php", c, function () {
                    $rootScope.agregarAlerta("No se ha podido modificar la categoría");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha modificado la categoría");
                    cargarCategorias();
                    $rootScope.waiting = false;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            } else {
                $rootScope.agregarAlerta("No deben haber parámetros vacíos");
            }
        }

        function cargarListaReactivos() {
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerListaReactivos.php", null, function () {
                $rootScope.agregarAlerta("No se ha podido cargar la lista de reactivos");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.listaReactivos = listaDatos;
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        function cargarUnidades() {
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerUnidadesMetricas.php", null, function () {
                $rootScope.agregarAlerta("No se ha podido cargar las unidades métricas");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.unidades = listaDatos;
                $scope.unidades.forEach(function (u) {
                    u.UnidadMetricaID = parseInt(u.UnidadMetricaID);
                })
                $scope.preUnidades = listaDatos;
                $rootScope.waiting = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        function cargarCategorias() {
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerCategorias.php", null, function () {
                $rootScope.agregarAlerta("No se ha podido cargar las categorías");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $scope.categorias = listaDatos;
                $scope.categorias.forEach(function (c) {
                    c.CategoriaReactivoID = parseInt(c.CategoriaReactivoID);
                })
                $scope.preCategorias = listaDatos;
                $rootScope.waiting = false;
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

/*CHAT*/
app.controller("chat", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = host + "login.html";
    } else {
        log("CHAT")
        $scope.listaContactos = [];
        $scope.verListaUsuarios = function () {
            var obj = {
                UsuarioID: $rootScope.idUsuarioActivo
            }
            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerListaUsuarios.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida (Sin lista de usuarios)");
                $rootScope.waiting = false;
            }, function (listaDatos) {
                $rootScope.waiting = false;
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No hay usuarios en el sistema");
                } else {
                    log("Lista de usuarios consultada con éxito");
                    $rootScope.agregarAlerta("Lista de usuarios consultada con éxito");
                    $scope.listaContactos = listaDatos;
                    $scope.idUsuarioChatSeleccionado = listaDatos[0].UsuarioID;
                    $scope.nombreUsuarioChatSeleccionado = listaDatos[0].Nombre;
                    $scope.verListaMensajes();
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        $scope.verListaMensajes = function () {
            var obj = {};
            obj.UsuarioAID = $rootScope.idUsuarioActivo;
            obj.UsuarioBID = $scope.idUsuarioChatSeleccionado;
//            $rootScope.waiting = true;
            $rootScope.solicitudHttp(rootHost + "API/VerChat.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida (Sin lista de mensajes)");
//                $rootScope.waiting = false;
            }, function (listaDatos) {
                log(listaDatos);
                $scope.listaMensajes = listaDatos;
                focus('txtMensaje');
                setTimeout($scope.verListaMensajes,2000);
//                $rootScope.waiting = false;

            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        $scope.enviarMensaje = function () {
            var obj = {
                UsuarioReceptorID: $scope.idUsuarioChatSeleccionado,
                UsuarioEmisorID: $rootScope.idUsuarioActivo,
                Mensaje: $scope.mensajeEnviar
            }
            if (obj.Mensaje != undefined && obj.Mensaje != '') {
                $rootScope.waiting = true;
                $rootScope.solicitudHttp(rootHost + "API/AgregarMensajeChat.php", obj, function () {
                    $rootScope.agregarAlerta("Respuesta desconocida (No se agregó el mensaje)");
                    $rootScope.waiting = false;
                }, function (listaDatos) {
                    log(listaDatos);
                    $rootScope.waiting = false;
                    $scope.mensajeEnviar = '';
                    $scope.verListaMensajes();
                }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            } else {
                $rootScope.agregarAlerta("Escriba un mensaje");
            }
        };
        $scope.seleccionarUsuarioChat = function (u) {
            $scope.idUsuarioChatSeleccionado = u.UsuarioID;
            $scope.nombreUsuarioChatSeleccionado = u.Nombre;
            $scope.verListaMensajes();
        }
        $scope.verListaUsuarios();
        $scope.getChatClass = function (m) {
            if (m.UsuarioEmisorID == $rootScope.idUsuarioActivo) {
                return 'aDer';
            } else {
                return 'aIzq bgOpaco';
            }
        }
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

    function actualizarFechaHora() {
        $rootScope.fechaHora = $filter('date')(new Date(), "dd/MM/yyyy hh:mm:ss a", "-0600");
    }
    $rootScope.waiting = false;
    $interval(actualizarFechaHora, 1000);
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
