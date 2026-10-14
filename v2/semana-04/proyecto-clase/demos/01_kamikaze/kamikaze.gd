extends Node2D
# Demo 01: el slime de la semana 3. Siempre hace lo mismo: ir derecho al jugador.
# Mantiene cuatro slimes en pantalla; cuando uno se sacrifica, aparece otro por un borde.

var escena_slime = preload("res://comun/slime.tscn")
var cantidad = 4
var golpes = 0

func _ready():
	$Jugador.area_entered.connect(_on_jugador_tocado)

func _process(delta):
	if get_tree().get_nodes_in_group("enemigo").size() < cantidad:
		aparecer()
	$Cartel.mostrar("Golpes recibidos: " + str(golpes) + "   ·   ¿Qué va a hacer el próximo slime? Siempre lo mismo.")

func aparecer():
	var slime = escena_slime.instantiate()
	slime.position = punto_en_borde()
	add_child(slime)

func punto_en_borde():
	match randi() % 4:
		0:
			return Vector2(randf_range(0, 1280), -20)
		1:
			return Vector2(randf_range(0, 1280), 740)
		2:
			return Vector2(-20, randf_range(100, 720))
		_:
			return Vector2(1300, randf_range(100, 720))

func _on_jugador_tocado(area):
	if area.is_in_group("enemigo"):
		golpes += 1
