"""Genera los sonidos del TP5 (semana 5): efectos cortos y un loop de musica.

Todo es sintesis propia (ondas cuadradas, triangulares y ruido), sin samples
de terceros: se pueden usar y redistribuir libremente dentro del curso.

Uso:  python v2/herramientas/generar-sonidos.py
Salida: v2/semana-05/assets/*.wav  (mono, 16 bits, 22050 Hz)
"""
import os
import wave

import numpy as np

SR = 22050
OUT = os.path.join(os.path.dirname(__file__), "..", "semana-05", "assets")
rng = np.random.default_rng(7)


def t(dur):
    return np.arange(int(SR * dur)) / SR


def square(freq, dur, duty=0.5):
    fase = np.cumsum(np.broadcast_to(freq, t(dur).shape) / SR)
    return np.where((fase % 1.0) < duty, 1.0, -1.0)


def triangle(freq, dur):
    fase = np.cumsum(np.broadcast_to(freq, t(dur).shape) / SR)
    return 4 * np.abs((fase % 1.0) - 0.5) - 1


def noise(dur):
    return rng.uniform(-1, 1, len(t(dur)))


def env(n, ataque=0.005, caida=None):
    """Envolvente: sube rapido y cae exponencial hasta 0 al final."""
    e = np.ones(n)
    a = max(1, int(SR * ataque))
    e[:a] = np.linspace(0, 1, a)
    k = np.linspace(0, 1, n - a)
    e[a:] = np.exp(-5 * k) * (1 - k) if caida is None else (1 - k) ** caida
    return e


def guardar(nombre, x, vol=0.8):
    x = x / (np.max(np.abs(x)) or 1) * vol
    datos = (x * 32767).astype("<i2").tobytes()
    with wave.open(os.path.join(OUT, nombre), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(datos)
    print(f"{nombre}: {len(x) / SR:.2f} s")


def nota(n):
    """Numero MIDI a frecuencia."""
    return 440.0 * 2 ** ((n - 69) / 12)


os.makedirs(OUT, exist_ok=True)

# disparo: "pip" corto que baja de tono
d = 0.08
f = np.linspace(1400, 700, len(t(d)))
guardar("disparo.wav", square(f, d, 0.25) * env(len(f)), 0.5)

# golpe (el jugador recibe dano): ruido grave + caida de tono
d = 0.25
f = np.linspace(220, 60, len(t(d)))
x = 0.6 * square(f, d) + 0.5 * noise(d)
guardar("golpe.wav", x * env(len(x), 0.002), 0.85)

# plop (muere un slime): burbuja que baja
d = 0.16
f = np.geomspace(520, 110, len(t(d)))
guardar("plop.wav", triangle(f, d) * env(len(f), 0.003, 1.5), 0.7)

# clic de boton
d = 0.04
guardar("clic.wav", square(1800, d, 0.5) * env(len(t(d)), 0.001), 0.35)

# game over: tres notas que bajan y una larga
partes = []
for n, dur in [(69, 0.22), (65, 0.22), (62, 0.22), (57, 0.9)]:
    x = 0.6 * square(nota(n), dur, 0.5) + 0.4 * triangle(nota(n) / 2, dur)
    partes.append(x * env(len(x), 0.01, 1.2))
guardar("game_over.wav", np.concatenate(partes), 0.6)

# musica: 8 compases a 120 bpm (16 s), La menor: Am F C G, en loop exacto
negra = 0.5
corcheas = int(SR * negra / 2)
acordes = [(57, 60, 64), (53, 57, 60), (48, 52, 55), (55, 59, 62)]
total = []
for compas in range(8):
    raiz, tercera, quinta = acordes[compas % 4]
    arpegio = [raiz + 12, tercera + 12, quinta + 12, tercera + 12] * 2
    for i, n in enumerate(arpegio):
        dur = corcheas / SR
        x = 0.28 * square(nota(n), dur, 0.25) * env(corcheas, 0.004, 2)
        # bajo: una negra cada dos corcheas
        if i % 2 == 0:
            x += 0.5 * triangle(nota(raiz - 12), dur) * env(corcheas, 0.004, 0.6)
        # hi-hat en contratiempo
        if i % 2 == 1:
            hh = noise(0.03) * env(int(SR * 0.03), 0.001)
            x[: len(hh)] += 0.12 * hh
        total.append(x)
guardar("musica.wav", np.concatenate(total), 0.55)
