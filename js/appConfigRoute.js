// control del archivo html que se carga en el ngview de la página dependiendo del path en la url
app.config(function ($routeProvider) {
    $routeProvider.when("/adminInventarioReactivos", {
        templateUrl: "includes/adminInventarioReactivos.html",
        controller: "adminInventarioReactivos"
    }).when("/adminInventarioCristaleria", {
        templateUrl: "includes/adminInventarioCristaleria.html",
        controller: "adminInventarioCristaleria"
    }).when("/adminUsuarios",{
        templateUrl: "includes/adminUsuarios.html",
        controller: "adminUsuarios"
    }).when("/reporteMovReactivos",{
        templateUrl: "includes/reporteMovReactivos.html",
        controller: "reportes"
    }).when("/reporteMovCristaleria",{
        templateUrl: "includes/reporteMovCristaleria.html",
        controller: "reportes"
    }).when("/alertaReactBajos",{
        templateUrl: "includes/alertaReactBajos.html",
        controller: "alertas"
    }).when("/alertaCristBaja",{
        templateUrl: "includes/alertaCristBaja.html",
        controller: "alertas"
    }).when("/reportePrestamos",{
        templateUrl: "includes/reportePrestamos.html",
        controller: "reportes"
    }).when("/adminSolicitudes",{
        templateUrl: "includes/adminSolicitudes.html",
        controller: "adminSolicitudes"
    }).when("/nuevoPrestamo",{
        templateUrl: "includes/solicitudPrestamo.html",
        controller: "adminPrestamos"
    }).when("/adminSoliPrestamos",{
        templateUrl: "includes/adminSoliPrestamos.html",
        controller: "adminPrestamos"
    }).when("/login",{
        templateUrl: "login.html"
    }).otherwise({
        redirectTo: "/adminInventarioReactivos"
    });
});
