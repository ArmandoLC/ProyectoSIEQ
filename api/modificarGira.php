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
$pFk_IdGira = $obj["pFk_IdGira"];
$pLugarSalida = $obj["pLugarSalida"];
$pLugarDestino = $obj["pLugarDestino"];
$pFechaPartida = $obj["pFechaPartida"];
$pLimitePersonas = $obj["pLimitePersonas"];
$pPrecioAdulto = $obj["pPrecioAdulto"];
$pPrecioNino = $obj["pPrecioNino"];
$pPrecioAdultoMayor = $obj["pPrecioAdultoMayor"];
$pFechaLimDepo = $obj["pFechaLimDepo"];
$pFechaLimPago = $obj["pFechaLimPago"];
$pFk_SitioTuristico = $obj["pFk_SitioTuristico"];
$pFk_Chofer = $obj["pFk_Chofer"];
$pFk_Guia = $obj["pFk_Guia"];

if($conexion){
    $consulta = "call modificarGira(".mysqli_real_escape_string($conexion,$pFk_IdGira).",
    '".mysqli_real_escape_string($conexion,$pLugarSalida)."',
    '".mysqli_real_escape_string($conexion,$pLugarDestino)."',
    '".mysqli_real_escape_string($conexion,$pFechaPartida)."',
    ".mysqli_real_escape_string($conexion,$pLimitePersonas).",
    ".mysqli_real_escape_string($conexion,$pPrecioAdulto).",
    ".mysqli_real_escape_string($conexion,$pPrecioNino).",
    ".mysqli_real_escape_string($conexion,$pPrecioAdultoMayor).",
    '".mysqli_real_escape_string($conexion,$pFechaLimDepo)."',
    '".mysqli_real_escape_string($conexion,$pFechaLimPago)."',
    ".mysqli_real_escape_string($conexion,$pFk_SitioTuristico).",
    ".mysqli_real_escape_string($conexion,$pFk_Chofer).",
    ".mysqli_real_escape_string($conexion,$pFk_Guia).")";
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
