extends Node2D
# Demo 03: Space Invaders. Los aliens se mueven en bloque y aceleran a medida que mueren.
# En el original fue un accidente del hardware: con menos sprites, dibujaba más rápido.

var columnas = 11
var filas = 5
var total = 55
var vivos = 55
var aliens = []                 # true = vivo, false = muerto
var velocidad_base = 20
var velocidad = 20
var flota = Vector2(160, 150)   # posición de la esquina de la flota
var sentido = 1                 # 1 = derecha, -1 = izquierda
var separacion = Vector2(52, 44)

# El dibujo de un alien: "#" = un píxel encendido
var dibujo = [
	"..#.....#..",
	"...#...#...",
	"..#######..",
	".##.###.##.",
	"###########",
	"#.#######.#",
	"#.#.....#.#",
	"...##.##...",
]

func _ready():
	reiniciar()

func reiniciar():
	aliens = []
	for i in total:
		aliens.append(true)
	vivos = total
	velocidad = velocidad_base
	flota = Vector2(160, 150)
	sentido = 1

func _process(delta):
	flota.x += sentido * velocidad * delta
	# Si el alien vivo de una punta toca el borde: bajan una fila y cambian de sentido
	var izquierda = 9999.0
	var derecha = -9999.0
	for f in filas:
		for c in columnas:
			if aliens[f * columnas + c]:
				var x = flota.x + c * separacion.x
				izquierda = min(izquierda, x)
				derecha = max(derecha, x + 33)
	if derecha > 1250 and sentido == 1:
		sentido = -1
		flota.y += 18
	elif izquierda < 30 and sentido == -1:
		sentido = 1
		flota.y += 18
	if flota.y > 400:
		flota.y = 150
	$Cartel.mostrar("Vivos: %d de %d   ·   velocidad: %d px/s   ·   %.1f veces más rápido que al empezar" % [vivos, total, velocidad, velocidad / float(velocidad_base)])
	queue_redraw()

# --- Toda la "IA" del juego: una línea ---
func _on_alien_muerto():
	vivos -= 1
	velocidad = velocidad_base * (float(total) / vivos)

func matar_uno():
	var candidatos = []
	for i in total:
		if aliens[i]:
			candidatos.append(i)
	aliens[candidatos.pick_random()] = false
	_on_alien_muerto()

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if event.physical_keycode == KEY_SPACE and vivos > 1:
		matar_uno()
	elif event.physical_keycode == KEY_K:
		while vivos > 1:
			matar_uno()
	elif event.physical_keycode == KEY_R:
		reiniciar()

func _draw():
	for f in filas:
		for c in columnas:
			if aliens[f * columnas + c]:
				dibujar_alien(flota + Vector2(c, f) * separacion)
	# El cañón del jugador, solo de adorno
	draw_rect(Rect2(620, 640, 40, 14), Color("5ac8ff"))
	draw_rect(Rect2(636, 630, 8, 12), Color("5ac8ff"))

func dibujar_alien(esquina):
	for fila in dibujo.size():
		for col in dibujo[fila].length():
			if dibujo[fila][col] == "#":
				draw_rect(Rect2(esquina + Vector2(col, fila) * 3, Vector2(3, 3)), Color("7cf29a"))
