extends CPUParticles2D
# La explosión es su propia escena: sobrevive al slime que la creó.
# Se borra sola cuando termina la ráfaga.

func _ready():
	finished.connect(queue_free)
	emitting = true
