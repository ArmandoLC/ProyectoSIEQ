<?php // Tell PHP that we're using UTF-8 strings until the end of the script
mb_internal_encoding('UTF-8');
// Tell PHP that we'll be outputting UTF-8 to the browser
mb_http_output('UTF-8');

if(!@include("includes/funciones.php")){
    die("Error fatal!!");
}

$conexion = mysqli_connect($host, $user, $pw, $db);

$obj = cargarObjPost();
$pFk_Sitio = $obj["pFk_Sitio"];

if($conexion){
    $consulta = "call getImagenesXSitio(".mysqli_real_escape_string($conexion,$pFk_Sitio).")";
    $resultado = consultar($consulta,$conexion);

    if(is_bool($resultado)===false){
        $arr = array();
        foreach($resultado as $img){
            $img["img"] = base64_encode($img["img"]);
            array_push($arr, $img) ;
        }
        echo getJsonSalida("OK", "listaDatos",$arr);
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
