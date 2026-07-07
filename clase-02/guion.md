# Parte 1

### **🚀 Bloque 1 — Hook inicial (10 min)**

Arrancá con algo concreto. No expliques nada todavía — mostrá.

**Frase de apertura:**

"Hoy vamos a hacer que un personaje reaccione cuando ustedes presionan una tecla. Eso es lo que hace un programador: le dice a la computadora qué hacer, cuándo hacerlo, y por qué."

Abrí Godot con un proyecto ya preparado y ejecutá este código en vivo:

gdscript

func \_process(delta):

    if Input.is\_action\_pressed("ui\_accept"):

        print("¡El jugador presionó ESPACIO\!")

**Tip pedagógico:** No expliques el código todavía. Solo ejecutalo. Preguntales: *"¿Qué creen que está pasando acá?"* Dejalos especular — eso activa la curiosidad.

---

### **💬 Bloque 2 — ¿Qué es programar? (10–15 min)**

La programación no es magia. Es comunicación: le estás hablando a una máquina que hace exactamente lo que le decís, ni más ni menos.

**La gran verdad sobre las computadoras:**

| Mito ❌ | Realidad ✅ |
| ----- | ----- |
| "La computadora es inteligente y entiende lo que queremos" | La computadora NO piensa. Solo ejecuta instrucciones paso a paso, exactamente como se las damos. |

**De lenguaje humano a código:**

* Lenguaje humano: *"Si presiono espacio, el personaje salta"*  
* Lógica de programación: `SI (condición) ENTONCES (acción)`

Esta estructura SI/ENTONCES es el núcleo de todo programa. Los videojuegos, aplicaciones y sistemas operativos son, en esencia, millones de estas instrucciones.

---

### **🧾 Bloque 3 — Introducción a GDScript (15–20 min)**

GDScript es el lenguaje de programación nativo de Godot Engine. Fue diseñado específicamente para el desarrollo de videojuegos, inspirado en Python pero optimizado para ser simple y rápido.

**¿Por qué GDScript?**

* Sintaxis simple y clara — rápido de aprender  
* Integrado con Godot — acceso directo al motor  
* Similar a Python — familiar para muchos  
* Pensado para juegos — `_process`, `_ready`, `Input`...

**El primer script — escribilo en vivo con los estudiantes:**

gdscript

extends CharacterBody2D

\# Este script controla el comportamiento de nuestro personaje

\# Todo lo que escribamos acá define QUÉ puede hacer

func \_ready():

    print("¡El personaje está listo\!")

**Qué significa cada línea:**

| Código | Significado |
| ----- | ----- |
| `extends CharacterBody2D` | Le dice a Godot qué tipo de nodo controla este script |
| `func _ready():` | Se ejecuta UNA SOLA VEZ cuando el nodo aparece en escena |
| `print(...)` | Imprime texto en la consola — nuestro mejor amigo para depurar |

**Actividad:** Que cada estudiante cree su primer script en Godot, aunque solo contenga un `print()`. El objetivo es sentir el proceso completo: crear nodo → adjuntar script → ejecutar.

---

### **📦 Bloque 4 — Variables y tipos de datos (25–30 min)**

Una variable es como una caja con una etiqueta. Dentro de la caja guardamos información que el programa va a necesitar. La etiqueta es el nombre para encontrarla.

**Analogía clave:** Imaginá un cajón con una etiqueta que dice "velocidad". Adentro hay un número: 200\. Cuando el programa necesita saber qué tan rápido se mueve el personaje, abre ese cajón.

**Declarar variables en GDScript:**

gdscript

\# La palabra "var" crea una nueva variable

var velocidad \= 200        \# Número entero

var nombre \= "Héroe"       \# Texto (String)

var esta\_vivo \= true       \# Booleano (verdadero/falso)

var energia \= 85.5         \# Número decimal (float)

\# Para ver el valor de cualquier variable:

print(velocidad)    \# → 200

print(nombre)       \# → Héroe

**Tipos de datos fundamentales:![][image1]Mini práctica — cambiá valores y observá:**

gdscript

extends Node

var vida \= 100

var velocidad \= 200

var nombre\_personaje \= "Héroe"

var tiene\_espada \= false

func \_ready():

    print("Personaje: " \+ nombre\_personaje)

    print("Vida: " \+ str(vida))

    print("Velocidad: " \+ str(velocidad))

    print("Tiene espada: " \+ str(tiene\_espada))

**Nota sobre `str()`:** Para concatenar un número con texto hay que convertirlo con `str()`. Por ejemplo, `str(100)` convierte el número 100 al texto "100". Esto es normal — lo van a ver mucho.

---

### **🔀 Bloque 5 — Condicionales (IF / ELSE) (25–30 min)**

Los condicionales son la forma en que el programa toma decisiones. Sin `if`, el código siempre hace lo mismo. Con `if`, puede reaccionar a distintas situaciones.

**Concepto clave:** Toda decisión en un videojuego es un condicional: ¿el jugador tocó el suelo? → puede saltar. ¿La vida llegó a 0? → mostrar Game Over. ¿Recogió el ítem? → sumar puntos.

**Sintaxis básica:**

gdscript

\# Estructura básica

if condicion:

    \# esto se ejecuta SOLO si la condición es verdadera

\# Ejemplo concreto

var vida \= 0

if vida \<= 0:

    print("Game Over")

**IF con ELSE — siempre hay un plan B:**

gdscript

var vida \= 50

if vida \<= 0:

    print("Game Over — el personaje murió")

else:

    print("Sigo vivo con " \+ str(vida) \+ " puntos de vida")

**IF / ELIF / ELSE — múltiples condiciones:**

gdscript

var vida \= 30

if vida \<= 0:

    print("💀 Game Over")

elif vida \<= 25:

    print("🔴 ¡Vida crítica\! Buscá un ítem de salud")

elif vida \<= 50:

    print("🟡 Vida baja — cuidado")

else:

    print("🟢 Estás bien")

**Operadores de comparación:![][image2]Ejercicio — sistema de vida:**

gdscript

extends Node

var vida \= 100

var dano \= 30

func \_ready():

    print("Vida inicial: " \+ str(vida))

    \# Simulamos recibir daño

    vida \= vida \- dano

    print("Recibiste " \+ str(dano) \+ " de daño")

    print("Vida actual: " \+ str(vida))

    \# Verificamos estado

    if vida \<= 0:

        print("💀 Game Over")

    elif vida \<= 30:

        print("🔴 Vida crítica")

    else:

        print("🟢 Seguís en pie")

**Desafío extra:** Que cambien el valor de `dano` para explorar distintos resultados. ¿Qué pasa con `dano = 100`? ¿Y con `dano = 50`? ¿Y `dano = 70`?

---

# Parte 2

### **🔁 Bloque 6 — Iteradores / Loops (15–20 min)**

A veces necesitamos que el programa haga lo mismo varias veces. En lugar de escribir el mismo código 100 veces, usamos un loop que lo repite automáticamente.

**Analogía del juego:** Es como la mecánica de "completar una ronda" — el juego corre el mismo ciclo de lógica 60 veces por segundo. `for` es la herramienta para repetir acciones un número definido de veces.

**El loop FOR:**

gdscript

\# range(5) genera: 0, 1, 2, 3, 4

for i in range(5):

    print("Vuelta número: " \+ str(i))

\# Resultado en consola:

\# Vuelta número: 0

\# Vuelta número: 1

\# Vuelta número: 2

\# Vuelta número: 3

\# Vuelta número: 4

**Ejemplos aplicados a videojuegos:**

gdscript

\# Spawner de enemigos — crear 3 enemigos

for i in range(3):

    print("Spawneando enemigo número " \+ str(i \+ 1))

\# Contar vidas (de 3 a 0\)

for vida in range(3, 0, \-1):

    print("Vida restante: " \+ str(vida))

\# Iterar sobre una lista de items

var inventario \= \["Espada", "Escudo", "Poción"\]

for item in inventario:

    print("Tienes: " \+ item)

**Importante:** En Godot, NO se usan loops para la lógica del juego en tiempo real. Para eso existe `_process()`. Los loops se usan para inicialización, generación de contenido y procesamiento de datos.

---

### **🧩 Bloque 7 — Funciones (20–25 min)**

Las funciones son bloques de código con nombre. En lugar de repetir el mismo código en varios lugares, lo escribís una vez y lo llamás cuando lo necesitás.

**Sin funciones vs. con funciones:**

Sin funciones — código repetido:

gdscript

print("Saltando")

velocidad.y \= \-300

\# ... más lógica

\# (el mismo bloque repetido más abajo)

print("Saltando")

velocidad.y \= \-300

Con funciones — código limpio:

gdscript

func saltar():

    print("Saltando")

    velocidad.y \= \-300

    \# ... lógica de salto

\# Usar cuando sea necesario:

saltar()

saltar()

**Anatomía de una función:**

gdscript

\# DEFINICIÓN — se escribe UNA vez

func nombre\_de\_la\_funcion():

    \# código que ejecuta la función

    print("Haciendo algo")

\# LLAMADO — se usa cuando se necesita

nombre\_de\_la\_funcion()  \# ← los paréntesis son obligatorios

**Funciones con parámetros:**

gdscript

var vida \= 100

\# Función que recibe daño como parámetro

func recibir\_dano(cantidad):

    vida \= vida \- cantidad

    print("Recibiste " \+ str(cantidad) \+ " de daño")

    print("Vida restante: " \+ str(vida))

\# Función que retorna un valor

func esta\_vivo():

    return vida \> 0

\# Usando las funciones

recibir\_dano(25)

recibir\_dano(40)

if esta\_vivo():

    print("Sigo en pie")

else:

    print("Game Over")

**Funciones especiales de Godot — las más importantes:**

| Función | Cuándo se ejecuta |
| ----- | ----- |
| `func _ready():` | Una sola vez cuando el nodo entra a la escena. Ideal para inicialización. |
| `func _process(delta):` | Cada frame (60 veces/segundo). Para lógica continua como detectar input. |
| `func _physics_process(delta):` | En cada paso de física. Para movimiento y colisiones. |

---

### **🎮 Bloque 8 — Input del jugador (30–40 min)**

El input es el puente entre el jugador y el juego. Todo lo que aprendieron hasta acá — variables, condicionales, funciones — se une en este bloque para crear interactividad real.

**Cómo funciona la detección de input:**

Godot tiene un sistema de `Input` que detecta qué teclas, botones o clicks están activos. Se usa dentro de `_process()` para verificar en cada frame:

gdscript

func \_process(delta):

    \# Detecta MIENTRAS la tecla esté presionada

    if Input.is\_action\_pressed("ui\_accept"):

        print("Espacio presionado")

    \# Detecta SOLO el momento en que se presiona

    if Input.is\_action\_just\_pressed("ui\_accept"):

        print("¡Acaba de presionar\!")

    \# Detecta SOLO cuando se suelta la tecla

    if Input.is\_action\_just\_released("ui\_accept"):

        print("Soltó la tecla")

**Acciones de input predeterminadas en Godot:![][image3]Todo junto — Input \+ Variables \+ IF \+ Funciones:**

gdscript

extends CharacterBody2D

var vida \= 100

var esta\_en\_suelo \= true

func \_process(delta):

    \# Detectar salto

    if Input.is\_action\_just\_pressed("ui\_accept"):

        if esta\_en\_suelo:

            saltar()

        else:

            print("Ya estás en el aire")

    \# Detectar movimiento

    if Input.is\_action\_pressed("ui\_right"):

        mover(1)    \# 1 \= derecha

    if Input.is\_action\_pressed("ui\_left"):

        mover(-1)   \# \-1 \= izquierda

func saltar():

    print("¡Saltando\!")

    esta\_en\_suelo \= false

func mover(direccion):

    print("Moviéndose hacia: " \+ str(direccion))

---

### **🧪 Bloque 9 — Mini práctica integradora (30–40 min)**

**Objetivo:** "El jugador presiona una tecla → el personaje reacciona", usando TODO lo aprendido en la clase.

**Pasos:**

1. Crear un nuevo proyecto en Godot (o usar el de la clase)  
2. Agregar un nodo CharacterBody2D  
3. Crear y adjuntar un nuevo script GDScript  
4. Declarar variables: vida, velocidad, nombre  
5. En `_process()`, detectar input con `if Input.is_action_just_pressed()`  
6. Llamar a una función `saltar()` cuando se presione `"ui_accept"`  
7. Mostrar el resultado en la consola con `print()`  
8. EXTRA: Agregar movimiento con `"ui_left"` y `"ui_right"`

**Código base para el ejercicio:**

gdscript

extends CharacterBody2D

\# Variables del personaje

var vida \= 100

var velocidad \= 200

var nombre\_personaje \= "Héroe"

func \_ready():

    print("=== " \+ nombre\_personaje \+ " está listo \===")

    print("Vida: " \+ str(vida))

    print("Presioná ESPACIO para saltar")

    print("Presioná ← → para moverse")

func \_process(delta):

    \# Saltar con espacio

    if Input.is\_action\_just\_pressed("ui\_accept"):

        saltar()

    \# Movimiento horizontal

    if Input.is\_action\_pressed("ui\_right"):

        mover("derecha")

    if Input.is\_action\_pressed("ui\_left"):

        mover("izquierda")

func saltar():

    print("¡" \+ nombre\_personaje \+ " saltó\!")

func mover(direccion):

    print(nombre\_personaje \+ " se mueve hacia: " \+ direccion)

**Desafíos extra para los más avanzados:**

* Agregar una variable `puntos` que aumente cada vez que el jugador salta  
* Crear una función `recibir_dano(cantidad)` que reduzca la vida  
* Mostrar un mensaje distinto según cuánta vida queda (if/elif/else)  
* Agregar un contador de cuántas veces saltó el jugador

---

### **🧭 Bloque 10 — Cierre (10 min)**

**Tabla resumen de la clase:![][image4]Pregunta de reflexión para cerrar:**

"¿Qué parte de un videojuego que conocen creen que usa un if? ¿Y cuál usa un loop? ¿Y cuál detecta input?"

Dejá que respondan 3 o 4 estudiantes, y conectá sus respuestas con lo que trabajaron en la clase.

---

*"Hoy dejaron de usar el motor… y empezaron a controlarlo."*

---

### **📚 Tarea para la próxima clase**

* Modificar el código de la práctica para que el personaje tenga más acciones (correr, agacharse)  
* Agregar una variable `monedas` que se incremente al presionar una tecla específica  
* Crear una función `mostrar_estado()` que imprima toda la información del personaje de una sola vez  
* **Desafío:** Hacer que el personaje "muera" después de recibir 3 golpes, usando un contador




