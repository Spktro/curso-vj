extends Enemigo
# Demo 06: el jefe escrito con booleanos, como en la diapositiva del spaghetti.
# Para mirar en pantalla:
#   1. Alejarse a más de 350 px: no vuelve a acechar. Falta esa flecha y nadie lo nota.
#   2. Dispararle mientras ataca: atacando y golpeado quedan en true A LA VEZ.
#      ¿Qué está haciendo? Depende de qué if se lea primero.

var lo_vi = false
var atacando = false
var golpeado = false
var jugador = null

func _ready():
	super()
	vida = 1000     # en la demo no muere
	velocidad = 70
	dano = 15
	radio = 22
	color = Color("9ca3af")
	jugador = get_tree().get_first_node_in_group("jugador")

func _process(delta):
	if jugador == null:
		return
	var d = position.distance_to(jugador.position)
	if golpeado:
		if $TimerGolpe.is_stopped(): golpeado = false
	elif lo_vi and not atacando:
		perseguir(delta)
		if d < 40: atacando = true
	elif atacando and not golpeado:
		atacar()
		if d > 60: atacando = false
	elif not lo_vi:
		acechar(delta)
		if d < 250: lo_vi = true

	$LabelEstado.text = "lo_vi = %s\natacando = %s\ngolpeado = %s" % [lo_vi, atacando, golpeado]
	queue_redraw()

func acechar(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * 0.5 * delta

func perseguir(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * delta

func atacar():
	if $TimerAtaque.is_stopped():
		jugador.recibir_dano(dano)
		$TimerAtaque.start()

func recibir_dano(cantidad):
	golpeado = true   # ¿y atacando? ¿y lo_vi? ¿se tocan o no?
	position += (position - jugador.position).normalized() * 20
	$TimerGolpe.start()

func _on_area_entered(area):
	pass   # no es kamikaze

func _draw():
	draw_arc(Vector2.ZERO, 250, 0, TAU, 96, Color(0.6, 0.65, 0.75, 0.5), 2.0)
	draw_arc(Vector2.ZERO, 350, 0, TAU, 96, Color(0.6, 0.65, 0.75, 0.25), 2.0)
	super()
	# Un signo de pregunta: no hay un nombre para "lo que está haciendo"
	draw_string(ThemeDB.fallback_font, Vector2(-8, 9), "?", HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("1b2230"))
