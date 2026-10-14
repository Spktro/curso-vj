class_name Semaforo
extends Node2D
# Una máquina de estados sin ningún juego: un semáforo.
# - Los ESTADOS son una lista con nombre (enum).
# - El estado actual es UNA variable: nunca hay dos luces a la vez.
# - Los EVENTOS son métodos. Cada uno decide, según el estado actual, si hay transición.

enum Estado { VERDE, AMARILLO, ROJO, INTERMITENTE }

var estado = Estado.ROJO
var tiempo = 0.0   # solo para el parpadeo del intermitente

# ---- Los eventos (los "botones" del semáforo) ----

func pasar_tiempo():
	match estado:
		Estado.VERDE:
			cambiar_estado(Estado.AMARILLO)
		Estado.AMARILLO:
			cambiar_estado(Estado.ROJO)
		Estado.ROJO:
			cambiar_estado(Estado.VERDE)
		# INTERMITENTE: el tiempo no lo saca de ahí. No hay flecha.

func fallar():
	if estado != Estado.INTERMITENTE:
		cambiar_estado(Estado.INTERMITENTE)

func arreglar():
	if estado == Estado.INTERMITENTE:
		cambiar_estado(Estado.ROJO)

# ---- El único lugar donde cambia el estado ----

func cambiar_estado(nuevo):
	print("Semáforo: " + Estado.keys()[estado] + " → " + Estado.keys()[nuevo])
	estado = nuevo
	queue_redraw()

# ---- Dibujo ----

func _process(delta):
	tiempo += delta
	if estado == Estado.INTERMITENTE:
		queue_redraw()

func _draw():
	draw_rect(Rect2(-60, -170, 120, 340), Color("2a3245"))
	draw_rect(Rect2(-12, 170, 24, 200), Color("2a3245"))
	var apagada = Color("3a4256")
	var rojo = apagada
	var amarillo = apagada
	var verde = apagada
	match estado:
		Estado.ROJO:
			rojo = Color("ff4d4d")
		Estado.AMARILLO:
			amarillo = Color("ffd54a")
		Estado.VERDE:
			verde = Color("4ade80")
		Estado.INTERMITENTE:
			if fmod(tiempo, 0.8) < 0.4:
				amarillo = Color("ffd54a")
	draw_circle(Vector2(0, -105), 42, rojo)
	draw_circle(Vector2(0, 0), 42, amarillo)
	draw_circle(Vector2(0, 105), 42, verde)
