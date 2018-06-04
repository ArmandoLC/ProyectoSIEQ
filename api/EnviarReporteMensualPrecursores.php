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
$CategoriaID = 0;
$Para = $obj["Para"];
$Asunto = $obj["Asunto"];


// $FechaDesde = '2000-01-01';
// $FechaHasta = '2000-01-01';
// $CategoriaID = 0;
// $Para = 'andreymendozaf@gmail.com';
// $Asunto = 'Precursores';


if($conexion){
    $consulta = "CALL VerMovimientosPrecursores(
					'".mysqli_real_escape_string($conexion, $FechaDesde)."',	
					'".mysqli_real_escape_string($conexion, $FechaHasta)."',
					".mysqli_real_escape_string($conexion, $CategoriaID).")";
	
	$body = 'Adjunto se encuentra el reporte de precursores para las fechas del '.$FechaDesde.' al '.$FechaHasta.'.\n';
    $body .= GenerarHTMLPrecursores($consulta,$conexion);
	
	$resultado = EnviarCorreo('Reporte de Precursores', $Para, $body, $Asunto);
	if($resultado == true){
        echo getJsonSalidaSimple("OK");
    }
    else{
         echo getJsonSalidaSimple("ERROR");
    }
}
else{
    echo getJsonSalidaSimple("ERROR de conexion");
}
?>