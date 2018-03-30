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
// host
//host = "http://localhost/ProyectoWeb/";
rootHost = "https://sieq.000webhostapp.com/"

/* LOGIN CONTROLLER */
app.controller("login", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = rootHost + "login.html";
    } else {
        log("login");

        $scope.ingresar = function (obj) {
            $rootScope.solicitudHttp(rootHost + "API/VerificarLogin.php", obj, "Los datos de inicio de sesión son incorrectos", function (listaDatos) {
                if (listaDatos.length == 0) {
                    $rootScope.agregarAlerta("Los datos de inicio de sesión son incorrectos");
                } else {
                    var usuario = listaDatos[0];
                    // guardar la sesion en una cookie
                    var sesion = {};
                    sesion.userUsuarioActivo = usuario.nombreUsuario;
                    $log.log(sesion);
                    var tiempo = new Date();
                    tiempo.setHours(tiempo.getHours() + 12); // guardamos la sesion por 12 horas
                    $cookies.putObject("fdsfsdfgsfg5vbv", sesion, {
                        expires: tiempo
                    });
                    //window.location.pathname = rootHost + "/includes/adminSitios.html";
                }
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

    }
});

/* REGISTRARSE CONTROLLER */
app.controller("registrarse", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        //window.location.pathname = rootHost + "login.html";
    } else {
        log("registrarse");
        $scope.roles = [{
                nombre: "Administrador",
                id: 1
            },
            {
                nombre: "Coordinador",
                id: 2
            }]

        $scope.registrarse = function (obj) {
            $rootScope.solicitudHttp(rootHost + "API/AgregarUsuario.php", obj, function () {
                $rootScope.agregarAlerta("Nombre de usuario no disponible");
            }, function (listaDatos) {
                log(listaDatos);
                $rootScope.agregarAlerta("Usuario miedo agregado");
                log("LISTO Solicitud registrada");

                //window.location.pathname = "login.html";
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");
        };

    }
});

/* ADMINSITIOS CONTROLLER */
app.controller("adminSitios", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = rootHost + "login.html";
    } else {
        log("adminSitios");
        $scope.editarReactivo = function (r) {
            $scope.reactivoEditar = JSON.clone(r);
            $scope.popupEditarReactivo = true;
        }
        $scope.mostrarPanelUnidades = function () {
            $scope.panelUnidades = true;
            //solicitudHttp(url, objEnviar, casoSoloOK, casoOKconLista, casoFallo, forzarDebug, casoCatch)
            $rootScope.solicitudHttp(rootHost + "API/getUnidades.php", null, function () {
                $rootScope.agregarAlerta("Error Desconocido");
            }, function (listaDatos) {
                log(listaDatos);
                $scope.unidades = listaDatos;
            }, "Ha ocurrido un error", true, "Error de comunicación con el servidor, por favor intente de nuevo en un momento");


        }
        /*Variables globales del Scope*/
        $scope.panelUnidades = false;
    }
});
/* ADMINFLOTILLAS CONTROLLER */
app.controller("adminFlotillas", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = rootHost + "login.html";
    } else {
        log("adminFlotillas");
        /*
            Codigo aquí
        */
    }
});
/* ADMINGIRAS CONTROLLER */
app.controller("adminGiras", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = rootHost + "login.html";
    } else {
        log("adminGiras");
        /*
            Codigo aquí
        */
    }
});
/* ADMINRESERVACIONES CONTROLLER */
app.controller("adminReservaciones", function ($scope, $rootScope, $location, $http, $cookies, $interval, $filter, $log) {
    if (!$rootScope.sesionActiva()) { // verificamos si una sesion ya fue iniciada
        window.location.pathname = rootHost + "login.html";
    } else {
        log("adminReservaciones");
        /*
            Codigo aquí
        */

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
            log("Alerta eliminada");
        }
        alerta.ocultarAlerta = function () {
            alerta.classAlert = "ocultarAlert";
            setTimeout(alerta.eliminarAlerta, 1100);
            log("Alerta ocultada");
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
    //    $rootScope.userUsuarioActivo = "";
    $rootScope.userUsuarioActivo = "Administrador";
    //$rootScope.sesionIniciada = false;
    $rootScope.sesionIniciada = true;
    // PARA CONTROLAR LA SESION
    $rootScope.sesionActiva = function () {
        if ($rootScope.sesionIniciada) {
            return true;
        } else if ($cookies.getObject("fdsfsdfgsfg5vbv")) {
            // carga las variables necesarias para garantizar el correcto funcionamiento de la aplicacioegn
            var sesion = $cookies.getObject("fdsfsdfgsfg5vbv");
            $rootScope.userUsuarioActivo = sesion.userUsuarioActivo;
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
        $rootScope.userUsuarioActivo = "";
        $rootScope.sesionIniciada = false;
        $location.path("login");
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
                log(respuesta);
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
