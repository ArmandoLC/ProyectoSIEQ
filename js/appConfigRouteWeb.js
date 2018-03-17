// control del archivo html que se carga en el ngview de la página dependiendo del path en la url
app.config(function ($routeProvider) {
    $routeProvider.when("/", {
        templateUrl: "includes/sitios.html",
        controller: "mainC"
    }).when("/adminFlotillas", {
        templateUrl: "includes/adminFlotillas.html",
        controller: "adminFlotillas"
    }).when("/adminGiras", {
        templateUrl: "includes/adminGiras.html",
        controller: "adminGiras"
    }).when("/adminReservaciones", {
        templateUrl: "includes/adminReservaciones.html",
        controller: "adminReservaciones"
    }).otherwise({
        redirectTo: "/"
    });
});
