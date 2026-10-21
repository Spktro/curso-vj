extends Node2D
# Demo 07 · Dos buses además de Master (ver default_bus_layout.tres o el panel Audio de abajo).
# La música va al bus "Musica" y los disparos al bus "Efectos" (propiedad Bus de cada AudioStreamPlayer).

var escena_bala = preload("res://comun/bala.tscn")
var volumen_musica = 1.0
var volumen_efectos = 1.0

func _ready():
	$Musica.finished.connect($Musica.play)   # loop sin tocar la importación

func _process(delta):
	$Cartel.mostrar("AudioServer.set_bus_volume_db(bus, linear_to_db(" + str(volumen_musica).pad_decimals(1) + "))  en Musica   ·   linear_to_db(" + str(volumen_efectos).pad_decimals(1) + ")  en Efectos")
	queue_redraw()

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var k = event.physical_keycode
	if k == KEY_SPACE:
		disparar()
	elif k == KEY_UP:
		volumen_musica = min(volumen_musica + 0.1, 1.0)
	elif k == KEY_DOWN:
		volumen_musica = max(volumen_musica - 0.1, 0.0)
	elif k == KEY_RIGHT:
		volumen_efectos = min(volumen_efectos + 0.1, 1.0)
	elif k == KEY_LEFT:
		volumen_efectos = max(volumen_efectos - 0.1, 0.0)
	elif k == KEY_M:
		var bus = AudioServer.get_bus_index("Musica")
		AudioServer.set_bus_mute(bus, not AudioServer.is_bus_mute(bus))
	aplicar()

func aplicar():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), linear_to_db(volumen_musica))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Efectos"), linear_to_db(volumen_efectos))

func disparar():
	var bala = escena_bala.instantiate()
	bala.position = $Caballero.position + Vector2(30, 0)
	add_child(bala)
	$Caballero/SfxDisparo.pitch_scale = randf_range(0.9, 1.1)
	$Caballero/SfxDisparo.play()

func _exit_tree():
	# al volver al menú, los buses quedan como estaban
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Efectos"), 0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Musica"), false)

func _draw():
	var fuente = ThemeDB.fallback_font
	var barras = [["Musica", volumen_musica, Color("a78bfa")], ["Efectos", volumen_efectos, Color("4ade80")]]
	for i in 2:
		var x = 640 + i * 260
		var alto = 360 * barras[i][1]
		draw_rect(Rect2(x, 180, 120, 360), Color(1, 1, 1, 0.12))
		var color = barras[i][2]
		if i == 0 and AudioServer.is_bus_mute(AudioServer.get_bus_index("Musica")):
			color = Color(0.5, 0.5, 0.5)
		draw_rect(Rect2(x, 540 - alto, 120, alto), color)
		draw_string(fuente, Vector2(x, 580), barras[i][0], HORIZONTAL_ALIGNMENT_CENTER, 120, 24, Color.WHITE)
		draw_string(fuente, Vector2(x, 612), str(int(barras[i][1] * 100)) + " %", HORIZONTAL_ALIGNMENT_CENTER, 120, 20, Color(0.8, 0.82, 0.9))
