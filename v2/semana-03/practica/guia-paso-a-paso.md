# La horda · guía paso a paso

Guía detallada de la práctica de la semana 3 (clase 5), desde la arena vacía hasta la bomba. Versión con `AnimatedSprite2D`, slime `Area2D` y Godot 4. Los menús figuran en inglés y, entre paréntesis, en español.

Cada bloque termina con un **punto de control**. Conviene no avanzar hasta que se cumpla.

## Cómo queda el proyecto al final

```
arena.tscn
Arena            Node2D            arena.gd
├── Jugador      CharacterBody2D   jugador.gd
│   ├── AnimatedSprite2D
│   └── CollisionShape2D
├── Spawner      Node2D            spawner.gd
│   └── Timer
└── Enemigos     Node2D            (vacío, sin script)

slime.tscn
Slime            Area2D            enemigo.gd
├── AnimatedSprite2D
└── CollisionShape2D

slime_elite.tscn (heredada de slime.tscn)
SlimeElite       Area2D            slime_elite.gd
```

Tres reglas que evitan la mayoría de los errores:

- Los **nombres** de nodos, grupos y animaciones tienen que coincidir letra por letra con los del código, mayúsculas incluidas.
- `Arena`, `Spawner` y `Enemigos` quedan siempre en **Position (0, 0)** y **Scale (1, 1)**.
- El tipo del nodo y la línea `extends` de su script tienen que coincidir (`Area2D` con `extends Area2D`, etc.).

---

## 0 · Preparación

### 0.1 Proyecto y filtro de texturas

1. Crear un proyecto nuevo llamado `clase-05`.
2. Si los sprites son pixel art: **Project → Project Settings** (**Proyecto → Configuración del Proyecto**) → **Rendering → Textures → Default Texture Filter** → **Nearest**. Sin esto se ven borrosos al agrandarlos.

### 0.2 Input Map

1. **Project → Project Settings → Input Map** (**Mapa de Entrada**).
2. En "Add New Action" escribir `mover_izquierda` y pulsar **Add** (**Añadir**).
3. Repetir con `mover_derecha`, `mover_arriba` y `mover_abajo`.
4. En cada acción, pulsar el **+** de la derecha, apretar la tecla (A, D, W, S o las flechas) y dar **OK**.

### 0.3 La arena

1. En el panel **Scene** (**Escena**) elegir **Other Node** (**Otro Nodo**) → `Node2D`. Renombrarlo `Arena` con F2.
2. Guardar con Ctrl+S como `arena.tscn`.
3. Seleccionar `Arena`, pulsar **+** (Ctrl+A) y agregar un `Node2D`. Renombrarlo `Enemigos`.

`Enemigos` queda **vacío**: sin script, sin sprite, sin hijos. Funciona como una carpeta donde el juego va a ir metiendo los slimes.

### 0.4 El jugador

1. Seleccionar `Arena` y agregar un `CharacterBody2D`. Renombrarlo `Jugador`.
2. En **Transform → Position** poner `576` y `324` (el centro de una ventana de 1152×648).
3. Con `Jugador` seleccionado, agregar un `AnimatedSprite2D`. No renombrarlo.
4. En el Inspector: **Animation → Sprite Frames** → **New SpriteFrames**. Hacer clic sobre el recurso creado: se abre el panel **SpriteFrames** abajo.
5. Renombrar la animación `default` a `idle` (doble clic sobre el nombre).
6. Pulsar el ícono de grilla, **Add frames from sprite sheet** (**Añadir fotogramas desde hoja de sprites**), y elegir la imagen del personaje.
7. Ajustar **Horizontal** y **Vertical** a la cantidad de columnas y filas de la hoja. Seleccionar los cuadros del personaje quieto y pulsar **Add Frames**.
8. Pulsar **Add Animation** (**Añadir Animación**), llamarla `run` y cargarle los cuadros de correr igual que antes.
9. En las dos animaciones: FPS en `10` aproximadamente y **loop** activado.
10. Ajustar **Transform → Scale** del `AnimatedSprite2D` hasta que el tamaño sea cómodo (en pixel art, `2` o `3`).
11. Seleccionar `Jugador` y agregar un `CollisionShape2D`. En **Shape** (**Forma**) elegir **New RectangleShape2D** y ajustar los puntos naranjas al cuerpo del personaje.

### 0.5 Script del jugador

Clic derecho en `Jugador` → **Attach Script** (**Añadir Script**) → `jugador.gd` → **Create**. Reemplazar todo por:

```gdscript
extends CharacterBody2D

var velocidad = 200
var vida = 100

func _ready():
	add_to_group("jugador")

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
```

Aclaraciones:

- `add_to_group("jugador")` es la etiqueta con la que los slimes lo van a encontrar.
- `_delta` lleva guion bajo porque `move_and_slide()` no lo necesita. Sin el guion bajo, Godot muestra la advertencia `UNUSED_PARAMETER`, que no rompe nada.
- `flip_h` espeja el sprite al ir a la izquierda. Si el dibujo original mira a la izquierda, cambiar `<` por `>`.
- `recibir_dano()` es el "botón" que los slimes van a apretar.
- Si el archivo se llama distinto (por ejemplo `player.gd`), no hay problema: lo que importa es el contenido.

Correr con **F5**. Cuando pregunte por la escena principal, elegir **Select Current** (**Seleccionar Actual**).

> **Punto de control:** el personaje se mueve con las teclas, cambia entre `idle` y `run` y mira hacia donde camina.

---

## 1 · El slime

### 1.1 La escena

1. **Scene → New Scene** (**Escena → Nueva Escena**) → **Other Node** → `Area2D`. Renombrar la raíz a `Slime`.
2. Agregar un `AnimatedSprite2D` hijo. No renombrarlo.
3. Crear el **New SpriteFrames** y cargar los cuadros igual que con el jugador. Alcanza con una animación; puede quedar como `default`.
4. En el panel SpriteFrames, activar el botón **Autoplay on Load** (**Reproducir automáticamente al cargar**) de esa animación. Sin esto el slime se mueve congelado en el primer cuadro.
5. Ajustar la escala del `AnimatedSprite2D`.
6. Seleccionar `Slime` y agregar un `CollisionShape2D` con **Shape → New CircleShape2D**. Ajustar el radio al cuerpo.
7. Con `Slime` seleccionado, verificar en el Inspector **Collision → Layer** y **Mask**: los dos con el **1** marcado.
8. Guardar como `slime.tscn`.

Por qué `Area2D` y no `CharacterBody2D`: un `Area2D` detecta sin chocar, así los slimes se superponen sin trabarse y la señal `body_entered` avisa sola cuando tocan al jugador.

Si la raíz quedó con otro tipo: clic derecho sobre ella → **Change Type…** (**Cambiar Tipo…**) → `Area2D`. Los hijos se conservan.

### 1.2 El script

Clic derecho en `Slime` → **Attach Script** → `enemigo.gd`. Reemplazar todo por:

```gdscript
class_name Enemigo
extends Area2D

var vida = 1
var velocidad = 60
var dano = 10

func _ready():
	add_to_group("enemigo")
	body_entered.connect(_on_body_entered)

func _process(delta):
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		return
	var direccion = (jugador.position - position).normalized()
	position += direccion * velocidad * delta
	$AnimatedSprite2D.flip_h = direccion.x < 0

func recibir_dano(cantidad):
	vida -= cantidad
	if vida <= 0:
		morir()

func morir():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		body.recibir_dano(dano)
		queue_free()
```

Qué hace cada parte:

| Línea | Para qué está |
|---|---|
| `class_name Enemigo` | Le da nombre a la clase. Sin esto el élite no puede escribir `extends Enemigo`. |
| `add_to_group("enemigo")` | Etiqueta para encontrarlos a todos después (bomba, contador). |
| `body_entered.connect(...)` | Conecta la señal que se dispara cuando un cuerpo entra en el área. |
| `get_first_node_in_group("jugador")` | Pregunta al árbol quién es el jugador, sin saber dónde está. |
| `if jugador == null: return` | Si no hay jugador, no hace nada en vez de dar error. |
| `(jugador.position - position).normalized()` | La resta da la flecha del slime al jugador; `normalized()` la deja de largo 1. |
| `position += ... * delta` | Un `Area2D` se mueve con `position`, y por eso lleva `delta`. |
| `body.recibir_dano(dano)` | Le pide daño al jugador; no le toca la `vida` directamente. |

### 1.3 Probarlo a mano

1. Guardar y volver a la pestaña `arena.tscn`.
2. Seleccionar `Enemigos` y pulsar el **ícono de cadena** del panel Scene (Ctrl+Shift+A). Elegir `slime.tscn`.
3. Con la herramienta Move (W), llevar el slime a una esquina.
4. Correr con F5.

> **Punto de control:** el slime persigue al jugador. Al tocarlo, el panel **Output** (**Salida**) muestra `Jugador: 90 de vida` y el slime desaparece.

5. Borrar ese slime de la arena (seleccionarlo y Supr): a partir de acá los crea el código.

---

## 2 · Instanciar con una tecla

Crear un objeto mientras el juego corre son siempre tres pasos:

1. `preload("res://slime.tscn")`: cargar el molde, una sola vez.
2. `molde.instantiate()`: sacar una copia, todavía fuera del juego.
3. `add_child(copia)`: meterla en el árbol. Recién ahí aparece y corre su `_ready()`.

Entre el 2 y el 3 se le pueden cambiar datos (`position`, `velocidad`…).

### 2.1 Script de la arena

1. Clic derecho en `Arena` → **Attach Script** → `arena.gd`.
2. Para no escribir la ruta a mano: escribir `var escena_slime = preload(`, arrastrar `slime.tscn` desde **FileSystem** hasta el script y cerrar el paréntesis.
3. Completar:

```gdscript
extends Node2D

var escena_slime = preload("res://slime.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		crear_slime()

func crear_slime():
	var slime = escena_slime.instantiate()
	slime.position = Vector2(randf_range(0, 1152),
		randf_range(0, 648))
	$Enemigos.add_child(slime)
	var total = get_tree().get_nodes_in_group("enemigo").size()
	print("Slimes en pantalla: " + str(total))
```

`ui_accept` ya viene definida en Godot: incluye Espacio y Enter.

> **Punto de control:** cada Espacio crea un slime en un lugar al azar y Output cuenta `Slimes en pantalla: 1`, `2`, `3`…

Este código es de prueba: se reemplaza en el bloque 4.

---

## 3 · El spawner

### 3.1 Los nodos

1. En `arena.tscn`, seleccionar `Arena` y agregar un `Node2D`. Renombrarlo `Spawner`. Dejarlo en (0, 0).
2. Seleccionar `Spawner` y agregar un `Timer`. Tiene que quedar **hijo de `Spawner`**.
3. En el Inspector del `Timer`: **Wait Time** en `1`, **Autostart** tildado, **One Shot** sin tildar.
4. Clic derecho sobre `Enemigos` → **Access as Unique Name** (**Acceder como Nombre Único**). Aparece un `%` al lado del nodo.

El nombre único permite escribir `%Enemigos` desde cualquier script de la escena, sin pensar en rutas. El deck usa `get_node("../Enemigos")`, que hace lo mismo: `..` sube de `Spawner` a `Arena` y desde ahí busca `Enemigos`. Esa ruta falla con `Cannot call method 'add_child' on a null value` si el nombre no coincide o si `Enemigos` no es hermano de `Spawner`.

### 3.2 Primero, posición fija

Clic derecho en `Spawner` → **Attach Script** → `spawner.gd`:

```gdscript
extends Node2D

var escena_slime = preload("res://slime.tscn")

func _ready():
	$Timer.timeout.connect(spawnear)

func spawnear():
	var slime = escena_slime.instantiate()
	slime.position = Vector2(100, 100)
	%Enemigos.add_child(slime)
```

Correr.

> **Punto de control:** sale un slime por segundo desde arriba a la izquierda.

Para ver que se están guardando donde corresponde: con el juego corriendo, en el panel Scene pasar a la pestaña **Remote** (**Remoto**) y abrir `Enemigos`.

### 3.3 Después, por los bordes

Cambiar la línea de la posición y agregar la función al final:

```gdscript
extends Node2D

var escena_slime = preload("res://slime.tscn")

func _ready():
	$Timer.timeout.connect(spawnear)

func spawnear():
	var slime = escena_slime.instantiate()
	slime.position = posicion_en_el_borde()
	%Enemigos.add_child(slime)

func posicion_en_el_borde():
	var tam = get_viewport_rect().size
	var lado = randi_range(0, 3)
	if lado == 0:
		return Vector2(randf_range(0, tam.x), -40)
	if lado == 1:
		return Vector2(randf_range(0, tam.x), tam.y + 40)
	if lado == 2:
		return Vector2(-40, randf_range(0, tam.y))
	return Vector2(tam.x + 40, randf_range(0, tam.y))
```

Cómo se lee `posicion_en_el_borde()`: se sortea un lado (0 arriba, 1 abajo, 2 izquierda, 3 derecha), se elige un punto al azar a lo largo de ese lado y se lo corre 40 píxeles hacia afuera, para que el slime entre caminando.

### 3.4 Limpiar la arena

En `arena.gd`, borrar `_process` y `crear_slime()`. Por ahora queda solo `extends Node2D`.

> **Punto de control:** un slime por segundo entra desde un borde al azar, y todos persiguen al jugador.

---

## 4 · El élite

El élite hace todo lo que hace el slime, con otros números y otro aspecto. En vez de copiar el código, se hereda. Son dos herencias: la de la **escena** (mismos nodos) y la del **script** (mismo código).

### 4.1 Escena heredada

1. Guardar todo con Ctrl+S.
2. En la barra de menú de arriba: **Scene → New Inherited Scene…** (**Escena → Nueva Escena Heredada…**).
3. Elegir `slime.tscn` y pulsar **Open** (**Abrir**).
4. Se abre una pestaña nueva. Los nodos hijos aparecen en **amarillo**: vienen heredados.
5. Hacer clic en el `AnimatedSprite2D`. En el Inspector: **CanvasItem → Visibility → Modulate** (**Visibilidad → Modular**). Clic en el rectángulo blanco y elegir un violeta.
6. No tocar la escala acá: se cambia desde el script.
7. Hacer clic en la raíz, apretar F2 y renombrarla `SlimeElite`.
8. Ctrl+S → `slime_elite.tscn`.

Cuidado con los recursos compartidos: el **Sprite Frames** y la **Shape** son los mismos que usa `slime.tscn`. Si se editan acá, cambia también el slime común. Para tener una copia propia, clic derecho sobre la propiedad → **Make Unique** (**Hacer Único**). Modulate y Scale son del nodo y no afectan al original.

### 4.2 Script heredado

1. Clic derecho en la raíz `SlimeElite` → **Extend Script…** (**Extender Script…**). No usar *Attach Script*: eso reemplaza el script en vez de heredarlo.
2. En **Path** (**Ruta**) poner `res://slime_elite.gd` y pulsar **Create**.
3. Borrar lo que aparece y escribir:

```gdscript
extends Enemigo

func _ready():
	super()
	vida = 5
	velocidad = 35
	dano = 25
	scale = Vector2(2, 2)

func morir():
	print("¡Cayó un élite!")
	super()
```

Aclaraciones:

- `extends Enemigo` trae todo `enemigo.gd`: perseguir, recibir daño, pegarle al jugador.
- `super()` ejecuta la versión de la madre. En `_ready` agrega al grupo y conecta la señal; en `morir` hace el `queue_free()`. Si falta, el élite no pega o no muere.
- `scale = Vector2(2, 2)` agranda la raíz al doble y, con ella, el sprite y la colisión.

Para probarlo, instanciar uno a mano en la arena con el ícono de cadena. Al tocarlo, Output muestra `Jugador: 75 de vida`. Después borrarlo.

### 4.3 Uno cada 8 en el spawner

`spawner.gd` completo:

```gdscript
extends Node2D

var escena_slime = preload("res://slime.tscn")
var escena_elite = preload("res://slime_elite.tscn")
var contador = 0

func _ready():
	$Timer.timeout.connect(spawnear)

func spawnear():
	contador += 1
	var slime
	if contador % 8 == 0:
		slime = escena_elite.instantiate()
	else:
		slime = escena_slime.instantiate()
	slime.position = posicion_en_el_borde()
	%Enemigos.add_child(slime)

func posicion_en_el_borde():
	var tam = get_viewport_rect().size
	var lado = randi_range(0, 3)
	if lado == 0:
		return Vector2(randf_range(0, tam.x), -40)
	if lado == 1:
		return Vector2(randf_range(0, tam.x), tam.y + 40)
	if lado == 2:
		return Vector2(-40, randf_range(0, tam.y))
	return Vector2(tam.x + 40, randf_range(0, tam.y))
```

`%` es el resto de la división: `contador % 8 == 0` se cumple en 8, 16, 24…

> **Punto de control:** cada 8 slimes entra uno violeta, grande y lento.

### 4.4 La bomba

`arena.gd` completo:

```gdscript
extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		for enemigo in get_tree().get_nodes_in_group("enemigo"):
			enemigo.recibir_dano(1)
```

La bomba no pregunta qué tipo de enemigo es cada uno: les pide lo mismo a todos y cada uno responde según su clase. Eso es polimorfismo.

> **Punto de control:** con Enter o Espacio los slimes comunes desaparecen y los élites siguen. Al quinto golpe, Output muestra `¡Cayó un élite!`.

---

## Cuando no funciona

| Mensaje o síntoma | Causa y arreglo |
|---|---|
| `Script inherits from native type 'Area2D', so it can't be assigned to an object of type 'CharacterBody2D'` | El tipo del nodo y el `extends` del script no coinciden. Cambiar el tipo del nodo con **Change Type** o corregir la línea `extends`. |
| `Cannot call method 'add_child' on a null value` | No se encontró `Enemigos`. Revisar el nombre exacto, que sea hijo directo de `Arena` y que tenga activado **Access as Unique Name**. |
| `Could not find type "Enemigo"` | Falta `class_name Enemigo` en `enemigo.gd`, o no se guardó. |
| `Could not preload resource` | Ruta mal escrita. Arrastrar el `.tscn` desde FileSystem al script. |
| `Node not found: AnimatedSprite2D` | El nodo tiene otro nombre. Renombrarlo o cambiar lo que sigue al `$`. |
| `Animation not found` | El nombre en `play("...")` no coincide con el del panel SpriteFrames. |
| Advertencia `UNUSED_PARAMETER` con `delta` | No es un error. Escribir `_delta` en esa función. |
| El slime no persigue | El jugador no está en el grupo `"jugador"`, o el nombre del grupo difiere en una letra. |
| El slime persigue un punto equivocado | `Arena`, `Enemigos` o `Spawner` no están en (0, 0). |
| El slime no le pega al jugador | Falta el `CollisionShape2D` (o su Shape) en alguno de los dos, o Layer/Mask no tienen el 1. |
| El sprite no se anima | Falta **Autoplay on Load** en el slime, o el `play()` en el jugador. |
| No sale ningún slime | **Autostart** sin tildar, el `Timer` no es hijo de `Spawner`, o se está corriendo otra escena con F6. |
| El élite muere de un golpe o no pega | Se usó Attach en vez de Extend Script, o falta `super()` en `_ready()`. |
| El élite queda enorme | Se escaló dos veces: en el editor y en el script. Resetear la escala en el editor. |
| Cambió el slime común al editar el élite | Faltó **Make Unique** en Shape o en Sprite Frames. |

## Desafío

1. **El veloz:** escena heredada de `slime.tscn`, amarilla y pequeña, con un script que `extends Enemigo` y pone `velocidad = 150`.
2. Que el spawner lo cree cada 5 slimes.
3. **Extra:** que el spawner acelere con el tiempo. En `spawnear()`: `$Timer.wait_time = max($Timer.wait_time * 0.98, 0.2)`.

Si la bomba sigue funcionando con el veloz sin cambiarle una línea, el polimorfismo está funcionando.
