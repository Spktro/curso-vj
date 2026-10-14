extends Node2D
# Detecta por DISTANCIA: un solo número. Simple y barato.
# Ve a través de todo: de espaldas, detrás de una pared, agachado o de pie.

var radio_vision = 200
var lo_ve = false

func _process(delta):
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		return
	lo_ve = position.distance_to(jugador.position) < radio_vision
	if lo_ve:
		$LabelEstado.text = "¡TE VEO!"
	else:
		$LabelEstado.text = "…"
	queue_redraw()

func _draw():
	var color = Color(0.6, 0.65, 0.75, 0.15)
	if lo_ve:
		color = Color(1, 0.3, 0.3, 0.25)
	draw_circle(Vector2.ZERO, radio_vision, color)
	draw_arc(Vector2.ZERO, radio_vision, 0, TAU, 64, Color(0.6, 0.65, 0.75, 0.8), 2.0)
	draw_circle(Vector2.ZERO, 18, Color("556b4f"))
	draw_string(ThemeDB.fallback_font, Vector2(-60, radio_vision + 28), "radio: " + str(radio_vision) + " px", HORIZONTAL_ALIGNMENT_CENTER, 120, 18, Color("9aa5b8"))
