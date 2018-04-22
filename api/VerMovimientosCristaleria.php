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
$FechaDesde = $obj["FechaDesde"];
$FechaHasta = $obj["FechaHasta"];

// $FechaDesde = '2018-01-01';
// $FechaHasta = '2018-04-01';


if($conexion){
    $consulta = "CALL VerMovimientosCristaleria(
					'".mysqli_real_escape_string($conexion, $FechaDesde)."',	
					'".mysqli_real_escape_string($conexion, $FechaHasta)."')";
					
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