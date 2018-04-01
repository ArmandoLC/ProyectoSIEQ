<?php
// Tell PHP that we're using UTF-8 strings until the end of the script
mb_internal_encoding('UTF-8');
// Tell PHP that we'll be outputting UTF-8 to the browser
mb_http_output('UTF-8');
if(!@include("funciones/funciones.php")){
    die("Error fatal!!");
}

 $conexion = mysqli_connect($host, $user, $pw, $db);

// $obj = cargarObjPost();

// $ArticuloID = $obj["ArticuloID"];
// $Nombre = $obj["Nombre"];
// $Ubicacion = $obj["Ubicacion"];
// $PuntoReorden = $obj["PuntoReorden"];
// $Descripcion = $obj["Descripcion"];


$ArticuloID = 40;
$Nombre = 'Cristaleria Actualizada';
$Ubicacion = 'Ubicacion Actualizada';
$PuntoReorden = 101;
$Descripcion = 'Modificacion de cristaleria';

if($conexion){
    $consulta = "CALL ActualizarCristaleria(
					".mysqli_real_escape_string($conexion, $ArticuloID).",
					'".mysqli_real_escape_string($conexion, $Nombre)."', 
					'".mysqli_real_escape_string($conexion, $Ubicacion)."',
					".mysqli_real_escape_string($conexion, $PuntoReorden).",
					'".mysqli_real_escape_string($conexion, $Descripcion)."')";
					
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