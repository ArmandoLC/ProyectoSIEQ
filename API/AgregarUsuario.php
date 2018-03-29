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
$Usuario = $obj["Usuario"];
$Nombre = $obj["Nombre"];
$Contrasenha = $obj["Contrasenha"];
$Correo = $obj["Correo"];
$RolID = $obj["RolID"];

if($conexion){
    $consulta = "CALL AgregarUsuario(
					'".mysqli_real_escape_string($conexion, $Nombre)."', 
					'".mysqli_real_escape_string($conexion, $Usuario)."',
					'".mysqli_real_escape_string($conexion, $Contrasenha)."',
					'".mysqli_real_escape_string($conexion, $Correo)."',
					".mysqli_real_escape_string($conexion, $RolID).")";
					
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