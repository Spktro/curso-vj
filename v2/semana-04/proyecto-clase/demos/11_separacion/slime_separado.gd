class_name SlimeSeparado
extends Enemigo
# Demo 11: el mismo slime de la semana 3, con UNA regla más: no pisar a los vecinos.
# Tres modos, para comparar:
#   SIN_SEPARAR:        todos van al mismo punto y se apilan en uno solo.
#   VECINOS:            cada uno mira solo a los que tiene encima (el Area2D ya los filtró).
#   TODOS_CONTRA_TODOS: cada uno mira a TODOS los demás, uno por uno. Funciona igual, pero cuesta mucho más.

enum Modo { SIN_SEPARAR, VECINOS, TODOS_CONTRA_TODOS }

var modo = Modo.SIN_SEPARAR
var fuerza = 90       # qué tan fuerte se empujan
var revisados = 0     # a cuántos otros miró en este frame (para el contador de la demo)

func _process(delta):
	super(delta)      # perseguir al jugador, igual que siempre
	revisados = 0
	if modo == Modo.VECINOS:
		for otro in get_overlapping_areas():
			if otro is Enemigo:
				revisados += 1
				position += (position - otro.position).normalized() * fuerza * delta
	elif modo == Modo.TODOS_CONTRA_TODOS:
		for otro in get_tree().get_nodes_in_group("enemigo"):
			if otro != self:
				revisados += 1
				if position.distance_to(otro.position) < radio * 2:
					position += (position - otro.position).normalized() * fuerza * delta

func _on_area_entered(area):
	pass   # no es kamikaze: se queda alrededor del jugador
