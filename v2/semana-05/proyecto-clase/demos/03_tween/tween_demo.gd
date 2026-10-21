extends Node2D
# Demo 03 · Tween, en dos filas.
#   Arriba: cinco efectos, uno por slime. Tecla 1 a 5: ese slime solo. Espacio: los cinco.
#   Abajo: la CURVA. Cinco slimes hacen el mismo viaje, en el mismo tiempo, cada uno con
#   una curva distinta (set_trans). Tecla C: largan todos a la vez y se comparan.

var escena_slime = preload("res://comun/slime.tscn")
var slimes = []
var etiquetas = []
var corredores = []
var nombres = ["flash", "pop", "salto", "aplastar", "girar"]
var lineas = [
	"modulate → blanco\nen 0.15 s",
	"scale × 1.6 y\nmodulate:a → 0",
	"position:y − 80\ny vuelve",
	"scale (1.4, 0.6)\ny vuelve",
	"rotation + 2π\nen 0.4 s",
]
var curvas = [Tween.TRANS_LINEAR, Tween.TRANS_SINE, Tween.TRANS_BACK, Tween.TRANS_ELASTIC, Tween.TRANS_BOUNCE]
var nombres_curvas = ["TRANS_LINEAR", "TRANS_SINE", "TRANS_BACK", "TRANS_ELASTIC", "TRANS_BOUNCE"]
var a_la_derecha = false

func _ready():
	titulo("Cinco efectos: tecla 1 a 5 para uno solo, Espacio para los cinco", 112)
	for i in 5:
		var etiqueta = Label.new()
		etiqueta.text = str(i + 1) + " · " + nombres[i] + "\n" + lineas[i]
		etiqueta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		etiqueta.add_theme_font_size_override("font_size", 18)
		etiqueta.position = Vector2(160 + i * 240 - 110, 285)
		etiqueta.size = Vector2(220, 90)
		add_child(etiqueta)
		etiquetas.append(etiqueta)
	reponer()
	titulo("La curva: el mismo viaje en 1 s, con cinco curvas distintas · tecla C para largar", 405)
	for i in 5:
		var c = escena_slime.instantiate()
		c.persigue = false
		c.position = Vector2(340, 470 + i * 42)
		c.scale = Vector2(0.75, 0.75)
		add_child(c)
		corredores.append(c)
		var nombre = Label.new()
		nombre.text = "set_trans(Tween." + nombres_curvas[i] + ")"
		nombre.add_theme_font_size_override("font_size", 17)
		nombre.add_theme_color_override("font_color", Color("c7b3ff"))
		nombre.position = Vector2(30, 458 + i * 42)
		add_child(nombre)

func titulo(texto, y):
	var t = Label.new()
	t.text = texto
	t.add_theme_font_size_override("font_size", 21)
	t.add_theme_color_override("font_color", Color("ffe07a"))
	t.position = Vector2(30, y)
	add_child(t)

func reponer():
	for s in slimes:
		if is_instance_valid(s):
			s.queue_free()
	slimes = []
	for i in 5:
		var s = escena_slime.instantiate()
		s.persigue = false
		s.position = Vector2(160 + i * 240, 225)
		s.scale = Vector2(1.6, 1.6)
		add_child(s)
		slimes.append(s)

func _process(delta):
	$Cartel.mostrar("R: reponer los slimes de arriba (el pop los borra)   ·   abajo, misma distancia y mismo tiempo: solo cambia la curva")

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var k = event.physical_keycode
	if k == KEY_SPACE:
		for i in 5:
			efecto(i)
	elif k >= KEY_1 and k <= KEY_5:
		efecto(k - KEY_1)
	elif k == KEY_C:
		largar()
	elif k == KEY_R:
		reponer()

func efecto(i):
	resaltar(etiquetas[i])
	var s = slimes[i]
	if not is_instance_valid(s):
		return
	var sprite = s.get_node("AnimatedSprite2D")
	if i == 0:
		# flash: rojo de golpe, y vuelve a blanco en 0.15 s
		sprite.modulate = Color(1, 0.3, 0.3)
		var tween = s.create_tween()
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)
	elif i == 1:
		# pop: se infla y se desvanece a la vez; al final, se borra
		var tween = s.create_tween()
		tween.tween_property(s, "scale", s.scale * 1.6, 0.12)
		tween.parallel().tween_property(s, "modulate:a", 0.0, 0.12)
		tween.tween_callback(s.queue_free)
	elif i == 2:
		# salto: sube y vuelve
		var tween = s.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(s, "position:y", 225 - 80, 0.2)
		tween.tween_property(s, "position:y", 225, 0.25).set_ease(Tween.EASE_IN)
	elif i == 3:
		# aplastar (squash): se achata y vuelve a su forma, con un rebote
		var tween = s.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(s, "scale", Vector2(2.24, 0.96), 0.08)
		tween.tween_property(s, "scale", Vector2(1.6, 1.6), 0.35)
	elif i == 4:
		# girar: una vuelta completa
		var tween = s.create_tween()
		tween.tween_property(s, "rotation", s.rotation + TAU, 0.4)

func largar():
	# Los cinco van al otro lado (o vuelven) en 1 s; lo único distinto es la curva
	a_la_derecha = not a_la_derecha
	var destino = 340
	if a_la_derecha:
		destino = 900
	for i in 5:
		var tween = corredores[i].create_tween().set_trans(curvas[i]).set_ease(Tween.EASE_OUT)
		tween.tween_property(corredores[i], "position:x", destino, 1.0)

func resaltar(etiqueta):
	# también es un Tween: la etiqueta se pone amarilla y vuelve a blanco
	etiqueta.modulate = Color(1, 0.85, 0.2)
	var tween = etiqueta.create_tween()
	tween.tween_property(etiqueta, "modulate", Color.WHITE, 0.5)
