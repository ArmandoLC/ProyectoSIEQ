<?php
header('Access-Control-Allow-Origin: *');

/* Información de la conexión a la base de datos*/
$host = 'localhost';
$pw = 'S1st3m@Sieq';
$user = 'id5183712_sieq';
$db = 'id5183712_sieq';

/**
* Se conecta a la base de datos, ejecuta el query ingresado y returna en un arreglo
* las filas retornadas.
* @param $consulta: es el query que va a ser ejecutado en MySql
* @param $conexion: es el objeto de la conexion a la base de datos ya establecida
* return $buffer: un arreglo con todas las filas leídas de la consulta.
*/
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

/**
* Crea un objeto Json a partir de otro objeto Json.
* @param $msj: es un mensaje el cual siempre va a retornar cualquier metodo del serivico.
* @param $nombreLista: nombre del array que contendrá el objeto obtenido de la consulta.
* @param $lista: lista que contiene la respuesta.
*/
function getJsonSalida($msj,$nombreLista,$lista){
    return json_encode(array("message"=>$msj,$nombreLista=>$lista));
}

/**
* Retorna las un json con solamente un mensaje 
* @param msj: mensaje que se desea mostrar en la respuesta del metodo.
*/
function getJsonSalidaSimple($msj){
    return json_encode(array("message"=>$msj));
}

/**
* Lee el objeto enviado en el encabezado HTTP a la hora de llamar el metodo del servicio
* @return un array con cada uno de los parametros cargados
*/
function cargarObjPost(){
    return json_decode($_POST["obj"],true);
}

/**
* Lee un pedido desde la base de datos y genera el codigo HTML con los datos obtenidos
* @param $consulta: procedimiento almacenado a llamar.
* @param $conexion: objeto de conexion a la base de datos 
* @param $titulo: titulo que va a tener el pedido 
* @param $descripcion: descripcion del pedido
* @param $propietario: nombre del propietario del pedido
* @return: un string con el HTML generado
*/
function GenerarHTMLPedido($consulta, $conexion, $titulo, $descripcion, $propietario){
    mysqli_set_charset($conexion,"utf8");
    $cStoreProcedure = mysqli_query($conexion, $consulta);
    if($cStoreProcedure){
        if(is_bool($cStoreProcedure)===false){
            $body = 
			'<!doctype html>
			<html lang="es">
			<head>
				<meta charset="utf-8">
				<style>
					table, h1, p{
						font-family: arial, sans-serif;
						border-collapse: collapse;
						width: 100%;
					}            
					td, th {
						border: 1px solid #dddddd;
						text-align: left;
						padding: 8px;
					}            
					th {
						background-color: #034a91;
						color: white;
						text-align: center;
					}            
					tr:nth-child(even) {
						background-color: #dddddd;
					}
				</style>		
				<h1><center> Sistema de Inventario de la Escuela de Química (SIEQ)</center></h1></head><body>
				<p><b>Pedido realizo por </b>'.$propietario.'</p>
				<p><b>Título: </b>'.$titulo.'</p>
				<table style="width:100%">
				
					<tr>
					  <th>Nombre</th>
					  <th>Tipo</th>
					  <th>¿En alerta?</th>
					  <th>Cantidad Actual</th>
					  <th>Cantidad de Alerta</th>
					  <th>Cantidad Solicitada</th>			  
					</tr>';
            if(mysqli_num_rows($cStoreProcedure) > 0){
                while($fila = mysqli_fetch_assoc($cStoreProcedure)){					
					$body .= 
					'<tr>
						<td> <center>'.$fila['Articulo'].'</center> </td>      
						<td> <center>'.$fila['TipoArticulo'].'</center> </td>';
						
						if ($fila['EsAlerta'] == 1){
							$body .= '<td> <center>' . 'No' . '</center> </td>';
						}
						else {
							$body .= '<td> <center>' . 'Sí' . '</center> </td>';
						}						
						$body .= 
						'<td> <center>'.$fila['CantidadActual'].'</center> </td>
						<td> <center>'.$fila['PuntoReorden'].'</center> </td>
						<td> <center>'.$fila['CantidadSolicitada'].'</center> </td>
					</tr>';
                }
				$body .= '</table></body></html>';
            }
            return $body; // la consulta se ejecutó correctamente y devolvió un arreglo
        }
        return true; // la consulta se ejecutó correctamente y devolvió un booleano
    }
    else{
        return false; // ocurrió un error en la consulta
    }
}

/**
* Genera un HTML con los datos de los precursores
* @param $consulta: procedimiento almacenado a llamar en la base de datos 
* @param $conexion: objeto de conexion a la base de datos.
* @return: string con el HTML del pedido.
*/
function GenerarHTMLPrecursores($consulta, $conexion){
    mysqli_set_charset($conexion,"utf8");
    $cStoreProcedure = mysqli_query($conexion, $consulta);
    if($cStoreProcedure){
        if(is_bool($cStoreProcedure)===false){
            $body = 
			'<!doctype html>
			<html lang="es">
			<head>
				<meta charset="utf-8">
				<style>
					table, h1, p{
						font-family: arial, sans-serif;
						border-collapse: collapse;
						width: 100%;
					}            
					td, th {
						border: 1px solid #dddddd;
						text-align: left;
						padding: 8px;
					}            
					th {
						background-color: #034a91;
						color: white;
						text-align: center;
					}            
					tr:nth-child(even) {
						background-color: #dddddd;
					}
				</style>		
				<h1><center> Sistema de Inventario de la Escuela de Química (SIEQ)</center></h1></head><body>
				<p><b>Reporte de Precursores </b></p>
				<table style="width:100%">
				
					<tr>
					  <th>Reactivo</th>
					  <th>Tipo de Movimiento</th>
					  <th>Antes</th>
					  <th>Después</th>
					  <th>Movido</th>
					  <th>Categoría</th>
					  <th>Fecha</th>
					  <th>Destino</th>
					  <th>Observaciones</th>
					  <th>Firma</th>
					</tr>';
            if(mysqli_num_rows($cStoreProcedure) > 0){
                while($fila = mysqli_fetch_assoc($cStoreProcedure)){					
					$body .= 
					'<tr>
						<td> <center>'.$fila['Reactivo'].'</center> </td>      
						<td> <center>'.$fila['Tipo de Movimiento'].'</center> </td>
						<td> <center>'.$fila['Antes'].'</center> </td>
						<td> <center>'.$fila['Despues'].'</center> </td>
						<td> <center>'.$fila['Movido'].'</center> </td>
						<td> <center>'.$fila['Categoria'].'</center> </td>
						<td> <center>'.$fila['Fecha'].'</center> </td>
						<td> <center>'.$fila['Destino'].'</center> </td>
						<td> <center>'.$fila['Observaciones'].'</center> </td>
						<td> <center>'.$fila['Firma'].'</center> </td>
					</tr>';
                }
				$body .= '</table></body></html>';
            }
            return $body; // la consulta se ejecutó correctamente y devolvió un arreglo
        }
        return true; // la consulta se ejecutó correctamente y devolvió un booleano
    }
    else{
        return false; // ocurrió un error en la consulta
    }
}

/**
* @param $fromName: nombre del emisor
* @param $to: correo a quien se le va a enviar 
* @param $body: cuerpo que va a llevar el correo.
* @param $subject: asunto que va a tener el correo
* @return: resultado booleano del resultado de la operacion.
*/
function EnviarCorreo($fromName, $to, $body, $subject)
{
	require('class.phpmailer.php');
	
	// SMTP utilizado para el envio de correo.
	$user = 'sieq.itcr@gmail.com';
	$pass = 'S1st3m@Sieq';
	$from = 'sieq.itcr@gmail.com';
	
	$mail = new PHPMailer();
	$mail->CharSet = 'UTF-8';
	$mail->IsSMTP();
	$mail->SMTPDebug = false;
	$mail->Debugoutput = 'html';
	$mail->isHTML(true);
	$mail->Host = 'smtp.gmail.com';
	$mail->Port = 465;
	$mail->SMTPSecure = 'ssl';
	$mail->SMTPAuth = true;
	$mail->Username = $user;
	$mail->Password = $pass;
	$mail->SetFrom($from, $fromName);
	$mail->AddAddress($to);
	$mail->Subject = $subject;
	$mail->Body = $body;

	if (!$mail->send()) {
		return false;
	} else {
		return true;
	}
}
?>