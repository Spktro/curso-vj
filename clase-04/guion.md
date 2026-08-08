# Clase 4 — El personaje cobra vida

**Diplomatura en Desarrollo de Videojuegos con Godot**
*CharacterBody2D · Colisiones · Señales*

## 🎯 Objetivos de la clase

- Entender la diferencia entre los tipos de cuerpos físicos de Godot.
- Usar `CharacterBody2D` y `move_and_slide()` para crear un personaje controlable.
- Agregar `CollisionShape2D` para que el personaje interactúe con el mundo.
- Comprender el sistema de Señales (Signals) y conectarlas en el editor.

---

## 🚀 Bloque 1 — Hook inicial (10 min)

Abrí Godot con dos escenas preparadas. Sin decir nada, ejecutalas una por una:

- **Escena A:** un sprite que «cae» a través del suelo como si no existiera.
- **Escena B:** el mismo personaje que se detiene sobre la plataforma y se mueve con el teclado.

Preguntá al grupo: *"¿Qué diferencia hay entre las dos escenas? ¿Qué tiene la segunda que no tiene la primera?"*

**💡 Tip pedagógico:** la diferencia es el tipo de nodo y la física. Que sientan la pregunta antes de ver la respuesta.

---

## 🧱 Bloque 2 — Tipos de cuerpos físicos (20 min)

Godot tiene tres tipos de nodos para manejar objetos físicos. Elegir el correcto es fundamental:

| Nodo | ¿Para qué sirve? |
| :---- | :---- |
| `StaticBody2D` | No se mueve. Es para el suelo, paredes, plataformas fijas. El motor lo respeta pero nunca lo mueve. |
| `CharacterBody2D` | Lo controlás vos por código. Ideal para el personaje jugable, enemigos con IA. No tiene gravedad automática. |
| `RigidBody2D` | El motor lo mueve solo con física realista (gravedad, rebote, impulsos). Ideal para objetos que se tiran o explotan. |

**Regla práctica:** el jugador siempre es `CharacterBody2D`. El suelo siempre es `StaticBody2D`. Los objetos que se tiran son `RigidBody2D`.

**🎮 Analogía:** `CharacterBody2D` es como un personaje de teatro: vos lo dirigís. `RigidBody2D` es como un extra al que empujás y se cae solo.

**🎮 Ejemplos en juegos reales** (para anclar el concepto):

- **StaticBody2D** → el suelo y las paredes de *Super Mario Bros.* y *Celeste*.
- **CharacterBody2D** → Madeline en *Celeste*, el Caballero de *Hollow Knight*, el prota de *Super Meat Boy*.
- **RigidBody2D** → los pájaros de *Angry Birds*, los barriles de *Donkey Kong*, las cajas de *World of Goo*.
- *Celeste* usa **los tres a la vez**: la protagonista (character), las plataformas (static) y los bloques que caen (rigid).

---

## ⚙️ Bloque 3 — CharacterBody2D y move_and_slide() (30 min)

**¿Por qué no alcanza con `position.x += velocidad`?**

En la clase anterior movimos objetos cambiando su posición directamente. Eso funciona para objetos que no interactúan con la física. Pero si queremos que el personaje choque con paredes o pise el suelo, necesitamos que el motor resuelva esas colisiones.

`move_and_slide()` hace exactamente eso: mueve el `CharacterBody2D` usando su variable `velocity`, detecta colisiones en el camino y ajusta el movimiento automáticamente.

**El patrón básico:**

```gdscript
extends CharacterBody2D

const VELOCIDAD = 200.0
const GRAVEDAD = 900.0
const FUERZA_SALTO = -400.0

func _physics_process(delta):
    # 1. Aplicar gravedad (acumulativa, por eso += )
    if not is_on_floor():
        velocity.y += GRAVEDAD * delta

    # 2. Leer input del jugador
    var dir = Input.get_axis("mover_izquierda", "mover_derecha")
    velocity.x = dir * VELOCIDAD

    # 3. Salto — solo si está en el suelo
    if Input.is_action_just_pressed("saltar") and is_on_floor():
        velocity.y = FUERZA_SALTO

    # 4. Dejar que Godot resuelva las colisiones
    move_and_slide()
```

**Diferencias clave con `_process()`:**

| Función | Cuándo usarla |
| :---- | :---- |
| `_process(delta)` | Para lógica de juego general: input, UI, lógica de estados. No interactúa con la física. |
| `_physics_process(delta)` | Para todo lo que usa física y colisiones. Se llama a frecuencia fija (60 Hz por defecto). |

**Regla:** si usás `move_and_slide()` o manejás colisiones físicas, va en `_physics_process()`. Todo lo demás puede ir en `_process()`.

Este patrón es el corazón de *Celeste*, *Super Meat Boy* y cualquier plataformero de precisión.

---

## 🔷 Bloque 4 — CollisionShape2D (15 min)

Un `CharacterBody2D` por sí solo no tiene forma física. Necesita un nodo hijo `CollisionShape2D` que define su «silueta» para las colisiones.

- **RectangleShape2D** — para personajes humanoides y objetos rectangulares. La más común.
- **CapsuleShape2D** — para personajes que necesitan deslizarse por esquinas suavemente.
- **CircleShape2D** — para objetos redondos (pelotas, monedas).

**⚠️ Error frecuente:** si el personaje no colisiona con nada, probablemente falta el `CollisionShape2D` o tiene el shape vacío. Siempre verificar que el shape esté bien configurado.

**Práctica guiada:** crear juntos una escena con:

- `CharacterBody2D` como raíz.
- `Sprite2D` como hijo visual.
- `CollisionShape2D` con un `RectangleShape2D`.
- Una plataforma `StaticBody2D` + `CollisionShape2D` debajo.
- Adjuntar el script de arriba y ejecutar.

---

## ── PARTE 2 ──

## 📡 Bloque 5 — ¿Qué son las Señales? (20 min)

Las **señales** (Signals) son el sistema de comunicación de Godot. Permiten que un nodo le avise a otro que algo ocurrió, sin que necesiten conocerse directamente.

**El problema sin señales:** si el jugador toca una moneda, ¿cómo lo sabe el sistema de puntaje? Una solución ingenua sería que la moneda busque el marcador y lo modifique directamente. Pero eso crea dependencias rígidas — si cambiás el nombre del nodo, todo se rompe.

**💡 Analogía:** una señal es como una campana. Cuando algo pasa, la moneda hace sonar la campana. Cualquier objeto que esté «escuchando» esa campana reacciona. La moneda no sabe quién escucha — solo toca la campana.

**Flujo de una señal:**

- Un nodo **emite** (emit) una señal cuando algo ocurre.
- Otro nodo **conecta** esa señal a una de sus funciones.
- Cuando la señal se emite, la función conectada se ejecuta automáticamente.

Así funcionan los logros de Steam, el puntaje que sube al juntar un anillo en *Sonic*, o el "¡Nivel completado!" al cruzar la meta.

---

## 🔌 Bloque 6 — Señales predefinidas y Area2D (30 min)

**Area2D — el detector de zonas**

`Area2D` es un nodo especial que detecta cuándo otros cuerpos entran o salen de una zona. No bloquea el paso (a diferencia de `StaticBody2D`), solo detecta. Es perfecto para monedas, poderes, zonas de daño, disparadores de eventos.

Los anillos de *Sonic*, las monedas de *Mario*, los pinchos y la lava, los checkpoints: todos son `Area2D` escuchando `body_entered`.

**Señales importantes de Area2D:**

| Señal | Cuándo se emite |
| :---- | :---- |
| `body_entered(body)` | Cuando un `CharacterBody2D` o `RigidBody2D` entra al área. Útil para daño, recolección. |
| `body_exited(body)` | Cuando el cuerpo sale del área. |
| `area_entered(area)` | Cuando otra `Area2D` entra. Útil para detectar zonas contra zonas. |

**Conectar señales desde el editor:**

Seleccioná el nodo `Area2D` → panel lateral «Node» → «Signals» → doble clic en `body_entered` → elegir el nodo que va a recibir la señal → Connect.

Godot genera automáticamente la función en el script del nodo receptor:

```gdscript
# Esta función es generada automáticamente al conectar la señal
func _on_area_2d_body_entered(body):
    # 'body' es el nodo que entró al área
    print("Algo entró: " + body.name)
```

**Conectar señales por código:**

```gdscript
# En _ready() del nodo receptor:
func _ready():
    # Buscar el Area2D y conectar su señal
    $Area2D.body_entered.connect(_on_moneda_tocada)

func _on_moneda_tocada(body):
    if body.is_in_group("jugador"):
        puntos += 1
        queue_free()  # Eliminar la moneda
```

**⚠️ Error frecuente:** si la señal no dispara, verificar que el `Area2D` tenga un `CollisionShape2D` hijo con un shape asignado. Sin shape, el área no tiene volumen y nunca detecta nada.

---

## 🛠️ Bloque 7 — Grupos: comunicación masiva (15 min)

Los grupos permiten etiquetar nodos para comunicarse con todos los de ese tipo a la vez. En vez de señales uno a uno, es como un megáfono.

```gdscript
# Agregar al grupo por código (en _ready):
func _ready():
    add_to_group("jugador")

# O desde el editor: seleccionar nodo → pestaña "Node" → "Groups"
```

```gdscript
# Verificar si un nodo pertenece a un grupo:
func _on_area_body_entered(body):
    if body.is_in_group("jugador"):
        print("El jugador tocó esta área")
        queue_free()

# Llamar a todos los nodos de un grupo:
get_tree().call_group("enemigos", "recibir_dano", 50)
```

Ejemplo mental: una explosión que le pega a todos los enemigos a la vez, o un hechizo que congela a todo lo etiquetado como `"enemigo"`.

---

## 🧪 Bloque 8 — Práctica integradora (40 min)

**Objetivo:** construir un escenario donde el jugador se mueve, salta, y al tocar una moneda la recoge.

**Estructura de la escena:**

```
Nivel (Node2D)               — raíz del nivel
├── Jugador (CharacterBody2D) — con Sprite2D y CollisionShape2D
├── Suelo (StaticBody2D)      — con CollisionShape2D
└── Moneda (Area2D)           — con Sprite2D y CollisionShape2D
```

**Script del Jugador:**

```gdscript
extends CharacterBody2D

const VELOCIDAD = 250.0
const GRAVEDAD = 980.0
const SALTO = -450.0

var puntos = 0

func _ready():
    add_to_group("jugador")
    print("Jugador listo. Puntos: " + str(puntos))

func _physics_process(delta):
    if not is_on_floor():
        velocity.y += GRAVEDAD * delta

    var dir = Input.get_axis("mover_izquierda", "mover_derecha")
    velocity.x = dir * VELOCIDAD

    if Input.is_action_just_pressed("saltar") and is_on_floor():
        velocity.y = SALTO

    move_and_slide()

func sumar_punto():
    puntos += 1
    print("¡Moneda! Puntos: " + str(puntos))
```

**Script de la Moneda:**

```gdscript
extends Area2D

func _ready():
    body_entered.connect(_on_body_entered)

func _on_body_entered(body):
    if body.is_in_group("jugador"):
        body.sumar_punto()   # llamar función del jugador
        queue_free()         # eliminar la moneda
```

**Desafíos extra:**

- Agregar 3 monedas en distintas posiciones del nivel.
- Mostrar un mensaje "¡Ganaste!" cuando `puntos` llega a 3.
- Agregar una zona de daño (`Area2D`) que reste vida al jugador.

---

## 🧭 Bloque Cierre (10 min)

**Repaso rápido de los conceptos de la clase:**

- Los tipos de cuerpos físicos definen cómo interactúan los nodos con el mundo: `StaticBody2D` es estático, `CharacterBody2D` lo controlamos nosotros, `RigidBody2D` lo maneja la física.
- `move_and_slide()` mueve el personaje resolviendo colisiones automáticamente; siempre va dentro de `_physics_process()`.
- `CollisionShape2D` es obligatorio en cualquier cuerpo físico: sin él, el nodo no tiene forma y no colisiona con nada.
- Las señales son el sistema de comunicación de Godot: un nodo emite, otro escucha. `Area2D` usa señales para detectar entradas y salidas.
- Los grupos permiten etiquetar nodos y comunicarse con todos los del mismo tipo a la vez.

**📚 Tarea para la próxima clase:**

- Agregar una zona de «Game Over» debajo del nivel (si el jugador cae, reaparece en la posición inicial).
- Crear 5 monedas y mostrar el puntaje en la consola cada vez que se recoge una.
- Agregar una plataforma que se mueva de lado a lado usando `_physics_process()` y `velocity`.
- **Desafío:** hacer que al recoger todas las monedas aparezca un mensaje de victoria y el juego se reinicie con `get_tree().reload_current_scene()`.
