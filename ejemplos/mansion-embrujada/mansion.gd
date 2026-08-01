extends Node

# =====================================================================
#  LA MANSION EMBRUJADA  🏚️
#  Una aventura de texto para la consola (panel Output) de Godot.
#
#  Sirve para explicar, con una historia de terror:
#    • VARIABLES    -> el ESTADO del juego (donde estas, que tenes)
#    • ARREGLOS     -> el inventario (una lista de items)
#    • IF/ELIF/ELSE -> las DECISIONES (¿podes pasar? ¿que hay aca?)
#    • FUNCIONES    -> acciones con nombre (avanzar, agarrar, describir)
#    • INPUT        -> reaccionar a las flechas del teclado
#
#  CONTROLES (hace clic en la ventana del juego para darle foco):
#    →  avanzar          ←  retroceder
#    ↑  agarrar item     ENTER  mirar la habitacion de nuevo
# =====================================================================


# ---- VARIABLES: el ESTADO del juego -------------------------------
var habitacion = 0            # en que habitacion estamos (empieza en la 0)
var vida = 100                # por si algo nos lastima
var inventario = []           # ARREGLO vacio: aca guardamos los items
var terminado = false         # true cuando el juego se acaba

# Nombre de cada habitacion (ARREGLO: la posicion 0 es la primera)
var habitaciones = [
	"el Porton de entrada",
	"el Recibidor",
	"el Pasillo oscuro",
	"la Biblioteca",
	"la Puerta del Sotano",
	"el Sotano",
]


func _ready():
	print("=== 🏚️  LA MANSION EMBRUJADA  🏚️ ===")
	print("Una tormenta te obligo a entrar. La puerta se cerro sola detras tuyo...")
	print("Controles:  →  avanzar   ←  retroceder   ↑  agarrar   ENTER  mirar")
	print("")
	describir()


# ---- INPUT: reaccionar a las teclas -------------------------------
# _process() corre en CADA frame (~60 por segundo) y revisa el teclado.
func _process(delta):
	if terminado:
		return   # si el juego termino, ignoramos las teclas

	if Input.is_action_just_pressed("ui_right"):    # flecha →
		avanzar()
	if Input.is_action_just_pressed("ui_left"):     # flecha ←
		retroceder()
	if Input.is_action_just_pressed("ui_up"):       # flecha ↑
		agarrar()
	if Input.is_action_just_pressed("ui_accept"):   # ENTER / Espacio
		describir()


# ---- FUNCIONES: cada una hace UNA cosa con nombre -----------------

# Describe la habitacion actual. Usa IF / ELIF para elegir el texto.
func describir():
	print("--- Estas en " + habitaciones[habitacion] + " ---")

	if habitacion == 0:
		print("Un hall enorme y helado. Solo se puede seguir hacia adelante. →")
	elif habitacion == 1:
		print("Muebles tapados con sabanas. Sobre una mesa hay una 🔦 LINTERNA.")
	elif habitacion == 2:
		print("Todo negro. Menos mal que trajiste luz. Algo brilla: un 🔮 AMULETO.")
	elif habitacion == 3:
		print("Miles de libros polvorientos. Colgada en la pared: una 🗝️ LLAVE oxidada.")
	elif habitacion == 4:
		print("Una puerta pesada con cerradura. Un frio horrible sube desde abajo.")
	elif habitacion == 5:
		print("Bajaste al sotano... y NO estas solo. 👻")


# Intenta avanzar a la siguiente habitacion.
# Antes de dejarte pasar, revisa con IF si tenes el item necesario.
func avanzar():
	# PUERTA 1: para entrar al Pasillo oscuro necesitas la LINTERNA
	if habitacion == 1 and not tengo("Linterna"):
		print("⚠️  Adelante esta TODO oscuro. Necesitas una 🔦 linterna para entrar.")
		return

	# PUERTA 2: para abrir la Puerta del Sotano necesitas la LLAVE
	if habitacion == 4 and not tengo("Llave"):
		print("🔒 La puerta esta cerrada con llave. Te falta una 🗝️ llave.")
		return

	# Si ya estamos en la ultima habitacion, no hay mas adelante
	if habitacion == habitaciones.size() - 1:
		print("Es el fondo de la mansion. No hay nada mas adelante.")
		return

	habitacion = habitacion + 1   # avanzamos una habitacion

	if habitacion == 5:
		enfrentar_final()         # llegar al sotano dispara el final
	else:
		describir()


# Retrocede una habitacion (si se puede).
func retroceder():
	if habitacion == 0:
		print("Es la entrada. La puerta detras tuyo esta cerrada. Solo se avanza.")
		return
	habitacion = habitacion - 1
	describir()


# Agarra el item que hay en la habitacion (si es que hay uno).
# Otra vez IF / ELIF: cada habitacion tiene (o no) su item.
func agarrar():
	if habitacion == 1 and not tengo("Linterna"):
		inventario.append("Linterna")
		print("🔦 Agarraste la LINTERNA. Ahora podes entrar a lugares oscuros.")
	elif habitacion == 2 and not tengo("Amuleto"):
		inventario.append("Amuleto")
		print("🔮 Agarraste el AMULETO. Dicen que protege de los espiritus...")
	elif habitacion == 3 and not tengo("Llave"):
		inventario.append("Llave")
		print("🗝️ Agarraste la LLAVE oxidada. Seguro abre alguna puerta.")
	else:
		print("No hay nada para agarrar aca.")
	mostrar_inventario()


# Devuelve true si el item esta en el inventario.
# Funcion con RETURN + un FOR que recorre el ARREGLO.
func tengo(item):
	for cosa in inventario:      # recorremos el inventario elemento por elemento
		if cosa == item:
			return true          # lo encontramos: cortamos y devolvemos true
	return false                 # recorrimos todo y no estaba


# Muestra el inventario recorriendolo con un FOR.
func mostrar_inventario():
	if inventario.size() == 0:
		print("🎒 Inventario vacio.")
		return
	print("🎒 Inventario:")
	for cosa in inventario:
		print("   • " + cosa)


# El FINAL cambia segun lo que hayas juntado. IF / ELSE decide si ganas.
func enfrentar_final():
	print("--- Estas en " + habitaciones[5] + " ---")
	print("Un fantasma se abalanza sobre vos en la oscuridad...")

	if tengo("Amuleto"):
		print("🔮 El amuleto brilla con fuerza y el espiritu retrocede.")
		print("Encontras una escalera hacia afuera y escapas de la mansion.")
		print("🏆  ¡GANASTE!  Saliste con vida.")
	else:
		print("👻 No tenes con que defenderte. La oscuridad te envuelve.")
		print("💀  GAME OVER.  Nunca saliste de la mansion.")

	terminado = true
	print("=== FIN ===")
