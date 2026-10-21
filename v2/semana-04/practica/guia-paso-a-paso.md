# El jefe piensa · guía paso a paso

Guía detallada de la práctica de la semana 4 (clase 8+). Arranca donde terminó la guía de la semana 3: la horda, el élite cada 8 slimes y la bomba con Enter. Se convierte al élite en un **jefe con máquina de estados**, se mira la **histéresis** con los números a la vista y, al final, el personaje **dispara solo** al enemigo más cercano. Los menús figuran en inglés y, entre paréntesis, en español.

Cada bloque termina con un **punto de control**. Conviene no avanzar hasta que se cumpla.

## Cómo queda el proyecto al final

```
arena.tscn
Arena            Node2D            arena.gd          (la bomba, sin cambios)
├── Jugador      CharacterBody2D   jugador.gd        ← bloque 6: dispara
│   ├── AnimatedSprite2D
│   ├── CollisionShape2D
│   └── TimerDisparo   Timer                         ← NUEVO (bloque 6)
├── Spawner      Node2D            spawner.gd        (sin cambios)
│   └── Timer
├── Enemigos     Node2D            (vacío, sin script)
└── Balas        Node2D            (vacío, sin script) ← NUEVO (bloque 6)

slime.tscn                                           (sin cambios)
Slime            Area2D            enemigo.gd        (sin cambios)

slime_elite.tscn (heredada de slime.tscn)
SlimeElite       Area2D            slime_elite.gd    ← se reescribe
├── AnimatedSprite2D                                 (heredado, amarillo)
├── CollisionShape2D                                 (heredado, amarillo)
├── LabelEstado    Label                             ← NUEVO (bloque 1)
├── TimerAtaque    Timer                             ← NUEVO (bloque 2)
└── TimerGolpe     Timer                             ← NUEVO (bloque 3)

bala.tscn                                            ← NUEVA (bloque 6)
Bala             Area2D            bala.gd
├── Sprite2D
├── CollisionShape2D
└── TimerVida      Timer
```

Tres reglas para hoy, además de las de la semana pasada:

- **`enemigo.gd` no se toca.** Todo lo del jefe va en `slime_elite.gd`. Si los slimes verdes cambian de comportamiento, se editó el archivo equivocado.
- Los nodos nuevos del jefe van en **`slime_elite.tscn`**, no en `slime.tscn`. Si se agregan al slime común, los tendrían todos.
- Los nombres `LabelEstado`, `TimerAtaque`, `TimerGolpe` y los del `enum` tienen que coincidir letra por letra con el código, mayúsculas incluidas.

Así se va armando la máquina, un estado por vez:

| Bloque | Qué se agrega | Qué se ve |
|---|---|---|
| 1 | `ACECHAR` ⇄ `PERSEGUIR` y la etiqueta | Viene despacio y medio transparente; cerca, acelera |
| 2 | `ATACAR` | Se frena y pega cada segundo; ya no es kamikaze |
| 3 | `GOLPEADO` | Con la bomba retrocede, se pone rojo y queda quieto 0.5 s |
| 4 | `cambiar_estado()` | Un color por estado y un aviso por consola en cada cambio |
| 5 | La histéresis | 40/40 contra 40/60: el jefe que parpadea y el que no |
| 6 | Disparos automáticos | Las balas reemplazan a la bomba como fuente de golpes |

---

## 0 · Punto de partida

### 0.1 Confirmar que la semana 3 anda

1. Abrir el proyecto `clase-05`. Si se quiere conservar la versión de la semana pasada, cerrar Godot, copiar la carpeta, renombrar la copia (por ejemplo `clase-08`) y abrir esa.
2. Correr con **F5**.

> **Punto de control:** los slimes entran por los bordes y persiguen al jugador; cada 8 entra un élite violeta, grande y lento; Enter mata a los comunes y al quinto golpe Output muestra `¡Cayó un élite!`.

### 0.2 El orden del árbol

En `arena.tscn`, mirar el panel **Scene**. `Jugador` tiene que estar **arriba** de `Enemigos`. Si `Enemigos` quedó primero (pasa si se creó antes que el jugador, como en el paso 0.3 de la semana pasada), arrastrar `Jugador` hasta dejarlo justo debajo de `Arena`.

Por qué importa hoy: el jefe busca al jugador **una sola vez**, en su `_ready()`. Godot corre los `_ready()` en el orden del árbol, de arriba hacia abajo. Si un élite puesto a mano dentro de `Enemigos` arranca antes que el jugador, el jugador todavía no se anotó en el grupo `"jugador"`, la búsqueda devuelve `null` y el jefe se queda quieto para siempre.

Para que no dependa del orden, poner también el grupo desde el editor:

1. Seleccionar `Jugador`.
2. A la derecha, pasar del Inspector al panel **Node** (**Nodo**) y elegir la pestaña **Groups** (**Grupos**).
3. Pulsar **+**, escribir `jugador` (minúsculas) y aceptar. Aparece un ícono de grupo al lado del nodo en el árbol.

Los grupos puestos desde el editor existen desde que la escena se carga, antes de cualquier `_ready()`. El `add_to_group("jugador")` de `jugador.gd` puede quedar: anotarse dos veces en el mismo grupo no hace nada.

### 0.3 Un élite a mano, para no esperar al spawner

1. En `arena.tscn`, seleccionar `Enemigos` → ícono de cadena (Ctrl+Shift+A) → `slime_elite.tscn`.
2. Con Move (W), llevarlo a una esquina, **lejos** del jugador (más de 350 px: por ejemplo, Position `100, 100`).
3. Para mirar al jefe sin la horda alrededor: seleccionar el `Timer` del `Spawner` y destildar **Autostart** mientras se arma el jefe. Al final de la guía se vuelve a tildar.

Ese élite se borra al terminar. A partir de acá, **F6** con la pestaña `arena.tscn` al frente (o F5, que es la misma escena principal).

---

## 1 · Dos estados: ACECHAR ⇄ PERSEGUIR

Hoy el élite hereda de `Enemigo` un `_process` que persigue siempre, a la misma velocidad. Se le da **su propio** `_process`, con una máquina de dos estados:

- **ACECHAR:** viene hacia el jugador **a la mitad de la velocidad** y **medio transparente**, como si todavía no se decidiera. No es patrullar: en un *survivors*, un enemigo que deambula se va de la pantalla y nadie lo enfrenta.
- **PERSEGUIR:** a menos de 250 px lo vio; acelera a toda velocidad y se vuelve opaco. Si el jugador se aleja a más de 350 px, vuelve a acechar.

### 1.1 La etiqueta

1. Abrir `slime_elite.tscn` (doble clic en FileSystem).
2. Seleccionar la raíz `SlimeElite` → **+** → `Label`. Renombrarlo `LabelEstado` con F2.
3. En el Inspector, **Text**: `ACECHAR` (solo para verla en el editor; el código la reescribe).
4. **Horizontal Alignment** (**Alineación Horizontal**): **Center**.
5. Con Move (W), llevarla arriba de la cabeza del slime. Como referencia, **Position** cerca de `-30, -40`.

Ojo con la escala: el script del élite hace `scale = Vector2(2, 2)`, y eso agranda también a la etiqueta y la aleja el doble del centro. En el editor se ve del tamaño normal; al correr, el doble. Si queda muy arriba o muy grande, acercarla al slime o bajar **Theme Overrides → Font Sizes** (**Anulaciones de Tema → Tamaños de Fuente**).

### 1.2 El script

Abrir `slime_elite.gd` y reemplazar todo por:

```gdscript
extends Enemigo

enum Estado { ACECHAR, PERSEGUIR }

var estado = Estado.ACECHAR
var jugador = null

func _ready():
	super()
	vida = 12
	velocidad = 70
	dano = 15
	scale = Vector2(2, 2)
	jugador = get_tree().get_first_node_in_group("jugador")

func _process(delta):
	if jugador == null:
		return
	var d = position.distance_to(jugador.position)
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < 250: estado = Estado.PERSEGUIR
		Estado.PERSEGUIR:
			perseguir(delta)
			if d > 350: estado = Estado.ACECHAR
	$LabelEstado.text = Estado.keys()[estado]

func acechar(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * 0.5 * delta
	$AnimatedSprite2D.flip_h = dir.x < 0
	modulate = Color(1, 1, 1, 0.5)

func perseguir(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * delta
	$AnimatedSprite2D.flip_h = dir.x < 0
	modulate = Color.WHITE

func morir():
	print("¡Cayó un élite!")
	super()
```

Qué hace cada parte nueva:

| Línea | Para qué está |
|---|---|
| `enum Estado { ACECHAR, PERSEGUIR }` | Nombres para los estados. Por dentro son 0 y 1; en el código se lee la palabra. |
| `var estado = Estado.ACECHAR` | La única pregunta de la máquina: ¿qué está haciendo ahora? Arranca acechando. |
| `jugador = get_tree()...` en `_ready()` | El jugador se busca **una vez** y se guarda. El slime común lo busca en cada frame. |
| `func _process(delta)` **sin** `super()` | Reemplaza al de `Enemigo`. Si llamara a `super()`, además perseguiría siempre. Los slimes comunes siguen con el de la madre. |
| `match estado:` | Ejecuta solo la rama del estado actual. En cada rama: primero **hacer** (la función), después **decidir** (el `if`). |
| `if d < 250: estado = ...` | Una flecha del diagrama. Cada `if` que cambia `estado` es una flecha. |
| `Estado.keys()[estado]` | Convierte el número del estado en su nombre (`"ACECHAR"`). La herramienta para depurar: se mira la etiqueta y se sabe qué piensa. |
| `velocidad * 0.5` | Acecha a 35 px/s, lo mismo que el élite de la semana pasada. Persiguiendo va a 70. |
| `modulate = Color(1, 1, 1, 0.5)` | Medio transparente mientras acecha. `Color.WHITE` lo devuelve a normal. Sin `$`: tiñe al jefe entero, etiqueta incluida. |
| `flip_h` en las dos funciones | El `flip_h` del slime estaba en el `_process` de la madre, que ya no corre para el jefe. |

Los `vida`, `velocidad` y `dano` cambian: es el jefe, aguanta más (12) y pega menos por golpe (15) porque va a pegar muchas veces. El `scale` queda como en la semana 3.

### 1.3 Probarlo

1. Guardar (Ctrl+S) y F6 con `arena.tscn` al frente.
2. Quedarse quieto y mirar al élite de la esquina.
3. Cuando cambie a `PERSEGUIR`, caminar en dirección contraria hasta perderlo.

> **Punto de control:** el jefe viene **despacio y medio transparente**, con `ACECHAR` encima. A menos de 250 px la etiqueta pasa a `PERSEGUIR`, se vuelve opaco y **acelera**. Al alejarse más de 350 px (el jugador a 200 px/s le gana), vuelve a `ACECHAR` y a la transparencia. Si llega a tocar al jugador, todavía es **kamikaze**: pega 15 y desaparece. Eso se arregla en el bloque 2.

Para probar otra vez después del kamikaze, cerrar el juego y volver a F6: el élite de la esquina vuelve a estar.

---

## 2 · Tercer estado: ATACAR

Al alcanzar al jugador, el jefe se **frena** y pega **una vez por segundo** mientras siga cerca. Entra a atacar a menos de 40 px y vuelve a perseguir a más de 60.

### 2.1 El Timer

1. En `slime_elite.tscn`, seleccionar `SlimeElite` → **+** → `Timer`. Renombrarlo `TimerAtaque`.
2. En el Inspector: **Wait Time** `1`, **One Shot** tildado, **Autostart** sin tildar.

### 2.2 El código

1. Agregar `ATACAR` al `enum`:

```gdscript
enum Estado { ACECHAR, PERSEGUIR, ATACAR }
```

2. En el `match`, la rama de `PERSEGUIR` pasa a tener **dos salidas**, y se suma la rama de `ATACAR` debajo:

```gdscript
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < 40: estado = Estado.ATACAR
			elif d > 350: estado = Estado.ACECHAR
		Estado.ATACAR:
			atacar()
			if d > 60: estado = Estado.PERSEGUIR
```

3. Debajo de `perseguir()`, dos funciones nuevas:

```gdscript
func atacar():
	if $TimerAtaque.is_stopped():
		jugador.recibir_dano(dano)
		$TimerAtaque.start()

func _on_body_entered(body):
	pass
```

Aclaraciones:

- **El golpe cada segundo:** al entrar a `ATACAR`, `TimerAtaque` está frenado, así que pega enseguida y lo arranca. Durante el segundo que corre, `is_stopped()` da `false` y no pega. Al terminar se frena solo (por **One Shot**) y en el frame siguiente vuelve a pegar. Sin variables extra ni contar `delta` a mano.
- **`atacar()` no mueve al jefe:** quedarse quieto también es un comportamiento.
- **Anular el kamikaze:** `Enemigo` conecta la señal `body_entered` a `_on_body_entered`, que pega y hace `queue_free()`. El jefe define una función **con el mismo nombre** y cuerpo vacío. La conexión la sigue haciendo el `super()` de `_ready()`, pero ahora llama a la versión de la hija, que no hace nada. Godot puede mostrar la advertencia `UNUSED_PARAMETER` por `body`: no rompe nada.

### 2.3 Probarlo

1. Guardar y F6. Quedarse quieto y dejarse alcanzar.
2. Dar un par de pasos para atrás y volver a dejarse alcanzar.

> **Punto de control:** la etiqueta pasa a `ATACAR`, el jefe se frena pegado al jugador y Output muestra `Jugador: 85 de vida`, `Jugador: 70 de vida`, `Jugador: 55 de vida`… uno por segundo, y el jefe **no desaparece**. Con un paso atrás, vuelve a `PERSEGUIR`.

Dos pruebas que conviene hacer una vez, para entender por qué está cada cosa:

- Comentar la función `_on_body_entered` (seleccionar las dos líneas y Ctrl+K): el jefe vuelve a ser kamikaze. Descomentar.
- Destildar **One Shot** de `TimerAtaque`: pega una sola vez y nunca más, porque el Timer se reinicia solo y `is_stopped()` no vuelve a dar `true`. Volver a tildarlo.

`slime_elite.gd` hasta acá:

```gdscript
extends Enemigo

enum Estado { ACECHAR, PERSEGUIR, ATACAR }

var estado = Estado.ACECHAR
var jugador = null

func _ready():
	super()
	vida = 12
	velocidad = 70
	dano = 15
	scale = Vector2(2, 2)
	jugador = get_tree().get_first_node_in_group("jugador")

func _process(delta):
	if jugador == null:
		return
	var d = position.distance_to(jugador.position)
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < 250: estado = Estado.PERSEGUIR
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < 40: estado = Estado.ATACAR
			elif d > 350: estado = Estado.ACECHAR
		Estado.ATACAR:
			atacar()
			if d > 60: estado = Estado.PERSEGUIR
	$LabelEstado.text = Estado.keys()[estado]

func acechar(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * 0.5 * delta
	$AnimatedSprite2D.flip_h = dir.x < 0
	modulate = Color(1, 1, 1, 0.5)

func perseguir(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * delta
	$AnimatedSprite2D.flip_h = dir.x < 0
	modulate = Color.WHITE

func atacar():
	if $TimerAtaque.is_stopped():
		jugador.recibir_dano(dano)
		$TimerAtaque.start()

func _on_body_entered(body):
	pass

func morir():
	print("¡Cayó un élite!")
	super()
```

---

## 3 · Cuarto estado: GOLPEADO

Hoy la bomba le resta vida al jefe y nada más: sigue caminando como si nada. Se busca que el golpe **se sienta**: un empujón hacia atrás y medio segundo congelado, en rojo.

Este estado tiene flechas distintas a las de antes:

| Flecha | Qué la dispara | Dónde vive |
|---|---|---|
| Entre ACECHAR, PERSEGUIR y ATACAR | La distancia | El `match` |
| De cualquier estado a GOLPEADO | Un evento: recibir un golpe | `recibir_dano()` |
| De GOLPEADO a PERSEGUIR | El tiempo: pasan 0.5 s | El `match` |

### 3.1 El Timer

1. En `slime_elite.tscn`, otro `Timer` hijo de `SlimeElite`. Renombrarlo `TimerGolpe`.
2. **Wait Time** `0.5`, **One Shot** tildado, **Autostart** sin tildar.

### 3.2 El código

1. El `enum`, completo:

```gdscript
enum Estado { ACECHAR, PERSEGUIR, ATACAR, GOLPEADO }
```

2. En el `match`, la rama de `GOLPEADO` **al final**, debajo de la de `ATACAR`:

```gdscript
		Estado.GOLPEADO:
			golpeado()
			if $TimerGolpe.is_stopped():
				modulate = Color.WHITE
				estado = Estado.PERSEGUIR
```

3. Debajo de `_on_body_entered`, dos funciones:

```gdscript
func golpeado():
	modulate = Color(1, 0.4, 0.4)

func recibir_dano(cantidad):
	super(cantidad)
	if vida > 0:
		position += (position - jugador.position).normalized() * 20
		$TimerGolpe.start()
		estado = Estado.GOLPEADO
```

Aclaraciones:

- **`super(cantidad)`** corre el `recibir_dano()` de `Enemigo`: resta la vida y, si llega a 0, llama a `morir()`. Recién después, y solo si sobrevivió, viene el golpe.
- **El empujón** es "perseguir al revés": `position - jugador.position` apunta del jugador hacia el jefe. `* 20` lo hace de 20 px. **No lleva `delta`**: no es un movimiento por frame, es un salto, una sola vez.
- **`golpeado()` no mueve al jefe ni pega:** en GOLPEADO solo se espera a que termine el Timer.
- **`modulate = Color.WHITE`** en la salida le saca el rojo. Si se lo pusiera dentro de `golpeado()`, se pisaría con el rojo en el mismo frame y nunca se vería.

### 3.3 Probarlo con la bomba

1. Guardar y F6.
2. Apretar **Enter** cada uno o dos segundos (Espacio también sirve: los dos son `ui_accept`).

> **Punto de control:** con cada Enter el jefe **retrocede**, se pone **rojo**, la etiqueta dice `GOLPEADO` y queda quieto medio segundo; después vuelve a `PERSEGUIR`. Si estaba lejos, en el frame siguiente pasa a `ACECHAR`: es correcto, la flecha de salida va a PERSEGUIR y de ahí decide la distancia. Al Enter número 12, Output muestra `¡Cayó un élite!`.

Para probar: apretar Enter muy seguido. El jefe queda trabado en GOLPEADO, porque cada golpe reinicia el medio segundo. Se llama *stun lock* y vuelve en el bloque 6 con las balas.

`slime_elite.gd` hasta acá:

```gdscript
extends Enemigo

enum Estado { ACECHAR, PERSEGUIR, ATACAR, GOLPEADO }

var estado = Estado.ACECHAR
var jugador = null

func _ready():
	super()
	vida = 12
	velocidad = 70
	dano = 15
	scale = Vector2(2, 2)
	jugador = get_tree().get_first_node_in_group("jugador")

func _process(delta):
	if jugador == null:
		return
	var d = position.distance_to(jugador.position)
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < 250: estado = Estado.PERSEGUIR
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < 40: estado = Estado.ATACAR
			elif d > 350: estado = Estado.ACECHAR
		Estado.ATACAR:
			atacar()
			if d > 60: estado = Estado.PERSEGUIR
		Estado.GOLPEADO:
			golpeado()
			if $TimerGolpe.is_stopped():
				modulate = Color.WHITE
				estado = Estado.PERSEGUIR
	$LabelEstado.text = Estado.keys()[estado]

func acechar(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * 0.5 * delta
	$AnimatedSprite2D.flip_h = dir.x < 0
	modulate = Color(1, 1, 1, 0.5)

func perseguir(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * delta
	$AnimatedSprite2D.flip_h = dir.x < 0
	modulate = Color.WHITE

func atacar():
	if $TimerAtaque.is_stopped():
		jugador.recibir_dano(dano)
		$TimerAtaque.start()

func _on_body_entered(body):
	pass

func golpeado():
	modulate = Color(1, 0.4, 0.4)

func recibir_dano(cantidad):
	super(cantidad)
	if vida > 0:
		position += (position - jugador.position).normalized() * 20
		$TimerGolpe.start()
		estado = Estado.GOLPEADO

func morir():
	print("¡Cayó un élite!")
	super()
```

---

## 4 · Que se note: cambiar_estado()

Mirando el script de arriba, lo que pasa "al cambiar de estado" está repartido:

- `estado = ...` aparece en **seis** lugares (cinco en el `match`, uno en `recibir_dano()`).
- La etiqueta se reescribe **en cada frame**, aunque el estado no cambie.
- El color se pone en `acechar()`, `perseguir()` y `golpeado()`, también en cada frame, y el rojo se saca en otra rama.
- Si se quisiera un color para ATACAR, o un sonido al entrar a un estado, habría que tocar cada flecha.

Se junta todo en **una función** que se llama una vez por flecha.

### 4.1 La función

Agregar, debajo de `_process`:

```gdscript
func cambiar_estado(nuevo):
	estado = nuevo
	var nombre = Estado.keys()[estado]
	$LabelEstado.text = nombre
	print("Jefe → " + nombre)
	match estado:
		Estado.ACECHAR: modulate = Color(1, 1, 1, 0.5)
		Estado.PERSEGUIR: modulate = Color.WHITE
		Estado.ATACAR: modulate = Color(1, 0.6, 0.2)
		Estado.GOLPEADO: modulate = Color(1, 0.4, 0.4)
```

ACECHAR medio transparente, PERSEGUIR normal, ATACAR naranja, GOLPEADO rojo.

### 4.2 Usarla en cada flecha

1. Al **final** de `_ready()`, una línea: `cambiar_estado(Estado.ACECHAR)`. Tiene que ir después del `super()`, así ya existe `$LabelEstado`.
2. Reemplazar cada `estado = Estado.ALGO` por `cambiar_estado(Estado.ALGO)`. Son cinco en el `match` y una en `recibir_dano()`. Ctrl+F con `estado = Estado` los encuentra. La declaración de arriba, `var estado = Estado.ACECHAR`, queda como está.
3. Borrar lo que ahora hace la función:
   - la línea `$LabelEstado.text = Estado.keys()[estado]` del final de `_process`;
   - la línea `modulate = ...` de `acechar()` y la de `perseguir()`;
   - la función `golpeado()` entera y su llamada en el `match`;
   - el `modulate = Color.WHITE` de la rama `GOLPEADO`.

La rama de `GOLPEADO` queda así:

```gdscript
		Estado.GOLPEADO:
			if $TimerGolpe.is_stopped():
				cambiar_estado(Estado.PERSEGUIR)
```

`slime_elite.gd` completo, igual al código de referencia del TP4 salvo el `scale` (que en el TP lo da el sprite) y la `BarraVida` (que este proyecto no tiene):

```gdscript
extends Enemigo

enum Estado { ACECHAR, PERSEGUIR, ATACAR, GOLPEADO }

var estado = Estado.ACECHAR
var jugador = null

func _ready():
	super()
	vida = 12
	velocidad = 70
	dano = 15
	scale = Vector2(2, 2)
	jugador = get_tree().get_first_node_in_group("jugador")
	cambiar_estado(Estado.ACECHAR)

func _process(delta):
	if jugador == null:
		return
	var d = position.distance_to(jugador.position)
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < 250: cambiar_estado(Estado.PERSEGUIR)
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < 40: cambiar_estado(Estado.ATACAR)
			elif d > 350: cambiar_estado(Estado.ACECHAR)
		Estado.ATACAR:
			atacar()
			if d > 60: cambiar_estado(Estado.PERSEGUIR)
		Estado.GOLPEADO:
			if $TimerGolpe.is_stopped():
				cambiar_estado(Estado.PERSEGUIR)

func cambiar_estado(nuevo):
	estado = nuevo
	var nombre = Estado.keys()[estado]
	$LabelEstado.text = nombre
	print("Jefe → " + nombre)
	match estado:
		Estado.ACECHAR: modulate = Color(1, 1, 1, 0.5)
		Estado.PERSEGUIR: modulate = Color.WHITE
		Estado.ATACAR: modulate = Color(1, 0.6, 0.2)
		Estado.GOLPEADO: modulate = Color(1, 0.4, 0.4)

func acechar(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * 0.5 * delta
	$AnimatedSprite2D.flip_h = dir.x < 0

func perseguir(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * delta
	$AnimatedSprite2D.flip_h = dir.x < 0

func atacar():
	if $TimerAtaque.is_stopped():
		jugador.recibir_dano(dano)
		$TimerAtaque.start()

func _on_body_entered(body):
	pass

func recibir_dano(cantidad):
	super(cantidad)
	if vida > 0:
		position += (position - jugador.position).normalized() * 20
		$TimerGolpe.start()
		cambiar_estado(Estado.GOLPEADO)

func morir():
	print("¡Cayó un élite!")
	super()
```

### 4.3 Probarlo

Guardar y F6. Dejarse alcanzar, alejarse, apretar Enter un par de veces.

> **Punto de control:** el jefe es **medio transparente** al acechar, normal al perseguir, **naranja** al atacar y **rojo** al recibir la bomba. Output muestra una línea **por cambio**, no por frame:

```
Jefe → ACECHAR
Jefe → PERSEGUIR
Jefe → ATACAR
Jugador: 85 de vida
Jefe → GOLPEADO
Jefe → PERSEGUIR
```

La diferencia entre "cada frame" y "una vez al cambiar": el `match` de `_process` corre unas 60 veces por segundo y ahí va lo que el estado **hace**. `cambiar_estado()` corre una vez por flecha y ahí va lo que pasa **al entrar**: el cartel, el color, y más adelante un sonido o una animación. Para verlo, mover el `print` a `_process` un momento: la consola se llena de 60 líneas por segundo. Devolverlo a su lugar.

---

## 5 · La histéresis

### 5.1 Qué es

Cada par de flechas de ida y vuelta usa **dos números distintos**: entra a PERSEGUIR a menos de 250 y sale a más de 350; entra a ATACAR a menos de 40 y sale a más de 60. Ese margen entre "entrar" y "salir" se llama **histéresis**. Es lo que hace cualquier termostato: prende la estufa a 19 °C y la apaga a 21 °C, no las dos cosas a 20.

Sin margen, cuando el jugador está justo en el borde, la máquina cambia de estado casi en cada frame. Este bloque lo hace a propósito para verlo.

### 5.2 Los umbrales con nombre

Para poder cambiarlos sin buscar números sueltos en el `match`, pasarlos a variables. Debajo de `var jugador = null`, agregar:

```gdscript
var distancia_ver = 250       # a menos de esto, PERSEGUIR
var distancia_perder = 350    # a más de esto, vuelve a ACECHAR
var entrar_a_atacar = 40      # a menos de esto, ATACAR
var salir_de_atacar = 60      # a más de esto, vuelve a PERSEGUIR
```

Y en el `match`, reemplazar cada número por su variable:

```gdscript
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < distancia_ver: cambiar_estado(Estado.PERSEGUIR)
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < entrar_a_atacar: cambiar_estado(Estado.ATACAR)
			elif d > distancia_perder: cambiar_estado(Estado.ACECHAR)
		Estado.ATACAR:
			atacar()
			if d > salir_de_atacar: cambiar_estado(Estado.PERSEGUIR)
		Estado.GOLPEADO:
			if $TimerGolpe.is_stopped():
				cambiar_estado(Estado.PERSEGUIR)
```

Guardar y F6: tiene que andar exactamente igual que antes. Además, el código se lee mejor: `d < entrar_a_atacar` dice qué significa el 40.

### 5.3 Un contador de cambios (provisorio)

Para que el parpadeo se pueda medir, contar los cambios en la etiqueta. Agregar una variable arriba:

```gdscript
var cambios = 0
```

Y en `cambiar_estado()`, reemplazar la línea `$LabelEstado.text = nombre` por estas dos:

```gdscript
	cambios += 1
	$LabelEstado.text = nombre + " " + str(cambios)
```

### 5.4 Sin margen: 40 / 40

1. Cambiar `var salir_de_atacar = 60` por `var salir_de_atacar = 40`.
2. En `jugador.gd`, bajar provisoriamente `var velocidad = 200` a `var velocidad = 50`. Tiene que quedar **más lento que el jefe** (70), para que el jefe lo alcance mientras se aleja.
3. Guardar y F6. Dejarse alcanzar (el jefe pasa a ATACAR, naranja).
4. Caminar **despacio y en línea recta**, alejándose del jefe.

> **Punto de control:** el jefe titila entre naranja y blanco, la etiqueta alterna `ATACAR` / `PERSEGUIR` sin parar y el contador sube decenas de veces por segundo. Output se llena de `Jefe → ATACAR` / `Jefe → PERSEGUIR`. (Medido en la demo 08 de la teórica: unos 40 cambios por segundo).

Por qué pasa: en ATACAR el jefe está quieto y el jugador se aleja, así que a los pocos frames la distancia pasa de 40 y vuelve a PERSEGUIR. En PERSEGUIR el jefe es más rápido, así que enseguida baja de 40 y vuelve a ATACAR. Con el mismo número de ida y de vuelta, cualquier movimiento chiquito cruza la línea.

Hace falta que el jugador **se mueva**: si se queda quieto, el jefe llega, entra a ATACAR y ahí se queda, porque la distancia ya no cambia.

### 5.5 Con margen: 40 / 60

1. Volver a `var salir_de_atacar = 60`.
2. F6 y repetir la misma caminata lenta.

> **Punto de control:** el jefe ataca, el jugador se aleja 20 px más antes de que lo suelte, lo vuelve a alcanzar y vuelve a atacar. Los cambios se cuentan de a uno o dos por segundo, no de a decenas. Entre 40 y 60 px el jefe se queda en el estado que tenía.

### 5.6 Ver y perder: 250 / 350

El mismo margen está en la flecha de "lo vio". Para notarlo, con el jugador a velocidad 50:

1. Poner `var distancia_perder = 250` (igual que `distancia_ver`). F6.
2. Desde lejos, ubicarse justo donde el jefe cambia a `PERSEGUIR` y dar pasitos cortos de un lado a otro de esa línea, alejándose y acercándose (el jefe también se mueve, así que hay que ir buscando el borde).
3. Volver a `var distancia_perder = 350` y repetir.

> **Punto de control:** con 250 / 250, cada pasito cruza la línea y el jefe alterna entre medio transparente y opaco, con el contador subiendo. Con 250 / 350, una vez que el jefe lo vio, hay que alejarse **100 px más** para que lo pierda: los pasitos ya no lo hacen dudar.

Esta flecha no titila sola como la de atacar, porque en los dos estados el jefe se mueve hacia el jugador (a 35 o a 70 px/s). Hay que provocarla yendo y viniendo sobre el borde.

### 5.7 Dejarlo como estaba

1. En `jugador.gd`, volver a `var velocidad = 200`.
2. En `slime_elite.gd`, confirmar los cuatro umbrales: **250, 350, 40, 60**.
3. Borrar `var cambios = 0` y, en `cambiar_estado()`, volver a la línea `$LabelEstado.text = nombre`. (O dejar el contador, si sirve para mostrarlo en clase).

---

## 6 · Disparos automáticos

En un *survivors* el arma es automática: el jugador solo se mueve. El personaje dispara cada 0.4 s hacia el enemigo **más cercano**, y cada bala que le pega al jefe lo manda a GOLPEADO, igual que la bomba. Es lo mismo que pide la Parte 4 del TP3.

**Si el proyecto ya tiene `bala.tscn` y `TimerDisparo` (como el TP3), saltear hasta 6.4.**

### 6.1 La escena de la bala

1. **Scene → New Scene** → **Other Node** → `Area2D`. Renombrarla `Bala`.
2. Agregar un `Sprite2D` hijo. En **Texture**, arrastrar un dibujo de bala si el proyecto tiene uno; si no, `icon.svg` (viene con todo proyecto nuevo) con **Scale** `0.2, 0.2`.
3. Agregar un `CollisionShape2D` hijo de `Bala` → **Shape → New CircleShape2D**, radio cerca de `8`.
4. Agregar un `Timer` hijo de `Bala`. Renombrarlo `TimerVida`. **Wait Time** `2`, **One Shot** tildado, **Autostart** tildado. Si la bala no le pega a nada, a los 2 s desaparece.
5. Guardar como `bala.tscn`.
6. Clic derecho en `Bala` → **Attach Script** → `bala.gd`. Reemplazar todo por:

```gdscript
extends Area2D

var velocidad = 400
var direccion = Vector2.RIGHT
var dano = 1

func _ready():
	area_entered.connect(_on_area_entered)
	$TimerVida.timeout.connect(queue_free)

func _process(delta):
	position += direccion * velocidad * delta

func _on_area_entered(area):
	if area is Enemigo:
		area.recibir_dano(dano)
		queue_free()
```

Aclaraciones:

- `area_entered` es la equivalente de `body_entered` para cuando entra **otro `Area2D`**. Los slimes son `Area2D`, así que la bala los detecta con esta. Al jugador (`CharacterBody2D`) la bala no lo ve.
- `area is Enemigo` pregunta por la **clase**: da `true` para el slime común y para el jefe, que es hijo de `Enemigo`.
- `area.recibir_dano(dano)` es el mismo "botón" que aprieta la bomba. Para el jefe, ese botón ya incluye el empujón y la flecha a GOLPEADO.

### 6.2 El contenedor de balas

1. En `arena.tscn`, seleccionar `Arena` → **+** → `Node2D`. Renombrarlo `Balas`. Dejarlo en (0, 0).
2. Clic derecho sobre `Balas` → **Access as Unique Name** (**Acceder como Nombre Único**). Aparece el `%`.

Como `Enemigos`: vacío, sin script. Las balas van ahí y no adentro del jugador, porque un hijo se mueve con su padre: si fueran hijas de `Jugador`, se desviarían cada vez que el personaje camina.

### 6.3 Disparar desde el jugador

1. Seleccionar `Jugador` → **+** → `Timer`. Renombrarlo `TimerDisparo`. **Wait Time** `0.4`, **Autostart** tildado, **One Shot** sin tildar.
2. `jugador.gd` completo:

```gdscript
extends CharacterBody2D

var velocidad = 200
var vida = 100
var escena_bala = preload("res://bala.tscn")

func _ready():
	add_to_group("jugador")
	$TimerDisparo.timeout.connect(disparar)

func _physics_process(_delta):
	var direccion = Input.get_vector("mover_izquierda",
		"mover_derecha", "mover_arriba", "mover_abajo")
	velocity = direccion * velocidad
	move_and_slide()

	if direccion == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("run")
	if direccion.x != 0:
		$AnimatedSprite2D.flip_h = direccion.x < 0

func recibir_dano(cantidad):
	vida -= cantidad
	print("Jugador: " + str(vida) + " de vida")

func disparar():
	var objetivo = enemigo_mas_cercano()
	if objetivo == null:
		return
	var bala = escena_bala.instantiate()
	bala.position = position
	bala.direccion = (objetivo.position - position).normalized()
	%Balas.add_child(bala)

func enemigo_mas_cercano():
	var mas_cercano = null
	var menor_distancia = INF
	for enemigo in get_tree().get_nodes_in_group("enemigo"):
		var distancia = position.distance_to(enemigo.position)
		if distancia < menor_distancia:
			menor_distancia = distancia
			mas_cercano = enemigo
	return mas_cercano
```

Qué hace cada parte nueva:

| Línea | Para qué está |
|---|---|
| `preload("res://bala.tscn")` | El molde de la bala, cargado una vez. Arrastrar el `.tscn` desde FileSystem para no errarle a la ruta. |
| `$TimerDisparo.timeout.connect(disparar)` | Cada 0.4 s, el Timer llama a `disparar()`. |
| `if objetivo == null: return` | Sin enemigos en pantalla, no dispara. |
| `bala.direccion = (objetivo.position - position).normalized()` | La misma resta de vectores del slime: la flecha del jugador al objetivo, de largo 1. |
| `%Balas.add_child(bala)` | Recién acá la bala entra al juego. Equivale a `get_node("../Balas")`. |
| `menor_distancia = INF` | "Infinito": la primera distancia que se mida siempre es menor. |
| El `for` con el `if` | Se recorre el grupo `"enemigo"` y cada vez que aparece uno más cerca que el récord, pasa a ser el récord. |

### 6.4 Probarlo con el jefe

1. Guardar y F6. Con el spawner todavía apagado, el único objetivo es el jefe.
2. Mantenerse lejos y dejar que las balas le peguen.

> **Punto de control:** las balas salen solas hacia el jefe. Con cada una el jefe retrocede, se pone **rojo**, dice `GOLPEADO`, y a las 12 balas Output muestra `¡Cayó un élite!`. Las balas que no le pegan a nada desaparecen a los 2 s (en la pestaña **Remote**, `Balas` no crece sin fin).

Mirando con atención se ve el **stun lock**: `TimerDisparo` (0.4 s) es más rápido que `TimerGolpe` (0.5 s). Cada bala reinicia el medio segundo antes de que termine, así que mientras el jefe sea el blanco más cercano no sale nunca de GOLPEADO y ni siquiera llega a atacar. En muchos *survivors* es a propósito: el jugador que dispara sin parar, "congela" al jefe. Si no se busca ese efecto, bajar el **Wait Time** de `TimerGolpe` a `0.3`.

### 6.5 Con la horda

1. Volver a tildar **Autostart** en el `Timer` del `Spawner`.
2. Borrar el élite puesto a mano dentro de `Enemigos`.
3. F5.

> **Punto de control:** las balas matan a los slimes comunes de un golpe; cada 8 entra un jefe que acecha medio transparente, acelera al ver al jugador, se frena naranja para pegar y acusa en rojo cada bala que le llega. La bomba de Enter sigue funcionando. Como la horda suele estar más cerca, el jefe recibe menos balas y tiene tiempo de atacar.

---

## Cuando no funciona

| Mensaje o síntoma | Causa y arreglo |
|---|---|
| El jefe no se mueve (la etiqueta se queda en `ACECHAR`) | `jugador` es `null`: el élite puesto a mano corrió su `_ready()` antes que el jugador. Pasa cuando `Enemigos` está **arriba** de `Jugador` en el árbol. Arreglo: poner el grupo `jugador` desde **Node → Groups** (paso 0.2), o arrastrar `Jugador` arriba de todo. Los élites que crea el spawner no tienen el problema, porque nacen con el juego ya andando. |
| El jefe no se mueve, corriendo con F6 | Se corrió `slime_elite.tscn` en vez de `arena.tscn`: sin jugador en la escena, `jugador` es `null`. Poner la pestaña `arena.tscn` al frente, o usar F5. |
| Los slimes comunes también cambiaron | Se modificó `enemigo.gd`, o se agregaron nodos a `slime.tscn`. Todo lo de hoy va en `slime_elite.gd` y `slime_elite.tscn`. |
| `Node not found: "LabelEstado"` (o `TimerAtaque`, `TimerGolpe`) | El nodo no está en `slime_elite.tscn`, o tiene otro nombre (mayúsculas incluidas), o no es hijo directo de `SlimeElite`. |
| `Identifier "PERSEGUIR" not declared` | Falta `Estado.` adelante, o el estado no está en el `enum`, o difiere en una letra. |
| El jefe persigue siempre, sin acechar | El `_process` del jefe llama a `super()`, o se llama distinto (`_proces`): en ese caso corre el de la madre. |
| La etiqueta y el color no cambian (desde el bloque 4) | Quedó algún `estado = Estado...` sin reemplazar por `cambiar_estado(...)`. Buscar con Ctrl+F. |
| `Node not found: "LabelEstado"` al arrancar (desde el bloque 4) | `cambiar_estado(Estado.ACECHAR)` quedó arriba del `super()` en `_ready()`. Va al final. |
| Sigue desapareciendo al tocar al jugador | La función de anulación no se llama exactamente `_on_body_entered` o le falta el parámetro. |
| Pega todo el tiempo, no cada segundo | Falta `$TimerAtaque.start()` después de pegar. |
| Pega una vez y nunca más | **One Shot** destildado en `TimerAtaque`. |
| Nunca llega a ATACAR | Con el sprite grande, 40 px puede quedar corto. Probar 60 y 80 (con variables, cambiando `entrar_a_atacar` y `salir_de_atacar`). |
| Parpadea entre dos estados | El mismo número en la flecha de ida y la de vuelta. Falta el margen (bloque 5). |
| Queda rojo para siempre | Bloque 3: el `modulate = Color.WHITE` no está en la salida de GOLPEADO. Bloque 4: esa salida todavía hace `estado = ...` en vez de `cambiar_estado(...)`. |
| Nunca sale de GOLPEADO | *Stun lock*: los golpes llegan más seguido que 0.5 s (Enter muy rápido, o las balas cada 0.4). Bajar `TimerGolpe` a 0.3. |
| Muere sin ponerse nunca rojo | El golpe está antes de `super(cantidad)` o afuera del `if vida > 0`. |
| La consola se llena de líneas iguales | El `print` quedó en `_process`, o `cambiar_estado()` se llama fuera de un `if`. |
| El jefe se ve chiquito o la etiqueta enorme | El `scale = Vector2(2, 2)` del script agranda también la etiqueta. Ajustar su Position o su tamaño de fuente. |
| El jefe ya no mira hacia donde camina | Falta `$AnimatedSprite2D.flip_h = dir.x < 0` en `acechar()` y `perseguir()`. |
| Las balas no salen | `TimerDisparo` sin **Autostart**, o no hay ningún enemigo en pantalla. |
| `Cannot call method 'add_child' on a null value` al disparar | Falta **Access as Unique Name** en `Balas`, o el nodo se llama distinto. |
| Las balas atraviesan a los enemigos | Falta el `CollisionShape2D` (o su Shape) en la bala, o Layer/Mask sin el 1. |
| Las balas se desvían cuando el jugador camina | Se agregaron como hijas del jugador. Van en `Balas`. |
| Advertencia `UNUSED_PARAMETER` con `body` | No es un error: `_on_body_entered(body)` no usa `body` a propósito. |

## Desafío: el aviso antes del golpe

1. Un estado nuevo, `AVISO`, entre PERSEGUIR y ATACAR: a menos de 40 px, el jefe pasa a AVISO en vez de atacar.
2. En AVISO se queda quieto y **amarillo** durante 0.4 s (un `TimerAviso`, One Shot).
3. Al terminar el Timer: si el jugador sigue a menos de 60 px, ATACAR; si no, PERSEGUIR.

Primero dibujar la flecha nueva en el diagrama. Después: un valor en el `enum`, una rama en el `match`, el `start()` del Timer en la flecha de entrada y un color en `cambiar_estado()`. Nada más. Es el aviso de *Hollow Knight*: el jugador que lo lee a tiempo, se salva.

## Código final de `slime_elite.gd`

Con los umbrales en variables del bloque 5, sin el contador. Se comporta igual que el código de referencia del TP4; cambian el `scale` (en el TP lo da el sprite), la falta de `BarraVida` y los números con nombre.

```gdscript
extends Enemigo

enum Estado { ACECHAR, PERSEGUIR, ATACAR, GOLPEADO }

var estado = Estado.ACECHAR
var jugador = null
var distancia_ver = 250       # a menos de esto, PERSEGUIR
var distancia_perder = 350    # a más de esto, vuelve a ACECHAR
var entrar_a_atacar = 40      # a menos de esto, ATACAR
var salir_de_atacar = 60      # a más de esto, vuelve a PERSEGUIR

func _ready():
	super()
	vida = 12
	velocidad = 70
	dano = 15
	scale = Vector2(2, 2)
	jugador = get_tree().get_first_node_in_group("jugador")
	cambiar_estado(Estado.ACECHAR)

func _process(delta):
	if jugador == null:
		return
	var d = position.distance_to(jugador.position)
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < distancia_ver: cambiar_estado(Estado.PERSEGUIR)
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < entrar_a_atacar: cambiar_estado(Estado.ATACAR)
			elif d > distancia_perder: cambiar_estado(Estado.ACECHAR)
		Estado.ATACAR:
			atacar()
			if d > salir_de_atacar: cambiar_estado(Estado.PERSEGUIR)
		Estado.GOLPEADO:
			if $TimerGolpe.is_stopped():
				cambiar_estado(Estado.PERSEGUIR)

func cambiar_estado(nuevo):
	estado = nuevo
	var nombre = Estado.keys()[estado]
	$LabelEstado.text = nombre
	print("Jefe → " + nombre)
	match estado:
		Estado.ACECHAR: modulate = Color(1, 1, 1, 0.5)
		Estado.PERSEGUIR: modulate = Color.WHITE
		Estado.ATACAR: modulate = Color(1, 0.6, 0.2)
		Estado.GOLPEADO: modulate = Color(1, 0.4, 0.4)

func acechar(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * 0.5 * delta
	$AnimatedSprite2D.flip_h = dir.x < 0

func perseguir(delta):
	var dir = (jugador.position - position).normalized()
	position += dir * velocidad * delta
	$AnimatedSprite2D.flip_h = dir.x < 0

func atacar():
	if $TimerAtaque.is_stopped():
		jugador.recibir_dano(dano)
		$TimerAtaque.start()

func _on_body_entered(body):
	pass

func recibir_dano(cantidad):
	super(cantidad)
	if vida > 0:
		position += (position - jugador.position).normalized() * 20
		$TimerGolpe.start()
		cambiar_estado(Estado.GOLPEADO)

func morir():
	print("¡Cayó un élite!")
	super()
```
