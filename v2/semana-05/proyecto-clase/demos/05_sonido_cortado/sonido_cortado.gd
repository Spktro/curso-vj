extends Node2D
# Demo 05 · Tres slimes, tres formas de morir (ver slime_sonido.gd).
# 1 no suena · 2 suena desde el caballero · 3 se esconde, espera la señal finished y recién se borra.

var escena_slime = preload("res://comun/slime.tscn")
var script_slime = preload("res://demos/05_sonido_cortado/slime_sonido.gd")
var titulos = ["1 · play() + queue_free()", "2 · suena el caballero", "3 · esperar finished"]
var notas = ["", "", ""]
var slimes = [null, null, null]

func _ready():
	reponer()

func reponer():
	for i in 3:
		if is_instance_valid(slimes[i]):
			slimes[i].queue_free()
		var s = escena_slime.instantiate()
		s.set_script(script_slime)
		s.modo = i + 1
		s.demo = self
		s.persigue = false
		s.choca = false
		s.position = Vector2(240 + i * 400, 300)
		s.scale = Vector2(2, 2)
		add_child(s)
		slimes[i] = s
		notas[i] = "vivo"
	queue_redraw()

func anotar(modo, texto):
	notas[modo - 1] = texto
	queue_redraw()

func _process(delta):
	$Cartel.mostrar("En los tres casos el código llama a morir(). Cambia QUIÉN toca el sonido y CUÁNDO se borra el slime.")

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var k = event.physical_keycode
	if k >= KEY_1 and k <= KEY_3:
		var s = slimes[k - KEY_1]
		if is_instance_valid(s) and s.is_in_group("enemigo"):
			s.recibir_dano(1)
	elif k == KEY_R:
		reponer()

func _draw():
	var fuente = ThemeDB.fallback_font
	for i in 3:
		var x = 240 + i * 400
		draw_string(fuente, Vector2(x - 180, 160), titulos[i], HORIZONTAL_ALIGNMENT_CENTER, 360, 24, Color("c7b3ff"))
		draw_multiline_string(fuente, Vector2(x - 180, 400), notas[i].replace("  →  ", "\n→ ").replace("  …  ", "\n… "), HORIZONTAL_ALIGNMENT_CENTER, 360, 19, -1, Color("ffe07a"))
