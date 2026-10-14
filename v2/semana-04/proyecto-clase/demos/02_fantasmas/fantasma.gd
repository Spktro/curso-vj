extends Node2D
# Demo 02: un fantasma de Pac-Man. Toda su "inteligencia" es elegir una casilla objetivo.
# Blinky: casillas_adelante = 0 → apunta al jugador.
# Pinky:  casillas_adelante = 4 → apunta 4 casillas ADELANTE del jugador y le sale al cruce.

@export var color = Color.RED
@export var casillas_adelante = 0

var velocidad = 160
var casilla = 32
var objetivo = Vector2.ZERO
var mira = Vector2.RIGHT

func _process(delta):
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		return
	# --- La regla de una línea ---
	objetivo = jugador.position + jugador.direccion * casilla * casillas_adelante

	if position.distance_to(objetivo) > 4:
		mira = (objetivo - position).normalized()
		position += mira * velocidad * delta
	if position.distance_to(jugador.position) < 28:
		jugador.recibir_dano(1)
	queue_redraw()

func _draw():
	# Objetivo: una mira del color del fantasma, y una línea punteada hasta él
	var o = objetivo - position
	draw_dashed_line(Vector2.ZERO, o, color, 2.0, 8.0)
	draw_arc(o, 14, 0, TAU, 32, color, 2.5)
	draw_line(o + Vector2(-20, 0), o + Vector2(20, 0), color, 2.0)
	draw_line(o + Vector2(0, -20), o + Vector2(0, 20), color, 2.0)
	# Cuerpo del fantasma
	draw_circle(Vector2(0, -4), 16, color)
	draw_rect(Rect2(-16, -4, 32, 18), color)
	for i in 3:
		draw_circle(Vector2(-10.6 + i * 10.6, 14), 5.3, color)
	# Ojos que miran hacia donde va
	for x in [-6, 6]:
		draw_circle(Vector2(x, -6), 5, Color.WHITE)
		draw_circle(Vector2(x, -6) + mira * 2.5, 2.5, Color("1b2230"))
