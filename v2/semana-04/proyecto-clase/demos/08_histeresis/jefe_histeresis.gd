extends Enemigo
# Demo 08: el jefe reducido a PERSEGUIR ⇄ ATACAR, con los umbrales en variables.
# Con 40 / 40, un jugador que se aleja despacio lo hace cambiar de estado casi en cada frame.
# Con 40 / 60 (histéresis), el margen entre entrar y salir lo deja tranquilo.

enum Estado { PERSEGUIR, ATACAR }

var estado = Estado.PERSEGUIR
var jugador = null
var entrar_a_atacar = 40   # a menos de esto, ATACAR
var salir_de_atacar = 60   # a más de esto, vuelve a PERSEGUIR (la tecla H lo alterna con 40)
var cambios = []           # momentos de cada cambio de estado, para contarlos

func _ready():
	super()
	velocidad = 120
	radio = 22
	color = Color("a78bfa")
	jugador = get_tree().get_first_node_in_group("jugador")
	cambiar_estado(Estado.PERSEGUIR)

func _process(delta):
	if jugador == null:
		return
	var d = position.distance_to(jugador.position)
	match estado:
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < entrar_a_atacar: cambiar_estado(Estado.ATACAR)
		Estado.ATACAR:
			# quieto: en esta demo no pega, solo cambia de color
			if d > salir_de_atacar: cambiar_estado(Estado.PERSEGUIR)
	queue_redraw()

func perseguir(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * delta

func cambiar_estado(nuevo):
	estado = nuevo
	$LabelEstado.text = Estado.keys()[estado]
	cambios.append(Time.get_ticks_msec())
	if estado == Estado.ATACAR:
		modulate = Color(1, 0.6, 0.2)
	else:
		modulate = Color.WHITE

func cambios_en_el_ultimo_segundo():
	var ahora = Time.get_ticks_msec()
	while cambios.size() > 0 and ahora - cambios[0] > 1000:
		cambios.pop_front()
	return cambios.size()

func _on_area_entered(area):
	pass

func _draw():
	draw_arc(Vector2.ZERO, entrar_a_atacar, 0, TAU, 48, Color(1, 0.6, 0.2, 0.9), 2.0)
	draw_arc(Vector2.ZERO, salir_de_atacar, 0, TAU, 48, Color(0.6, 0.65, 0.75, 0.7), 2.0)
	super()
