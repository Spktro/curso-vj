# Mapa de contenidos · v2 de la diplomatura

> **Estado: borrador para corregir.** Parte del inventario real de la v1 (tag `v1-2026`) y propone una redistribución en semanas. Cada semana tiene **una clase teórica (T)**, **una clase teórico-práctica (TP-clase, con más código en vivo)** y **un TP semanal**, más largo, que unifica lo que antes eran dos.
>
> Supuestos a confirmar: **8 semanas** y **el mismo juego final** (el *survivors* con jefe). Si cambia alguno, el mapa se reacomoda.

Leyenda de la columna "Origen": ✅ **reusar** tal cual · 🔧 **reforzar** con código en vivo · 🔗 **unificar** dos piezas en una · ✨ **nuevo** (no existe en la v1)

---

## 1 · Inventario de la v1

### Clases (decks)

| Clase | Título | Temas (por bloque de diapositivas) |
| :--- | :--- | :--- |
| 01 | Primeros pasos con Godot | Motores y por qué Godot · instalar y crear proyecto · interfaz (4 paneles) · nodos, escenas, jerarquía, escenas anidadas = prefab · plano cartesiano · 2D / 3D / 2.5D con ejemplos · UI (diegética, 4 tipos) · qué es el código, sintaxis vs semántica, "el salto de Mario" |
| 02 | Programar con GDScript | Qué es programar · anatomía de un script · variables y tipos · `if / elif / else` · `for` (Tower Defense) · funciones, parámetros, `return` · funciones especiales de Godot · input y acciones · práctica integradora |
| 03 | El juego está vivo | Game loop y 60 FPS · `_ready()` vs `_process()` · `delta` (problema y solución) · `Vector2` · tres variantes de input · Input Map · movimiento con teclado · input de mouse |
| 04 | El personaje cobra vida | Tres cuerpos físicos y regla práctica · `CharacterBody2D` + `move_and_slide()` · `_process` vs `_physics_process` · `CollisionShape2D` · señales (flujo, conectar desde editor y por código) · `Area2D` · grupos · escena Jugador + Moneda |
| 05 | Muchos de uno | POO: los 4 pilares · scripts como clases · tipado estático · instanciar (`preload` vs `load`) · spawner con timer manual y nodo `Timer` · acceder a instancias |
| 06 | La cara del juego | Jerarquía de UI · `CanvasLayer` · nodos `Control` · HUD e info dinámica · `@onready` · `ProgressBar` · botones y señales · cambio de escenas · menú + HUD |
| 07 | El juego se siente vivo | `AnimatedSprite2D` y animar por código · `AnimationPlayer` · game feel · nodos de audio y buses · cámara con smoothing · squash & stretch · partículas · capas de pulido |
| 08 | Enemigos con cerebro | Qué es la IA de un juego · 4 ejemplos famosos (Pac-Man, Space Invaders, Commandos, Doom) · comportamientos básicos · detección · spaghetti de `if` · máquina de estados, `enum` + `match`, hacer + decidir · agregar un estado (GOLPEADO) · FSM en juegos reales |

Contenido que **estuvo** en la v1 y se sacó del deck 08 (recuperable de git, commit `00dd0a5~1`): estructura de proyecto, exportar a Windows en 4 pasos, testing antes de entregar, cómo presentar tu juego.

### Trabajos prácticos

| TP | Título | Partes |
| :--- | :--- | :--- |
| 1 | Tu primera escena | Piso (`RigidBody2D`) · jugador con animación · caja que cae · `Camera2D` · música · cartel de UI |
| 2 | Tu primer juego de texto | Variables · arreglos · condicionales · `for` · funciones · input · *La Cripta del Golem* |
| 3 | Un personaje que se mueve | `CharacterBody2D` · Input Map · 4 direcciones con `delta` · `clamp()` · correr · dash |
| 4 | Un plataformero: juntá las monedas | TileSet con colisiones · jugador · salto y animación · monedas con señales · cámara y victoria |
| 5 | Atrapa las piezas | Clase base · canasta · dos clases hijas (comida / bombas) · spawner · puntaje |
| 6 | Menú, HUD y Game Over | Menú · Main Scene · HUD ampliado · Autoload `Partida` · Game Over · derrota |
| 7 | Sobreviví a los slimes | Jugador + HUD · slime (perseguir) · spawner por los bordes · balas automáticas · élite con herencia y barra de vida |
| 8 | Proyecto final: terminá tu juego | Cámara · piso infinito (`Parallax2D`) · tiempo en `Partida` · menú con nombre · ranking con `FileAccess` + JSON · pantalla final · exportar · **tu aporte** |

TP del jefe con máquina de estados (versión anterior del TP8, recuperable de git, commit `59cad72~1`): ACECHAR / PERSEGUIR / ATACAR / GOLPEADO sobre `enemigo_elite.gd`.

---

## 2 · Propuesta de redistribución (8 semanas)

| Sem. | Eje | Clase T (teórica) | Clase TP (teórico-práctica, más código) | TP semanal | Origen |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Godot y el código | Clase 01 completa: motor, interfaz, nodos, escenas, 2D/3D/UI | Clase 02: GDScript en vivo. Variables, `if`, `for`, funciones, input, escribiendo el juego de texto frente a ellos | **TP1+2 unificado:** la primera escena (piso, jugador, caja, cámara, música, cartel) **y** el juego de texto, en un solo proyecto | ✅ 01 · 🔧 02 · 🔗 TP1+TP2 |
| 2 | El juego está vivo | Clase 03: game loop, `_ready` / `_process`, `delta`, `Vector2`, Input Map | Clase 04 (primera mitad): cuerpos físicos, `CharacterBody2D`, `move_and_slide`, `_physics_process`. En vivo: el personaje que se mueve, corre y hace dash | **TP3+4 unificado:** personaje en un plataformero con TileSet: movimiento, salto, correr, dash, cámara. Sin monedas todavía | ✅ 03 · 🔧 04a · 🔗 TP3+TP4 (sin señales) |
| 3 | Señales y objetos | Clase 04 (segunda mitad) + Clase 05: señales, `Area2D`, grupos, POO, herencia, instanciar | Clase 05 en vivo: clase base + hijas + spawner con `Timer`, escribiendo el código completo | **TP4+5 unificado:** al plataformero se le agregan monedas con señales, y objetos que caen con herencia y spawner (comida / bombas) | 🔗 04b+05 · 🔧 05 · 🔗 TP4 (monedas) + TP5 |
| 4 | La cara del juego | Clase 06: UI, `CanvasLayer`, `Control`, HUD, botones, cambio de escenas | En vivo: menú, HUD con `@onready`, Autoload, Game Over, escribiendo todo el flujo de pantallas | **TP6:** menú, HUD, Autoload `Partida`, Game Over, derrota. Se puede engordar con pausa | ✅ 06 · 🔧 06 · ✅ TP6 |
| 5 | Se siente vivo | Clase 07: animación, `AnimationPlayer`, audio y buses, game feel | En vivo: `Tween`, sacudida de cámara, partículas, squash & stretch sobre un personaje real | **TP7 (survivors base) + game feel:** jugador, slime, spawner, balas, élite con barra; más sonidos, sacudida y partículas al matar | ✅ 07 · 🔧 07 · 🔗 TP7 + ✨ parte de game feel (no existía) |
| 6 | Enemigos con cerebro | Clase 08 (parte IA): qué es la IA, 4 ejemplos famosos, comportamientos, detección, máquinas de estado | Clase 08 (parte código): el jefe con `enum` + `match` escrito en vivo, estado por estado, hasta GOLPEADO | **TP del jefe:** ACECHAR / PERSEGUIR / ATACAR / GOLPEADO en `enemigo_elite.gd` + un quinto estado propio (EMBESTIR o disparar) | ✅ 08 · 🔧 08 · ✅ TP8 anterior (git) + ✨ quinto estado |
| 7 | Terminar el juego | ✨ Deck nuevo: cámara y mundo abierto, `Parallax2D`, persistencia (`user://`, `FileAccess`, JSON), diseño de menús y ranking | En vivo: guardar y cargar un ranking desde cero, mostrando el archivo | **TP8 partes 1 a 6:** cámara, piso infinito, tiempo, menú con nombre, ranking guardado, pantalla final | ✨ deck · 🔧 · ✅ TP8 (1–6) |
| 8 | Al mundo | ✨ Deck a partir de lo que se sacó del 08: estructura de proyecto, exportar, testing, cómo presentar. Más: itch.io y exportar a web | En vivo: exportar el juego de la cátedra y publicarlo; armar un "aporte propio" de ejemplo de punta a punta | **TP8 partes 7 y 8 + presentación:** exportar, el aporte propio, `aporte.md`, y la presentación final del juego | ✨ deck (git `00dd0a5~1`) · 🔧 · ✅ TP8 (7–8) |

### Qué cambia respecto de la v1, en una línea

- **Semanas 1 a 3 concentran lo que antes eran 5 clases y 5 TPs.** Es la parte con más riesgo de quedar densa: conviene medir el TP1+2 y el TP3+4 con un alumno real antes de cerrar.
- **La semana 5 gana un TP de game feel que no existía** (en la v1, la clase 07 no tenía TP propio: el TP7 era el survivors).
- **El jefe vuelve a ser un TP** (semana 6). En la v1 se hizo en clase y el TP8 pasó a ser el proyecto final; en la v2 hay lugar para las dos cosas.
- **Dos decks nuevos** (semanas 7 y 8). El de la semana 8 se arma con contenido ya escrito; el de la 7 es de cero.
- **El TP de cada semana termina en un punto jugable**, igual que ahora, pero el proyecto es uno solo desde la semana 5: survivors → jefe → juego terminado → exportado.

---

## 3 · Huecos y decisiones pendientes

1. **Cantidad de semanas.** El mapa asume 8. Con 10 o 12, las semanas 1 a 3 se descomprimen (por ejemplo, GDScript puro en su propia semana).
2. **Juego final.** Sigue siendo el survivors. Si se cambia, las semanas 5 a 8 se rediseñan.
3. **Herramienta de las clases TP-clase.** Si van a ser "código en vivo", conviene que cada una traiga un proyecto de Godot de partida versionado en el repo (`v2/semana-0N/proyecto-clase/`), para que la clase arranque desde un punto conocido.
4. **Godot 4.3+** como mínimo (por `Parallax2D`). Fijarlo en la semana 1.
5. **Qué pasa con el TP2 (juego de texto)** si la semana 1 queda muy cargada: puede bajar a "ejercicio en clase" en vez de TP.

---

## 4 · Estructura de carpetas de la v2

```
v2/
├── index.html                  # índice por semanas
├── mapa-de-contenidos.md       # este archivo
├── herramientas/build-pdf.js   # generador de PDF compartido
└── semana-0N/
    ├── teorica/index.html      # clase T
    ├── practica/index.html     # clase TP (más código)
    ├── proyecto-clase/         # (opcional) proyecto Godot de partida para el código en vivo
    ├── tp.md  +  tp.pdf        # TP semanal
    └── assets/
```
