extends Node2D
# Demo 09 · Los slimes van y vienen. Espacio le pega al más cercano: flash, empujón y,
# si está prendido, hit stop (Engine.time_scale = 0.05 durante unos milisegundos REALES).
# Con 0.25 s ya no se siente un impacto: se siente un tirón, como si el juego se trabara.

var escena_slime = preload("res://comun/slime.tscn")
var slimes = []
var hit_stop = true
var duracion = 0.06
var tiempo = 0.0

func _ready():
	for i in 5:
		var s = escena_slime.instantiate()
		s.persigue = false
		s.choca = false
		s.position = Vector2(560 + i * 140, 200 + i * 90)
		s.scale = Vector2(1.5, 1.5)
		add_child(s)
		slimes.append(s)

func _process(delta):
	# delta ya viene multiplicado por Engine.time_scale: durante el hit stop, casi no se mueven
	tiempo += delta
	for i in slimes.size():
		slimes[i].position.x = 760 + sin(tiempo * 2 + i) * 200
	var estado = "NO"
	if hit_stop:
		estado = "SÍ, " + str(duracion) + " s"
	$Cartel.mostrar("hit stop: " + estado + "   ·   Engine.time_scale = " + str(Engine.time_scale))

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var k = event.physical_keycode
	if k == KEY_SPACE:
		golpear()
	elif k == KEY_H:
		hit_stop = not hit_stop
	elif k == KEY_1:
		duracion = 0.03
	elif k == KEY_2:
		duracion = 0.06
	elif k == KEY_3:
		duracion = 0.25

func golpear():
	var objetivo = slimes[0]
	for s in slimes:
		if s.position.distance_to($Caballero.position) < objetivo.position.distance_to($Caballero.position):
			objetivo = s
	objetivo.destello()
	$Caballero/SfxGolpe.play()
	var sprite = objetivo.get_node("AnimatedSprite2D")
	var tween = create_tween()
	tween.tween_property(sprite, "position", Vector2(12, 0), 0.05)
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.1)
	if hit_stop:
		frenar_tiempo()

func frenar_tiempo():
	Engine.time_scale = 0.05     # todo va al 5 %
	# esperar REALES (el último true: ignorar time_scale)
	await get_tree().create_timer(duracion, true, false, true).timeout
	Engine.time_scale = 1.0      # de vuelta a la normalidad

func _exit_tree():
	Engine.time_scale = 1.0
