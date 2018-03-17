var app = angular.module('app', ['ngCookies']);
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
}
// host
host = "http://192.168.100.10/ProyectoWeb/";
rootHost = "/ProyectoWeb/"


app.directive('fileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;

            element.bind('change', function () {
                scope.$apply(function () {
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
}]);
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
        }
        alerta.ocultarAlerta = function () {
            alerta.classAlert = "ocultarAlert";
            setTimeout(alerta.eliminarAlerta, 1100);
        }
        setTimeout(alerta.ocultarAlerta, 5000);
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
    $rootScope.userUsuarioActivo = "";
    $rootScope.sesionIniciada = false;
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
        // solicitud postfal

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
    }
    $rootScope.formatearFecha = function (fecha) {
        return $filter('date')(new Date(fecha), "dd/MM/yyyy hh:mm:ss a", "-0600")
    }

    /* ************************************************************ */

    $scope.enviarComprobanteDeposito = function (objEnviar,pimgDep) {
        var fd = new FormData();
        fd.append("obj", JSON.stringify(objEnviar));
        fd.append("pimgDep", pimgDep);
        var config = {
            headers: {
                transformRequest: angular.identity,
                'Content-Type': undefined
            }
        }
        $http.post(host+"api/adjuntarDepositoRes.php", fd, config).then(function (respuesta) {
            log("respuesta");
            log(respuesta);
            if (respuesta.data.message === "OK") {
                $scope.agregarAlerta("La imagen se ha enviado correctamente");
            } else {
                 $scope.agregarAlerta("Ha ocurrido un error al enviar la image, intente de nuevo");
            }
        }).catch(function (respuesta) {
            $rootScope.agregarAlerta("Ha ocurrido un error");
        });
    }
     $scope.enviarComprobanteFinal = function (objEnviar,pimgPagoFin) {
        var fd = new FormData();
        fd.append("obj", JSON.stringify(objEnviar));
        fd.append("pimgPagoFin", pimgPagoFin);
        var config = {
            headers: {
                transformRequest: angular.identity,
                'Content-Type': undefined
            }
        }
        $http.post(host+"api/adjuntarPagoFinalRes.php", fd, config).then(function (respuesta) {
            log("respuesta");
            log(respuesta);
            if (respuesta.data.message === "OK") {
                $scope.agregarAlerta("La imagen se ha enviado correctamente");
            } else {
                 $scope.agregarAlerta("Ha ocurrido un error al enviar la image, intente de nuevo");
            }
        }).catch(function (respuesta) {
            $rootScope.agregarAlerta("Ha ocurrido un error");
        });
    }
    $scope.consultarReservacion = function (obj) {
        $scope.solicitudHttp(host + "api/consultarReservacion.php", obj, "", function (data) {
            if (data[0]) {
                log(data[0]);
                $scope.objConsultaRes = data[0];
                $scope.objConsultaRes.pIdReservacion = obj.pIdReservacion
            } else {
                $scope.objConsultaRes = null;
                $rootScope.agregarAlerta("La reservación con el ID " + obj.pIdReservacion +" no existe");
            }
        });
    };
    $scope.cancelarReservacion = function (obj) {
        $scope.solicitudHttp(host + "api/cancelarReservacion.php", obj, "", function (data) {
            $scope.agregarAlerta("Se ha cancelado la reservación con el ID " + obj.pIdReservacion);
            $scope.consultarReservacion(obj);
        });
    }
    $scope.popupMisReservaciones = true;
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
