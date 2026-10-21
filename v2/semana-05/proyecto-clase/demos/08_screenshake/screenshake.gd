extends Node2D
# Demo 08 · La Arena tiene una Camera2D (Camara) en 0, 0 con Anchor Mode = Fixed Top Left:
# muestra lo mismo que sin cámara. Sacudir = mover su offset unos píxeles con un Tween.
# El cartel está en un CanvasLayer: no tiembla, igual que el HUD del survivors.

var escena_slime = preload("res://comun/slime.tscn")
var intensidad = 6

func _ready():
	for i in 8:
		var s = escena_slime.instantiate()
		s.persigue = false
		s.position = Vector2(180 + i * 130, 200 + (i % 2) * 340)
		add_child(s)

func _process(delta):
	$Cartel.mostrar("Intensidad: " + str(intensidad) + " px   ·   5 saltos al azar de 0.03 s y vuelta al centro   ·   camara.offset = " + str($Camara.offset.round()))

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var k = event.physical_keycode
	if k == KEY_SPACE:
		sacudir_camara()
	elif k == KEY_1:
		intensidad = 3
	elif k == KEY_2:
		intensidad = 6
	elif k == KEY_3:
		intensidad = 15

func sacudir_camara():
	var camara = $Camara
	var tween = create_tween()
	for i in 5:        # cinco saltitos al azar…
		var salto = Vector2(randf_range(-intensidad, intensidad), randf_range(-intensidad, intensidad))
		tween.tween_property(camara, "offset", salto, 0.03)
	tween.tween_property(camara, "offset", Vector2.ZERO, 0.03)   # …y al centro
