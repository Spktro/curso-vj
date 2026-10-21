extends Node2D
# Demo 01 · Qué animación se reproduce depende del ORDEN de los if (ver animar() en caballero.gd).
# Con el orden correcto, "golpe" le gana a "run". Con O se invierte: moviéndose, el golpe no se ve.

func _ready():
	$Caballero/AnimatedSprite2D.animation_finished.connect(_on_animacion_terminada)

func _process(delta):
	var orden = "if golpeado → elif se mueve → else (correcto)"
	if not $Caballero.orden_correcto:
		orden = "if se mueve → elif golpeado → else (el golpe se pierde)"
	$Cartel.mostrar("play(\"" + $Caballero/AnimatedSprite2D.animation + "\")   ·   golpeado = " + str($Caballero.golpeado) + "   ·   " + orden)

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if event.physical_keycode == KEY_G:
		$Caballero.recibir_dano(10)
	elif event.physical_keycode == KEY_O:
		$Caballero.orden_correcto = not $Caballero.orden_correcto
	elif event.physical_keycode == KEY_M:
		$Caballero.morir()
	elif event.physical_keycode == KEY_R:
		$Caballero.revivir()

func _on_animacion_terminada():
	if $Caballero/AnimatedSprite2D.animation == "morir":
		$Caballero.modulate.a = 0.5   # acá el survivors lo borraría o pasaría al Game Over
