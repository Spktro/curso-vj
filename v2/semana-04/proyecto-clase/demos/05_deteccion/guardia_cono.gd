extends Node2D
# Detecta con dos Area2D en forma de cono, como los soldados de Commandos.
# Cono CERCA (claro): lo ve siempre. Cono LEJOS (oscuro): solo si está de pie.
# Los conos son hijos de $Vision, que gira de un lado a otro: el guardia "barre" con la mirada.

var tiempo = 0.0
var lo_ve = false

func _process(delta):
	tiempo += delta
	$Vision.rotation = PI + sin(tiempo * 0.6) * 0.9   # mira a la izquierda y barre

	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		return
	var en_cerca = $Vision/ConoCerca.overlaps_area(jugador)
	var en_lejos = $Vision/ConoLejos.overlaps_area(jugador)
	# --- La regla de Commandos ---
	lo_ve = en_cerca or (en_lejos and not jugador.agachado)

	if lo_ve:
		$LabelEstado.text = "¡TE VEO!"
	elif en_lejos:
		$LabelEstado.text = "(agachado: no lo ve)"
	else:
		$LabelEstado.text = "…"
	queue_redraw()

func _draw():
	# Se dibujan los mismos polígonos que usan las Area2D, girados con $Vision
	var lejos = $Vision.transform * $Vision/ConoLejos/CollisionPolygon2D.polygon
	var cerca = $Vision.transform * $Vision/ConoCerca/CollisionPolygon2D.polygon
	var color_lejos = Color(0.3, 0.33, 0.4, 0.55)
	var color_cerca = Color(1, 0.84, 0.29, 0.55)
	if lo_ve:
		color_lejos = Color(0.9, 0.3, 0.3, 0.45)
		color_cerca = Color(1, 0.35, 0.35, 0.6)
	draw_colored_polygon(lejos, color_lejos)
	draw_colored_polygon(cerca, color_cerca)
	draw_circle(Vector2.ZERO, 18, Color("556b4f"))
