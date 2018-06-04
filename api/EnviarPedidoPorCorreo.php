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
$PedidoID = $obj["PedidoID"];
$Titulo = $obj["Titulo"];
$Descripcion = $obj["Descripcion"];
$Para = $obj["Para"];
$Asunto = $obj["Asunto"];
$NombrePropietario = $obj["NombrePropietario"];


// $PedidoID = 1;
// $Titulo = 'Prueba';
// $Descripcion = 'Probando reporte';
// $Para = 'andreymendozaf@gmail.com';
// $Asunto = 'Reporte de prueba';
// $NombrePropietario = 'Andrey Mendoza';


if($conexion){
    $consulta = "CALL VerArticulosDelPedido(
					".mysqli_real_escape_string($conexion, $PedidoID).")";
					
    $body = GenerarHTMLPedido($consulta,$conexion, $Titulo, $Descripcion, $NombrePropietario);
	
	$resultado = EnviarCorreo('Pedido del Sistema SIEQ', $Para, $body, $Asunto);
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