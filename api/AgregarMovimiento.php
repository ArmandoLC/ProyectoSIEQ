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

$TipoMovimientoID = $obj["TipoMovimientoID"];
$UsuarioAutorizadorID = $obj["UsuarioAutorizadorID"];
$ArticuloID = $obj["ArticuloID"];
$CantidadSolicitada = $obj["CantidadSolicitada"];
$Destino = $obj["Destino"];
$Observaciones = $obj["Observaciones"];

// $TipoMovimientoID = 1;
// $UsuarioAutorizadorID = $obj["UsuarioAutorizadorID"];
// $ArticuloID = $obj["ArticuloID"];
// $CantidadSolicitada = $obj["CantidadSolicitada"];
// $Destino = $obj["Destino"];
// $Observaciones = $obj["Observaciones"];

if($conexion){
    $consulta = "CALL AgregarMovimiento(
					".mysqli_real_escape_string($conexion, $TipoMovimientoID).",
					".mysqli_real_escape_string($conexion, $UsuarioAutorizadorID).", 
					".mysqli_real_escape_string($conexion, $ArticuloID).",
					".mysqli_real_escape_string($conexion, $CantidadSolicitada).",
					'".mysqli_real_escape_string($conexion, $Destino)."',
					'".mysqli_real_escape_string($conexion, $Observaciones)."')"; 
					
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