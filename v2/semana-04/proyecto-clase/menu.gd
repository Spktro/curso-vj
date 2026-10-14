extends Control
# Menú de demos. Cada botón abre una escena; Esc vuelve acá desde cualquier demo.

# [texto, escena, columna]. Sin escena = título de bloque.
var demos = [
	["Bloque 0 · Apertura", "", 0],
	["01 · El slime de la semana 3: una sola idea", "res://demos/01_kamikaze/kamikaze.tscn", 0],
	["Bloque 1 · Qué es la IA de un juego", "", 0],
	["02 · Pac-Man: Blinky y Pinky", "res://demos/02_fantasmas/fantasmas.tscn", 0],
	["03 · Space Invaders: menos aliens, más rápido", "res://demos/03_invaders/invaders.tscn", 0],
	["Bloque 2 · Máquina de estados, sin juegos", "", 0],
	["04 · El semáforo: una clase con estados", "res://demos/04_semaforo/semaforo_demo.tscn", 0],
	["Bloque 3 · Del semáforo al enemigo", "", 1],
	["05 · Detectar: por distancia o con un cono", "res://demos/05_deteccion/deteccion.tscn", 1],
	["06 · El jefe escrito con booleanos (spaghetti)", "res://demos/06_spaghetti/spaghetti.tscn", 1],
	["07 · El jefe con máquina de estados", "res://demos/07_jefe/jefe.tscn", 1],
	["08 · Histéresis: ¿por qué 40 y 60?", "res://demos/08_histeresis/histeresis.tscn", 1],
	["Bloque 4 · FSM en juegos conocidos", "", 1],
	["09 · Pac-Man: los estados del fantasma", "res://demos/09_pacman_estados/pacman_estados.tscn", 1],
	["10 · Boo: avanza o se tapa", "res://demos/10_boo/boo.tscn", 1],
	["Bloque 5 · La IA no siempre es un enemigo", "", 1],
	["11 · El grupo: que no se apilen", "res://demos/11_separacion/separacion.tscn", 1],
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
