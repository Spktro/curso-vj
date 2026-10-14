extends Node2D
# Demo 08: H alterna el umbral de salida entre 40 (sin margen) y 60 (con histéresis).
# El jugador camina más lento que el jefe, así el jefe siempre lo alcanza.

var maximo = 0

func _ready():
	$Jugador.velocidad = 100

func _process(delta):
	var jefe = $JefeHisteresis
	var por_segundo = jefe.cambios_en_el_ultimo_segundo()
	maximo = max(maximo, por_segundo)
	$Contador.text = str(por_segundo)
	$Cartel.mostrar("Entra a ATACAR a menos de %d px · vuelve a PERSEGUIR a más de %d px   ·   récord: %d cambios en un segundo" % [jefe.entrar_a_atacar, jefe.salir_de_atacar, maximo])

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_H:
		if $JefeHisteresis.salir_de_atacar == 60:
			$JefeHisteresis.salir_de_atacar = 40
		else:
			$JefeHisteresis.salir_de_atacar = 60
		maximo = 0
