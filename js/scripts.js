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

//hostSieq
/*
host = "";
rootHost = "/"
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
        $scope.listaArticulos= [];
        $scope.listaActivos = [];
        $scope.popupAgregarArticulo = false;
        $scope.activoSeleccionado = {};
        $scope.activoXAgregar = {};

        $scope.pedidoID = urlParams.PedidoID;
        $scope.tituloPedido = urlParams.Titulo;
        $scope.descripcionPedido = urlParams.Descripcion;

        $scope.cargarArticulosPedido = function(){
            var obj = {'PedidoID': $scope.pedidoID};
            log("Cargando Articulos del pedido");
            log(obj);

            $rootScope.solicitudHttp(rootHost + "API/VerArticulosDelPedido.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida, se esperaba una lista de articulos");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Pedido sin artículos");
                } else {
                    log("Artículos consultados con éxito");
                    $scope.listaArticulos = listaDatos;
                    $rootScope.agregarAlerta("Artículos consultados con éxito");
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

        };

        $scope.cargarActivos = function(){

            $rootScope.solicitudHttp(rootHost + "API/VerListaArticulos.php", {}, function () {
                $rootScope.agregarAlerta("Respuesta desconocida, se esperaba una lista de activos");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No existen Activos");
                } else {
                    log("Activos consultados con éxito");
                    $scope.listaActivos = listaDatos;
                    $rootScope.agregarAlerta("Activos consultados con éxito");
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

        };


        $scope.mostrarPanelAgregarArticulo = function(){
            $scope.cargarActivos();

            $scope.activoSeleccionado = {};
            $scope.activoXAgregar = {};
            $scope.popupAgregarArticulo = true;
        };

        $scope.seleccionarActivo = function(activo){
            $scope.activoSeleccionado = activo;
            $scope.activoXAgregar = {
                "PedidoID": $scope.pedidoID,
                "ArticuloID": activo.ArticuloID,
            };

        };

        $scope.agregarArticuloPedido = function(obj){
            log(obj);
            log($scope.activoXAgregar);

            if($scope.activoXAgregar.ArticuloID == undefined){
                $rootScope.agregarAlerta("Seleccione un artículo");
            }else{
                obj.PedidoID = $scope.activoXAgregar.PedidoID;
                obj.ArticuloID = $scope.activoXAgregar.ArticuloID;

                log("Agregando artículo");
                log(obj);

                $rootScope.solicitudHttp(rootHost + "API/AgregarArticuloAPedido.php", obj, function () {
                    $rootScope.agregarAlerta("Respuesta desconocida");
                }, function (listaDatos) {
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
                ArticuloPedidoID : articulo.ArticuloPedidoID
            }
        };

        $scope.borrarArticulo = function () {
            $rootScope.solicitudHttp(rootHost + "API/EliminarArticuloDelPedido.php", $scope.articuloABorrar, function () {
                $rootScope.agregarAlerta("No se ha podido borrar el artículo");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha eliminado el artículo");
                $scope.cargarArticulosPedido();
                $scope.panelPregunta = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.verArticulo = function(articulo){
            var obj = {
                "ArticuloPedidoID": articulo.ArticuloPedidoID
            };
            log(obj);

            $rootScope.solicitudHttp(rootHost + "API/VerArticuloDelPedido.php", obj , function () {
                $rootScope.agregarAlerta("No se ha podido consultar el artículo");
            }, function (listaDatos) {
                log("Artículo consultado con éxito");
                $scope.articuloVisualizado = listaDatos[0];

            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");

            $scope.popupVerArticulo = true;
        };

        $scope.preActualizarArticulo = function(articulo){
            log("Actualizando Articulo");
            $scope.articuloXActualizar = articulo;
            log($scope.articuloXActualizar);
            $scope.popupActualizarArticulo = true;
        };

        $scope.actualizarArticulo = function(articuloActualizado){
            log(articuloActualizado);

            $rootScope.solicitudHttp(rootHost + "API/ActualizarArticuloDelPedido.php", articuloActualizado, function () {
                    $rootScope.agregarAlerta("Respuesta desconocida");
                }, function (listaDatos) {
                    if (listaDatos.length == 0) {
                        $rootScope.agregarAlerta("Lista vacía");
                    } else {
                        $rootScope.agregarAlerta("Artículo actualizado con éxito");

                        $scope.cargarArticulosPedido();
                        $scope.popupActualizarArticulo = false;

                    }
                }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        if($scope.listaArticulos.length == 0){
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

        $scope.cargarListaPedidos = function(){

            $rootScope.solicitudHttp(rootHost + "API/VerPedidos.php", {}, function () {
                $rootScope.agregarAlerta("Respuesta desconocida, se esperaba una lista de pedidos");
            }, function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("No se encontraron pedidos");
                } else {
                    log("Pedidos consultados con éxito");
                    $scope.listaPedidos = listaDatos;
                    $rootScope.agregarAlerta("Pedidos consultados con éxito");
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.agregarPedido = function(obj){
            obj.UsuarioID = $rootScope.idUsuarioActivo;

            log("Agregando pedido");
            log(obj);

            $rootScope.solicitudHttp(rootHost + "API/AgregarPedido.php", obj, function () {
                $rootScope.agregarAlerta("Respuesta desconocida");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Pedido Creado y listo para editarse");
                $scope.cargarListaPedidos();
                $scope.popupCrearPedido = false;
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
            $rootScope.solicitudHttp(rootHost + "API/EliminarPedido.php", $scope.pedidoABorrar, function () {
                $rootScope.agregarAlerta("No se ha podido borrar el pedido");
            }, function (listaDatos) {
                $rootScope.agregarAlerta("Se ha eliminado el pedido");
                $scope.cargarListaPedidos();
                $scope.panelPregunta = false;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.mostrarPanelCrearPedido = function(){
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
            $rootScope.solicitudHttp(rootHost + "API/" + tipoActivo + ".php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                $scope.listaActivos = listaDatos;
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };
        $scope.cargarlistaPrestamos = function () {
            $rootScope.solicitudHttp(rootHost + "API/VerPrestamos.php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                $scope.listaPrestamos = listaDatos;
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
            prestamo.EstadoPrestamoID = 1;
            if ($scope.objNuevoPrestamo.ArticuloID == undefined) {
                $rootScope.agregarAlerta("Seleccione un activo");
            } else if ($scope.objNuevoPrestamo.FechaLimiteDevolucion == undefined) {
                $rootScope.agregarAlerta("Seleccione una fecha");
            } else {
                prestamo.UsuarioSolicitanteID = $rootScope.idUsuarioActivo;
                //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
                $rootScope.solicitudHttp(rootHost + "API/AgregarPrestamo.php", prestamo, function () {
                    $rootScope.agregarAlerta("No se ha podido ingresar el activo de cristalería");
                }, function (listaDatos) {
                    $rootScope.agregarAlerta("Se ha registrado el préstamo correctamente");
                    limpiarCamposPrestamo();
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            }
        };

        $scope.aprobarPrestamo

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
            log(obj);
            $rootScope.solicitudHttp(rootHost + "API/Ver" + tipoActivo + "DebajoDelMinimo.php", obj, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                $scope.listaActivosBajos = listaDatos;
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
                $scope.categorias.unshift({
                    CategoriaReactivoID: 0,
                    Nombre: "Todas"
                });
                $scope.obj.CategoriaID = $scope.categorias[0].CategoriaReactivoID;
                $scope.verActivosBajos($scope.obj, 'Reactivos');
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
            $rootScope.solicitudHttp(rootHost + "API/VerLista" + tipoActivo + ".php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
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
            $rootScope.solicitudHttp(rootHost + "API/VerListaNegraDeUsuario.php", obj, function () {
                $rootScope.agregarAlerta("Error Desconocido");
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
            }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

        $scope.agregarAListaNegra = function (a) {
            if (a.enListaNegra != 1) {
                obj = {
                    UsuarioID: $rootScope.idUsuarioActivo,
                    ArticuloID: a.ArticuloID
                };
                $rootScope.solicitudHttp(rootHost + "API/AgregarArticuloAListaNegra.php", obj, function () {
                    $rootScope.agregarAlerta("Error Desconocido");
                }, function (listaDatos) {
                    a.enListaNegra = 1;
                    a.ListaNegraID = listaDatos[0].ListaNegraID;
                }, "Ha ocurrido un error", false, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
            }
        };
        $scope.removerDeListaNegra = function (a) {
            if (a.enListaNegra != 0) {
                obj = {
                    ListaNegraID: a.ListaNegraID
                };
                $rootScope.solicitudHttp(rootHost + "API/EliminarArticuloListaNegra.php", obj, function () {
                    $rootScope.agregarAlerta("Error Desconocido");
                }, function (listaDatos) {
                    a.enListaNegra = 0;
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
                $scope.buscarReporte($scope.opciones[5], $scope.tipoReporte); // carga todos los registros por defecto
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

    function actualizarFechaHora() {
        $rootScope.fechaHora = $filter('date')(new Date(), "dd/MM/yyyy hh:mm:ss a", "-0600");
    }
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
