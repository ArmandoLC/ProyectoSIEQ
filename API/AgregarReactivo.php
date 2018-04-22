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

$Nombre = $obj["Nombre"];
$Ubicacion = $obj["Ubicacion"];
$CantidadActual = $obj["CantidadActual"];
$PuntoReorden = $obj["PuntoReorden"];
$Descripcion = $obj["Descripcion"];
$EsPrecursor = $obj["EsPrecursor"];
$UnidadMetricaID = $obj["UnidadMetricaID"];
$CategoriaID = $obj["CategoriaID"];
$URLHojaSeguridad = $obj["URLHojaSeguridad"];
$UsuarioID = $obj["UsuarioID"];

// $Nombre = 'Acetona';
// $Ubicacion = 'I - 4';
// $CantidadActual = 36;
// $PuntoReorden = 10;
// $Descripcion = 'Probando ingreso de reactivos';
// $EsPrecursor = 0;
// $UnidadMetricaID = 2;
// $CategoriaID = 3;
// $URLHojaSeguridad = 'www.sieq.000webhost.com';
// $UsuarioID = 7;

if($conexion){
    $consulta = "CALL AgregarReactivo('".mysqli_real_escape_string($conexion, $Nombre)."', 
					'".mysqli_real_escape_string($conexion, $Ubicacion)."',
					".mysqli_real_escape_string($conexion, $CantidadActual).",
					".mysqli_real_escape_string($conexion, $PuntoReorden).",
					'".mysqli_real_escape_string($conexion, $Descripcion)."',
					".mysqli_real_escape_string($conexion, $EsPrecursor).",
					".mysqli_real_escape_string($conexion, $UnidadMetricaID).",
					".mysqli_real_escape_string($conexion, $CategoriaID).",
					'".mysqli_real_escape_string($conexion, $URLHojaSeguridad)."', 
					".mysqli_real_escape_string($conexion, $UsuarioID).")";
					
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