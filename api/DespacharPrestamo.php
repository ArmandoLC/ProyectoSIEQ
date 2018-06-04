<?php
// Tell PHP that we're using UTF-8 strings until the end of the script
mb_internal_encoding('UTF-8');
// Tell PHP that we'll be outputting UTF-8 to the browser
mb_http_output('UTF-8');
if(!@include("funciones/funciones.php")){
    die("Error fatal!!");
}

$conexion = mysqli_connect($host, $user, $pw, $db);

$obj = cargarObjPost();

$UsuarioAutorizadorID = $obj["UsuarioAutorizadorID"];
$PrestamoID = $obj["PrestamoID"];
$Comentario = $obj["Comentario"];



// $UsuarioAutorizadorID = 12;
// $PrestamoID = 5;
// $Comentario = 'Probando Prestamo';
// $CantidadDevuelta = 40;

if($conexion){
    $consulta = "CALL DespacharPrestamo(
					".mysqli_real_escape_string($conexion, $UsuarioAutorizadorID).",
					".mysqli_real_escape_string($conexion, $PrestamoID).",
					'".mysqli_real_escape_string($conexion, $Comentario)."')";
    
    $resultado = consultar($consulta,$conexion);
    if(is_bool($resultado)===false){
        echo getJsonSalida("OK", "listaDatos",$resultado);
    }
    else if($resultado){
        echo getJsonSalidaSimple("OK");
    }
    else{
         echo getJsonSalidaSimple("ERROR BD");
    }
}
else{
    echo getJsonSalidaSimple("ERROR de conexion");
}
?>