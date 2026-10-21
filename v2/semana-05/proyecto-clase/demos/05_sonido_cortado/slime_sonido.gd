extends "res://comun/slime.gd"
# Demo 05 · Tres formas de morir con sonido. El SfxMuerte es hijo del slime.

var modo = 1
var demo   # la demo, para anotar en pantalla qué pasa

func morir():
	if modo == 1:
		# ❌ play() y queue_free() en el mismo frame: el hijo SfxMuerte se borra con el slime
		$SfxMuerte.play()
		demo.anotar(modo, "SfxMuerte.play()  →  queue_free()  →  silencio")
		queue_free()
	elif modo == 2:
		# ✅ que suene alguien que sigue vivo: el caballero
		jugador().get_node("SfxKill").play()
		demo.anotar(modo, "jugador.SfxKill.play()  →  queue_free()  →  se oye")
		queue_free()
	elif modo == 3:
		# ✅ esperar la señal finished del sonido antes de borrar
		var inicio = Time.get_ticks_msec()
		$SfxMuerte.play()
		hide()                                # ya no se ve…
		set_deferred("monitorable", false)    # …ni choca
		remove_from_group("enemigo")
		demo.anotar(modo, "SfxMuerte.play() + hide()  …  esperando finished")
		await $SfxMuerte.finished             # esta función se pausa acá hasta que termina el sonido
		demo.anotar(modo, "SfxMuerte.play() + hide()  …  finished a los " + str(Time.get_ticks_msec() - inicio) + " ms  →  queue_free()")
		queue_free()

func jugador():
	return get_tree().get_first_node_in_group("jugador")
