# Demos de la Clase 8 · Enemigos con cerebro

Proyecto Godot (4.3 o posterior) para **mostrar en vivo** durante la teórica de la semana 4. No es para que el grupo lo programe: el código del jefe se escribe en la Clase 8+.

- **Abrir:** Godot → Importar → elegir `project.godot` de esta carpeta → F5.
- **Menú:** clic en una demo (o flechas + Enter). **Esc** vuelve al menú. **F11** alterna pantalla completa.
- **Estilo:** vista desde arriba, todo dibujado con `_draw()`, sin assets. El jugador es el punto celeste (WASD). Los enemigos muestran su estado en `LabelEstado`.
- **Código:** tabs, sin tipado estático y los mismos nombres del survivors (`enemigo.gd` / `Enemigo`, `slime_elite.gd`, `enum Estado`, `cambiar_estado()`, `TimerAtaque`, `TimerGolpe`, `LabelEstado`).

## Qué mostrar en cada una

| Demo | Bloque | Teclas | Qué mirar |
|---|---|---|---|
| **01 · Kamikaze** | 0 | WASD | El slime de la semana 3: a los 10 segundos se sabe qué va a hacer cada uno. |
| **02 · Blinky y Pinky** | 1 | WASD | Caminar en línea recta: Pinky apunta 4 casillas adelante y sale al cruce. Se dibuja el objetivo de cada uno. |
| **03 · Space Invaders** | 1 | Espacio, K, R | Eliminar aliens de a uno; con K queda uno solo, 55 veces más rápido. Toda la "IA" es `_on_alien_muerto()`. |
| **04 · Semáforo** | 2 | T, F, A, M | Cada tecla es un evento (un método). Si el evento no tiene flecha en ese estado, queda **ignorado**. M: el `Timer` llama a `pasar_tiempo()`. Abrir `semaforo.gd` y leerlo. |
| **05 · Detección** | 3 | WASD, Ctrl | Izquierda: un radio (ve de espaldas y a través de todo). Derecha: dos `Area2D` en cono, como Commandos. En el cono oscuro, agachado, no ve. |
| **06 · Spaghetti** | 3 | WASD, Espacio | Tres booleanos en pantalla. Alejarse a más de 350 px: no vuelve a acechar (falta esa flecha). Disparar mientras ataca: `atacando` y `golpeado` en `true` a la vez. |
| **07 · El jefe** | 3 | WASD, Espacio | La misma conducta con `match`. Los círculos son las flechas del diagrama: 250 / 350 y 40 / 60. Disparar: GOLPEADO medio segundo. |
| **08 · Histéresis** | 3 | WASD, H | Dejar que alcance y alejarse despacio. Con 40 / 40: unos 40 cambios de estado por segundo. Con 40 / 60: 2 o 3. |
| **09 · Pac-Man** | 4 | WASD, P | El reloj SCATTER (7 s) ⇄ CHASE (20 s). P: FRIGHTENED (azul, parpadea al final). Tocarlo asustado: EATEN, vuelve a la casa. El reloj queda en pausa mientras tanto. |
| **10 · Boo** | 4 | WASD, ← → | Mirarlo: se tapa. Darle la espalda: avanza. Lejos: flota. Flechas: girar sin moverse. |
| **11 · Separación** | 5 | WASD, M, ↑ ↓, C | M cambia de modo. **Sin separar:** se apilan en uno. **Vecinos:** se reparten, casi sin costo. **Todos contra todos:** se reparten igual, pero los FPS se desploman (medido: 600 enemigos, unos 140 FPS con vecinos y unos 5 FPS todos contra todos). ↑ suma 100 enemigos al máximo. |

## Estructura

```
proyecto-clase/
├── menu.tscn / menu.gd        # lista de demos
├── comun/                     # jugador, bala, slime (enemigo.gd), cartel, atajos (autoload)
└── demos/
    ├── 01_kamikaze/ … 11_separacion/   # una carpeta por demo: su escena y sus scripts
```
