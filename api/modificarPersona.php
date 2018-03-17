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
$pIdPersona = $obj["pIdPersona"];
$pNombre = $obj["pNombre"];
$pCelular = $obj["pCelular"];
$pFk_Rol = $obj["pFk_Rol"];
//$pIdPersona = 12;
//$pNombre = "NADA";
//$pCelular = "60606500";
//$pFk_Rol = 2;


if($conexion){
    $consulta = "call modificarPersona(".mysqli_real_escape_string($conexion,$pIdPersona).",'".mysqli_real_escape_string($conexion,$pNombre)."','".mysqli_real_escape_string($conexion,$pCelular)."',".mysqli_real_escape_string($conexion,$pFk_Rol).")";
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
