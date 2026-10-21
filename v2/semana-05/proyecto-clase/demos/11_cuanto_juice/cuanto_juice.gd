extends Node2D
# Demo 11 · El survivors con la mecánica fija y el "juice" por niveles.
# Del 0 al 7 se suma una respuesta por nivel. El 8 y el 9 son el exceso: todo tiembla,
# todo se congela, todo brilla, y deja de entenderse qué pasa.

var escena_slime = preload("res://comun/slime.tscn")
var script_slime = preload("res://demos/11_cuanto_juice/slime_juice.gd")
var escena_bala = preload("res://comun/bala.tscn")
var escena_explosion = preload("res://comun/explosion.tscn")

var nivel = 0
var niveles = [
	"Nada: correcto, pero mudo",
	"Animación: caminar y correr",
	"Sonido del disparo, bajito y con tono al azar",
	"Flash rojo del slime al recibir la bala",
	"Pop y \"plop\" al morir",
	"Partículas al morir",
	"Golpe al caballero: parpadeo, sonido y temblor de 6 px",
	"Música",
	"DEMASIADO: temblor en cada disparo y hit stop en cada slime",
	"DEMASIADO++: partículas gigantes, pantalla blanca en cada slime, disparo fuerte",
]

func _ready():
	$TimerSpawn.timeout.connect(spawnear)
	$TimerDisparo.timeout.connect(disparar)
	$Caballero.recibio_golpe.connect(_on_caballero_golpeado)
	$Musica.finished.connect($Musica.play)
	aplicar_nivel()

func activo(n):
	return nivel >= n

func _unhandled_input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var k = event.physical_keycode
	if k >= KEY_0 and k <= KEY_9:
		nivel = k - KEY_0
	elif k == KEY_RIGHT:
		nivel = min(nivel + 1, 9)
	elif k == KEY_LEFT:
		nivel = max(nivel - 1, 0)
	else:
		return
	aplicar_nivel()

func aplicar_nivel():
	$Caballero.animado = activo(1)
	$Caballero.parpadea = activo(6)
	if activo(7) and not $Musica.playing:
		$Musica.play()
	elif not activo(7):
		$Musica.stop()
	var texto = ""
	for i in niveles.size():
		var marca = "□ "
		if i <= nivel:
			marca = "■ "
		if i == 8:
			texto += "\n— a partir de acá, sobra —\n"
		texto += marca + str(i) + " · " + niveles[i] + "\n"
	$Capa/Lista.text = texto
	$Cartel.mostrar("Nivel " + str(nivel) + ": " + niveles[nivel])

func spawnear():
	var s = escena_slime.instantiate()
	s.set_script(script_slime)
	s.demo = self
	s.vida = 2
	s.velocidad = 70
	var lado = randi() % 3
	if lado == 0:
		s.position = Vector2(-20, randf_range(120, 700))
	elif lado == 1:
		s.position = Vector2(randf_range(0, 880), 740)
	else:
		s.position = Vector2(randf_range(0, 880), 100)
	$Slimes.add_child(s)

func disparar():
	var objetivo = null
	var menor = INF
	for enemigo in get_tree().get_nodes_in_group("enemigo"):
		var d = $Caballero.position.distance_to(enemigo.position)
		if d < menor:
			menor = d
			objetivo = enemigo
	if objetivo == null:
		return
	var bala = escena_bala.instantiate()
	bala.position = $Caballero.position
	bala.direccion = (objetivo.position - $Caballero.position).normalized()
	$Balas.add_child(bala)
	var sfx = $Caballero/SfxDisparo
	if activo(9):
		sfx.pitch_scale = 1.0
		sfx.volume_db = 4      # el sonido más repetido, el más fuerte: error
		sfx.play()
	elif activo(2):
		sfx.pitch_scale = randf_range(0.9, 1.1)
		sfx.volume_db = -10
		sfx.play()
	if activo(9):
		sacudir_camara(12)
	elif activo(8):
		sacudir_camara(6)

func slime_murio(posicion):
	if activo(4):
		$Caballero/SfxKill.play()   # suena el caballero, que sigue vivo
	if activo(5):
		var e = escena_explosion.instantiate()
		e.position = posicion
		if activo(9):
			e.amount = 60
			e.lifetime = 0.9
			e.initial_velocity_min = 200
			e.initial_velocity_max = 380
			e.scale_amount_min = 8
			e.scale_amount_max = 14
		add_child(e)
	if activo(9):
		$Capa/Destello.color = Color(1, 1, 1, 0.6)
		var tween = create_tween()
		tween.tween_property($Capa/Destello, "color:a", 0.0, 0.2)
	if activo(8):
		frenar_tiempo()

func _on_caballero_golpeado():
	if activo(6):
		$Caballero/SfxGolpe.play()
		sacudir_camara(6)

func sacudir_camara(intensidad):
	var tween = create_tween()
	for i in 5:
		var salto = Vector2(randf_range(-intensidad, intensidad), randf_range(-intensidad, intensidad))
		tween.tween_property($Camara, "offset", salto, 0.03)
	tween.tween_property($Camara, "offset", Vector2.ZERO, 0.03)

func frenar_tiempo():
	Engine.time_scale = 0.05
	await get_tree().create_timer(0.06, true, false, true).timeout
	Engine.time_scale = 1.0

func _exit_tree():
	Engine.time_scale = 1.0
