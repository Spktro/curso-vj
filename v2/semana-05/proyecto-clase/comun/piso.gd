extends Node2D
# Un piso de baldosas, solo para que se note cuando la cámara tiembla.

func _draw():
	for x in range(0, 1280, 64):
		for y in range(64, 720, 64):
			var color = Color("23402a")
			if (x / 64 + y / 64) % 2 == 0:
				color = Color("1f3a26")
			draw_rect(Rect2(x, y, 64, 64), color)
