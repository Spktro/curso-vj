extends Area2D
# El jugador de todas las demos: un punto celeste visto desde arriba.
# WASD: mover · Flechas izquierda/derecha: girar sin moverse · Ctrl: agacharse
# Espacio: disparar al enemigo más cercano (solo si la demo lo permite).
# El grupo "jugador" está puesto en la escena (pestaña Grupos), así los enemigos lo encuentran
# en su _ready() aunque estén antes en el árbol.

var velocidad = 220
var direccion = Vector2.RIGHT   # hacia dónde se movió por última vez (Pinky la usa)
var mirando = 1                 # 1 = mira a la derecha, -1 = a la izquierda (Boo lo usa)
var agachado = false            # agachado, el cono lejano de Commandos no lo ve
@export var puede_disparar = false
var destello = 0.0              # al recibir daño se pone rojo un instante

var escena_bala = preload("res://comun/bala.tscn")

func _process(delta):
	var mover = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_A):
		mover.x -= 1
	if Input.is_physical_key_pressed(KEY_D):
		mover.x += 1
	if Input.is_physical_key_pressed(KEY_W):
		mover.y -= 1
	if Input.is_physical_key_pressed(KEY_S):
		mover.y += 1
	agachado = Input.is_physical_key_pressed(KEY_CTRL)

	if mover != Vector2.ZERO:
		direccion = mover.normalized()
		if mover.x > 0:
			mirando = 1
		elif mover.x < 0:
			mirando = -1

	var vel = velocidad
	if agachado:
		vel = velocidad * 0.4
	position += mover.normalized() * vel * delta
	position = position.clamp(Vector2(20, 100), Vector2(1260, 700))

	destello = max(destello - delta, 0.0)
	queue_redraw()

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if event.physical_keycode == KEY_LEFT:
		mirando = -1
	elif event.physical_keycode == KEY_RIGHT:
		mirando = 1
	elif event.physical_keycode == KEY_SPACE and puede_disparar:
		disparar()

func disparar():
	# Igual que en el survivors: apuntar al enemigo más cercano.
	var objetivo = null
	var mejor = INF
	for enemigo in get_tree().get_nodes_in_group("enemigo"):
		var d = global_position.distance_to(enemigo.global_position)
		if d < mejor:
			mejor = d
			objetivo = enemigo
	if objetivo == null:
		return
	var bala = escena_bala.instantiate()
	bala.position = position
	bala.direccion = (objetivo.global_position - global_position).normalized()
	get_parent().add_child(bala)

func recibir_dano(cantidad):
	destello = 0.25

func _draw():
	var color = Color("5ac8ff")
	if destello > 0:
		color = Color("ff4d4d")
	var radio = 14
	if agachado:
		radio = 10
		color = color.darkened(0.35)
	draw_circle(Vector2.ZERO, radio, color)
	# La "nariz": muestra hacia dónde mira
	draw_circle(Vector2(mirando * radio * 0.6, -2), 4, Color("1b2230"))
