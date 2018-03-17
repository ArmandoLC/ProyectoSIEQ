<?php

// Tell PHP that we're using UTF-8 strings until the end of the script
mb_internal_encoding('UTF-8');

// Tell PHP that we'll be outputting UTF-8 to the browser
mb_http_output('UTF-8');

if(!@include("includes/funciones.php")){
    die("Error fatal!!");
}

$obj = cargarObjPost();
$idPage = $obj["id"];
$url = $obj["url"];
$img = $obj["img"];
$name = $obj["name"];
$description = $obj["description"];

$conexion = mysqli_connect($host, $user, $pw, $db);

if($conexion){
    $consulta = "call actualizarPagina(".mysqli_real_escape_string($conexion,$idPage).",'".mysqli_real_escape_string($conexion,$url)."','".mysqli_real_escape_string($conexion,$img)."','".mysqli_real_escape_string($conexion,$name)."','".mysqli_real_escape_string($conexion,$description)."')";
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
