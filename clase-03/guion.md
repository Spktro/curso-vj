## **Parte 1**

## **🎮 Clase 3 — "El juego está vivo"**

**Diplomatura en Desarrollo de Videojuegos con Godot**

---

### **🎯 Objetivos de la clase**

Al finalizar, los estudiantes podrán:

* Entender qué pasa cuando el juego arranca y en cada frame  
* Usar `_ready()` y `_process()` correctamente  
* Lograr movimiento continuo usando `delta`  
* Configurar y usar el Input Map de forma profesional

---

### **🚀 Bloque 1 — Hook inicial (10 min)**

Arrancá mostrando dos escenas en Godot, sin decir nada todavía:

1. Un objeto completamente quieto en pantalla  
2. Ese mismo objeto moviéndose solo, sin parar

Luego preguntás al grupo:

"¿Cómo hacemos para que algo no pare nunca de moverse?"

Dejá que especulen. Después revelás el concepto clave:

"El juego no es una foto. Es un bucle que se repite millones de veces. Nosotros escribimos qué pasa en cada repetición."

**Tip pedagógico:** No des la respuesta de entrada. La pregunta crea el gancho. Que sientan la necesidad de la solución antes de verla.

---

### **🔁 Bloque 2 — El Game Loop (15–20 min)**

#### **¿Qué es el game loop?**

Un videojuego no es un programa que corre de arriba a abajo y termina. Es un programa que corre en bucle, constantemente, mientras el juego esté abierto.

**Analogía clave:**

"Un juego es como una película infinita que se actualiza muchas veces por segundo. Cada cuadro de esa película es un frame."

#### **¿Qué pasa en cada frame?**

En cada frame, el motor hace siempre lo mismo, en orden:

1. Detecta si hubo input del jugador  
2. Actualiza la lógica del juego (posiciones, física, variables)  
3. Dibuja todo en pantalla  
4. Repite

**Analogía del corazón:**

"Es como un corazón latiendo: cada latido es un frame. Si el corazón late 60 veces por segundo, el juego se actualiza 60 veces por segundo."

#### **¿Cuántos frames por segundo?![][image1]**Godot por defecto corre a 60 FPS. Eso significa que todo el código dentro del game loop se ejecuta 60 veces por segundo.

**Pregunta para el grupo:**

"Si escribimos `print('hola')` dentro del game loop... ¿cuántas veces se imprime por segundo?"

Dejá que respondan. La respuesta es 60\. Eso ilustra perfectamente qué significa "continuo".

---

### **⚙️ Bloque 3 — Función `_ready()` (20 min)**

#### **¿Qué es `_ready()`?**

Es la función que Godot llama automáticamente una sola vez, justo cuando el nodo entra a la escena. Es el momento de arranque, de preparación.

gdscript

extends Node2D

func \_ready():

    print("El juego comenzó")

    print("Esta línea se imprime UNA sola vez")

#### **¿Para qué sirve?**

Para todo lo que necesitás configurar antes de que empiece la acción:

gdscript

extends Node2D

var vida \= 100

var velocidad \= 200

var nombre \= "Héroe"

func \_ready():

    \# Posición inicial del personaje

    position \= Vector2(100, 300\)

    \# Mensajes de inicio

    print("=== Juego iniciado \===")

    print("Personaje: " \+ nombre)

    print("Vida: " \+ str(vida))

    print("Velocidad: " \+ str(velocidad))

#### **Regla de oro**

`_ready()` es como el discurso de apertura: se dice una vez, al principio, y después el juego toma su curso.

**Mini práctica:** Que cada estudiante cambie la posición inicial y los valores de las variables, ejecute el proyecto, y observe cómo cambia el punto de partida. El objetivo es entender que `_ready()` define el estado inicial del mundo.

---

### **🔄 Bloque 4 — Función `_process(delta)` (30–35 min)**

#### **¿Qué es `_process()`?**

Es la función que Godot llama automáticamente en cada frame. Si el juego corre a 60 FPS, `_process()` se ejecuta 60 veces por segundo. Es el corazón del juego en movimiento.

gdscript

func \_process(delta):

    print("Estoy corriendo constantemente")

Si ejecutás esto, vas a ver "Estoy corriendo constantemente" llenando la consola sin parar. Eso es exactamente lo que hace el motor — llama a esta función una y otra vez, sin descanso.

#### **`_ready()` vs `_process()![][image2]`Ejemplo comparativo — escribilo en vivo:**

gdscript

extends Node2D

func \_ready():

    print("Esto se imprime UNA vez — al inicio")

func \_process(delta):

    print("Esto se imprime CADA frame — sin parar")

Ejecutalo. Que vean la diferencia en la consola. Es el momento donde muchos estudiantes tienen el "click" de entender el game loop.

---

### **⏱️ Bloque 5 — ¿Qué es delta? (20–25 min)**

Este es uno de los conceptos más importantes de la clase, y uno de los que más se explica mal. No lo evites — enfrentalo directo.

#### **El problema sin delta**

Imaginá que escribís esto:

gdscript

func \_process(delta):

    position.x \+= 5

En una computadora que corre a 60 FPS, el objeto se mueve 5 × 60 \= 300 píxeles por segundo. En una computadora que corre a 30 FPS, se mueve 5 × 30 \= 150 píxeles por segundo.

**El mismo juego, en distintas máquinas, se comporta diferente.** Eso es un problema serio.

#### **La solución: delta**

`delta` es el tiempo (en segundos) que pasó desde el frame anterior. Es un número muy pequeño — alrededor de 0.016 a 60 FPS.

gdscript

func \_process(delta):

    position.x \+= 200 \* delta

Ahora el movimiento es: 200 píxeles × tiempo\_transcurrido.

* A 60 FPS: 200 × 0.016 ≈ 3.2 píxeles por frame → 200 píxeles por segundo  
* A 30 FPS: 200 × 0.033 ≈ 6.6 píxeles por frame → 200 píxeles por segundo

**El resultado es el mismo sin importar los FPS.** El movimiento queda atado al tiempo real, no a la velocidad de la máquina.

#### **Analogía para explicarlo**

"Es como pagar el alquiler por día en lugar de por cuota fija. Si el mes tiene 28 o 31 días, siempre terminás pagando lo mismo al final."

#### **Resumen visual![][image3]Regla:** Cada vez que escriban movimiento dentro de `_process()`, multiplican por `delta`. Sin excepción.

---

## Parte 2

### **🏃 Bloque 6 — Movimiento constante (30–40 min)**

#### **Primera aplicación real**

Ahora combinan todo lo anterior para lograr algo concreto: un objeto que se mueve solo.

gdscript

extends Node2D

var velocidad \= 100

func \_process(delta):

    position.x \+= velocidad \* delta

Ejecutalo. El objeto se mueve solo hacia la derecha, sin que el jugador haga nada. Eso es movimiento constante.

#### **Explorar direcciones**

gdscript

extends Node2D

var velocidad \= 150

func \_process(delta):

    \# Elegí UNA sola dirección para probar

    position.x \+= velocidad \* delta   \# → Derecha

    \# position.x \-= velocidad \* delta \# ← Izquierda

    \# position.y \+= velocidad \* delta \# ↓ Abajo

    \# position.y \-= velocidad \* delta \# ↑ Arriba

**Ejercicio guiado:**

1. Ejecutar con movimiento a la derecha — observar  
2. Cambiar `velocidad` de 100 a 300 — ¿qué cambia?  
3. Cambiar a movimiento hacia abajo — ¿qué cambia?  
4. Combinar dos direcciones a la vez — ¿qué pasa?

gdscript

\# ¿Qué pasa si movemos en diagonal?

func \_process(delta):

    position.x \+= velocidad \* delta

    position.y \+= velocidad \* delta

**Pregunta para el grupo:** "Si queremos que el objeto vuelva al centro cuando sale de pantalla, ¿qué herramienta de la clase pasada usaríamos?"

La respuesta es `if`. Ese puente entre clases es importante marcarlo.

#### **Movimiento con dirección usando Vector2**

gdscript

extends Node2D

var velocidad \= 200

func \_process(delta):

    \# Vector2(x, y) — x es horizontal, y es vertical

    position \+= Vector2(velocidad, 0\) \* delta   \# Derecha

    \# position \+= Vector2(-velocidad, 0\) \* delta \# Izquierda

    \# position \+= Vector2(0, velocidad) \* delta  \# Abajo

No profundices demasiado en Vector2 todavía — solo mostrá que existe y que se puede usar. La clase de física lo va a retomar.

---

### **🎮 Bloque 7 — Input del jugador (segunda capa) (30–35 min)**

En la Clase 2 detectaron input con `print()`. Ahora eso se conecta con movimiento real.

#### **Input \+ process \= control en tiempo real**

gdscript

extends Node2D

var velocidad \= 200

func \_process(delta):

    if Input.is\_action\_pressed("ui\_right"):

        position.x \+= velocidad \* delta

Ejecutalo. Ahora el objeto solo se mueve cuando el jugador mantiene presionada la tecla. Eso es control en tiempo real.

#### **Las tres variantes de input — cuándo usar cada una**

gdscript

func \_process(delta):

    \# Mientras esté presionada (ideal para movimiento continuo)

    if Input.is\_action\_pressed("ui\_right"):

        position.x \+= velocidad \* delta

    \# Solo en el instante de presionar (ideal para saltar, disparar)

    if Input.is\_action\_just\_pressed("ui\_accept"):

        print("¡Salto\!")

    \# Solo en el instante de soltar (ideal para cargar poderes)

    if Input.is\_action\_just\_released("ui\_accept"):

        print("Soltaste el botón")![][image4]

---

### **🗺️ Bloque 8 — Input Map (20–25 min)**

Este bloque es clave para profesionalizar el trabajo desde temprano. No se detectan teclas directamente — se detectan acciones con nombre.

#### **¿Por qué Input Map?**

Imaginá que en tu código escribís `if Input.is_key_pressed(KEY_D)` en 50 lugares distintos. Cuando querés cambiar la tecla de movimiento, tenés que cambiar 50 líneas. Con Input Map, cambiás la configuración en un solo lugar y todo el código sigue funcionando.

#### **Cómo acceder al Input Map**

En Godot: `Project → Project Settings → Input Map`

Ahí van a ver las acciones predeterminadas (`ui_left`, `ui_right`, `ui_up`, `ui_down`, `ui_accept`, etc.) y las teclas asignadas a cada una.

#### **Crear una acción nueva**

1. En el campo de texto arriba, escribir el nombre de la acción: `mover_derecha`  
2. Hacer clic en "Add"  
3. Hacer clic en el botón "+" a la derecha de la acción creada  
4. Presionar la tecla que querés asignar (por ejemplo, D)  
5. Confirmar

Ahora en el código pueden usar:

gdscript

if Input.is\_action\_pressed("mover\_derecha"):

    position.x \+= velocidad \* delta

#### **Acciones recomendadas para crear desde ahora![][image5]Mini práctica:** Que cada estudiante cree al menos la acción `mover_derecha` y `mover_izquierda`, las asigne a teclas, y las use en su código. El objetivo es romper la dependencia de las acciones predeterminadas de Godot.

---

### **🖱️ Bloque 9 — Input de teclado y mouse (20 min)**

#### **Movimiento completo con teclado**

gdscript

extends Node2D

var velocidad \= 200

func \_process(delta):

    if Input.is\_action\_pressed("mover\_derecha"):

        position.x \+= velocidad \* delta

    if Input.is\_action\_pressed("mover\_izquierda"):

        position.x \-= velocidad \* delta

    if Input.is\_action\_pressed("mover\_arriba"):

        position.y \-= velocidad \* delta

    if Input.is\_action\_pressed("mover\_abajo"):

        position.y \+= velocidad \* delta

Nota importante: en Godot, el eje Y está invertido respecto a lo que se espera. Y positivo es hacia abajo. Marcalo en clase — es una fuente frecuente de confusión.

#### **Input de mouse**

gdscript

func \_process(delta):

    \# Detectar clic izquierdo

    if Input.is\_mouse\_button\_pressed(MOUSE\_BUTTON\_LEFT):

        print("¡Click izquierdo\!")

    \# Detectar clic derecho

    if Input.is\_mouse\_button\_pressed(MOUSE\_BUTTON\_RIGHT):

        print("Click derecho")

    \# Obtener la posición actual del mouse

    var pos\_mouse \= get\_viewport().get\_mouse\_position()

    print("Mouse en: " \+ str(pos\_mouse))

#### **Bonus — mover el personaje hacia donde apunta el mouse**

gdscript

func \_process(delta):

    if Input.is\_mouse\_button\_pressed(MOUSE\_BUTTON\_LEFT):

        var objetivo \= get\_viewport().get\_mouse\_position()

        position \= position.move\_toward(objetivo, velocidad \* delta)

No profundices demasiado en `move_toward` — solo mostralo como algo que existe y que van a entender mejor cuando lleguen a la clase de física. Lo importante ahora es que vean el mouse como otra fuente de input posible.

---

### **🧪 Bloque 10 — Práctica integradora (40–50 min)**

**Objetivo:** Hacer que un personaje se mueva con el teclado en tiempo real, usando todo lo visto en la clase.

#### **Requisitos mínimos**

* Movimiento horizontal con `_process()` y `delta`  
* Acciones configuradas en el Input Map  
* Variable `velocidad` ajustable

#### **Código base**

gdscript

extends Node2D

var velocidad \= 200

func \_ready():

    print("=== Juego iniciado \===")

    print("Usá las flechas o WASD para moverte")

func \_process(delta):

    if Input.is\_action\_pressed("mover\_derecha"):

        position.x \+= velocidad \* delta

    if Input.is\_action\_pressed("mover\_izquierda"):

        position.x \-= velocidad \* delta

#### **Extensiones guiadas (ir agregando de a una)**

**Paso 1 — Agregar movimiento vertical:**

gdscript

   if Input.is\_action\_pressed("mover\_abajo"):

        position.y \+= velocidad \* delta

    if Input.is\_action\_pressed("mover\_arriba"):

        position.y \-= velocidad \* delta

**Paso 2 — Agregar velocidad variable con if:**

gdscript

var velocidad\_normal \= 200

var velocidad\_rapida \= 400

func \_process(delta):

    var vel\_actual \= velocidad\_normal

    if Input.is\_action\_pressed("correr"):  \# configurar en Input Map

        vel\_actual \= velocidad\_rapida

    if Input.is\_action\_pressed("mover\_derecha"):

        position.x \+= vel\_actual \* delta

    if Input.is\_action\_pressed("mover\_izquierda"):

        position.x \-= vel\_actual \* delta

**Paso 3 (bonus) — Limitar el personaje a la pantalla:**

gdscript

func \_process(delta):

    \# movimiento...

    \# Que no salga de la pantalla

    var tam \= get\_viewport\_rect().size

    position.x \= clamp(position.x, 0, tam.x)

    position.y \= clamp(position.y, 0, tam.y)

#### **Desafíos extra para los más avanzados**

* Hacer que el personaje deje un rastro (cambiar su color al presionar una tecla)  
* Agregar una variable `puntos` que aumente mientras el jugador se mueve  
* Mostrar la posición actual en la consola solo cuando cambia  
* Crear un límite de velocidad máxima usando `clamp()`

---

### **🧭 Bloque 11 — Cierre (10–15 min)**

#### **![][image6]Pregunta de cierre para el grupo**

"Si quisiéramos hacer que el personaje acelere gradualmente en lugar de moverse a velocidad constante, ¿qué tendríamos que cambiar?"

La respuesta involucra modificar la variable `velocidad` dentro de `_process()`. No hace falta que lleguen a la solución exacta — la pregunta planta la semilla para la próxima clase.

---

*"Hoy hicieron que el juego deje de ser una foto… y pase a ser algo vivo."*

---

### **📚 Tarea para la próxima clase**

* Experimentar cambiando la velocidad del personaje y observar el efecto  
* Agregar al menos una acción nueva en el Input Map y usarla en el código  
* Intentar que el personaje no pueda salir de la pantalla usando `clamp()`  
* **Desafío:** Hacer que el personaje se mueva más rápido cuanto más tiempo esté presionada la tecla (velocidad acumulativa)






