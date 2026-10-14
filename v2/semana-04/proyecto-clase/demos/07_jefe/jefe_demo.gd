extends Node2D
# Demo 07: si el jefe cae, aparece otro en la esquina.

var escena_jefe = preload("res://demos/07_jefe/slime_elite.tscn")

func _ready():
	$Jugador.puede_disparar = true

func _process(delta):
	if get_tree().get_nodes_in_group("enemigo").is_empty():
		var jefe = escena_jefe.instantiate()
		jefe.position = Vector2(200, 220)
		add_child(jefe)
