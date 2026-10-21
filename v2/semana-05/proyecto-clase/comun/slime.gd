extends Area2D
# El slime común. Si persigue = true, camina hacia el caballero.
# Las demos que necesitan otra conducta al morir extienden este script.

var velocidad = 60
var vida = 1
var dano = 10
var persigue = true
var choca = true    # en false, tocar al caballero no le hace nada (demos donde el slime es de muestra)

func _ready():
	add_to_group("enemigo")
	body_entered.connect(_on_body_entered)

func _process(delta):
	if not persigue:
		return
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		return
	var direccion = (jugador.position - position).normalized()
	position += direccion * velocidad * delta
	$AnimatedSprite2D.flip_h = direccion.x < 0

func recibir_dano(cantidad):
	vida -= cantidad
	destello()
	if vida <= 0:
		morir()

func destello():
	$AnimatedSprite2D.modulate = Color(1, 0.3, 0.3)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.15)

func morir():
	queue_free()

func _on_body_entered(body):
	if choca and body.is_in_group("jugador"):
		body.recibir_dano(dano)
		queue_free()
