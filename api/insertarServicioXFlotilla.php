<?php

// Tell PHP that we're using UTF-8 strings until the end of the script
mb_internal_encoding('UTF-8');

// Tell PHP that we'll be outputting UTF-8 to the browser
mb_http_output('UTF-8');

if(!@include("includes/funciones.php")){
    die("Error fatal!!");
}
$conexion = mysqli_connect($host, $user, $pw, $db);

$obj = cargarObjPost();
$pFk_IdFlotilla = $obj["pFk_IdFlotilla"];
$pFk_ServicioFlotilla = $obj["pFk_ServicioFlotilla"];
//$pFk_IdFlotilla = 3;
//$pFk_ServicioFlotilla = 2;

if($conexion){
    $consulta = "call insertarServicioXFlotilla(".mysqli_real_escape_string($conexion,$pFk_IdFlotilla).",".mysqli_real_escape_string($conexion,$pFk_ServicioFlotilla).")";
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
