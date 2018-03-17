<?php

header('Access-Control-Allow-Origin: *');

/* Información de la conexión */

$host = 'localhost';

$user = 'root';

$pw = '';

$db = 'girasbd';

/* Funciones Generalísimas by Manuel */
function consultar($consulta, $conexion){
    mysqli_set_charset($conexion,"utf8");
    $cStoreProcedure = mysqli_query($conexion, $consulta);
    if($cStoreProcedure){
        if(is_bool($cStoreProcedure)===false){
            $buffer = array();
            if(mysqli_num_rows($cStoreProcedure) > 0){
                while($fila = mysqli_fetch_assoc($cStoreProcedure)){
                    array_push($buffer,$fila);
                }
            }
            return $buffer; // la consulta se ejecutó correctamente y devolvió un arreglo
        }
        return true; // la consulta se ejecutó correctamente y devolvió un booleano
    }
    else{
        return false; // ocurrió un error en la consulta
    }
}

function getJsonSalida($msj,$nombreLista,$lista){
    return json_encode(array("message"=>$msj,$nombreLista=>$lista));
}

function getJsonSalidaSimple($msj){
    return json_encode(array("message"=>$msj));
}

function cargarObjPost(){
    return json_decode($_POST["obj"],true);
}

?>
