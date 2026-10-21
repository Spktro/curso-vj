extends Control
# Menú de demos. Cada botón abre una escena; Esc vuelve acá desde cualquier demo.

# [texto, escena, columna]. Sin escena = título de bloque.
var demos = [
	["Animación", "", 0],
	["01 · AnimatedSprite2D: el orden es la prioridad", "res://demos/01_prioridad/prioridad.tscn", 0],
	["02 · AnimationPlayer: el parpadeo de daño", "res://demos/02_parpadeo/parpadeo.tscn", 0],
	["03 · Tween: flash, pop, salto, aplastar, girar", "res://demos/03_tween/tween_demo.tscn", 0],
	["Sonido", "", 0],
	["04 · Que no canse: pitch_scale al azar", "res://demos/04_pitch/pitch.tscn", 0],
	["05 · El slime muere y se lleva su sonido", "res://demos/05_sonido_cortado/sonido_cortado.tscn", 0],
	["06 · Encadenar: cada señal dispara lo que sigue", "res://demos/06_encadenar/encadenar.tscn", 0],
	["07 · Buses: música y efectos por separado", "res://demos/07_buses/buses.tscn", 0],
	["Efectos", "", 1],
	["08 · Screenshake: la cámara tiembla", "res://demos/08_screenshake/screenshake.tscn", 1],
	["09 · Hit stop: congelar el tiempo un instante", "res://demos/09_hit_stop/hit_stop.tscn", 1],
	["10 · Partículas: desde código, escena o hija", "res://demos/10_particulas/particulas.tscn", 1],
	["Diseño", "", 1],
	["11 · Cuánto juice es demasiado (el survivors)", "res://demos/11_cuanto_juice/cuanto_juice.tscn", 1],
]

func _ready():
	var primero = null
	for demo in demos:
		var columna = $Columnas.get_child(demo[2])
		if demo[1] == "":
			var titulo = Label.new()
			titulo.text = demo[0]
			titulo.add_theme_font_size_override("font_size", 20)
			titulo.add_theme_color_override("font_color", Color("a78bfa"))
			columna.add_child(titulo)
		else:
			var boton = Button.new()
			boton.text = demo[0]
			boton.alignment = HORIZONTAL_ALIGNMENT_LEFT
			boton.add_theme_font_size_override("font_size", 19)
			var escena = demo[1]
			boton.pressed.connect(func(): get_tree().change_scene_to_file(escena))
			columna.add_child(boton)
			if primero == null:
				primero = boton
	primero.grab_focus()
