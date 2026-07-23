## **🧠 1\. Apertura (10–15 min)**

Objetivo: dar contexto y motivación

* Presentación de profesores  
* Qué van a aprender en la diplomatura  
* Mostrar **un juego hecho en Godot Engine** (puede ser tuyo o uno simple)

Mensaje clave:

“Hoy no van a aprender todo, pero sí van a entender cómo pensar dentro del motor.”

---

## **2\. ¿Qué es un motor de videojuegos? (15–20 min)**

Un **motor de juegos** (o *game engine*) es un software que reúne, en un solo entorno, todas las herramientas necesarias para crear un videojuego: renderizado de gráficos, físicas, audio, manejo de entrada del jugador, animación, scripting, y exportación a distintas plataformas.

La idea clave para principiantes: **sin un motor, harías todo desde cero** — escribir código para dibujar un píxel en pantalla, detectar colisiones entre dos rectángulos, reproducir un sonido, etc. Eso lleva años. Un motor te da todo eso resuelto y vos te concentrás en el *juego en sí*: las reglas, los niveles, la experiencia.

**Analogía útil:** un motor de juegos es como una cocina equipada. Podrías construir tu horno, fabricar tus cuchillos y cultivar tus ingredientes, o entrar a una cocina lista y dedicarte a cocinar. Los grandes chefs (estudios) a veces construyen su propia cocina (motor propio); la mayoría usa una existente.

**Panorama rápido de motores populares:**

* **Unity** — muy usado en la industria, C\#, gratuito hasta cierto nivel de ingresos.  
* **Unreal Engine** — gráficos AAA, C++ y Blueprints, royalties sobre ingresos.  
* **GameMaker** — orientado a 2D, lenguaje propio (GML).  
* **Godot** — el que vamos a usar. Open source, gratuito sin royalties ni licencias, liviano (el editor pesa menos de 100 MB), y con una filosofía de diseño muy particular: **todo es un nodo**.

**¿Por qué Godot para empezar?** Es gratis, corre en máquinas modestas, tiene una curva de aprendizaje amable, y su sistema de nodos —que vemos en el segundo bloque— es uno de los modelos mentales más claros para entender cómo se estructura un juego.

---

##  **3\. Instalación y primer contacto (15–20 min)**

Godot se descarga desde su sitio oficial (godotengine.org). Es un único ejecutable: no hay instalador, no hay registro, no hay cuenta. Lo descomprimís y lo abrís.

**Versiones que conviene mencionar:**

* **Godot 4.x** — la versión actual, con mejor render 3D y nuevas funcionalidades. Es la que vamos a usar.  
* **Godot 3.x** — versión anterior, todavía soportada. Útil saber que existe porque mucho material online sigue siendo de la 3.x y la sintaxis cambió.  
* **.NET / C\# vs estándar** — Godot tiene dos sabores: el estándar usa GDScript (lenguaje propio, parecido a Python); el de .NET además permite usar C\#. Para empezar, recomiendo el estándar.

**Práctica en clase:** que cada estudiante descargue, descomprima y abra Godot. Cuando lo abren por primera vez aparece el **Project Manager**, donde se listan los proyectos y se crean nuevos.

Crear un proyecto de prueba juntos: clic en *New Project*, elegir nombre, carpeta, dejar el resto por defecto. Eso los lleva al editor.

---

## **4\. Recorrido por la interfaz (30–40 min)**

Acá conviene ir mostrando en pantalla cada panel mientras los estudiantes los identifican en su propia ventana. La ventana del editor de Godot tiene cuatro zonas principales que vale la pena nombrar y describir una por una:

**El Viewport (centro).** Es la ventana grande del medio donde "ves" tu juego. Tiene pestañas en la parte superior para alternar entre vista **2D**, **3D** y editor de **Script**. Es el escenario donde vas a posicionar visualmente todo lo que aparece en el juego.

**Escena (arriba a la izquierda).** Muestra la **jerarquía de nodos** de la escena que estás editando: una estructura de árbol donde cada elemento del juego es un nodo, y los nodos pueden tener nodos hijos. Este panel es probablemente el más importante de Godot y vamos a profundizarlo en el segundo bloque.

**Sistema de Archivos / FileSystem (abajo a la izquierda).** Muestra todos los archivos del proyecto: escenas, scripts, imágenes, sonidos, etc. Es básicamente un explorador de archivos integrado. Una particularidad de Godot: las rutas dentro del proyecto empiezan con `res://` (de *resource*), y eso vas a verlo mucho.

**Inspector (derecha).** Cuando seleccionás un nodo en el panel de Escena, el Inspector muestra todas sus **propiedades** editables: posición, rotación, color, tamaño, etc. Acá es donde modificás cómo se ve y se comporta cada cosa, sin necesariamente escribir código.

**Otros elementos a señalar:**

* La **barra superior** con los botones de *Play* (ejecutar el proyecto), *Play Scene* (ejecutar solo la escena actual), y los botones de pausa y stop.  
* El **panel inferior**, que se expande para mostrar la consola de depuración, errores, animaciones, mezclador de audio, etc.  
* Los **menús** Scene, Project, Debug, Editor, Help — sobre todo *Project → Project Settings*, donde se configuran cosas como resolución, controles, capas físicas.

**Práctica guiada:** agregar un nodo simple (por ejemplo un `Sprite2D` con una imagen de prueba que viene con Godot, el "icon.svg" del proyecto), verlo aparecer en el Viewport, mover sus propiedades en el Inspector, y observar cómo se refleja el cambio.

---

## **5\. Sistema de nodos (bloque CLAVE) (30–40 min)**

Este es el concepto central de Godot, y vale la pena dedicarle tiempo porque cambia la forma de pensar el desarrollo.

Un **nodo** es la unidad mínima de funcionalidad en Godot. Cada nodo hace *una cosa específica*: mostrar una imagen, reproducir un sonido, detectar colisiones, mostrar texto en pantalla, recibir input del jugador, etc.

Godot trae cientos de tipos de nodos distintos. Algunos ejemplos:

* `Sprite2D` — muestra una imagen 2D.  
* `Camera2D` — define qué parte de la escena se ve.  
* `AudioStreamPlayer` — reproduce un sonido.  
* `Label` — muestra texto.  
* `CharacterBody2D` — un cuerpo físico controlable, ideal para personajes.  
* `Timer` — dispara un evento cada cierto tiempo.

**Analogía clave:** los nodos son como **piezas de Lego**. Cada pieza es simple y hace poco por sí sola. Lo interesante es **combinarlas**: un personaje jugable no es un solo nodo gigante con todo adentro, sino un cuerpo físico que tiene como hijos un sprite (la imagen), un colisionador (la forma física), una cámara, un reproductor de sonido para los pasos, etc.

## **🎬 6\. Concepto de escena y jerarquía (20–25 min)**

Acá viene el segundo concepto clave, que se entrelaza con el anterior.

Una **Escena** en Godot es **un árbol de nodos guardado como archivo** (extensión `.tscn`). No es solamente "un nivel del juego" como podría sugerir la palabra: en Godot una escena puede ser cualquier cosa que quieras tratar como una unidad reusable.

**Ejemplos de qué puede ser una escena:**

* Un nivel completo del juego.  
* El menú principal.  
* Un enemigo.  
* Una bala.  
* El HUD (la interfaz del jugador con vida, puntaje, etc.).  
* Hasta un solo botón estilizado, si lo vas a reutilizar.

**Toda escena tiene un nodo raíz**, y de ahí cuelgan los demás nodos formando una jerarquía. Por ejemplo, una escena de jugador podría verse así:

Player (CharacterBody2D)  
├── Sprite2D  
├── CollisionShape2D  
├── Camera2D  
└── AudioStreamPlayer

**El gran truco de Godot: las escenas son anidables.** Una escena puede ser instanciada *dentro* de otra como si fuera un solo nodo. Entonces tu escena `Nivel1` podría tener instanciada la escena `Player` y diez instancias de la escena `Enemigo`. Si después modificás la escena `Enemigo`, todas las instancias en todos los niveles se actualizan automáticamente.

Esto resuelve algo que en otros motores requiere sistemas más complejos (prefabs en Unity, blueprints en Unreal): en Godot, **la escena ES el prefab**. No hay distinción.

**Reglas de la jerarquía que conviene mencionar:**

* Un nodo hijo hereda transformaciones del padre. Si movés el padre, los hijos se mueven con él. Esto es lo que hace que un personaje completo se mueva como una unidad.  
* El orden de los hijos importa para el dibujado en 2D: los de más abajo en la lista se dibujan encima.  
* Cualquier nodo puede convertirse en la raíz de una nueva escena (clic derecho → *Save Branch as Scene*), permitiendo refactorizar a medida que el proyecto crece.

**Práctica guiada:** armar entre todos una escena `Player` simple con un `CharacterBody2D` como raíz, y agregarle un `Sprite2D` y un `CollisionShape2D` como hijos. Guardarla como `player.tscn`. No hace falta que se mueva todavía — el objetivo es que vean el árbol formándose y entiendan que esa escena ahora es una "pieza" reutilizable.

---

## **7\. Tipos de nodos: 2D · 2.5D · 3D · UI (40–50 min)**

Este bloque responde a una pregunta previa a cualquier decisión técnica: **¿dónde vive tu juego?** Godot no tiene un "modo" configurable — tiene **tres sistemas separados** de nodos, con reglas propias, y hay que elegir en cuál trabajás antes de armar nada. Casi todo juego usa al menos dos a la vez: un mundo (2D o 3D) más una capa de UI encima.

---

### **🟦 2D — qué significa, en serio**

2D es **dos dimensiones**, o sea **dos ejes**. Todo lo que existe en el juego se ubica sobre un **plano cartesiano**: cada objeto tiene una posición `(x, y)` y nada más.

* **Eje X:** izquierda ↔ derecha. **Eje Y:** arriba ↔ abajo.
* **Detalle importante que confunde a todo el mundo:** en pantalla el **eje Y crece hacia abajo**, y el origen `(0,0)` está en la **esquina superior izquierda**. Es al revés que en la clase de matemática. La razón es histórica: los monitores dibujan la imagen línea por línea, de arriba hacia abajo, y las coordenadas heredaron ese orden. Mostralo en vivo: mové un `Sprite2D` hacia abajo en el Viewport y que vean el número de `y` **subiendo** en el Inspector.
* La **unidad es el píxel**.
* **No hay profundidad real.** Quién tapa a quién no se decide por distancia sino por **orden de dibujo**.
* Las transformaciones son tres: posición, rotación (un solo ángulo) y escala.

**Plano no quiere decir aburrido.** Con dos ejes se simulan puntos de vista muy distintos, y conviene mostrarlos con capturas:

* **Vista lateral (side-view):** X es correr, Y es saltar, hay gravedad. *Celeste*, *Hollow Knight*, *Super Mario Bros.*
* **Vista cenital (top-down):** mirás desde arriba, X e Y son el piso. *Stardew Valley*, los *Zelda* clásicos, *Brotato*.
* **Isométrico:** parece 3D pero **sigue siendo 2D**: el volumen está *pintado* dentro del sprite. *Hades*, *Diablo II*, *Age of Empires II*.

En los tres casos el motor sólo maneja `(x, y)`. La profundidad del isométrico es dibujo y orden de capas: puro arte.

**En Godot:**

| Nodo | Para qué |
| :---- | :---- |
| `Node2D` | Base de todo lo 2D: aporta posición, rotación y escala en el plano |
| `Sprite2D` | Dibuja una imagen |
| `AnimatedSprite2D` | Dibuja una secuencia de imágenes |
| `CharacterBody2D` | Cuerpo con física, pensado para el personaje |
| `TileMapLayer` | Pinta el escenario con una grilla de mosaicos |
| `Camera2D` | El recorte del plano que se ve en pantalla |

Tres detalles que van a morder a los estudiantes:

* Los nodos 2D **terminan en `2D`**. Si el nombre no lo tiene, casi seguro no es 2D.
* **El orden en el árbol es el orden de dibujo:** el hermano de más abajo se dibuja **encima**. Si el personaje quedó tapado por el piso, la solución es moverlo abajo en la lista, no tocar código. Para saltear esa regla existe `z_index`.
* Todos heredan de `CanvasItem`, y por eso comparten `modulate` (tinte), `visible` y las capas de dibujo.

---

### **🟥 3D — sumar un eje lo cambia todo**

3D agrega el eje **Z**: la **profundidad**. Cada objeto vive en `(x, y, z)` dentro de un volumen, y la cámara se encarga de **proyectar** ese volumen sobre tu pantalla, que sigue siendo plana.

* En Godot **Y apunta hacia arriba** (al revés que en 2D) y **−Z es "hacia adelante"**.
* La unidad ya no es el píxel: por convención **1 unidad = 1 metro**.
* Los objetos no son imágenes: son **mallas** (vértices → triángulos → superficie) con un **material** encima que define color, textura y brillo.
* **Sin luz no se ve nada.** Aparecen luces, sombras y entorno. La escena arranca negra y eso no es un error: le falta iluminación.
* La rotación pasa de un número a **tres** (cabeceo, giro, alabeo).

**Ejemplos para mostrar** (los de la diapositiva): *Elden Ring* (tercera persona: la cámara va detrás del personaje), *Portal 2* (primera persona: la cámara **es** los ojos del personaje, nunca lo ves), *Minecraft* (3D total con estética de bloques y texturas mínimas), *Diablo IV* (3D real con cámara fija desde arriba — parece isométrico y no lo es; señalá las sombras proyectadas, que son la prueba). Sirven igual *Breath of the Wild* o *Horizon* para tercera persona.

⚠️ **Ojo con un ejemplo que parece bueno y no lo es:** *Cult of the Lamb* tiene esa misma cámara elevada, pero sus personajes son **sprites 2D** dentro de un escenario 3D. No es 3D: es 2.5D, y encaja en el bloque siguiente. Es un buen caso para plantearle a la clase *después* de ver 2.5D.

**En Godot:** `Node3D`, `MeshInstance3D` (el equivalente al `Sprite2D`), `Camera3D` (con FOV), `DirectionalLight3D` / `OmniLight3D` / `SpotLight3D`, `CharacterBody3D`, `WorldEnvironment`.

Lo que cambia respecto de 2D: los nodos terminan en `3D` y **no se mezclan** con los `2D` — cada mundo tiene su rama del árbol. Y el orden del árbol ya no importa para dibujar: el motor usa la distancia a la cámara (buffer de profundidad).

**Mencionar el costo real del 3D:** modelado, texturizado, rigging, animación, iluminación y optimización. Es muchísimo más trabajo por objeto, y por eso la diplomatura arranca en 2D.

---

### **🟨 2.5D — se ve en una dimensión, se juega en otra**

No es un formato técnico ni un botón del motor: es una **decisión de presentación**. Hay dos caminos, y van en direcciones opuestas.

**A · Mundo 3D, juego 2D.** Todo está modelado en 3D —con luces, sombras y cámara real— pero el jugador **sólo se mueve en dos ejes**. Ganás la belleza del 3D con la simpleza de diseño del 2D. *Little Nightmares*, *Trine*, *New Super Mario Bros. U*, *Donkey Kong Country Returns*.

**B · Mundo 2D que finge volumen.** Imágenes planas acomodadas para simular profundidad: perspectiva isométrica, capas de fondo que se mueven a distinta velocidad (*parallax*), o sprites planos que siempre miran a la cámara. *DOOM* (1993) —los enemigos nunca te muestran la espalda porque son una imagen que gira hacia vos—, *Don't Starve*, *Octopath Traveler* (el estilo "HD-2D": sprites planos parados dentro de escenarios 3D con desenfoque), *Age of Empires II*.

**¿Por qué tanto juego elige 2.5D?** Cuesta menos producir, se lee mejor (una cámara previsible no marea) y diseñar niveles en dos ejes es mucho más simple.

**Pregunta útil para clasificar cualquier juego:** *¿en cuántos ejes puede moverse el jugador?* Eso define el género técnico; lo demás es cómo se ve.

**En Godot** no hay un modo 2.5D: elegís uno de los dos mundos y lo disfrazás.

* **Escena 3D con cámara plana:** escena 3D normal + `Camera3D` con **Projection: Orthogonal** y el movimiento del `CharacterBody3D` bloqueado en un eje. → estilo *Little Nightmares*.
* **Sprites parados en 3D:** `Sprite3D` / `AnimatedSprite3D` con **Billboard: Enabled** dentro de una escena 3D: la imagen plana siempre rota hacia la cámara. → estilo HD-2D o *DOOM*.
* **Todo 2D con falsa profundidad:** `Parallax2D` para capas de fondo a distinta velocidad, más **Y-Sort** para que lo que está más abajo se dibuje encima. `TileMapLayer` tiene modo **Isometric**. → estilo *Hades* o *Stardew Valley*.

Regla práctica: si el **arte** es plano, hacelo en 2D; si el arte tiene volumen y luces, hacelo en 3D y limitá el movimiento. Nunca mezcles los dos árboles.

---

### **🟩 UI — no está en el mundo, está en la pantalla**

La interfaz es todo lo que **le comunica información al jugador** y no forma parte del terreno donde ocurre la acción. Si la cámara se mueve, el mundo se corre; **la UI se queda quieta**.

* **HUD** (durante el juego): vida, munición, puntaje, minimapa, misión activa.
* **Pantallas**: menú principal, pausa, inventario, opciones, game over.
* Su sistema de coordenadas es **la pantalla**, medida en píxeles, y tiene que sobrevivir a **cualquier resolución** → anclas y contenedores, nunca posiciones fijas.

La UI es **diseño de información**, y se resume en tres preguntas: ¿**qué** necesita saber el jugador para tomar la próxima decisión?, ¿**cuándo** —todo el tiempo o sólo cuando importa—?, y ¿**cuánto ruido** estoy dispuesto a meterle a la imagen para decírselo? Esa tercera pregunta es exactamente la que separa la UI diegética de la no diegética.

#### **Diegética vs. no diegética**

**Diégesis** es el mundo de la ficción. La pregunta es simple: **¿el personaje puede ver eso que estás viendo vos?**

* **Diegética — *Dead Space*.** El ejemplo canónico: la vida es la **columna luminosa del traje** de Isaac y la munición se proyecta **holográficamente sobre el arma**. No hay ni un píxel de HUD flotando. Todo existe dentro de la ficción y el personaje lo ve. Máxima inmersión: el jugador nunca "sale" del juego para leer. Otros: *Far Cry 2* (sacás un **mapa de papel** real con la mano en vez de abrir un menú), *Metro Exodus* (un **reloj de muñeca** te indica si te están viendo y cuánto le queda al filtro de la máscara), *Alien: Isolation* (el **detector de movimiento** que Amanda sostiene físicamente, y por eso mirarlo te deja vulnerable).
* **No diegética — *Fortnite*, *Overwatch*, *Counter-Strike*.** Barras, números y minimapa **pegados a la pantalla**, con tipografía y estilo propios que no pertenecen al mundo. El personaje no los ve: existen sólo para el jugador. Es la opción más común porque es la **más clara y la más barata de producir**.

#### **En realidad son cuatro tipos**

Se cruzan dos preguntas: *¿pertenece a la ficción?* y *¿está dibujada en el mundo o pegada a la pantalla?*

| Tipo | ¿Ficción? | ¿Dónde? | Ejemplos |
| :---- | :---- | :---- | :---- |
| **Diegética** | Sí | En el mundo | *Dead Space* (vida en la espalda), *Far Cry 2* (mapa de papel), *Alien: Isolation* (detector en la mano) |
| **No diegética** | No | En la pantalla | *Hollow Knight* (máscaras de vida), *League of Legends* (minimapa), el puntaje de *Tetris* |
| **Espacial** | No | En el mundo | Siluetas de los compañeros a través de las paredes en *Left 4 Dead*, nombres flotando sobre los NPC en *WoW*, el cartel "E para abrir" pegado a la puerta |
| **Meta** | Sí | En la pantalla | Salpicaduras de sangre cuando te disparan en *Call of Duty*, gotas de lluvia sobre "el lente", estática en pantalla cuando te detectan |

Ningún juego elige uno solo: **los mezclan**. Más diegético significa más inmersión, pero menos legibilidad y más costo de producción. Es un intercambio de diseño, no una escala de calidad.

#### **En Godot**

| Nodo | Para qué |
| :---- | :---- |
| `Control` | Base de **toda** la UI. No usa posición suelta: usa un rectángulo con **anclas** |
| `CanvasLayer` | Capa aparte que **no se mueve con la cámara**. Acá va el HUD |
| `Label`, `RichTextLabel`, `Button`, `TextureButton` | Texto y botones |
| `ProgressBar` / `TextureProgressBar` | La clásica barra de vida, con arte propio |
| `VBoxContainer`, `HBoxContainer`, `MarginContainer`, `GridContainer` | Acomodan a los hijos solos: la UI sobrevive a cualquier resolución |

**¿Y la UI diegética?** No se hace con nodos de UI: **se hace con nodos del mundo**.

* En 2D: colgás un `Label` o un `Sprite2D` como **hijo del personaje** —fuera del `CanvasLayer`— y se mueve con él.
* En 3D: `Label3D` o `Sprite3D` pegados al modelo.
* Para una pantalla dentro del juego (un monitor, un celular, el arma de *Dead Space*): armás la UI con nodos `Control` dentro de un `SubViewport` y usás **esa textura** sobre un `MeshInstance3D`.

---

### **Cuadro comparativo**

|  | 🟦 2D | 🟥 3D | 🟩 UI |
| :---- | :---- | :---- | :---- |
| **Nodo base** | `Node2D` | `Node3D` | `Control` |
| **Ejes** | X, Y — **Y hacia abajo** | X, Y, Z — **Y hacia arriba** | X, Y de la pantalla |
| **Unidad** | píxel | metro (1 unidad) | píxel de pantalla |
| **Qué dibuja** | `Sprite2D` (imagen) | `MeshInstance3D` (malla) | `Label`, `Button`… |
| **Cámara** | `Camera2D` | `Camera3D` (con FOV) | ninguna: `CanvasLayer` |
| **Profundidad** | orden en el árbol / `z_index` | distancia real a la cámara | orden de las capas |
| **Se nota porque…** | termina en `2D` | termina en `3D` | no lleva sufijo |

---

### **💡 Ejercicio del bloque**

1. En una escena con raíz `Node2D`, agregar un `Sprite2D` y moverlo en el Viewport. Mirar cómo cambia `position` en el Inspector: **el valor de Y sube al bajar el sprite**.
2. Agregar un `Button`. Notar que aparece **en otro lugar** y que su panel de propiedades es **completamente distinto**: tiene anclas, no posición libre.
3. Agregar un `Camera2D` y moverlo: el sprite se corre… **y el botón no**.
4. Meter el botón dentro de un `CanvasLayer` y confirmar que ahí sí queda clavado a la pantalla pase lo que pase con la cámara.

**Lo que tienen que poder responder al final:** ¿por qué el botón no se movió con la cámara? ¿Ese botón es UI diegética o no diegética? ¿Cómo lo harían diegético sin reemplazar el nodo por otro?

**🕹️ Extra para casa:** elegir un juego que les guste, sacarle una captura y marcar cada elemento de UI como *diegético*, *no diegético*, *espacial* o *meta*.

---

## **8\. Mini práctica integradora (20–30 min)**

Algo simple pero poderoso:

👉 “Crear una escena con:

* Un nodo raíz  
* Un elemento visual  
* Un botón UI”

No importa que sea básico. Importa que:

* Creen una escena  
* Usen nodos  
* Vean la interfaz en acción

---

## **🧭 9\. Cierre (10 min)**

Repaso rápido de los conceptos:

* Un motor de juegos es una caja de herramientas integrada para crear videojuegos.  
* Godot organiza el trabajo en cuatro paneles: Escena, FileSystem, Inspector y Viewport.  
* Todo en Godot es un *nodo*; los nodos se organizan en árboles llamados *escenas*; las escenas pueden anidarse unas dentro de otras.  
* Hay tres familias principales de nodos: 2D, 3D y UI, y cada una vive en su propio sistema.

**Tarea sugerida:** que cada estudiante cree un nuevo proyecto, agregue una escena con un nodo raíz `Node2D`, y experimente agregando al menos tres tipos distintos de nodos hijos. No tiene que hacer nada funcional — solo familiarizarse con el editor, mover cosas, romper, deshacer, leer el Inspector. La próxima clase arrancan con eso.

