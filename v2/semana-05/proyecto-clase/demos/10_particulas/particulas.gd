extends Node2D
# Demo 10 · Tres formas de poner la explosión cuando muere el slime.
#   1 · crear el CPUParticles2D desde código y agregarlo a la arena (explotar())
#   2 · instanciar la escena explosion.tscn, armada en el editor
#   3 · el error: las partículas son hijas del slime y se borran con él

var escena_slime = preload("res://comun/slime.tscn")
var escena_explosion = preload("res://comun/explosion.tscn")
var slime = null
var modo = 1
var nombres = ["", "1 · desde código: CPUParticles2D.new()", "2 · escena: escena_explosion.instantiate()", "3 · hijas del slime: se borran con él (error)"]

func _ready():
	reponer()

func reponer():
	slime = escena_slime.instantiate()
	slime.persigue = false
	slime.position = Vector2(640, 380)
	slime.scale = Vector2(2.5, 2.5)
	add_child(slime)

func _process(delta):
	var lenta = ""
	if Engine.time_scale < 1:
		lenta = "   ·   CÁMARA LENTA (L para volver)"
	$Cartel.mostrar(nombres[modo] + lenta)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		explotar(event.position)
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var k = event.physical_keycode
	if k == KEY_SPACE and is_instance_valid(slime):
		matar_slime()
	elif k >= KEY_1 and k <= KEY_3:
		modo = k - KEY_0
	elif k == KEY_L:
		if Engine.time_scale < 1:
			Engine.time_scale = 1.0
		else:
			Engine.time_scale = 0.25

func matar_slime():
	if modo == 1:
		explotar(slime.position)
	elif modo == 2:
		var e = escena_explosion.instantiate()
		e.position = slime.position
		add_child(e)   # hija de la arena: sobrevive al slime
	elif modo == 3:
		var e = escena_explosion.instantiate()
		slime.add_child(e)   # hija del slime…
	slime.queue_free()       # …y acá se borra con él
	slime = null
	await get_tree().create_timer(1.2).timeout
	reponer()

func explotar(posicion):
	var p = CPUParticles2D.new()
	p.one_shot = true
	p.amount = 24
	p.lifetime = 0.8
	p.explosiveness = 1.0           # todas a la vez
	p.spread = 180                  # para todos lados
	p.gravity = Vector2.ZERO        # vista de arriba: no caen
	p.initial_velocity_min = 160
	p.initial_velocity_max = 260
	p.scale_amount_min = 8
	p.scale_amount_max = 12
	p.damping_min = 120             # frenan al final
	p.damping_max = 120
	var fundido = Gradient.new()    # y se desvanecen
	fundido.set_color(0, Color.WHITE)
	fundido.set_color(1, Color(1, 1, 1, 0))
	p.color_ramp = fundido
	p.color = Color("d9ff73")
	p.position = posicion
	p.finished.connect(p.queue_free)   # se borra sola al terminar
	add_child(p)
	p.emitting = true

func _exit_tree():
	Engine.time_scale = 1.0
