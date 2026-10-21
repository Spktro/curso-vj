extends Node2D
# Demo 04 · Mantener Espacio: el caballero dispara cada 0.12 s con el mismo disparo.wav.
# Con la variación prendida, cada disparo usa pitch_scale = randf_range(0.9, 1.1).

var escena_bala = preload("res://comun/bala.tscn")
var variar = false

func _ready():
	$TimerDisparo.timeout.connect(disparar)

func _process(delta):
	if Input.is_physical_key_pressed(KEY_SPACE):
		if $TimerDisparo.is_stopped():
			disparar()
			$TimerDisparo.start()
	else:
		$TimerDisparo.stop()
	var sfx = $Caballero/SfxDisparo
	var texto = "variación: NO (siempre 1.0)"
	if variar:
		texto = "variación: SÍ, randf_range(0.9, 1.1)"
	$Cartel.mostrar("pitch_scale = " + str(sfx.pitch_scale).pad_decimals(2) + "   ·   " + texto + "   ·   volume_db = " + str(sfx.volume_db))

func disparar():
	var bala = escena_bala.instantiate()
	bala.position = $Caballero.position + Vector2(30, 0)
	bala.direccion = Vector2(1, randf_range(-0.05, 0.05)).normalized()
	add_child(bala)
	var sfx = $Caballero/SfxDisparo
	if variar:
		sfx.pitch_scale = randf_range(0.9, 1.1)
	else:
		sfx.pitch_scale = 1.0
	sfx.play()

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var sfx = $Caballero/SfxDisparo
	if event.physical_keycode == KEY_V:
		variar = not variar
	elif event.physical_keycode == KEY_UP:
		sfx.volume_db = min(sfx.volume_db + 5, 5)
	elif event.physical_keycode == KEY_DOWN:
		sfx.volume_db = max(sfx.volume_db - 5, -30)
