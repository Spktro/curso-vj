class_name Enemigo
extends Area2D
# El slime de la semana 3 (enemigo.gd del TP3), dibujado con un círculo.
# Una sola idea: ir hacia el jugador. Al tocarlo, le pega y se sacrifica.

var vida = 1
var velocidad = 90
var dano = 10
var radio = 14
var color = Color("7ccf4a")

func _ready():
	add_to_group("enemigo")
	area_entered.connect(_on_area_entered)

func _process(delta):
	# --- La IA: perseguir al jugador ---
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		return
	var direccion = (jugador.position - position).normalized()
	position += direccion * velocidad * delta

# ---- Los "botones" del enemigo ----

func recibir_dano(cantidad):
	vida -= cantidad
	if vida <= 0:
		morir()

func morir():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("jugador"):
		area.recibir_dano(dano)   # le pega…
		queue_free()              # …y se sacrifica

func _draw():
	draw_circle(Vector2.ZERO, radio, color)
	draw_circle(Vector2(-radio * 0.35, -radio * 0.2), radio * 0.18, Color.WHITE)
	draw_circle(Vector2(radio * 0.35, -radio * 0.2), radio * 0.18, Color.WHITE)
