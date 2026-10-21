extends Node2D
# Demo 06 · Desencadenantes: cada paso arranca cuando el anterior AVISA que terminó (una señal).
#   morir → animación "morir" → animation_finished → sonido → finished → cartel + Timer → timeout → reiniciar
# Con X se hace todo en el mismo frame, sin esperar: se pisa todo.

var registro = []
var inicio = 0

func _process(delta):
	$Cartel.mostrar("await señal  =  \"pausar esta función hasta que llegue la señal\". El resto del juego sigue andando.")

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if $Caballero.muerto:
		return
	if event.physical_keycode == KEY_K:
		morir_encadenado()
	elif event.physical_keycode == KEY_X:
		morir_todo_junto()

func morir_encadenado():
	empezar()
	anotar("morir(): empieza la animación \"morir\"")
	$Caballero.morir()
	await $Caballero/AnimatedSprite2D.animation_finished
	anotar("animation_finished  →  suena el game over")
	$SfxGameOver.play()
	await $SfxGameOver.finished
	anotar("finished (el sonido)  →  cartel GAME OVER + Timer de 1.5 s")
	$CartelGameOver.show()
	$TimerReinicio.start()
	await $TimerReinicio.timeout
	anotar("timeout  →  reiniciar")
	reiniciar()

func morir_todo_junto():
	empezar()
	anotar("morir() + play() + cartel + reiniciar, todo en el mismo frame")
	$Caballero.morir()
	$SfxGameOver.play()
	$CartelGameOver.show()
	reiniciar()
	anotar("el caballero revivió antes de terminar de caer; el sonido sigue solo")

func empezar():
	registro = []
	inicio = Time.get_ticks_msec()

func anotar(texto):
	var ms = Time.get_ticks_msec() - inicio
	registro.append(str(ms).lpad(5) + " ms   " + texto)
	queue_redraw()

func reiniciar():
	$CartelGameOver.hide()
	$Caballero.revivir()

func _draw():
	var fuente = ThemeDB.fallback_font
	draw_string(fuente, Vector2(560, 170), "Registro", HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("c7b3ff"))
	for i in registro.size():
		draw_string(fuente, Vector2(560, 220 + i * 44), registro[i], HORIZONTAL_ALIGNMENT_LEFT, 710, 20, Color("ffe07a"))
