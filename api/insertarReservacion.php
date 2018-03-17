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
$pCliente = $obj["pCliente"];
$pCelularCliente = $obj["pCelularCliente"];
$pCantNinos = $obj["pCantNinos"];
$pCantAdultos = $obj["pCantAdultos"];
$pCantAdultosMayores = $obj["pCantAdultosMayores"];
$pFk_Gira = $obj["pFk_Gira"];

if($conexion){
    $consulta = "call insertarReservacion('".mysqli_real_escape_string($conexion,$pCliente)."'
    ,'".mysqli_real_escape_string($conexion,$pCelularCliente)."'
    ,".mysqli_real_escape_string($conexion,$pCantNinos)."
    ,".mysqli_real_escape_string($conexion,$pCantAdultos)."
    ,".mysqli_real_escape_string($conexion,$pCantAdultosMayores)."
    ,".mysqli_real_escape_string($conexion,$pFk_Gira).")";

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
