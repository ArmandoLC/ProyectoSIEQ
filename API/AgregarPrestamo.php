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

$UsuarioSolicitanteID = $obj["UsuarioSolicitanteID"];
$ArticuloID = $obj["ArticuloID"];
$CantidadSolicitada = $obj["CantidadSolicitada"];
$FechaLimiteDevolucion = $obj["FechaLimiteDevolucion"];
$EstadoPrestamoID = $obj["EstadoPrestamoID"];
$Descripcion = $obj["Descripcion"];

// $UsuarioSolicitanteID = 7;
// $ArticuloID = 31;
// $CantidadSolicitada = 4;
// $FechaLimiteDevolucion = '2018-04-25';
// $EstadoPrestamoID = 1;
// $Descripcion = 'Probando';


if($conexion){
    $consulta = "CALL AgregarPrestamo(
					".mysqli_real_escape_string($conexion, $UsuarioSolicitanteID).",
					".mysqli_real_escape_string($conexion, $ArticuloID).",
					".mysqli_real_escape_string($conexion, $CantidadSolicitada).",
					'".mysqli_real_escape_string($conexion, $FechaLimiteDevolucion)."',
					".mysqli_real_escape_string($conexion, $EstadoPrestamoID).",
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
