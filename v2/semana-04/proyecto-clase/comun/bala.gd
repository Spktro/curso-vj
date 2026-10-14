extends Area2D
# La bala del survivors: va en línea recta y le pega al primer enemigo que toca.

var velocidad = 520
var direccion = Vector2.RIGHT
var dano = 1

func _ready():
	area_entered.connect(_on_area_entered)

func _process(delta):
	position += direccion * velocidad * delta
	if position.x < -50 or position.x > 1330 or position.y < -50 or position.y > 770:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemigo"):
		area.recibir_dano(dano)
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 5, Color("ffe13a"))
