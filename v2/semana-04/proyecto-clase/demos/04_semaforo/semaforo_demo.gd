extends Node2D
# Demo 04: se aprietan teclas (eventos) y se anota qué transición hubo.
# Si el evento no corresponde al estado actual, no pasa nada: queda anotado como ignorado.

var registro = []
var automatico = false

func _ready():
	$TimerCambio.timeout.connect(_on_timer_cambio_timeout)
	actualizar()

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var antes = $Semaforo.estado
	match event.physical_keycode:
		KEY_T:
			$Semaforo.pasar_tiempo()
			anotar("pasar_tiempo()", antes)
		KEY_F:
			$Semaforo.fallar()
			anotar("fallar()", antes)
		KEY_A:
			$Semaforo.arreglar()
			anotar("arreglar()", antes)
		KEY_M:
			automatico = not automatico
			if automatico:
				$TimerCambio.start()
			else:
				$TimerCambio.stop()
			actualizar()

func _on_timer_cambio_timeout():
	var antes = $Semaforo.estado
	$Semaforo.pasar_tiempo()
	anotar("pasar_tiempo()  (lo llamó el Timer)", antes)

func anotar(evento, antes):
	var nombres = Semaforo.Estado.keys()
	var despues = $Semaforo.estado
	var linea = ""
	if antes == despues:
		linea = evento + "   →   ignorado: en " + nombres[antes] + " no hay flecha para este evento"
	else:
		linea = evento + "   →   " + nombres[antes] + "  pasa a  " + nombres[despues]
	registro.push_front(linea)
	if registro.size() > 9:
		registro.pop_back()
	actualizar()

func actualizar():
	$Estado.text = "estado = " + Semaforo.Estado.keys()[$Semaforo.estado]
	$Registro.text = "\n".join(registro)
	var modo = "manual"
	if automatico:
		modo = "automático: un Timer llama a pasar_tiempo() cada 1.5 s"
	$Cartel.mostrar("Modo " + modo)
