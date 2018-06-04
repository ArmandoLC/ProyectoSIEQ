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
$UsuarioEmisorID = $obj["UsuarioEmisorID"];
$UsuarioReceptorID = $obj["UsuarioReceptorID"];
$Mensaje = $obj["Mensaje"];


// $UsuarioEmisorID = 7;
// $UsuarioReceptorID = 9;
// $Mensaje = "Prueba del API";

if($conexion){
    $consulta = "CALL AgregarMensajeChat(
					".mysqli_real_escape_string($conexion, $UsuarioEmisorID).",
					".mysqli_real_escape_string($conexion, $UsuarioReceptorID).",
					'".mysqli_real_escape_string($conexion, $Mensaje)."')";

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