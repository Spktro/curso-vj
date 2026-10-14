extends Node2D
# Demo 09: la tecla P es la píldora grande (un evento).

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_P:
		$Fantasma.comer_pildora()
