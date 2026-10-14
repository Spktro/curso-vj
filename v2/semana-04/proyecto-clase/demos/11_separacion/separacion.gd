extends Node2D
# Demo 11: un spawner que no para y la tecla M para cambiar de modo.
# Abajo se muestra cuántos enemigos hay, cuántas comparaciones se hicieron en el frame y los FPS.

var escena_slime = preload("res://demos/11_separacion/slime_separado.tscn")
var modo = SlimeSeparado.Modo.SIN_SEPARAR
var por_segundo = 10
var maximo = 300
var acumulado = 0.0
var nombres = ["SIN SEPARAR", "VECINOS (con el Area2D)", "TODOS CONTRA TODOS"]

func _process(delta):
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	var cantidad = enemigos.size()
	acumulado += delta * por_segundo
	while acumulado >= 1:
		acumulado -= 1
		if cantidad < maximo:
			aparecer()
			cantidad += 1

	var comparaciones = 0
	for enemigo in enemigos:
		comparaciones += enemigo.revisados
	$Cartel.mostrar("Modo: %s   ·   enemigos: %d de %d   ·   comparaciones en este frame: %d   ·   FPS: %d" % [nombres[modo], enemigos.size(), maximo, comparaciones, Engine.get_frames_per_second()])

func aparecer():
	var slime = escena_slime.instantiate()
	slime.position = punto_en_borde()
	slime.modo = modo
	add_child(slime)

func punto_en_borde():
	match randi() % 4:
		0:
			return Vector2(randf_range(0, 1280), -20)
		1:
			return Vector2(randf_range(0, 1280), 740)
		2:
			return Vector2(-20, randf_range(100, 720))
		_:
			return Vector2(1300, randf_range(100, 720))

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.physical_keycode:
		KEY_M:
			modo = (modo + 1) % 3
			for enemigo in get_tree().get_nodes_in_group("enemigo"):
				enemigo.modo = modo
		KEY_UP:
			maximo += 100
		KEY_DOWN:
			maximo = max(100, maximo - 100)
		KEY_C:
			for enemigo in get_tree().get_nodes_in_group("enemigo"):
				enemigo.queue_free()
