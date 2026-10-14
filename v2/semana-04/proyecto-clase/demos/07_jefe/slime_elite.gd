extends Enemigo
# Demo 07: el jefe del TP4 (slime_elite.gd), igual que el código de referencia.
# Únicas diferencias: se dibuja con círculos (no hay AnimatedSprite2D)
# y dibuja sus umbrales para que se vean las flechas del diagrama.

enum Estado { ACECHAR, PERSEGUIR, ATACAR, GOLPEADO }

var estado = Estado.ACECHAR
var jugador = null

func _ready():
	super()
	vida = 12
	velocidad = 70
	dano = 15
	radio = 22
	color = Color("a78bfa")
	$BarraVida.max_value = vida
	$BarraVida.value = vida
	jugador = get_tree().get_first_node_in_group("jugador")
	cambiar_estado(Estado.ACECHAR)

func _process(delta):
	if jugador == null:
		return
	var d = position.distance_to(jugador.position)
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < 250: cambiar_estado(Estado.PERSEGUIR)
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < 40: cambiar_estado(Estado.ATACAR)
			elif d > 350: cambiar_estado(Estado.ACECHAR)
		Estado.ATACAR:
			atacar()
			if d > 60: cambiar_estado(Estado.PERSEGUIR)
		Estado.GOLPEADO:
			if $TimerGolpe.is_stopped():
				cambiar_estado(Estado.PERSEGUIR)
	queue_redraw()

func cambiar_estado(nuevo):
	estado = nuevo
	var nombre = Estado.keys()[estado]
	$LabelEstado.text = nombre
	print("Jefe → " + nombre)
	match estado:
		Estado.ACECHAR: modulate = Color(1, 1, 1, 0.5)
		Estado.PERSEGUIR: modulate = Color.WHITE
		Estado.ATACAR: modulate = Color(1, 0.6, 0.2)
		Estado.GOLPEADO: modulate = Color(1, 0.4, 0.4)

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

func _on_area_entered(area):
	pass

func recibir_dano(cantidad):
	super(cantidad)
	$BarraVida.value = vida
	if vida > 0:
		position += (position - jugador.position).normalized() * 20
		$TimerGolpe.start()
		cambiar_estado(Estado.GOLPEADO)

func morir():
	print("💜 ¡Cayó un élite!")
	super()

# ---- Solo para la demo: los umbrales dibujados ----

func _draw():
	var gris = Color(0.6, 0.65, 0.75, 0.55)
	draw_arc(Vector2.ZERO, 250, 0, TAU, 96, gris, 2.0)                  # entra a PERSEGUIR
	draw_dashed_line(Vector2(250, 0), Vector2(350, 0), gris, 1.0, 6.0)
	draw_arc(Vector2.ZERO, 350, 0, TAU, 96, Color(0.6, 0.65, 0.75, 0.25), 2.0)  # vuelve a ACECHAR
	draw_arc(Vector2.ZERO, 40, 0, TAU, 48, Color(1, 0.6, 0.2, 0.8), 2.0)  # entra a ATACAR
	draw_arc(Vector2.ZERO, 60, 0, TAU, 48, Color(1, 0.6, 0.2, 0.4), 2.0)  # vuelve a PERSEGUIR
	var fuente = ThemeDB.fallback_font
	draw_string(fuente, Vector2(150, -6), "250", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, gris)
	draw_string(fuente, Vector2(300, -6), "350", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, gris)
	super()
