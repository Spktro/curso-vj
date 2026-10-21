extends Node2D
# Demo 03 · Cinco Tweens distintos sobre cinco slimes quietos.
# Debajo de cada uno se lee la línea que lo anima. T cambia la curva de "salto" y "aplastar".

var escena_slime = preload("res://comun/slime.tscn")
var slimes = []
var curvas = [Tween.TRANS_LINEAR, Tween.TRANS_SINE, Tween.TRANS_BACK, Tween.TRANS_ELASTIC, Tween.TRANS_BOUNCE]
var nombres_curvas = ["TRANS_LINEAR", "TRANS_SINE", "TRANS_BACK", "TRANS_ELASTIC", "TRANS_BOUNCE"]
var curva = 2
var textos = [
	"1 · flash\nmodulate → blanco\nen 0.15 s",
	"2 · pop\nscale × 1.6 y\nmodulate:a → 0",
	"3 · salto\nposition:y − 80\ny vuelve",
	"4 · aplastar\nscale (1.4, 0.6)\ny vuelve",
	"5 · girar\nrotation + 2π\nen 0.4 s",
]

func _ready():
	for i in 5:
		var etiqueta = Label.new()
		etiqueta.text = textos[i]
		etiqueta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		etiqueta.add_theme_font_size_override("font_size", 19)
		etiqueta.position = Vector2(160 + i * 240 - 100, 470)
		etiqueta.size = Vector2(200, 100)
		add_child(etiqueta)
	reponer()

func reponer():
	for s in slimes:
		if is_instance_valid(s):
			s.queue_free()
	slimes = []
	for i in 5:
		var s = escena_slime.instantiate()
		s.persigue = false
		s.position = Vector2(160 + i * 240, 380)
		s.scale = Vector2(2, 2)
		add_child(s)
		slimes.append(s)

func _process(delta):
	$Cartel.mostrar("Curva de salto y aplastar: tween.set_trans(Tween." + nombres_curvas[curva] + ")   ·   T para cambiarla")

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var k = event.physical_keycode
	if k == KEY_SPACE:
		for i in 5:
			efecto(i)
	elif k >= KEY_1 and k <= KEY_5:
		efecto(k - KEY_1)
	elif k == KEY_T:
		curva = (curva + 1) % curvas.size()
	elif k == KEY_R:
		reponer()

func efecto(i):
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
		# salto: sube y vuelve, con la curva elegida
		var y = 380
		var tween = s.create_tween().set_trans(curvas[curva]).set_ease(Tween.EASE_OUT)
		tween.tween_property(s, "position:y", y - 80, 0.25)
		tween.tween_property(s, "position:y", y, 0.35)
	elif i == 3:
		# aplastar (squash): se achata y vuelve a su forma
		var tween = s.create_tween().set_trans(curvas[curva]).set_ease(Tween.EASE_OUT)
		tween.tween_property(s, "scale", Vector2(2.8, 1.2), 0.08)
		tween.tween_property(s, "scale", Vector2(2, 2), 0.4)
	elif i == 4:
		# girar: una vuelta completa
		var tween = s.create_tween()
		tween.tween_property(s, "rotation", s.rotation + TAU, 0.4)
