# Capturas pendientes · v2

Imágenes del material que hoy son **genéricas** (de la documentación de Godot u otra fuente) y conviene reemplazar por **capturas propias** del editor, hechas con los assets y nombres del curso. Evaluadas por contexto, sin abrirlas (24/9/2026).

**Prioridad:** 🔴 muestra algo distinto de lo que dice el paso (otro tileset, otro personaje, otros números) · 🟡 genérica pero sirve (la pantalla es igual en cualquier proyecto; mejora si es propia).

**Cómo entregarlas:** dejar el PNG en la carpeta indicada con el nombre sugerido (o pasármelo y lo recorto). Después cambio la referencia en el archivo y regenero el PDF.

## TP1 · `v2/semana-01/tp.md` → `v2/semana-01/assets/`

| Pri. | Línea | Hoy muestra | Captura que hace falta | Nombre sugerido |
| :-: | :-: | :--- | :--- | :--- |
| 🟡 | 69 | Botón **Otro Nodo** (docs) | Panel Escena vacío del proyecto `tp1` con el botón **Otro Nodo** | `tp1-otro-nodo.png` |
| 🔴 | 73 | Buscador de nodos con otra búsqueda | Buscador con `Node` escrito y el resultado seleccionado | `tp1-buscar-node.png` |
| 🔴 | 78 | Menú **Attach Script** sobre otro nodo | Clic derecho sobre el nodo `Variables` → **Attach Script** | `tp1-attach-script.png` |
| 🔴 | 82 | Diálogo Attach Node Script con otra ruta | El diálogo con Path `res://01_variables.gd` | `tp1-attach-dialogo.png` |
| 🔴 | 96 | Output con otro mensaje | Panel **Output** mostrando `¡La escena arrancó!` | `tp1-output.png` |

## TP2 · `v2/semana-02/tp.md` → `v2/semana-02/assets/`

| Pri. | Línea | Hoy muestra | Captura que hace falta | Nombre sugerido |
| :-: | :-: | :--- | :--- | :--- |
| 🔴 | 81 | Colisión rectangular del tutorial *Dodge the Creeps* | `CollisionShape2D` sobre el `icon.svg` del explorador | `tp2-colision-explorador.png` |
| 🔴 | 137 | Input Map con `move_*` | Input Map con `mover_derecha`, `mover_izquierda`, `mover_arriba`, `mover_abajo` y `saltar` (también sirve para la diapo 20 de C3) | `tp2-input-map.png` |
| 🔴 | 290 | TileSet de 64×64 | Inspector del TileSet con **Tile Size 16×16** | `tp2-tile-size.png` |
| 🔴 | 296 | Otro tileset | `world_tileset.png` con los tiles creados automáticamente | `tp2-tiles-auto.png` |
| 🔴 | 311 | Colisión con tiles de otro pack | Colisión rectangular (tecla F) sobre un tile de `world_tileset.png` | `tp2-colision-tile.png` |
| 🔴 | 315 | Pintar colisión con otro pack | Pintando la colisión sobre varios tiles del curso | `tp2-pintar-colision.png` |
| 🔴 | 327 | Otro tileset en el panel TileMap | Panel TileMap con un tile del curso seleccionado | `tp2-elegir-tile.png` |
| 🔴 | 366 | Ranas | Selección de frames de `knight.png` (8×8) con los del idle marcados | `tp2-frames-caballero.png` |
| 🔴 | 378 | Colisión rectangular del tutorial | `CapsuleShape2D` envolviendo al caballero | `tp2-capsula-caballero.png` |
| 🟡 | 74, 86, 117, 121, 125, 286, 302, 323, 356, 361 | Pantallas del editor (docs) | Opcional: las mismas con el proyecto `tp2` | — |

## TP3 · `v2/semana-03/tp.md` → `v2/semana-03/assets/`

| Pri. | Línea | Hoy muestra | Captura que hace falta | Nombre sugerido |
| :-: | :-: | :--- | :--- | :--- |
| 🔴 | 97 | Selección de frames genérica | `knight.png` 8×8 con los frames del **idle** seleccionados | `tp3-frames-caballero.png` |
| 🔴 | 178 | Hoja genérica | `slime_green.png` en grilla **4×3** con la fila del medio seleccionada | `tp3-frames-slime.png` |

## TP5 · `v2/semana-05/tp.md` → `v2/semana-05/assets/`

| Pri. | Línea | Hoy muestra | Captura que hace falta | Nombre sugerido |
| :-: | :-: | :--- | :--- | :--- |
| 🔴 | 119 | Pestaña Globals con otro autoload | **Globals → Autoload** con `Partida` → `res://partida.gd` | `tp5-autoload-partida.png` |
| 🔴 | 462 | Panel de animación genérico | Animación `golpe` del caballero: pista **Modulate** con keys en 0 / 0.1 / … / 0.4 | `tp5-animacion-golpe.png` |
| 🟡 | 213 | Menú de anclas (docs) | Sirve igual; opcional con el `Fondo` seleccionado | — |
| 🟡 | 531, 535 | Export templates / Add… (locales) | Sirven igual | — |

## Decks

| Pri. | Deck · diapo | Hoy muestra | Captura que hace falta | Nombre sugerido |
| :-: | :--- | :--- | :--- | :--- |
| 🔴 | C1 · “Crear un proyecto” | `nuevo-projecto.png` genérica | Project Manager creando el proyecto del curso | `v2/semana-01/teorica/assets/nuevo-proyecto.png` |
| 🔴 | C1 · “Los cuatro paneles” | `editor.png` genérica | Editor con un proyecto del curso abierto (las cuatro zonas visibles) | `v2/semana-01/teorica/assets/editor.png` |
| ✅ | C1 · “Panorama de motores” | Capturas OK; los alt ya se corrigieron | — | — |
| 🔴 | C2 · “¿Qué es y dónde está?” | `godot-console.png` genérica | Output con la salida de `01_variables` | `v2/semana-01/practica/assets/godot-console.png` |
| 🟡 | C2 · “if / else” | `diagrama-if.png` genérico | Diagrama con el ejemplo del curso (vida y daño); lo puedo dibujar en SVG | — |
| 🟡 | C2 · “Ejemplo: Tower Defense” | `tw-defense.png`, alt pobre | Captura de un Tower Defense a elección | `v2/semana-01/practica/assets/tw-defense.png` |
| 🟡 | C3 · “Por qué Input Map” | Captura de docs con `move_*` | La misma de `tp2-input-map.png` | — |
