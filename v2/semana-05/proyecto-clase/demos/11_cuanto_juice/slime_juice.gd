extends "res://comun/slime.gd"
# Demo 11 · El slime del survivors. Cada respuesta se activa solo si el nivel de juice la incluye.

var demo   # la demo: demo.activo(n) dice si el nivel actual incluye el efecto n

func _process(delta):
	super(delta)
	if demo.activo(1):
		$AnimatedSprite2D.play("caminar")
	else:
		$AnimatedSprite2D.stop()

func recibir_dano(cantidad):
	vida -= cantidad
	if demo.activo(3):
		destello()
	if vida <= 0:
		morir()

func morir():
	remove_from_group("enemigo")
	set_process(false)
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	demo.slime_murio(position)
	if demo.activo(4):
		# pop: se infla, se desvanece y recién ahí se borra
		var tween = create_tween()
		tween.tween_property(self, "scale", scale * 1.6, 0.12)
		tween.parallel().tween_property(self, "modulate:a", 0.0, 0.12)
		tween.tween_callback(queue_free)
	else:
		queue_free()
