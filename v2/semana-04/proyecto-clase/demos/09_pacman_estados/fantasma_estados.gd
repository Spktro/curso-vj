extends Node2D
# Demo 09: un fantasma de Pac-Man con sus cuatro estados.
# - SCATTER ⇄ CHASE: por TIEMPO, con un reloj fijo (7 s y 20 s).
# - FRIGHTENED: entra por EVENTO (la píldora) y sale por TIEMPO (TimerSusto).
# - EATEN: entra por EVENTO (el jugador lo toca asustado) y sale al llegar a la casa.
# Mientras está asustado o comido, el reloj de SCATTER/CHASE queda en pausa.

enum Estado { SCATTER, CHASE, FRIGHTENED, EATEN }

var estado = Estado.SCATTER
var modo_reloj = Estado.SCATTER     # lo que marca el reloj: SCATTER o CHASE
var esquina = Vector2(1180, 230)    # su esquina en SCATTER
var casa = Vector2(640, 420)
var velocidad = 150
var jugador = null
var tiempo = 0.0

func _ready():
	jugador = get_tree().get_first_node_in_group("jugador")
	$TimerModo.timeout.connect(_on_timer_modo_timeout)
	$TimerSusto.timeout.connect(_on_timer_susto_timeout)
	cambiar_estado(Estado.SCATTER)
	$TimerModo.start(7)

func _process(delta):
	tiempo += delta
	match estado:
		Estado.SCATTER:
			ir_hacia(esquina, velocidad, delta)
		Estado.CHASE:
			ir_hacia(jugador.position, velocidad, delta)
		Estado.FRIGHTENED:
			huir(delta)
		Estado.EATEN:
			ir_hacia(casa, velocidad * 2.5, delta)
			if position.distance_to(casa) < 6:
				$TimerModo.paused = false
				cambiar_estado(modo_reloj)

	# El jugador lo toca
	if position.distance_to(jugador.position) < 30:
		if estado == Estado.FRIGHTENED:
			cambiar_estado(Estado.EATEN)
		elif estado != Estado.EATEN:
			jugador.recibir_dano(1)

	$LabelEstado.text = Estado.keys()[estado] + texto_reloj()
	queue_redraw()

# ---- Eventos ----

func comer_pildora():
	if estado == Estado.EATEN:
		return
	$TimerModo.paused = true
	$TimerSusto.start()
	cambiar_estado(Estado.FRIGHTENED)

func _on_timer_modo_timeout():
	if modo_reloj == Estado.SCATTER:
		modo_reloj = Estado.CHASE
		$TimerModo.start(20)
	else:
		modo_reloj = Estado.SCATTER
		$TimerModo.start(7)
	if estado == Estado.SCATTER or estado == Estado.CHASE:
		cambiar_estado(modo_reloj)

func _on_timer_susto_timeout():
	if estado == Estado.FRIGHTENED:
		$TimerModo.paused = false
		cambiar_estado(modo_reloj)

func cambiar_estado(nuevo):
	estado = nuevo
	print("Fantasma → " + Estado.keys()[estado])

# ---- Comportamientos ----

func ir_hacia(destino, vel, delta):
	if position.distance_to(destino) > 4:
		position += (destino - position).normalized() * vel * delta

func huir(delta):
	var dir = (position - jugador.position).normalized()
	position += dir * velocidad * 0.6 * delta
	position = position.clamp(Vector2(30, 110), Vector2(1250, 690))

func texto_reloj():
	if estado == Estado.FRIGHTENED:
		return "\nse le pasa en %.1f s" % $TimerSusto.time_left
	if estado == Estado.EATEN:
		return "\nvuelve a la casa"
	return "\ncambia en %.1f s" % $TimerModo.time_left

# ---- Dibujo ----

func _draw():
	# La esquina y la casa, para que se vea a dónde va
	draw_rect(Rect2(to_local(casa) - Vector2(40, 24), Vector2(80, 48)), Color(0.6, 0.65, 0.75, 0.6), false, 2.0)
	draw_arc(to_local(esquina), 18, 0, TAU, 32, Color(1, 0.23, 0.23, 0.5), 2.0)
	var color = Color("ff3b3b")
	if estado == Estado.FRIGHTENED:
		color = Color("3b5bff")
		# Parpadea cuando le quedan menos de 2 segundos: el juego avisa
		if $TimerSusto.time_left < 2 and fmod(tiempo, 0.3) < 0.15:
			color = Color.WHITE
	if estado != Estado.EATEN:
		draw_circle(Vector2(0, -4), 18, color)
		draw_rect(Rect2(-18, -4, 36, 20), color)
		for i in 3:
			draw_circle(Vector2(-12 + i * 12, 16), 6, color)
	# Los ojos: lo único que queda cuando está comido
	for x in [-7, 7]:
		draw_circle(Vector2(x, -6), 5.5, Color.WHITE)
		draw_circle(Vector2(x, -6), 2.8, Color("1b2230"))
