# Diplomatura de Desarrollo de Videojuegos · Godot

Material de las clases de la diplomatura, en forma de presentaciones HTML navegables.

## 🌐 Ver online

Si están publicadas con GitHub Pages: **https://spktro.github.io/curso-vj/**

## 📚 Clases

| # | Clase | Contenido |
|---|-------|-----------|
| 01 | [Primeros pasos con Godot](clase-1/index.html) | Motores, instalación, interfaz, nodos, escenas y jerarquía |

## 🗂️ Estructura

El home vive en la raíz; cada clase es una carpeta **autocontenida** (trae su propio deck y assets).

```
.
├── index.html          # home: índice de clases
├── assets/             # imágenes del home
└── clase-1/            # todo lo de la Clase 1, junto
    ├── index.html      # la presentación
    ├── deck.css        # framework de slides (slidedeck)
    ├── deck.js
    ├── guion.md        # guion / outline de la clase
    └── assets/         # imágenes de la clase
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
