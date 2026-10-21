extends Node2D
# Demo 02 · El caballero tiene un AnimationPlayer con dos animaciones de 0.4 s sobre
# AnimatedSprite2D:modulate. "golpe" termina en blanco; "golpe_sin_final" no tiene el
# último keyframe y el caballero queda rojo. Abrir caballero.tscn → AnimationPlayer para verlas.
# Abajo se dibuja la línea de tiempo con el cabezal.

func _process(delta):
	var anim = $Caballero.anim_golpe
	var color = $Caballero/AnimatedSprite2D.modulate
	$Cartel.mostrar("AnimationPlayer.play(\"" + anim + "\")   ·   modulate = " + str(color.r).pad_decimals(1) + ", " + str(color.g).pad_decimals(1) + ", " + str(color.b).pad_decimals(1))
	queue_redraw()

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if event.physical_keycode == KEY_G:
		$Caballero.recibir_dano(10)
	elif event.physical_keycode == KEY_B:
		if $Caballero.anim_golpe == "golpe":
			$Caballero.anim_golpe = "golpe_sin_final"
		else:
			$Caballero.anim_golpe = "golpe"
		$Caballero/AnimatedSprite2D.modulate = Color.WHITE

func _draw():
	# La línea de tiempo: un casillero cada 0.1 s, como en la diapositiva
	var colores = [Color.WHITE, Color(1, 0.3, 0.3), Color.WHITE, Color(1, 0.3, 0.3), Color.WHITE]
	var cantidad = 5
	if $Caballero.anim_golpe == "golpe_sin_final":
		cantidad = 4
	var x0 = 390
	var ancho = 100
	var fuente = ThemeDB.fallback_font
	for i in 5:
		var caja = Rect2(x0 + i * ancho + 4, 520, ancho - 8, 70)
		if i < cantidad:
			draw_rect(caja, colores[i])
		else:
			draw_rect(caja, Color(1, 1, 1, 0.25), false, 2)
			draw_string(fuente, caja.position + Vector2(10, 42), "falta", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(1, 1, 1, 0.6))
		draw_string(fuente, Vector2(x0 + i * ancho + 30, 615), str(i * 0.1).pad_decimals(1) + " s", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.8, 0.82, 0.9))
	# El cabezal: dónde está la animación ahora
	var player = $Caballero/AnimationPlayer
	if player.is_playing():
		var x = x0 + 50 + player.current_animation_position / 0.1 * ancho
		draw_line(Vector2(x, 505), Vector2(x, 600), Color("ffd54a"), 4)
