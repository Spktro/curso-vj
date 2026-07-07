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

## **7\. Tipos de nodos (20–30 min)**

Dividilo claro y visual:

### **🟦 2D**

* Para juegos planos  
* Ej: personajes, plataformas

### **🟥 3D**

* Para mundos tridimensionales  
* Cámara, luces, modelos

### **🟩 UI (Interfaz)**

* Botones, HUD, menús

💡 Ejercicio corto:  
 Que agreguen:

* Un nodo 2D  
* Un nodo UI (ej: botón)

Y que vean la diferencia en pantalla

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

