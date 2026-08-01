# 🏚️ La Mansión Embrujada — ejemplo en vivo

> **Diplomatura de Videojuegos · apoyo de la Clase 2**
> Una **aventura de texto de terror** que corre en la consola de Godot y se juega con las flechas. Sirve para explicar, con una historia, **`if`, funciones e ítems** — sin gráficos, todo en el panel **Output**.

Es el mismo esqueleto del TP2 (*La Cripta del Golem*), pero en vez de un combate por turnos es una **aventura de exploración**: avanzás por una mansión, juntás objetos y el final cambia según lo que tengas.

---

## ▶️ Cómo correrlo (2 minutos)

1. Godot → **New Project** → carpeta vacía → **Create & Edit**.
2. Panel **Escena** → **Otro Nodo** → buscá **`Node`** → **Crear**. Renombralo `Juego`.
3. Clic derecho sobre `Juego` → **Attach Script** → **Create** (path `res://mansion.gd`).
4. Borrá la plantilla y pegá el contenido de **`mansion.gd`**.
5. **Ctrl + S** y **F6**. Cuando abra la ventana del juego, **hacé clic sobre ella** para que reciba las teclas.
6. Jugá mirando el panel **Output**:
   - **→** avanzar · **←** retroceder · **↑** agarrar ítem · **ENTER** volver a mirar la sala.

**El recorrido "ganador":** Recibidor → agarrá 🔦 linterna → Pasillo oscuro → agarrá 🔮 amuleto → Biblioteca → agarrá 🗝️ llave → Puerta del Sótano → Sótano → **ganás** (por el amuleto). Si te olvidás el amuleto… **Game Over**.

---

## 🗺️ El mapa (para dibujar en el pizarrón)

```
[0 Portón] → [1 Recibidor] → [2 Pasillo] → [3 Biblioteca] → [4 Puerta] → [5 Sótano]
                  🔦             🔮             🗝️            🔒 llave      👻 amuleto?
              linterna         amuleto        llave       (para pasar)   (para ganar)
                              (necesita
                               linterna
                               para entrar)
```

Dos **puertas con condición** (necesitás un ítem para pasar) y **un final que se ramifica**. Eso es todo `if`.

---

## 🎯 Dónde está cada concepto (para señalar en el código)

| Concepto | Dónde mirarlo en `mansion.gd` | Frase para decir en clase |
|---|---|---|
| **Variables (estado)** | `var habitacion`, `var vida`, `var terminado` | "Estas cajas guardan *dónde estamos* y *cómo venimos*." |
| **Arreglo** | `var inventario = []` y `var habitaciones = [...]` | "Una lista: el inventario arranca vacío y le vamos agregando." |
| **`if` como decisión** | `func describir()` (un `elif` por sala) | "Según en qué sala estás, imprime un texto distinto." |
| **`if` como candado** | `func avanzar()` (los dos `if` de arriba) | "No te deja pasar *si* no tenés el ítem. Esa es la regla del juego." |
| **`if / else` (final)** | `func enfrentar_final()` | "El mismo sótano, dos finales, según lo que juntaste." |
| **Función con `return`** | `func tengo(item)` | "Pregunta '¿lo tengo?' y devuelve verdadero o falso." |
| **`for` sobre un arreglo** | `tengo()` y `mostrar_inventario()` | "Recorre el inventario ítem por ítem." |
| **Input** | `func _process(delta)` | "Cada flecha llama a una función distinta." |
| **Funciones que se llaman entre sí** | `avanzar()` llama a `enfrentar_final()`; casi todas llaman a `describir()` | "Las funciones se usan como piezas de Lego." |

---

## 🎬 Guion sugerido (cómo contarlo)

1. **Primero jugalo, no expliques.** Corré el juego, recorré la mansión en vivo y perdé a propósito (entrá al sótano sin amuleto). *"¿Por qué perdí?"* → que especulen.
2. **Mostrá el `if` candado.** Volvé a `avanzar()`: *"Miren, acá dice: **si** estás en el recibidor **y no** tenés la linterna, no te dejo pasar."* Ese `if` **es** la regla del juego.
3. **Mostrá una función.** Señalá `agarrar()`: *"Cada vez que aprieto ↑, se ejecuta esta función. Escrita una vez, usada siempre."*
4. **Mostrá `tengo()`.** *"Esta función hace una pregunta y **devuelve** una respuesta (sí/no), que después uso en los `if`."* Buen momento para `return` + `for`.
5. **Cerrá con el ítem.** *"Un ítem es solo un texto dentro de una lista. La magia la hacen los `if` que preguntan si lo tenés."*

---

## 🛠️ Modificaciones en vivo (que se vea que es editable)

- **Cambiá un texto** de una sala en `describir()` → apretá F6 → apareció. (Ver que el código manda.)
- **Sacá el candado** de la linterna (borrá el primer `if` de `avanzar()`) → ahora entrás a oscuras. *"¿Ven cómo el `if` era lo único que te frenaba?"*
- **Sumá un ítem nuevo** (ej: una 🕯️ vela en la Biblioteca): agregala en `agarrar()` con otro `elif`.
- **Agregá daño:** en el pasillo restá `vida = vida - 20` y con un `if vida <= 0` mandá Game Over. Conecta con el sistema de vida de la clase.

---

## 🧪 Desafíos para los estudiantes

- **Fácil:** cambiar los textos y los emojis para que sea *tu* mansión.
- **Medio:** agregar una habitación nueva (sumá un texto a `habitaciones` y un `elif` en `describir()`).
- **Medio:** que el amuleto sea **obligatorio** para bajar (otro `if` candado antes del sótano).
- **Difícil:** que una sala tenga **dos salidas** (ej: ↑ para subir a un desván) usando otra variable de posición.

> 💡 **Idea clave para dejar picando:** *La historia cambia, la lógica no.* Este mismo esqueleto (variables + arreglo + `if` + funciones + input) es el de un combate, el de un menú o el de un RPG. Lo que cambia es el cuento que le ponés encima.
