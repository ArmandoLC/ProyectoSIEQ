// control del archivo html que se carga en el ngview de la página dependiendo del path en la url
app.config(function ($routeProvider) {
    $routeProvider.when("/adminInventarioReactivos", {
        templateUrl: "includes/adminInventarioReactivos.html",
        controller: "adminInventarioReactivos"
    }).when("/adminInventarioCristaleria", {
        templateUrl: "includes/adminInventarioCristaleria.html",
        controller: "adminInventarioCristaleria"
    }).when("/adminFlotillas", {
        templateUrl: "includes/adminFlotillas.html",
        controller: "adminFlotillas"
    }).when("/adminGiras", {
        templateUrl: "includes/adminGiras.html",
        controller: "adminGiras"
    }).when("/adminReservaciones", {
        templateUrl: "includes/adminReservaciones.html",
        controller: "adminReservaciones"
    }).when("/adminUsuarios",{
        templateUrl: "includes/adminUsuarios.html",
        controller: "adminUsuarios"
    }).when("/adminSolicitudes",{
        templateUrl: "includes/adminSolicitudes.html",
        controller: "adminSolicitudes"
    }).when("/login",{
        templateUrl: "login.html"
    }).otherwise({
        redirectTo: "/adminInventarioReactivos"
    });
});
