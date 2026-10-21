extends CanvasLayer
# El cartel de arriba de cada demo: título y teclas.
# La línea de abajo ($Info) la va actualizando cada demo.

@export var titulo = ""
@export_multiline var ayuda = ""

func _ready():
	$Titulo.text = titulo
	$Ayuda.text = ayuda + "   ·   Esc: menú"

func mostrar(texto):
	$Info.text = texto
