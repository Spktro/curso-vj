# Prompt para retomar la v2 en una sesión nueva

Copiá y pegá esto al abrir una sesión de Claude Code en `C:\RepoGit\curso-vj`, cambiando la semana:

---

Estoy armando la segunda versión de mi diplomatura de desarrollo de videojuegos con Godot 4.3+ (repo `Spktro/curso-vj`, GitHub Pages en https://spktro.github.io/curso-vj/). Soy Javier, docente; el material es en español rioplatense, para alumnos sin experiencia previa.

**Hoy toca: SEMANA N.** (4: IA y el jefe con máquina de estados · 5: look and feel + UI + terminar el juego · 6: cierre)

Antes de hacer nada, leé solo esto:

1. `v2/mapa-de-contenidos.md`: distribución de las 6 semanas, cambios pendientes por clase y decisiones abiertas.
2. Como modelo de formato, la semana 3 ya hecha: `v2/semana-03/practica/index.html` (deck teórico-práctico con diapos EN VIVO) y `v2/semana-03/tp.md` (TP). Para el deck teórico, `v2/semana-03/teorica/index.html`.
3. El material v1 de la semana que toca (decks `clase-0N/`, TPs en `trabajos-practicos/`), solo las partes necesarias.

Reglas de trabajo:

* La v1 (raíz del repo, tag `v1-2026`) no se toca. Todo va en `v2/semana-0N/` con `teorica/`, `practica/`, `tp.md` + `tp.pdf` y `assets/`. Los decks se copian del v1 (o del deck v2 anterior, para reusar los estilos de las diapos en vivo) y se editan ahí.
* **Deck teórico-práctico:** cada bloque cierra con una diapo EN VIVO: código a la izquierda; a la derecha, los pasos en el orden en que se escriben, un punto de control (salida exacta de consola o lo que se ve) y un "Probá" para romperlo. Al final: "cuando no anda" (tabla de síntomas), desafío en clase, resumen, diapo del TP.
* **Redacción impersonal en todo** (decks y TPs), sin "vos", "tú" ni tono chabacano: instrucciones en infinitivo ("Apretar F6", "Renombrarlo Piso") y explicaciones con "se" o tercera persona ("lo controla el programador", "el código se escribe, no se pega"). En los TPs, "🎯 Al finalizar este TP" y `<summary>Ver soluciones</summary>`.
* **Imágenes:** no buscar ni descargar nada de internet (ni scrapear videos o tiendas). Reusar lo que haya en el repo; si falta, dejar `🖼️ IMAGEN PENDIENTE` con la descripción y listarlo en el resumen. Yo las consigo.
* **Ahorrar tokens:** verificar overflow con un chequeo por JavaScript (alto de cada diapo ≤ 584 px a 1280×720, servidor `python -m http.server 4599` o el `curso-vj` de `.claude/launch.json`), no con capturas de pantalla, salvo que haya un diagrama nuevo que ver.
* TPs: formato de los v1 (árbol final, partes numeradas, ✅ puntos de control, 🧠 por qué, 🛟 `<details>` de errores, checklist, extras, recursos). Código con tabs y sin tipado estático. PDF con `node v2/herramientas/build-pdf.js v2/semana-0N/tp.md`.
* Continuidad del código: el survivors nace en la semana 3 (`arena.tscn`, `jugador.gd`, `enemigo.gd` con `class_name Enemigo extends Area2D`, `slime.tscn`, `slime_elite.tscn` heredada, `spawner.gd`, `bala.gd`). Las semanas 4 y 5 construyen sobre eso con los mismos nombres. En la semana 4, `slime_elite.gd` pasó a ser el jefe con máquina de estados (`enum Estado`, `cambiar_estado()`) y `slime_elite.tscn` sumó `LabelEstado`, `TimerAtaque` y `TimerGolpe`. En la semana 5 se sumaron el Autoload `Partida` (`kills`, `tiempo`, `mejor_tiempo`), `hud.gd`, `arena.gd`, `menu.tscn`, `game_over.tscn`, la `Camara` fija y el `aporte.md` de cada alumno.
* Al terminar cada pieza: enlazarla en `v2/index.html`, marcar el mapa, commit en `main` con mensaje en español sin tildes, push, y pasarme los links. Si una decisión es mía, preguntá una vez y seguí con lo demás.

---

## Estado al 22/9/2026

| Semana | Teórica | Teórico-práctica | TP |
| :--- | :--- | :--- | :--- |
| 1 | ✅ C1 | ✅ C2 | ✅ TP1 (escena + juego de texto) |
| 2 | ✅ C3 (con vectores) | ✅ C4 (físicas y señales) | ✅ TP2 (arena + plataformero) |
| 3 | ✅ C5 (POO pura) | ✅ C5+ (la horda en vivo) | ✅ TP3 (base del survivors) |
| 4 | ✅ C8 (IA y máquinas de estado) | ✅ C8+ (el jefe en vivo) | ✅ TP4 (el jefe piensa) |
| 5 | ✅ C7 (look and feel) | ✅ C6 (UI en vivo) | ✅ TP5 (terminá tu juego) |
| 6 | Presentación de los TPs | — | — |

Imágenes pendientes: C4 diapo 6 (Angry Birds, pájaro impactando la estructura) y C5 diapo 7 (captura de un survivors con mucha acción).
