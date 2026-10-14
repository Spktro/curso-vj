# Plan · C8 teórica rearmada — "Enemigos con cerebro"

Documento de trabajo para rehacer `v2/semana-04/teorica/index.html`. Cuando el deck y el proyecto de demos estén terminados, este archivo se resume en `mapa-de-contenidos.md` (sección Semana 4).

## Por qué se rehace

- El deck actual es correcto pero condensado: no llena las dos horas.
- El relato salta al código del jefe sin construir antes la idea de máquina de estados.
- Faltan ejemplos funcionando para mostrar en vivo.
- Nivel del grupo: recién aprenden objetos (semana 3). Las demos se **muestran**, no se programan. El código fino del jefe sigue en el C8+.

## Hilo de la clase

De lo abstracto a lo concreto, y de lo chico a lo grande:

**una regla** (bloque 1) → **una máquina sin juego** (bloque 2) → **un enemigo con máquina** (bloque 3) → **juegos reales** (bloque 4) → **IA más allá de un enemigo: el grupo, el perseguidor, la partida** (bloque 5).

Cada concepto aparece primero en un ejemplo no-juego, en papel o en un diagrama, y recién después en Godot.

Leyenda: **C** = conceptual · **J** = interactivo en el deck (JS local) · **G** = demo en Godot (solo mostrar) · **E** = ejercicio · 🖼️ = hueco de imagen

## Tiempos (unas 2 h con recreo)

| Bloque | Min | Tipo dominante |
|---|---|---|
| 0 · Apertura | 5 | C |
| 1 · Qué es la IA de un juego | 15 | C + G |
| 2 · Máquina de estados, sin juegos | 25 | C + J |
| 3 · Del semáforo al enemigo | 25 | C + G |
| *Recreo* | 10 | |
| 4 · FSM en juegos conocidos | 20 | C + G + E |
| 5 · La IA no siempre es un enemigo | 25 | C + G + 🖼️ |
| Cierre | 5 | C |
| **Total** | **130** | (margen: el bloque 5 se puede acortar en vivo) |

## Diapositivas, bloque por bloque

Estado: **=** se mantiene · **~** se reescribe/mueve · **+** nueva

### 0 · Apertura (5')
| # | Diapo | Estado | Notas |
|---|---|---|---|
| 1 | Portada | ~ | Subtítulo nuevo acorde al hilo (de una regla a la partida entera) |
| 2 | Objetivos | ~ | Suma "IA en distintos niveles" y quita "implementarla en GDScript" (eso es C8+) |
| 3 | Hook: el slime tiene una sola idea | = | **G01** kamikaze: mostrarlo 30 s y preguntar "¿qué va a hacer?" |

### 1 · Qué es la IA de un juego (15')
| # | Diapo | Estado | Notas |
|---|---|---|---|
| 4 | "IA" en un juego no es lo que parece | ~ | Ajustar el anticipo de ejemplos (ahora son dos acá; Commandos y Doom pasan al bloque 3) |
| 5 | Pac-Man: cuatro fantasmas, cuatro reglas | = | **G02** Blinky y Pinky persiguiendo al punto |
| 6 | Space Invaders: la IA que fue un accidente | = | **G03** aliens que aceleran |
| 7 | **+** Una regla no alcanza | + | Puente: una regla da UN comportamiento. Para que cambie de idea hace falta algo más → bloque 2 |

### 2 · Máquina de estados, sin juegos (25')
| # | Diapo | Estado | Notas |
|---|---|---|---|
| 8 | Qué es una máquina de estados | ~ | La diapo actual, sin hablar de enemigos: estados, transiciones, eventos, un estado a la vez |
| 9 | **+** El semáforo, con botones | + | **J1**: semáforo dibujado + botones de evento ("pasa el tiempo", "falla la luz", "se arregla"). Muestra el estado actual y un registro de transiciones. Un evento que no corresponde al estado **no hace nada** (se marca en gris) |
| 10 | **+** Las partes de una máquina | + | Diagrama del semáforo con rótulos: estado inicial, estados, flechas, condición de cada flecha |
| 11 | **+** Una máquina es una clase | + | `semaforo.gd`: `enum Estado`, `var estado`, métodos `pasar_tiempo()`, `fallar()`, `arreglar()` que cambian el estado. Puente con objetos de la semana 3: los métodos son los eventos. **G04** la misma clase corriendo en Godot |
| 12 | **+** Ya hay máquinas de estado en los juegos conocidos | + | **J2**: Mario chico → grande → fuego con botones (hongo, flor, golpe). Mismo mecanismo que el semáforo, ya dentro de un juego |

### 3 · Del semáforo al enemigo (25')
| # | Diapo | Estado | Notas |
|---|---|---|---|
| 13 | Comportamientos básicos | = | Los ladrillos (tabla actual) |
| 14 | ¿Cómo "ve" al jugador? | ~ | Absorbe el caso **Commandos** (cono de visión). **G05** distancia vs cono, con el punto agachado |
| 15 | Con `if` se vuelve un spaghetti | = | **G06** la versión con booleanos y su bug visible |
| 16 | Máquina de estados: una sola pregunta | ~ | Se reduce a "la misma idea del semáforo, aplicada al jefe" |
| 17 | La máquina de estados del jefe | = | Diagrama SVG actual |
| 18 | `enum` para nombrar, `match` para elegir | = | |
| 19 | El `_process`: hacer + decidir | = | **G07** el jefe con los círculos 250/350 y 40/60 dibujados y `LabelEstado` |
| 20 | Doom: la transición que llega de afuera | ~ | La diapo de Doom, ahora presentada como la flecha "al recibir daño" (entrada a GOLPEADO) |
| 21 | **+** ¿Por qué 40 y 60? | + | Histéresis, explicada y mostrada (antes era solo la pregunta del ejercicio). **G08** alternar 40/40 ↔ 40/60 con una tecla y ver el parpadeo |

### Recreo (10')

### 4 · FSM en juegos conocidos (20')
| # | Diapo | Estado | Notas |
|---|---|---|---|
| 22 | Pac-Man: el fantasma tiene cuatro estados | = | **G09** scatter/chase/frightened con el reloj en pantalla. Vuelve el Pac-Man del bloque 1: misma regla, ahora con estados |
| 23 | Metal Gear Solid: el estado está en pantalla | = | Sin demo (por tiempo) |
| 24 | Hollow Knight: leer el estado es el juego | = | Sin demo: el estado AVISO es el desafío del C8+ |
| 25 | ¿Qué tienen en común? | = | |
| 26 | Ejercicio: la máquina de Boo | ~ | 7 minutos. Sale la pregunta de histéresis (ya vista en la 21) |
| 27 | Boo: una solución posible | ~ | **G10** Boo avanzando o tapándose según hacia dónde mira el punto |

### 5 · La IA no siempre es un enemigo (25')
| # | Diapo | Estado | Notas |
|---|---|---|---|
| 28 | **+** Cuatro niveles de IA | + | Mapa del bloque: individuo → grupo → perseguidor → partida. Referencia formal: Millington y Funge, *AI for Games* (movimiento, decisión, estrategia) |
| 29 | **+** El grupo: que no se apilen | + | Separación / *steering* / *flocking* (Reynolds, *boids*, 1987). Las 4 líneas con `get_overlapping_areas()`. **G11** separación on/off con contador de enemigos y FPS |
| 30 | **+** ¿Cuánto cuesta? | + | Todos contra todos: 100 → 10.000 comparaciones, 500 → 250.000. Con el área, cada uno mira solo a sus vecinos. El motor ya hizo el filtro |
| 31 | **+** El perseguidor: Mr. X y Nemesis | + | 🖼️ Mr. X (RE2) y Nemesis (RE3). Reglas: busca por el ruido, camina sin parar, aparece cuando el juego decide, se lo voltea unos segundos (su GOLPEADO), no entra a las salas de guardado. Las debilidades son el respiro del diseño |
| 32 | **+** Dos cerebros: Alien: Isolation | + | 🖼️ Alien: Isolation. El director sabe dónde está el jugador y solo da pistas; el alien busca con vista y oído. Cuando la tensión es mucha, el director lo aleja |
| 33 | **+** La partida: el director de Left 4 Dead | + | 🖼️ Left 4 Dead. Diagrama SVG: ACUMULAR → PICO → CALMA, y gráfico de intensidad que ondula. Es una FSM sobre el spawner: en el survivors equivale a cambiar el `wait_time` del Timer según el estado. Solo conceptual |
| 34 | **+** Ritmo no es dificultad | + | Ritmo (L4D: tensión y respiro) vs ajuste dinámico de dificultad (RE4: agresividad oculta según el desempeño). Dos ideas distintas |

### Cierre (5')
| # | Diapo | Estado | Notas |
|---|---|---|---|
| 35 | Resumen | ~ | Suma: semáforo/clase, histéresis, niveles de IA |
| 36 | Próxima clase: el jefe, en vivo | = | Se agrega "traer el proyecto de demos" solo si se reparte |

## Proyecto de demos en Godot

- **Ruta:** `v2/semana-04/proyecto-clase/` (convención del mapa: proyecto de clase versionado).
- **Versión:** Godot 4.3+ (se verifica con el 4.6.2 local, headless, sin errores).
- **Estilo:** vista desde arriba, todo con `_draw()` (puntos, círculos, conos), sin assets. Jugador = punto con WASD. Cada enemigo muestra `LabelEstado` y un color por estado.
- **Código:** tabs, sin tipado estático, comentarios en español, mismos nombres del survivors donde aplica (`enemigo.gd`/`Enemigo`, `slime_elite.gd`, `Estado`, `cambiar_estado()`, `TimerAtaque`, `TimerGolpe`, `LabelEstado`, umbrales 250/350 y 40/60).
- **Menú:** escena principal con la lista; cada demo se abre con su número y Esc vuelve al menú. En cada demo, una línea de ayuda arriba con las teclas.

| Id | Escena | Bloque | Qué se ve | Teclas |
|---|---|---|---|---|
| G01 | `01_kamikaze` | 0 | El slime de la semana 3: siempre directo | WASD |
| G02 | `02_fantasmas` | 1 | Blinky va al jugador, Pinky a 4 casillas adelante; se dibuja el objetivo de cada uno | WASD |
| G03 | `03_invaders` | 1 | Fila de aliens que acelera al ir eliminándolos | Espacio elimina uno, R reinicia |
| G04 | `04_semaforo` | 2 | La clase `Semaforo` funcionando | T tiempo, F falla, A arreglar |
| G05 | `05_deteccion` | 3 | Un enemigo detecta por distancia, otro por cono | WASD, Ctrl agacharse |
| G06 | `06_spaghetti` | 3 | Versión con booleanos: se ve el bug (dos "estados" a la vez) | WASD, Espacio = bala |
| G07 | `07_jefe` | 3 | ACECHAR/PERSEGUIR/ATACAR/GOLPEADO con círculos y `LabelEstado` | WASD, Espacio = bala |
| G08 | `08_histeresis` | 3 | Mismo jefe; alterna 40/40 ↔ 40/60 y cuenta cambios de estado por segundo | WASD, H alterna |
| G09 | `09_pacman_estados` | 4 | Fantasma con scatter/chase/frightened y el reloj en pantalla | WASD, P píldora |
| G10 | `10_boo` | 4 | Boo avanza o se tapa según hacia dónde mira el jugador | A/D giran, WASD |
| G11 | `11_separacion` | 5 | Spawner continuo; separación on/off, contador y FPS | S alterna, +/- ritmo |

## Interactivos en el deck (JS local, sin librerías)

- **J1** semáforo con botones de evento, estado actual y registro de transiciones.
- **J2** Mario chico/grande/fuego con hongo, flor y golpe.
- Mismo estilo que los interactivos de `v2/semana-02/teorica`. Se reinician al salir de la diapositiva.

## Imágenes pendientes (huecos 🖼️)

Se suman a `v2/capturas-pendientes.md`:
1. Mr. X (Resident Evil 2, 2019) persiguiendo por un pasillo.
2. Nemesis (Resident Evil 3) en su aparición.
3. Alien: Isolation: el alien recorriendo un pasillo, o la jugadora escondida en un armario.
4. Left 4 Dead: una horda llegando.

## Cambios posteriores (14/10)

- **Boo deja de ser el ejercicio** y pasa a ser el cuarto caso de análisis del bloque 4 (después de Hollow Knight, antes de "¿Qué tienen en común?", que suma su fila). Motivo: quien no jugó a Mario no lo conoce.
- **Ejercicio nuevo, genérico, en papel, 15 minutos** (unos 5 para elegir el caso y 10 para desarrollarlo): elegir un caso de un juego o de la vida real, identificar los estados, identificar qué los hace transicionar, dibujar el diagrama y marcar cada flecha (distancia, evento, tiempo). Va después de "¿Qué tienen en común?".
- El bloque 4 pasa de 20 a unos 30 minutos: la clase queda en unas 2 h 20 con recreo. Si hace falta recortar, el bloque 5 se puede acortar en vivo.
- Título del perseguidor: "el Tyrant (Mr. X) y Nemesis". Imágenes de Mr. X, Nemesis y Alien: Isolation colocadas.

## Decisiones tomadas

- Las demos se muestran, no se programan. El código del jefe se escribe en el C8+.
- Sin demo jugable del AVISO de Hollow Knight (es el desafío del C8+).
- Director de IA: solo conceptual (diagrama, sin demo).
- El tiempo extra del bloque 5 sale del bloque 4: sin demo de MGS, ejercicio de Boo en 7 minutos.

## Fuera de esta clase (anotado para más adelante)

- Pathfinding (A*, `NavigationAgent2D`): ver si encaja en otra semana.
- Behavior trees y utility AI: demasiado para este nivel. A lo sumo, una mención en el cierre de la diplomatura (semana 6).

## Qué no cambia para el C8+ ni el TP4

Nombres, umbrales y estados del jefe quedan iguales (`slime_elite.gd`, `Estado { ACECHAR, PERSEGUIR, ATACAR, GOLPEADO }`, `cambiar_estado()`, 250/350, 40/60). No hace falta tocar `practica/index.html` ni `tp.md`.

## Orden de trabajo

1. ~~Proyecto de demos (G01–G11) y verificación headless.~~ Hecho: `proyecto-clase/` con `LEEME.md` (qué mostrar en cada demo). Verificado con Godot 4.6.2 headless: las 12 escenas corren sin errores ni advertencias y cada conducta da lo esperado (histéresis: ~40 cambios/s con 40/40 y 3 con 40/60; separación con 600 enemigos: ~140 FPS con vecinos y ~5 FPS todos contra todos).
2. ~~Deck: bloques 2 y 5 (lo nuevo), después el reordenamiento del resto.~~ Hecho: 38 diapos (se sumó "El recorrido de hoy" después de Objetivos; Commandos quedó como diapo propia en el bloque 3).
3. ~~J1 y J2.~~ Hecho: semáforo y Mario (con la tabla de transiciones que se resalta).
4. ~~Verificación de alturas (≤ 584 px a 1280×720) y anchos de `<pre>` y tablas.~~ Hecho.
5. ~~Huecos en `capturas-pendientes.md`, mapa, commit y push.~~ Hecho.
