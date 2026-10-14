extends Node2D
# Demo 10: Boo, el fantasma de Super Mario.
# Si Mario está lejos, flota. Si está cerca y le da la espalda, avanza.
# Si Mario lo mira, se tapa la cara y se queda quieto.
# Dos datos del jugador: la distancia y hacia dónde mira.

enum Estado { FLOTAR, AVANZAR, TAPARSE }

var estado = Estado.FLOTAR
var velocidad = 80
var cerca = 300    # entra a AVANZAR
var lejos = 380    # vuelve a FLOTAR (histéresis otra vez)
var jugador = null
var tiempo = 0.0

func _ready():
	jugador = get_tree().get_first_node_in_group("jugador")
	cambiar_estado(Estado.FLOTAR)

func _process(delta):
	tiempo += delta
	var d = position.distance_to(jugador.position)
	match estado:
		Estado.FLOTAR:
			if d < cerca: cambiar_estado(Estado.AVANZAR)
		Estado.AVANZAR:
			avanzar(delta)
			if mario_me_mira(): cambiar_estado(Estado.TAPARSE)
			elif d > lejos: cambiar_estado(Estado.FLOTAR)
		Estado.TAPARSE:
			# quieto: no hace nada
			if not mario_me_mira(): cambiar_estado(Estado.AVANZAR)
	if d < 34:
		jugador.recibir_dano(1)
	queue_redraw()

func mario_me_mira():
	# Mira a la derecha (1) y Boo está a la derecha, o mira a la izquierda (-1) y Boo está a la izquierda
	return (position.x - jugador.position.x) * jugador.mirando > 0

func avanzar(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * delta

func cambiar_estado(nuevo):
	estado = nuevo
	$LabelEstado.text = Estado.keys()[estado]

func _draw():
	draw_arc(Vector2.ZERO, cerca, 0, TAU, 96, Color(0.6, 0.65, 0.75, 0.35), 2.0)
	draw_arc(Vector2.ZERO, lejos, 0, TAU, 96, Color(0.6, 0.65, 0.75, 0.18), 2.0)
	var flota = Vector2(0, sin(tiempo * 3) * 5)   # sube y baja
	var blanco = Color(1, 1, 1, 0.95)
	if estado == Estado.FLOTAR:
		blanco = Color(1, 1, 1, 0.6)
	draw_circle(flota, 30, blanco)
	var mira = sign(jugador.position.x - position.x)
	if estado == Estado.TAPARSE:
		# Las manos sobre la cara y las mejillas coloradas
		draw_circle(flota + Vector2(-12, -4), 10, Color("e5e7eb"))
		draw_circle(flota + Vector2(12, -4), 10, Color("e5e7eb"))
		draw_circle(flota + Vector2(-18, 10), 5, Color(1, 0.5, 0.6, 0.8))
		draw_circle(flota + Vector2(18, 10), 5, Color(1, 0.5, 0.6, 0.8))
	else:
		draw_circle(flota + Vector2(-9 + mira * 4, -6), 5, Color("1b2230"))
		draw_circle(flota + Vector2(9 + mira * 4, -6), 5, Color("1b2230"))
		if estado == Estado.AVANZAR:
			# Boca abierta y lengua
			draw_circle(flota + Vector2(mira * 4, 12), 9, Color("1b2230"))
			draw_circle(flota + Vector2(mira * 4, 16), 5, Color("ff6b8a"))
