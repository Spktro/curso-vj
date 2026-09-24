# Mapa de contenidos · v2 de la diplomatura

> **Estado: distribución acordada; contenidos en ajuste.** Parte del inventario real de la v1 (tag `v1-2026`). Cada semana tiene **una clase teórica (T)**, **una clase teórico-práctica (TP-clase, con más código en vivo)** y **un TP semanal**, más largo, que unifica lo que antes eran dos.
>
> Distribución acordada con Javier el 20/9/2026 (planilla "Hoja 1"): **5 semanas de 3 clases + una clase de cierre**, 16 encuentros. El juego que atraviesa el curso sigue siendo el *survivors* con jefe.

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

## 2 · Distribución acordada (5 semanas + cierre)

Cada semana: **T** (teórica) → **T/P** (teórico-práctica: mismo formato, mucho más código en vivo) → **P** (clase práctica, donde se hace el TP semanal). El *survivors* arranca en la semana 3 y es el proyecto hasta el final.

| Sem. | Clase | Tipo | Contenido | Base en la v1 | Origen |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | C1 | T | Presentación: motor, interfaz, nodos, escenas, 2D/3D/UI | Clase 01 | ✅ con ajustes (ver §3) |
| 1 | C2 | T/P | GDScript: variables, `if`, `for`, funciones, input, escribiendo en vivo | Clase 02 | 🔧 |
| 1 | TP1+2 | P | **Un solo TP:** la primera escena (solo hasta el punto 3 del TP1 actual) + el juego de texto, con **una escena por ejemplo** y una escena final para *La Cripta del Golem* | TP1 + TP2 | 🔗 |
| 2 | C3 | T | Game loop, `_ready` / `_process`, `delta`, **vectores (más desarrollo antes de usarlos)**, Input Map | Clase 03 | ✅ con ajustes |
| 2 | C4 | T/P | Físicas: cuerpos, `CharacterBody2D`, `move_and_slide`, señales, `Area2D`, grupos. **Más práctica**; evaluar mover algo de C4 a C3 | Clase 04 | 🔧 |
| 2 | TP3+4 | P | **Un solo TP:** personaje que se mueve + plataformero con TileSet, monedas con señales. Se unifica y se recorta: no hace falta que lo terminen entero | TP3 + TP4 | 🔗 |
| 3 | C5 | T | **POO primero**: los 4 pilares, clases, herencia, con ejemplos de videojuegos pero centrada en orientación a objetos | Clase 05 (parte POO) | 🔧 reescribir |
| 3 | C5+ | T/P | **POO aplicada al spawn de enemigos**: instanciar, `preload`, `Timer`, clase base + hijas, escribiendo en vivo el código que spawnea y explicando cada línea | Clase 05 (parte spawning) + TP7 partes 2–3 | ✨ deck nuevo |
| 3 | TP5+ | P | **Survivors base**: jugador + HUD, slime que persigue, spawner, balas automáticas, élite con herencia y barra | TP7 (reemplaza a la canasta del TP5) | 🔗 rediseñar |
| 4 | C8 | T | IA de enemigos: qué es, 4 ejemplos famosos, comportamientos, detección, máquinas de estado | Clase 08 (parte IA) | ✅ |
| 4 | C8+ | T/P | Más práctica: el jefe con `enum` + `match` escrito en vivo, estado por estado | Clase 08 (parte código) | 🔧 |
| 4 | TP8 | P | **El jefe piensa**: ACECHAR / PERSEGUIR / ATACAR / GOLPEADO en `enemigo_elite.gd` | TP8 anterior (git `59cad72~1`) | ✅ rediseñar |
| 5 | C7 | T | Look and feel: animación, `AnimationPlayer`, audio, game feel | Clase 07 | ✅ |
| 5 | C6 | T/P | UI: `CanvasLayer`, `Control`, HUD, botones, cambio de escenas, Autoload. Recibe la diapo 29 de C1 (UI en Godot) | Clase 06 | 🔧 |
| 5 | TP7+6 | P | **Terminar el juego**: menú, HUD, Game Over, sonido y game feel sobre el survivors. A definir si entran cámara, piso infinito, ranking guardado y exportación (TP8 actual, partes 1–7) y el **aporte propio** | TP6 + TP8 actual | 🔗 rediseñar |
| 6 | — | T | **Mostrar TP por alumnos**: presentación final. No hay TP después | Deck de presentación (git `00dd0a5~1`) | ✨ |

### Qué cambia respecto de la v1

- **La IA se adelanta** (semana 4) y **UI + game feel cierran** (semana 5). Tiene sentido porque el survivors nace en la semana 3 con el spawning: semana 3 la horda, semana 4 el jefe, semana 5 se viste el juego.
- **La canasta con piezas de Tetris (TP5) desaparece**: el spawning se enseña directamente con los slimes.
- **C5 se parte en dos clases**: POO pura primero (T), y POO aplicada al spawn con mucho código (T/P). Es el cambio más fuerte de la v2.
- **Cuatro TPs unificados**: TP1+2, TP3+4, TP5+ y TP7+6. El jefe (TP8) queda solo.
- **Sin deck propio para cámara / parallax / guardado / exportar.** Si esos temas siguen, entran en la semana 5 (C6 o TP7+6). Decidir al diseñar esa semana.

## 3 · Lista de cambios recibidos (WhatsApp, 17/9/2026)

Notas de Javier sobre la v1, para aplicar al construir cada clase de la v2. **No es una lista cerrada:** se va a ir detallando al trabajar cada semana.

### Clase 01
- [x] Diapos 9 y 10: unificar texto e imagen. *(hecho en `v2/semana-01/teorica`)*
- [x] Diapo 12 ("qué es un nodo"): mejorar la explicación. Revisar si la 13 sigue haciendo falta. *(reescrita: tipo / propiedades / hijos + ejemplo del personaje; la 13 se absorbió y se quitó)*
- [x] Quitar la diapo 26 ("Cómo se arma un 2.5D en Godot"). *(hecho)*
- [x] Diapo 29 (UI en Godot): demasiado específica. Mover a la clase de UI (C6). *(decisión 20/9: se deja en C1)*

### TP1 + TP2 (semana 1)
- [x] Del TP1 se usa solo hasta el punto 3 (piso, jugador, caja). *(Parte A del `v2/semana-01/tp.md`; cámara y música quedaron como extras)*
- [x] TP2, punto 2: no se entiende si hay que crear un nodo nuevo, dónde va, ni si es una escena por ejemplo. Falta el paso "creá un nodo, ponele tal nombre, adjuntale el script". *(sección B.0 "El ritual", y cada parte dice nodo, script y escena)*
- [x] Decisión: **una escena por cada ejemplo** y una última escena para *La Cripta del Golem*. *(`01_variables` … `06_input` + `07_cripta`)*
- [x] TP1 y TP2 se juntan en un solo TP, el de la clase práctica. *(hecho)*
- [x] (24/9) Se quita la Parte A (piso, jugador, caja) del TP1: queda solo el juego de texto, con las partes renumeradas 0–7.

### Todo el material (24/9/2026)
- [x] Redacción impersonal en decks y TPs: instrucciones en infinitivo, explicaciones con "se". Pendiente de decidir: los textos que imprime el propio juego ("Tenés:", "Presioná:", "¡Ganaste!", "Movete con WASD", "Sobreviviste…").

### Clase 03
- [x] Hablar más de **vectores** antes de usarlos en el código. *(C3 v2: tres diapos "Qué es un vector", "Sumar y multiplicar", "Vector2 en Godot", más `Input.get_vector`)*
- [x] Diapo 22 ("Extensiones guiadas"): no se entiende; probablemente sacarla. *(quitada; sus ideas viven en el TP2)*

### Clases 03 y 04
- [x] C4 es señales: agregar más práctica. Ver si algo de C4 puede pasar a C3. *(C4 v2: cuatro bloques en vivo, "señales que ya usaste", "cuando la señal no dispara", desafío. "`_process` vs `_physics_process`" pasó a C3)*
- [x] Juntar TP3 y TP4 en uno. No hace falta que lo terminen entero: se unifica y se recorta. *(`v2/semana-02/tp.md`: Parte A sin correr ni dash, Parte B sin cámara ni victoria; todo eso quedó en extras)*

### TP5+ (semana 3)
- [x] Survivors base a partir del TP7 v1, con los nombres de C5+ (`arena`, `slime`, `class_name Enemigo`, élite como escena heredada + `extends Enemigo`). *(hecho: `v2/semana-03/tp.md`)*

### Clase 05
- [x] Diapo 7 (tipado estático): queda rara, no se sabe dónde va. Quizás a C2. *(movida a C2 v2, después de "Tipos de datos")*
- [x] Reescribir como POO pura (ver semana 3). Lo de spawning pasa a C5+. *(C5 v2: objeto, clase vs objeto, 4 pilares con ejemplos de juegos, herencia en GDScript, "es un" vs "tiene un", ejercicio de diseño del survivors. Hueco de imagen pendiente en la diapo 7)*

### Semana 4 (C8, C8+, TP4)
- [x] C8 teórica: la parte de IA de la Clase 08 v1 sin voseo y sin tipado estático. Salen las diapos de código fino ("funciones cortas", "agregar GOLPEADO"), que pasan al C8+, y el cierre de la diplomatura (juegos comerciales, recorrido, recursos), que queda para la semana 6. Se suman un ejercicio en papel (la máquina de Boo + la pregunta de histéresis), su solución, resumen y próxima clase.
- [x] C8+ teórico-práctica: cuatro bloques en vivo sobre el proyecto `clase-05` (sin proyecto de partida nuevo): ACECHAR ⇄ PERSEGUIR con `LabelEstado`, ATACAR con `TimerAtaque` y el kamikaze anulado, GOLPEADO con la bomba de Enter, y `cambiar_estado()` con un color por estado. Desafío: estado AVISO (Hollow Knight).
- [x] TP4 "El jefe piensa": sobre el `tp3`, en `slime_elite.gd` (no `enemigo_elite.gd`). Los nodos nuevos se agregan en el editor, no por código. Jefe con vida 12, velocidad 70, daño 15. Parte 4 `cambiar_estado()`, Parte 5 ajustar números. **La exportación del TP8 anterior salió de acá** y queda para la semana 5 (decisión pendiente 1).

### Semana 5 (C7, C6, TP5)
- [x] C7 teórica: la Clase 7 v1 llevada al survivors (vista de arriba, sin saltos ni aterrizajes), sin voseo ni tipado. Suma `Tween` (flash, pop), la tabla "cuál de los tres" (`AnimatedSprite2D` / `AnimationPlayer` / `Tween`), el sonido que se corta con `queue_free()`, `pitch_scale` al azar, screenshake con `Camera2D` fija, hit stop, partículas con `CPUParticles2D`, "cuánto juice es demasiado", un demo interactivo en el hook y el ejercicio de la **planilla de feedback** (con solución, que es la guía del TP).
- [x] C6 teórico-práctica: cuatro bloques en vivo sobre el `clase-05` (sin proyecto de partida nuevo): HUD con `hud.gd` y barra por colores, menú + Main Scene, Autoload `Partida` (kills, tiempo, mejor_tiempo) y Game Over con récord de la sesión. Desafío: pausa con Esc (`process_mode`). La diapo 29 de C1 se quedó en C1 (decisión del 20/9).
- [x] TP5 "Terminá tu juego" sobre el `tp4`: `Partida` + HUD con script, menú, Game Over, sonido, game feel (destello y pop en `enemigo.gd`, parpadeo con `AnimationPlayer`, temblor con `Camera2D`), **exportar** y **aporte propio** con `aporte.md` para mostrar en la semana 6. Cámara que sigue, piso infinito y ranking en archivo quedaron como extras (con link al TP8 v1). Sonidos: síntesis propia, `v2/herramientas/generar-sonidos.py` → `v2/semana-05/assets/*.wav`.

## 4 · Decisiones pendientes

1. ~~**Semana 5:** qué entra del TP8 actual (cámara, piso infinito, ranking guardado, exportar; la exportación ya no está en el TP del jefe) y dónde vive el **aporte propio** para que tengan algo que mostrar en el cierre.~~ Resuelto el 22/9: exportar y aporte propio son partes obligatorias del TP5; cámara, piso infinito y ranking guardado, extras.
2. *(C5+ hecho sin proyecto de partida: la clase arranca con 5 min armando la arena y el jugador, ya vistos en la semana 2. C8+ también se hizo sin proyecto de partida: arranca del `clase-05` de la semana 3. Sigue abierto para C6.)* **C5+ como deck nuevo:** conviene que traiga un **proyecto Godot de partida** versionado (`v2/semana-03/proyecto-clase/`) para el código en vivo. Mismo criterio para C2, C4, C8+ y C6.
3. **Godot 4.3+** como mínimo si queda `Parallax2D`. Fijarlo en C1.
4. ~~**TP3+4:** dónde cortar.~~ Resuelto: movimiento + `clamp` (A) y salto + monedas con señales (B); correr, dash, cámara y victoria como extras. Un solo proyecto `tp2` con dos escenas.

## 5 · Estructura de carpetas de la v2

```
v2/
├── index.html                  # índice por semanas
├── mapa-de-contenidos.md       # este archivo
├── PROMPT-siguiente-sesion.md  # cómo retomar el trabajo en una sesión nueva
├── herramientas/build-pdf.js   # generador de PDF compartido
└── semana-0N/
    ├── teorica/index.html      # clase T
    ├── practica/index.html     # clase T/P (más código)
    ├── proyecto-clase/         # (opcional) proyecto Godot de partida para el código en vivo
    ├── tp.md  +  tp.pdf        # TP semanal
    └── assets/
```

## 6 · Cómo se trabaja (para cualquier sesión que retome esto)

- **La v1 no se toca** (tag `v1-2026`, raíz del repo). Todo lo nuevo va en `v2/`.
- Cada deck de la v2 **nace copiando** el deck v1 correspondiente (`clase-0N/index.html` + `deck.css` + `deck.js` + `assets/`) a su carpeta de semana, y se edita ahí.
- Los TPs siguen el formato de los TPs v1: pasos numerados, ✅ puntos de control, 🧠 "por qué", 🛟 `<details>` de errores comunes, checklist, código de referencia, extras, recursos. Tabs en los bloques gdscript. PDF con `node v2/herramientas/build-pdf.js <tp.md>`.
- Antes de cerrar un deck: sondeo de overflow (contenido ≤ 584 px por slide a 1280×720) y capturas con Chrome headless.
- Commits a `main`, en español, sin tildes en el mensaje, y push; verificar la URL en Pages.
