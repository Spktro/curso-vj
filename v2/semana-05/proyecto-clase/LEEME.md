# Demos de la Clase 7 · El juego se siente vivo

Proyecto Godot (4.3 o posterior) para **mostrar en vivo** durante la teórica de la semana 5. No es para que el grupo lo programe: el sonido, el HUD y el game feel del survivors se hacen en el TP5.

- **Abrir:** Godot → Importar → elegir `project.godot` de esta carpeta → F5.
- **Menú:** clic en una demo (o flechas + Enter). **Esc** vuelve al menú. **F11** alterna pantalla completa.
- **Estilo:** el caballero y los slimes del survivors (`assets/`, de Brackeys, ver `LICENSE-brackeys.txt`) y los sonidos del TP5. WASD mueve al caballero en todas las demos.
- **Código:** tabs, sin tipado estático y los mismos nombres del survivors (`recibir_dano()`, `destello()`, `morir()`, `sacudir_camara()`, `frenar_tiempo()`, `SfxDisparo`, `SfxGolpe`, `SfxKill`, `Camara`).
- **Con sonido:** la mitad de las demos se entiende solo con los parlantes prendidos.

## Qué mostrar en cada una

| Demo | Diapo | Teclas | Qué mirar |
|---|---|---|---|
| **01 · Prioridad** | `AnimatedSprite2D` | WASD, G, O, M, R | Caminando, G muestra el golpe. Con **O** se invierte el orden de los `if`: caminando, el golpe ya no se ve. M: la animación `morir` no tiene loop y al terminar emite `animation_finished`. |
| **02 · Parpadeo** | `AnimationPlayer` y el parpadeo | G, B | La línea de tiempo con el cabezal, igual que en la diapo. **B** pasa a `golpe_sin_final` (sin el keyframe de 0.4 s): el caballero queda **rojo**. Las dos animaciones están en `comun/caballero.tscn` → `AnimationPlayer`. |
| **03 · Tween** | `Tween` | Espacio, 1 a 5, T, R | Cinco `Tween` distintos: flash, pop, salto, aplastar, girar. **T** cambia la curva (`set_trans`) del salto y del aplastado: `BACK` y `ELASTIC` se sienten vivos, `LINEAR` se siente mecánico. |
| **04 · pitch_scale** | Reproducir y variar | Espacio (mantener), V, ↑ ↓ | Primero sin variación (ametralladora de juguete), después con **V**. |
| **05 · Sonido cortado** | El sonido que se corta | 1, 2, 3, R | 1: `play()` + `queue_free()` → no suena. 2: suena el caballero. 3: el slime se esconde, **espera la señal `finished`** y recién se borra (en pantalla, a cuántos ms llegó la señal). |
| **06 · Encadenar** | Desencadenantes | K, X | **K:** morir → animación → `animation_finished` → sonido → `finished` → cartel + `Timer` → `timeout` → reiniciar, con los ms de cada paso. **X:** todo en el mismo frame: el caballero revive antes de caer. |
| **07 · Buses** | Buses | Espacio, ↑ ↓, ← →, M | Bajar la música sin tocar los disparos. Los buses están en `default_bus_layout.tres` (panel **Audio**). |
| **08 · Screenshake** | Screenshake | Espacio, 1, 2, 3 | 3, 6 y 15 px. El cartel de arriba no tiembla: está en un `CanvasLayer`, como el HUD. |
| **09 · Hit stop** | Hit stop | Espacio, H, 1, 2, 3 | Con 0.06 s se siente un impacto; con 0.25 s, un tirón (parece que el juego se trabó). H: comparar con y sin. |
| **10 · Partículas** | Partículas (las dos) | Espacio, 1, 2, 3, clic | 1: el `CPUParticles2D` se crea en el código (`explotar()`). 2: se instancia `explosion.tscn`. 3: las partículas son hijas del slime y **no se ven**: se borran con él. |
| **11 · Cuánto juice** | Arranque y Cuánto juice es demasiado | WASD, 0 a 9, ← → | El survivors con la mecánica fija. **0**: nada. Del **1 al 7** se suma una respuesta por nivel (lista a la derecha). **8 y 9**: el exceso. Sirve también para abrir la clase: 0 y después 7. |

## Estructura

```
proyecto-clase/
├── menu.tscn / menu.gd        # lista de demos
├── default_bus_layout.tres    # buses Master, Musica y Efectos
├── assets/                    # caballero, slime, bala y sonidos
├── comun/                     # caballero (con su AnimationPlayer), slime, bala, explosión, cartel, piso, atajos (autoload)
└── demos/
    ├── 01_prioridad/ … 11_cuanto_juice/   # una carpeta por demo: su escena y sus scripts
```
