# Diplomatura de Desarrollo de Videojuegos · Godot

Material de las clases de la diplomatura, en forma de presentaciones HTML navegables.

## 🌐 Ver online

Si están publicadas con GitHub Pages: **https://spktro.github.io/curso-vj/**

## 📚 Clases

| # | Clase | Contenido |
|---|-------|-----------|
| 01 | [Primeros pasos con Godot](clase-01/index.html) | Motores, instalación, interfaz, nodos, escenas y jerarquía |
| 02 | [Programar con GDScript](clase-02/index.html) | Qué es programar, variables, condicionales, loops, funciones e input |
| 03 | [El juego está vivo](clase-03/index.html) | Game loop, `_ready()`, `_process(delta)`, movimiento con delta e Input Map |
| 04 | [El personaje cobra vida](clase-04/index.html) | Cuerpos físicos, `CharacterBody2D` con `move_and_slide()`, colisiones, señales, `Area2D` y grupos |
| 05 | [Muchos de uno](clase-05/index.html) | POO básica, scripts como clases, tipado, instanciación de escenas y spawning |
| 06 | [La cara del juego](clase-06/index.html) | UI: `CanvasLayer`, `Label`, `Button`, `ProgressBar`, HUD, menús y cambio de escenas |
| 07 | [El juego se siente vivo](clase-07/index.html) | Animación, `AnimationPlayer`, audio y buses, y Game Feel (cámara, `Tween`, partículas) |
| 08 | [Tu juego en el mundo](clase-08/index.html) | Exportar a Windows y Android, organización, testing y proyecto final |

## 📝 Trabajos prácticos

Tutoriales paso a paso, muy guiados, para hacer en casa. Cada uno en Markdown y PDF.

> Los PDF se regeneran desde el Markdown con [`build-pdf.js`](trabajos-practicos/build-pdf.js):
> `cd trabajos-practicos && npm install && node build-pdf.js trabajo-practico-4.md`

| # | Trabajo práctico | Temas |
|---|-------|-------|
| 1 | [Tu primera escena](trabajos-practicos/trabajo-practico-1.md) ([PDF](trabajos-practicos/trabajo-practico-1.pdf)) | `RigidBody2D`, `CharacterBody2D`, caja que cae, `Camera2D`, audio y UI |
| 2 | [Tu primer juego de texto](trabajos-practicos/trabajo-practico-2.md) ([PDF](trabajos-practicos/trabajo-practico-2.pdf)) | Variables, arreglos, `if`, `for`, funciones e input — combate por consola |
| 3 | [Un personaje que se mueve](trabajos-practicos/trabajo-practico-3.md) ([PDF](trabajos-practicos/trabajo-practico-3.pdf)) | `CharacterBody2D`, Input Map, `delta`, correr, dash y `clamp()` |
| 4 | [Un plataformero: juntá las monedas](trabajos-practicos/trabajo-practico-4.md) ([PDF](trabajos-practicos/trabajo-practico-4.pdf)) | Señales y `Area2D` para juntar monedas, `CharacterBody2D` + `move_and_slide()`, y **TileSet** con colisiones para las plataformas (sprites de Brackeys, CC0) |
| 5 | [Atrapa las piezas](trabajos-practicos/trabajo-practico-5.md) ([PDF](trabajos-practicos/trabajo-practico-5.pdf)) | **Herencia** (clase base + hijas), grupos, instanciación y spawning con `Timer`: atrapar piezas de Tetris con una canasta (suman) y esquivar bombas (restan) |

## 🗂️ Estructura

El home vive en la raíz; cada clase es una carpeta **autocontenida** (trae su propio deck y assets).

```
.
├── index.html          # home: índice de clases
├── assets/             # imágenes del home
├── clase-01/           # todo lo de la Clase 1, junto
│   ├── index.html      # la presentación
│   ├── deck.css        # framework de slides (slidedeck)
│   ├── deck.js
│   ├── guion.md        # guion / outline de la clase
│   └── assets/         # imágenes de la clase
├── clase-02/           # todo lo de la Clase 2 (misma estructura)
├── clase-03/           # todo lo de la Clase 3 (misma estructura)
├── clase-04/           # todo lo de la Clase 4 (misma estructura)
├── clase-05/ … clase-08/   # Clases 5 a 8 (misma estructura)
└── trabajos-practicos/ # TPs guiados, en Markdown y PDF
```

## ▶️ Cómo usar las presentaciones

- **Navegar:** flechas `←` `→` o barra espaciadora
- **Tema claro/oscuro:** botón arriba a la derecha (se recuerda)
- **Miniaturas:** pasar el mouse por el borde izquierdo
- **Exportar a PDF:** `Cmd` / `Ctrl` + `P`
- **Volver al índice:** link "← Índice" arriba a la izquierda

## 🛠️ Ver localmente

Abrí `index.html` en el navegador, o levantá un server:

```bash
python3 -m http.server 4599
# luego abrí http://localhost:4599
```

## 📎 Créditos

Presentaciones hechas con [slidedeck](https://github.com/Spktro/slidedeck).
Logo, mascota (Godette) e ilustraciones de Godot © Godot Foundation, licencia **CC BY 4.0**.
Logos de Unity, Unreal Engine y GameMaker son marcas de sus respectivos dueños (uso educativo).
