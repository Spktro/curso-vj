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
	$Cartel.mostrar(nombres[modo])

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
	await get_tree().create_timer(0.8).timeout
	reponer()

func explotar(posicion):
	var p = CPUParticles2D.new()
	p.one_shot = true
	p.amount = 12
	p.lifetime = 0.4
	p.explosiveness = 1.0           # todas a la vez
	p.spread = 180                  # para todos lados
	p.gravity = Vector2.ZERO        # vista de arriba: no caen
	p.initial_velocity_min = 80
	p.initial_velocity_max = 140
	p.scale_amount_min = 4
	p.scale_amount_max = 6
	p.color = Color("a3e635")
	p.position = posicion
	p.finished.connect(p.queue_free)   # se borra sola al terminar
	add_child(p)
	p.emitting = true
