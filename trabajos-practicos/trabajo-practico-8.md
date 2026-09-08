# Trabajo Práctico 8 — El jefe aprende a pensar (máquina de estados)

> **Diplomatura de Videojuegos · Clase 8 · Proyecto final**
> Objetivo: darle **cerebro al slime élite** (el jefe) del TP7 con una **máquina de estados**: te va a **acechar** de lejos, **perseguirte** cuando te acercás, **atacarte** cuando te alcanza, y **sentir el golpe** cuando le pegás: un empujón y medio segundo congelado. El slime básico **queda como está**: es la horda. Y al final, **exportás** el juego: es tu proyecto final.

---

## 🎯 Qué vas a lograr

- El **jefe** con **cuatro estados** —`ACECHAR`, `PERSEGUIR`, `ATACAR`, `GOLPEADO`— y las transiciones entre ellos, escritas con `enum` + `match` como en la clase.
- Una **etiqueta sobre el jefe** que muestra en qué estado está: vas a *ver* la máquina de estados funcionando.
- El jefe **ya no es kamikaze**: se frena y te pega **cada segundo** mientras estés cerca.
- Cada bala que le pega al jefe lo **empuja** y lo **congela 0.5 s**: el golpe se siente.
- El slime básico **intacto**: sigue siendo la horda simple del TP7.
- El juego **exportado** a `.exe`, listo para compartir.

> 💡 **Tiempo estimado:** 75–100 min. Se toca **un solo script**: `enemigo_elite.gd`. El slime básico, el jugador, las balas y el spawner quedan como estaban.

> 🔗 **Viene de la Clase 8:** comportamientos básicos, el problema del spaghetti de `if`, máquinas de estado, `enum` y `match`, y el patrón **hacer + decidir**. Y de todo el curso: herencia y `super()` (TP5), `Timer`, grupos y `distance_to` (TP7).

---

## 📍 Punto de partida

Este TP continúa **`tp7-sobrevivir`**. Abrilo (o copiá la carpeta como `tp8-final`).

Confirmá que el **punto de control 5 del TP7** sigue andando: los slimes te persiguen, las balas salen solas, y cada 8 aparece un élite con su barra.

> 🧠 **Recordá cómo quedó el élite en el TP7.** `enemigo_elite.gd` **hereda** de `enemigo.gd` (`extends "res://enemigo.gd"`): en `_ready()` llama a `super()` y después cambia `vida`, `velocidad`, `dano` y su `$BarraVida`; y en `recibir_dano()` llama a `super(cantidad)` y actualiza la barra. Todo lo demás —perseguir en `_process`, `morir()`, y el `_on_body_entered()` kamikaze— lo **hereda tal cual** del básico. Hoy le vamos a dar **su propio `_process`**.

### 🧠 Decisión de diseño: ¿por qué solo el jefe?

Si le diéramos la máquina de estados a **todos** los slimes, ¿cuál sería su estado “tranquilo”? La opción clásica es **patrullar** (caminar al azar), pero en un *survivors* sería un error: los slimes se irían **fuera de la pantalla**, el jugador podría **evitarlos para siempre**, y el juego se llenaría de enemigos que nadie ve y que igual gastan procesador.

Por eso:

- La **horda** (slime básico) sigue **simple y kamikaze**: siempre viene por vos. Es previsible a propósito.
- El **jefe** es el que **piensa**. Y su estado tranquilo **no es patrullar**: es **acechar** — venir hacia vos, pero **despacio**. Nunca se pierde, nunca se va de pantalla.

> Fijate que la decisión no es técnica, es de **diseño de juego**: la IA tiene que hacer el juego más divertido, no más “inteligente” (Clase 8).

---

## 🧩 El plan: primero el diagrama

En la clase dijimos: **si no lo podés dibujar, no lo podés programar.** Este es el diagrama que vamos a implementar en el jefe, con los mismos umbrales de la clase:

![Máquina de estados del jefe: ACECHAR, PERSEGUIR, ATACAR](tp8-assets/diagrama-3-estados.png)

Y lo vamos a construir **de a un estado por vez**, probando cada uno antes de seguir:

| Parte | Estados | Qué se ve |
| :---- | :---- | :---- |
| 1 | `ACECHAR` ⇄ `PERSEGUIR` | El jefe viene despacio; al acercarte, acelera |
| 2 | + `ATACAR` | Se frena al alcanzarte y te pega cada segundo |
| 3 | + `GOLPEADO` | Cada bala lo empuja y lo congela 0.5 s |
| 4 | — | Ajustar, exportar y entregar |

---

## 🛠️ Parte 0 — Dibujar antes de programar

Antes de escribir una línea, respondé estas tres preguntas **mirando el diagrama** (en papel o mentalmente):

1. El jefe está **acechando** y el jugador pasa a **200 px**. ¿En qué estado queda?
2. El jefe está **persiguiendo** y el jugador está a **300 px**. ¿Cambia de estado?
3. El jefe está **atacando** y el jugador se aleja a **50 px**. ¿Cambia? ¿Y si se aleja a **70 px**?

<details>
<summary>Respuestas (abrí después de pensarlas)</summary>

1. **`PERSEGUIR`**: 200 es menos de 250, así que cruza la flecha de “lo vio”.
2. **No.** 300 no es menos de 40 (no ataca) ni más de 350 (no lo perdió). **Se queda persiguiendo.** Las flechas solo se cruzan cuando se cumple su condición.
3. A **50 px sigue atacando** (50 no es más de 60). A **70 px vuelve a `PERSEGUIR`**.

> 🧠 **¿Por qué entra a atacar a 40 y sale a 60, y no a 40 en los dos?** Si el umbral fuera el mismo, un jugador parado justo en el borde haría que el jefe **parpadee** entre atacar y perseguir cada frame. Dejar un margen entre “entrar” y “salir” se llama **histéresis**, y es un truco que vas a usar en toda máquina de estados.
</details>

✅ **Punto de control 0:** contestaste las tres, entendés que cada flecha tiene **su** condición, y por qué los umbrales de entrada y salida son distintos.

---

## 🕵️ Parte 1 — Dos estados: ACECHAR y PERSEGUIR

> **Concepto:** el jefe deja de usar el `_process` del slime básico y recibe **el suyo**, con la máquina de estados. Arrancamos con **dos** estados, y una **etiqueta** encima que muestra cuál está activo.

**Reemplazá `enemigo_elite.gd`** por esta versión completa:

```gdscript
extends "res://enemigo.gd"

enum Estado { ACECHAR, PERSEGUIR }

var estado := Estado.ACECHAR
var jugador: Node2D = null

func _ready() -> void:
	super()                          # grupo, señal y animación del slime básico
	vida = 5
	velocidad = 35.0
	dano = 25
	$BarraVida.max_value = vida
	$BarraVida.value = vida

	jugador = get_tree().get_first_node_in_group("jugador")

	# Etiqueta que muestra el estado, creada por código
	var etiqueta := Label.new()
	etiqueta.name = "LabelEstado"
	etiqueta.position = Vector2(-36, -66)
	add_child(etiqueta)

func _process(delta: float) -> void:     # SOBREESCRIBE el _process del básico
	if jugador == null:
		return
	var d := distancia_al_jugador()
	match estado:
		Estado.ACECHAR:
			acechar(delta)                          # hacer
			if d < 250: estado = Estado.PERSEGUIR   # decidir
		Estado.PERSEGUIR:
			perseguir(delta)
			if d > 350: estado = Estado.ACECHAR
	$LabelEstado.text = Estado.keys()[estado]   # mostrar el estado encima

func _on_body_entered(body: Node) -> void:   # ANULA el kamikaze del básico
	pass

# ---- comportamientos: cada estado, una función ----
func acechar(delta: float) -> void:          # hacia el jugador, a MITAD de velocidad
	var dir := (jugador.position - position).normalized()
	position += dir * velocidad * 0.5 * delta
	$AnimatedSprite2D.flip_h = dir.x < 0

func perseguir(delta: float) -> void:        # hacia el jugador, a toda velocidad
	var dir := (jugador.position - position).normalized()
	position += dir * velocidad * delta
	$AnimatedSprite2D.flip_h = dir.x < 0

func distancia_al_jugador() -> float:
	return position.distance_to(jugador.position)

# ---- vida: igual que en el TP7 ----
func recibir_dano(cantidad: int) -> void:
	super(cantidad)
	$BarraVida.value = vida
```

> 🧠 **Qué está pasando acá (tres ideas de herencia):**
> - **Sobreescribir `_process`.** Al definirlo en el hijo, el del padre **deja de correr** para el jefe (a propósito no llamamos `super()` ahí). Los slimes básicos siguen usando el del padre: por eso no cambian.
> - **Anular `_on_body_entered`.** El padre lo conecta a la señal en su `_ready()` (que sí llamamos con `super()`), pero como el jefe lo **redefine vacío** (`pass`), al tocarte no pasa nada. El ataque va a llegar por un **estado**, en la Parte 2.
> - **`jugador` se busca una sola vez, en `_ready()`.** El slime básico del TP7 lo busca **cada frame** dentro de `_process`. Funciona, pero es trabajo repetido: el jugador es siempre el mismo nodo. Guardarlo en una variable al arrancar es lo correcto, y por eso el `if jugador == null: return` de arriba: si no lo encontró, mejor no hacer nada que romperse.
> - **`Estado.keys()[estado]`** devuelve el nombre del estado como texto (`"ACECHAR"`). Eso muestra la etiqueta. Es *la* herramienta para depurar una máquina de estados: si algo anda raro, mirás la etiqueta y sabés exactamente en qué estado está.
>
> Y el patrón de siempre: en cada estado, primero **hacer** (llamar a la función), después **decidir** (¿cambio?).

**Probarlo rápido:** esperar 8 slimes cada vez es lento. Para testear, en `nivel.tscn` seleccioná `Enemigos` e **instanciá** un `enemigo_elite.tscn` a mano (ícono de cadena), ubicado lejos del jugador. Cuando termines el TP, borrá esa instancia.

Apretá **F6**. El jefe viene hacia vos **despacio** con `ACECHAR` encima. Acercate a menos de 250 px: la etiqueta cambia a **`PERSEGUIR`** y **acelera**. Corré lejos (más de 350): vuelve a **`ACECHAR`** y afloja. Los slimes verdes siguen igual que siempre, sin etiqueta.

✅ **Punto de control 1:** el jefe muestra su estado encima, te acecha despacio, te persigue rápido al acercarte y se calma al alejarte. **Por ahora no te pega** (eso es la Parte 2). Los básicos no cambiaron.

> 🛟 **Errores comunes en esta parte**
>
> <details>
> <summary>Abrí para ver soluciones</summary>
>
> - **El jefe se queda quieto con la etiqueta vacía** → `jugador` es `null`. Si lo instanciaste a mano, ponelo **dentro de `Enemigos`** (que está debajo de `Jugador` en el árbol): así el jugador ya se anotó en el grupo cuando el jefe arranca.
> - **El jefe sigue desapareciendo al tocarte** → la función tiene que llamarse **exactamente** `_on_body_entered` con el mismo parámetro `(body: Node)` que en `enemigo.gd`; si no, no está *sobreescribiendo* nada.
> - **"Invalid get index 'PERSEGUIR'"** → el `enum` se escribe **una sola vez**, arriba, y los nombres van **en mayúsculas exactas**.
> - **La etiqueta no se ve** → es texto blanco; sobre fondo claro se pierde. Agregá `etiqueta.modulate = Color.BLACK` después de crearla.
> - **Los slimes verdes también cambiaron** → tocaste `enemigo.gd`. En este TP ese archivo **no se modifica**.
> </details>

---

## ⚔️ Parte 2 — Tercer estado: ATACAR

> **Concepto:** al alcanzarte, el jefe **se frena** y te pega **cada segundo** mientras estés cerca. Es un estado más y una función más — nada del resto se toca.

Cuatro cambios en **`enemigo_elite.gd`**:

**1.** Agregá el estado al `enum`:

```gdscript
enum Estado { ACECHAR, PERSEGUIR, ATACAR }
```

**2.** En `_ready()`, **debajo del bloque de la etiqueta**, creá el temporizador de ataque:

```gdscript
	var timer_ataque := Timer.new()
	timer_ataque.name = "TimerAtaque"
	timer_ataque.wait_time = 1.0      # un golpe por segundo
	timer_ataque.one_shot = true      # se dispara una vez y se frena
	add_child(timer_ataque)
```

**3.** **Reemplazá la función `_process` entera** por esta (es la de la clase, con las tres flechas):

```gdscript
func _process(delta: float) -> void:
	if jugador == null:
		return
	var d := distancia_al_jugador()
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < 250: estado = Estado.PERSEGUIR
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < 40:    estado = Estado.ATACAR
			elif d > 350: estado = Estado.ACECHAR
		Estado.ATACAR:
			atacar()
			if d > 60:  estado = Estado.PERSEGUIR
	$LabelEstado.text = Estado.keys()[estado]
```

**4.** Y agregá la función del nuevo estado, junto a las otras:

```gdscript
func atacar() -> void:                 # quieto: no se mueve
	if $TimerAtaque.is_stopped():      # ¿ya pasó el segundo desde el último golpe?
		jugador.recibir_dano(dano)
		$TimerAtaque.start()
```

> 🧠 **Cómo funciona el golpe cada segundo.** El `TimerAtaque` es *one shot*: al entrar en `ATACAR` está **frenado**, así que pega **enseguida** y lo arranca. Mientras corre (1 s), `is_stopped()` es falso y no pega. Al terminar se frena solo, y en el próximo frame vuelve a pegar. Sin variables extra, sin contar `delta` a mano.
>
> Y fijate que `atacar()` **no mueve** al jefe: estar quieto también es un comportamiento.

Apretá **F6**. Dejá que el jefe te alcance: la etiqueta pasa a **`ATACAR`**, se frena pegado a vos, y tu barra baja **25 cada segundo** (cuatro golpes y perdés: es el jefe). Date un paso atrás: vuelve a **`PERSEGUIR`**.

> 💡 Para testear tranquilo, bajá `dano = 25` a `dano = 5` un rato, y después volvelo.

✅ **Punto de control 2:** el jefe te persigue, al alcanzarte se frena y te pega una vez por segundo, y si te alejás retoma la persecución. Compará con el diagrama: **cada `if` es una flecha**.

> 🛟 **Errores comunes en esta parte**
>
> <details>
> <summary>Abrí para ver soluciones</summary>
>
> - **"Node not found: TimerAtaque"** → el bloque que lo crea tiene que estar **dentro de `_ready()`**, con la misma sangría que el de la etiqueta.
> - **Pega todo el tiempo, no cada segundo** → te faltó `one_shot = true`, o el `$TimerAtaque.start()` después de pegar.
> - **Parpadea entre ATACAR y PERSEGUIR** → revisá los umbrales: entra a **40** y sale a **60**. Si pusiste el mismo número en los dos, es la histéresis de la Parte 0.
> - **Nunca llega a ATACAR** → 40 px es poco si el `CollisionShape2D` del jefe es grande. Probá con `d < 60` y `d > 80`.
> </details>

---

## 💥 Parte 3 — Cuarto estado: GOLPEADO

> **Concepto:** la prueba de fuego de la clase: agregar un estado **sin romper nada**. Y con dos flechas distintas a las de antes: se **entra** por un **evento** (recibir una bala) y se **sale** por **tiempo** (pasan 0.5 s).

Hoy, cuando una bala le pega al jefe, la barra baja y nada más: sigue caminando como si nada. Queremos que **se sienta**: un **empujón** hacia atrás y **medio segundo congelado**, en rojo. Nada de huir: en un *survivors*, un jefe que escapa es un jefe que no se enfrenta.

![Máquina de estados con GOLPEADO: se entra desde recibir_dano y se sale cuando termina el Timer](tp8-assets/diagrama-4-estados.png)

Cinco cambios en **`enemigo_elite.gd`**:

**1.** El `enum`, completo:

```gdscript
enum Estado { ACECHAR, PERSEGUIR, ATACAR, GOLPEADO }
```

**2.** En `_ready()`, **debajo del bloque del `TimerAtaque`**, un segundo temporizador:

```gdscript
	var timer_golpe := Timer.new()
	timer_golpe.name = "TimerGolpe"
	timer_golpe.wait_time = 0.5       # medio segundo congelado
	timer_golpe.one_shot = true
	add_child(timer_golpe)
```

**3.** En `_process`, la rama de `GOLPEADO` **al final del `match`**, debajo de la de `ATACAR`:

```gdscript
		Estado.GOLPEADO:
			golpeado()
			if $TimerGolpe.is_stopped():                  # pasó el medio segundo
				$AnimatedSprite2D.modulate = Color.WHITE   # se le va el rojo
				estado = Estado.PERSEGUIR
```

**4.** La función, junto a las otras:

```gdscript
func golpeado() -> void:                              # congelado: no se mueve ni pega
	$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)   # rojo, para que se note
```

**5.** Y la **flecha de entrada**, en `recibir_dano()`:

```gdscript
func recibir_dano(cantidad: int) -> void:
	super(cantidad)
	$BarraVida.value = vida
	if vida > 0:                                                    # si murió, no hay golpe que valga
		position += (position - jugador.position).normalized() * 20   # empujón: 20 px hacia atrás
		$TimerGolpe.start()                                             # arranca el medio segundo
		estado = Estado.GOLPEADO
```

> 🧠 **Dos flechas nuevas, dos disparadores nuevos.** Las transiciones de antes viven en el `match` y se deciden por **distancia**. La de **entrada** a `GOLPEADO` vive en `recibir_dano()` y se dispara por un **evento**: recibir un golpe. Una máquina de estados no exige que todas las flechas salgan del mismo lugar. La de **salida** se decide por **tiempo**, con el mismo truco de `is_stopped()` que ya usás en `atacar()`.
>
> **El empujón** es "perseguir al revés" en una sola línea: `(position - jugador.position)` es la dirección **del jugador hacia el jefe**, y `* 20` la convierte en 20 píxeles. No lleva `delta` porque no es un movimiento por frame: es un salto, una vez, en el momento del golpe.
>
> **¿Por qué `vida > 0`?** Si la bala lo mató, `super()` ya llamó a `morir()` y el nodo está por desaparecer: no tiene sentido empujarlo ni congelarlo.

Apretá **F6**. Dejá que una bala le pegue al jefe: retrocede un poco, se pone **rojo**, la etiqueta dice **`GOLPEADO`** y se queda clavado medio segundo. Después vuelve a **`PERSEGUIR`**, blanco otra vez. Con varias balas seguidas se lo ve trabarse a cada golpe: eso es lo que hace que un jefe se sienta **pesado**.

✅ **Punto de control 3:** cada bala empuja y congela al jefe medio segundo, y después retoma la persecución. Agregaste un estado y **nada de lo anterior se rompió**. Los slimes básicos siguen sin inmutarse cuando les pegás: `enemigo.gd` no cambió.

> 🛟 **Errores comunes en esta parte**
>
> <details>
> <summary>Abrí para ver soluciones</summary>
>
> - **"Identifier 'GOLPEADO' not declared"** → falta agregarlo al `enum`.
> - **"Node not found: TimerGolpe"** → el bloque que lo crea va **dentro de `_ready()`**, con la misma sangría que el del `TimerAtaque`.
> - **No se congela ni se pone rojo** → las tres líneas van **después** de `super(cantidad)` y `$BarraVida.value = vida`, adentro del `if vida > 0:`. Y revisá que la última sea `estado = Estado.GOLPEADO`.
> - **Nunca sale de GOLPEADO mientras le disparás** → el `TimerDisparo` del jugador tira una bala cada **0.4 s**, más seguido que los 0.5 s del congelado: si el jefe es el único objetivo, cada bala **reinicia** el Timer y queda trabado hasta morir. En muchos *survivors* eso es a propósito (*stun lock*). Si no te gusta, que el golpe **no se acumule**: `if $TimerGolpe.is_stopped(): $TimerGolpe.start()`. O bajá el `wait_time` a `0.3`.
> - **Queda rojo para siempre** → el `modulate = Color.WHITE` va en la **salida** (dentro del `if` del `match`), no en `golpeado()`.
> - **Retrocede pero casi no se nota** → 20 px es poco con el sprite chico; probá `40`. Mucho más y parece que se teletransporta.
> </details>

---

## 🏁 Parte 4 — Proyecto final: ajustar, exportar, entregar

Ya está todo. Ahora convertilo en **tu** juego.

### 4.1 · Ajustar los números

Todo lo que define cómo se siente el jefe son **siete números**. Jugá y tocalos hasta que te guste:

| Dónde | Variable | Qué cambia |
| :---- | :---- | :---- |
| `enemigo_elite.gd` | `velocidad` | Qué tan rápido persigue (acecha a la mitad) |
| `enemigo_elite.gd` | umbrales `250` / `350` | Desde cuán lejos te ve y cuándo se calma |
| `enemigo_elite.gd` | `wait_time` del `TimerAtaque` | Cada cuánto pega |
| `enemigo_elite.gd` | `wait_time` del `TimerGolpe` | Cuánto queda congelado por cada bala |
| `enemigo_elite.gd` | el `20` del empujón | Cuánto retrocede por cada bala |
| `spawner.gd` | `wait_time` del `Timer` | Cuántos slimes por segundo |
| `spawner.gd` | `contador >= 8` | Cada cuántos aparece un jefe |

(Opcional) Para la versión final, ocultá la etiqueta agregando `etiqueta.visible = false` justo después de crearla en `_ready()`. O dejala: es simpática y muestra que el jefe piensa.

### 4.2 · Exportar

Como vimos en la clase 8:

1. **Editor → Manage Export Templates → Download and Install** (solo la primera vez).
2. **Project → Project Settings → Application → Config**: poné el **nombre** de tu juego.
3. **Project → Export → Add… → Windows Desktop** → carpeta y nombre (`mi_juego.exe`) → **Export Project**.
4. Godot genera `mi_juego.exe` **y** `mi_juego.pck`. **Van siempre juntos**: sin el `.pck` el `.exe` no arranca.

✅ **Punto de control 4 (final):** el `.exe` corre en una compu **sin Godot instalado**, y se juega igual que en el editor.

---

## 📤 Entrega — Proyecto final

Entregá **las dos cosas**:

1. La **carpeta del proyecto** comprimida en `.zip` (sin la carpeta `.godot/`), **y**
2. El juego **exportado**: `mi_juego.exe` + `mi_juego.pck` en un `.zip` aparte.

(Opcional) Un **video corto** donde se vea: la horda persiguiéndote, el jefe acechando de lejos, acelerando al acercarte, atacándote, y frenándose en seco con cada bala.

**Nombre:** `tp8-final-ApellidoNombre.zip` y `tp8-final-ApellidoNombre-exe.zip`

### ✔️ Checklist de autoevaluación

- [ ] `enemigo_elite.gd` tiene `enum Estado` con **cuatro** estados y **su propio** `_process` con `match`.
- [ ] Cada estado tiene **su función** (`acechar`, `perseguir`, `atacar`, `golpeado`).
- [ ] El jefe muestra su **estado** en una etiqueta encima (aunque después la ocultes).
- [ ] El jefe **acecha despacio** hacia vos, **persigue** a menos de 250 px y se **calma** a más de 350.
- [ ] Al alcanzarte **se frena** y pega **una vez por segundo** (ya no desaparece al tocarte).
- [ ] Cada bala lo **empuja y lo congela 0.5 s** (flecha desde `recibir_dano()`), y al terminar el Timer vuelve a perseguir.
- [ ] El slime básico quedó **igual que en el TP7**: kamikaze y sin etiqueta. **`enemigo.gd` no se tocó.**
- [ ] El juego está **exportado** y corre sin Godot.

---

## 📄 Código completo de referencia

Por si te perdiste en algún paso: así tiene que quedar `enemigo_elite.gd` al final. **`enemigo.gd` es el mismo del TP7, sin cambios.**

<details>
<summary><code>enemigo_elite.gd</code> completo</summary>

```gdscript
extends "res://enemigo.gd"

enum Estado { ACECHAR, PERSEGUIR, ATACAR, GOLPEADO }

var estado := Estado.ACECHAR
var jugador: Node2D = null

func _ready() -> void:
	super()
	vida = 5
	velocidad = 35.0
	dano = 25
	$BarraVida.max_value = vida
	$BarraVida.value = vida

	jugador = get_tree().get_first_node_in_group("jugador")

	var etiqueta := Label.new()
	etiqueta.name = "LabelEstado"
	etiqueta.position = Vector2(-36, -66)
	add_child(etiqueta)

	var timer_ataque := Timer.new()
	timer_ataque.name = "TimerAtaque"
	timer_ataque.wait_time = 1.0
	timer_ataque.one_shot = true
	add_child(timer_ataque)

	var timer_golpe := Timer.new()
	timer_golpe.name = "TimerGolpe"
	timer_golpe.wait_time = 0.5
	timer_golpe.one_shot = true
	add_child(timer_golpe)

func _process(delta: float) -> void:
	if jugador == null:
		return
	var d := distancia_al_jugador()
	match estado:
		Estado.ACECHAR:
			acechar(delta)
			if d < 250: estado = Estado.PERSEGUIR
		Estado.PERSEGUIR:
			perseguir(delta)
			if d < 40:    estado = Estado.ATACAR
			elif d > 350: estado = Estado.ACECHAR
		Estado.ATACAR:
			atacar()
			if d > 60:  estado = Estado.PERSEGUIR
		Estado.GOLPEADO:
			golpeado()
			if $TimerGolpe.is_stopped():
				$AnimatedSprite2D.modulate = Color.WHITE
				estado = Estado.PERSEGUIR
	$LabelEstado.text = Estado.keys()[estado]

func _on_body_entered(body: Node) -> void:
	pass

func acechar(delta: float) -> void:
	var dir := (jugador.position - position).normalized()
	position += dir * velocidad * 0.5 * delta
	$AnimatedSprite2D.flip_h = dir.x < 0

func perseguir(delta: float) -> void:
	var dir := (jugador.position - position).normalized()
	position += dir * velocidad * delta
	$AnimatedSprite2D.flip_h = dir.x < 0

func atacar() -> void:
	if $TimerAtaque.is_stopped():
		jugador.recibir_dano(dano)
		$TimerAtaque.start()

func golpeado() -> void:
	$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)

func distancia_al_jugador() -> float:
	return position.distance_to(jugador.position)

func recibir_dano(cantidad: int) -> void:
	super(cantidad)
	$BarraVida.value = vida
	if vida > 0:
		position += (position - jugador.position).normalized() * 20
		$TimerGolpe.start()
		estado = Estado.GOLPEADO
```
</details>

---

## 🌟 Extra (opcional)

- **Que se note el cambio.** Un color por estado con `modulate` (blanco acechando, amarillo persiguiendo, naranja atacando; el rojo ya es de `GOLPEADO`), o un `Tween` de escala al entrar a `ATACAR` (Clase 7). Los buenos enemigos **avisan** en qué estado están.
- **Que la horda también sienta el golpe.** Hoy solo el jefe reacciona a las balas. Si querés que los básicos también retrocedan, la línea del empujón va en el `recibir_dano()` de `enemigo.gd`… pero pensá primero si un slime que se muere de un tiro necesita retroceder.
- **Un quinto estado: `EMBESTIR`.** Desde `PERSEGUIR`, si el jugador está entre 100 y 150 px, que cargue en línea recta a 3× durante medio segundo (un `Timer`) y después vuelva a perseguir. Es el ataque clásico de un jefe.
- **Un jefe que dispara.** Que en `ATACAR`, en vez de acercarse, se **frene a distancia** e instancie una bala hacia vos (todo lo que hace falta ya lo tenés del TP7).
- **Dificultad progresiva.** Que la `velocidad` y el radio de visión del jefe suban un poco cada vez que aparece uno nuevo.
- **¿Y si la horda también pensara?** Podrías darle la máquina a `enemigo.gd`. Pero antes contestá: ¿cuál sería su estado tranquilo? Si la respuesta es “patrullar al azar”, releé la decisión de diseño del principio.
- **Game Over de verdad.** Puntaje en un Autoload y pantalla final, como en el TP6.

---

## 📚 Recursos

- `enum` y `match` en GDScript: **[GDScript basics](https://docs.godotengine.org/es/4.x/tutorials/scripting/gdscript/gdscript_basics.html)**
- Máquinas de estado en Godot, con más profundidad: **[GDQuest — Finite State Machine](https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/)**
- El nodo `Timer`: **[Timer](https://docs.godotengine.org/es/4.x/classes/class_timer.html)**
- Exportar el proyecto: **[Exporting projects](https://docs.godotengine.org/es/4.x/tutorials/export/exporting_projects.html)**

> Diagramas: elaboración propia para la diplomatura. Sprites de **Brackeys** (CC0), heredados del TP7.
>
> **¡Felicitaciones! Terminaste la diplomatura con un juego exportado, con un jefe que piensa.** 🎉
