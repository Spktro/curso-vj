extends CharacterBody2D
# El caballero del survivors. WASD: mover.
# Cada demo lo usa tal cual y le cambia alguna variable (o llama a sus funciones).

signal recibio_golpe

var velocidad = 200
var golpeado = false        # true durante TimerGolpe (0.4 s) después de un golpe
var muerto = false
var orden_correcto = true   # demo 01: false = "run" va antes que "golpe" (el error)
var animado = true          # demo 11: en false el sprite queda quieto (nivel 0)
var anim_golpe = "golpe"    # demo 02: "golpe_sin_final" muestra el keyframe que falta
var parpadea = true        # demo 11: en false no hay parpadeo al recibir un golpe

func _ready():
	add_to_group("jugador")
	$TimerGolpe.timeout.connect(_on_timer_golpe_timeout)

func _physics_process(delta):
	if muerto:
		return
	var direccion = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_A):
		direccion.x -= 1
	if Input.is_physical_key_pressed(KEY_D):
		direccion.x += 1
	if Input.is_physical_key_pressed(KEY_W):
		direccion.y -= 1
	if Input.is_physical_key_pressed(KEY_S):
		direccion.y += 1
	velocity = direccion.normalized() * velocidad
	move_and_slide()
	position = position.clamp(Vector2(30, 120), Vector2(1250, 650))
	animar(direccion)

func animar(direccion):
	if not animado:
		$AnimatedSprite2D.stop()
		return
	if direccion.x != 0:
		$AnimatedSprite2D.flip_h = direccion.x < 0
	# El orden es la PRIORIDAD: lo más importante primero
	if orden_correcto:
		if golpeado:
			$AnimatedSprite2D.play("golpe")
		elif direccion != Vector2.ZERO:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		# Error: si se mueve, "run" pisa a "golpe" y el golpe nunca se ve
		if direccion != Vector2.ZERO:
			$AnimatedSprite2D.play("run")
		elif golpeado:
			$AnimatedSprite2D.play("golpe")
		else:
			$AnimatedSprite2D.play("idle")

func recibir_dano(cantidad):
	if muerto:
		return
	golpeado = true
	$TimerGolpe.start()
	if parpadea:
		$AnimationPlayer.stop()
		$AnimationPlayer.play(anim_golpe)
	recibio_golpe.emit()

func _on_timer_golpe_timeout():
	golpeado = false

func morir():
	if muerto:
		return   # ya está muerto: no vuelve a caer desde el principio
	muerto = true
	$AnimationPlayer.stop()
	$AnimatedSprite2D.modulate = Color.WHITE
	$AnimatedSprite2D.play("morir")   # no tiene loop: al terminar emite animation_finished

func revivir():
	if not muerto:
		return
	modulate.a = 1.0
	muerto = false
	golpeado = false
	$AnimatedSprite2D.play("idle")
