extends Area2D
# La bala del survivors: va en línea recta y le pega al primer enemigo que toca.

var velocidad = 420
var direccion = Vector2.RIGHT

func _ready():
	area_entered.connect(_on_area_entered)

func _process(delta):
	position += direccion * velocidad * delta
	if not get_viewport_rect().has_point(position):
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemigo"):
		area.recibir_dano(1)
		queue_free()
