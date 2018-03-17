<?php

// Tell PHP that we're using UTF-8 strings until the end of the script
mb_internal_encoding('UTF-8');

// Tell PHP that we'll be outputting UTF-8 to the browser
mb_http_output('UTF-8');

if(!@include("includes/funciones.php")){
    die("Error fatal!!");
}

$obj = cargarObjPost();
$pIdFlotilla = $obj["pIdFlotilla"];
$pPlaca = $obj["pPlaca"];
$pCapacidad = $obj["pCapacidad"];
$pEstado = $obj["pEstado"];
//$pIdFlotilla = 2;
//$pPlaca = "pPlaca";
//$pEstado = 1;

$conexion = mysqli_connect($host, $user, $pw, $db);

if($conexion){
    $consulta = "call modificarFlotilla(".mysqli_real_escape_string($conexion,$pIdFlotilla).",'".mysqli_real_escape_string($conexion,$pPlaca)."',".mysqli_real_escape_string($conexion,$pCapacidad).",".mysqli_real_escape_string($conexion,$pEstado).")";
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
