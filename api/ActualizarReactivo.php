<?php
header("Access-Control-Allow-Origin: *");
// Tell PHP that we're using UTF-8 strings until the end of the script
mb_internal_encoding('UTF-8');
// Tell PHP that we'll be outputting UTF-8 to the browser
mb_http_output('UTF-8');
if(!@include("funciones/funciones.php")){
    die("Error fatal!!");
}

 $conexion = mysqli_connect($host, $user, $pw, $db);

$obj = cargarObjPost();

$ReactivoID = $obj["ReactivoID"];
$Nombre = $obj["Nombre"];
$Ubicacion = $obj["Ubicacion"];
$PuntoReorden = $obj["PuntoReorden"];
$Descripcion = $obj["Descripcion"];
$EsPrecursor = $obj["EsPrecursor"];
$UnidadMetricaID = $obj["UnidadMetricaID"];
$CategoriaID = $obj["CategoriaID"];
$URLHojaSeguridad = $obj["URLHojaSeguridad"];

// $ReactivoID = 28;
// $Nombre = 'Actualizar';
// $Ubicacion = 'Ubicacion de Prueba';
// $PuntoReorden = 101;
// $Descripcion = 'Modificacion de reactivos';
// $EsPrecursor = 1;
// $UnidadMetricaID = 2;
// $CategoriaID = 2;
// $URLHojaSeguridad = 'prueba.com';

if($conexion){
    $consulta = "CALL ActualizarReactivo(
					".mysqli_real_escape_string($conexion, $ReactivoID).",
					'".mysqli_real_escape_string($conexion, $Nombre)."', 
					'".mysqli_real_escape_string($conexion, $Ubicacion)."',
					".mysqli_real_escape_string($conexion, $PuntoReorden).",
					'".mysqli_real_escape_string($conexion, $Descripcion)."',
					".mysqli_real_escape_string($conexion, $EsPrecursor).",
					".mysqli_real_escape_string($conexion, $UnidadMetricaID).",
					".mysqli_real_escape_string($conexion, $CategoriaID).",
					'".mysqli_real_escape_string($conexion, $URLHojaSeguridad)."')"; 
					
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