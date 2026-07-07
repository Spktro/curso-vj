/* slidedeck — framework de presentaciones HTML
   https://github.com/Spktro/slidedeck

   Uso mínimo:
     <link rel="stylesheet" href="deck.css">
     <div class="deck" id="deck" data-brand="Mi charla" data-home="../index.html">
       <section class="slide" data-chapter="Intro" data-topic="Bienvenida"> ... </section>
       ...
     </div>
     <script src="deck.js"></script>

   Config en el contenedor .deck:
     data-brand : texto del pie de marca (lo anterior al primer " · " va en negrita)
     data-home  : href del botón "← Índice" (si se omite, no se muestra)
   Por slide (opcional, para el navegador):
     data-chapter : agrupador  ·  data-topic : tema
*/
(function () {
  "use strict";

  /* ------------------------------------------------------------------ */
  /* Utilidades                                                          */
  /* ------------------------------------------------------------------ */

  function ready(fn) {
    if (document.readyState !== "loading") fn();
    else document.addEventListener("DOMContentLoaded", fn);
  }

  function el(tag, cls, parent) {
    const node = document.createElement(tag);
    if (cls) node.className = cls;
    if (parent) parent.appendChild(node);
    return node;
  }

  /* ------------------------------------------------------------------ */
  /* Construcción del chrome (cada función devuelve lo que se necesita)  */
  /* ------------------------------------------------------------------ */

  function buildProgress() {
    return el("div", "progress", document.body);
  }

  function buildHomeLink(href) {
    if (!href) return;
    const a = el("a", "home-link", document.body);
    a.href = href;
    a.textContent = "← Índice";
  }

  // Barra superior: toggle de tema + selector de tamaño.
  // Devuelve { sizer, themeBtn } para que las features los cableen.
  function buildTopBar() {
    const sizer = el("div", "sizer");
    const themeBtn = el("button", "theme-toggle", sizer);
    themeBtn.type = "button";
    themeBtn.title = "Modo claro / oscuro";
    themeBtn.setAttribute("aria-label", "Cambiar tema");

    el("span", "sizer-div", sizer);
    el("span", "lbl", sizer).textContent = "Tamaño";

    const SIZES = [["fit", "Ajustar"], ["m", "Cómodo"], ["l", "Grande"], ["xl", "Enorme"]];
    SIZES.forEach(([id, label]) => {
      const b = el("button", null, sizer);
      b.dataset.size = id;
      b.textContent = label;
    });

    document.body.appendChild(sizer);
    return { sizer, themeBtn };
  }

  function buildBrand(text, repo) {
    if (!text && !repo) return;
    const brand = el("div", "brand", document.body);
    if (text) {
      const idx = text.indexOf(" · ");
      if (idx > -1) {
        el("b", null, brand).textContent = text.slice(0, idx);
        brand.appendChild(document.createTextNode(text.slice(idx)));
      } else {
        brand.textContent = text;
      }
    }
    if (repo) {
      const a = el("a", "repo-link", brand);
      a.href = repo;
      a.target = "_blank";
      a.rel = "noopener";
      a.title = "Ver el repositorio en GitHub";
      a.setAttribute("aria-label", "Repositorio en GitHub");
      a.innerHTML = '<svg viewBox="0 0 16 16" aria-hidden="true"><path fill="currentColor" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"/></svg>';
    }
  }

  // Devuelve el <span> del número actual, que actualiza la navegación.
  function buildPager(count) {
    const pager = el("div", "pager", document.body);
    const cur = el("span", null, pager);
    cur.textContent = "1";
    pager.appendChild(document.createTextNode(" / "));
    el("span", null, pager).textContent = count;
    return cur;
  }

  /* ------------------------------------------------------------------ */
  /* Features                                                            */
  /* ------------------------------------------------------------------ */

  // Botón "Copiar" en cada bloque de código.
  function setupCopyButtons(root) {
    root.querySelectorAll("pre.code").forEach((pre) => {
      const wrap = el("div", "code-wrap");
      pre.parentNode.insertBefore(wrap, pre);
      wrap.appendChild(pre);

      const btn = el("button", "copy-btn", wrap);
      btn.type = "button";
      btn.textContent = "Copiar";

      const flash = (txt, ok) => {
        btn.textContent = txt;
        btn.classList.toggle("copied", !!ok);
        setTimeout(() => { btn.textContent = "Copiar"; btn.classList.remove("copied"); }, 1500);
      };

      btn.addEventListener("click", async (e) => {
        e.stopPropagation();
        try {
          await navigator.clipboard.writeText(pre.innerText);
          flash("¡Copiado!", true);
        } catch (err) {
          try {
            const r = document.createRange();
            r.selectNodeContents(pre);
            const sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(r);
            document.execCommand("copy");
            sel.removeAllRanges();
            flash("¡Copiado!", true);
          } catch (_) { flash("Error", false); }
        }
      });
    });
  }

  // Tema claro / oscuro, recordado en localStorage y sincronizado entre pestañas.
  function setupTheme(themeBtn) {
    let theme = localStorage.getItem("deckTheme") || "light";
    const apply = () => {
      document.documentElement.setAttribute("data-theme", theme);
      themeBtn.textContent = theme === "dark" ? "☀️" : "🌙";
    };
    themeBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      theme = theme === "dark" ? "light" : "dark";
      localStorage.setItem("deckTheme", theme);
      apply();
    });
    window.addEventListener("storage", (e) => {
      if (e.key === "deckTheme" && e.newValue) { theme = e.newValue; apply(); }
    });
    apply();
  }

  // Selector de tamaño: escala el lienzo 1280x720 vía la variable CSS --fit.
  function setupSizing(sizer) {
    let sizeId = localStorage.getItem("deckSize") || "m";
    const compute = () => {
      const fw = window.innerWidth / 1280;
      const fh = window.innerHeight / 720;
      let z;
      if (sizeId === "fit") z = Math.min(fw, fh);
      else if (sizeId === "l") z = fw * 1.2;
      else if (sizeId === "xl") z = fw * 1.4;
      else z = fw;
      document.documentElement.style.setProperty("--fit", z.toFixed(3));
    };
    const syncButtons = () => {
      sizer.querySelectorAll("button[data-size]").forEach((b) => b.classList.toggle("on", b.dataset.size === sizeId));
    };
    sizer.querySelectorAll("button[data-size]").forEach((b) => {
      b.addEventListener("click", (e) => {
        e.stopPropagation();
        sizeId = b.dataset.size;
        localStorage.setItem("deckSize", sizeId);
        compute();
        syncButtons();
      });
    });
    window.addEventListener("resize", compute);
    compute();
    syncButtons();
  }

  // Navegador lateral de miniaturas (clones escalados con capítulo · tema).
  // onSelect(n) se llama al clickear una miniatura. Devuelve el array de thumbs.
  function buildFilmstrip(slides, onSelect) {
    const film = el("div", "filmstrip");
    const hot = el("div", "filmstrip-hot");
    const thumbs = [];

    slides.forEach((s, n) => {
      const thumb = el("button", "thumb", film);
      thumb.type = "button";

      const frame = el("div", "thumb-frame", thumb);
      const canvas = el("div", "thumb-canvas", frame);
      const clone = s.cloneNode(true);
      clone.classList.remove("active");
      clone.classList.add("thumb-slide");
      clone.removeAttribute("id");
      clone.querySelectorAll(".copy-btn").forEach((b) => b.remove());
      canvas.appendChild(clone);
      el("span", "thumb-num", frame).textContent = n + 1;

      const chapter = s.dataset.chapter || (s.querySelector(".slide-eyebrow") || {}).textContent || "";
      const topic = s.dataset.topic || (s.querySelector(".slide-title, .title") || {}).textContent || "";
      const label = el("div", "thumb-label", thumb);
      if (chapter) el("span", "thumb-chapter", label).textContent = chapter;
      if (topic) el("span", "thumb-topic", label).textContent = topic;

      thumb.addEventListener("click", (e) => { e.stopPropagation(); onSelect(n); });
      thumbs.push(thumb);
    });

    document.body.appendChild(film);
    document.body.appendChild(hot);
    hot.addEventListener("mouseenter", () => film.classList.add("open"));
    film.addEventListener("mouseleave", () => film.classList.remove("open"));
    return thumbs;
  }

  // Crea la función show() que cambia de slide y actualiza progreso/pager/thumbs.
  // `state` lleva el índice actual y (cuando exista) el array de thumbs.
  function makeShow(slides, state, refs) {
    return function show(idx) {
      const i = Math.max(0, Math.min(slides.length - 1, idx));
      state.i = i;
      slides.forEach((s, n) => s.classList.toggle("active", n === i));
      refs.cur.textContent = i + 1;
      refs.progress.style.width = ((i + 1) / slides.length * 100) + "%";
      if (location.hash !== "#" + (i + 1)) history.replaceState(null, "", "#" + (i + 1));
      state.thumbs.forEach((t, n) => t.classList.toggle("current", n === i));
      if (state.thumbs[i]) state.thumbs[i].scrollIntoView({ block: "nearest" });
    };
  }

  // Teclado, clic por mitades, hashchange y posición inicial.
  function setupInput(show, slides, state) {
    document.addEventListener("keydown", (e) => {
      if (e.key === "ArrowRight" || e.key === "PageDown" || e.key === " ") { show(state.i + 1); e.preventDefault(); }
      else if (e.key === "ArrowLeft" || e.key === "PageUp") { show(state.i - 1); e.preventDefault(); }
      else if (e.key === "Home") { show(0); }
      else if (e.key === "End") { show(slides.length - 1); }
    });

    document.addEventListener("click", (e) => {
      if (e.target.closest("a, pre, code, input, button, .filmstrip")) return;
      const x = e.clientX / window.innerWidth;
      if (x > 0.5) show(state.i + 1); else show(state.i - 1);
    });

    window.addEventListener("hashchange", () => {
      const n = parseInt((location.hash || "#1").slice(1), 10);
      if (!isNaN(n)) show(n - 1);
    });

    const initial = parseInt((location.hash || "#1").slice(1), 10);
    show(isNaN(initial) ? 0 : initial - 1);
  }

  /* ------------------------------------------------------------------ */
  /* Orquestación                                                        */
  /* ------------------------------------------------------------------ */

  function init() {
    const deck = document.getElementById("deck") || document.querySelector(".deck");
    if (!deck) return;
    const slides = Array.from(deck.querySelectorAll(".slide"));
    if (!slides.length) return;

    // Chrome
    const progress = buildProgress();
    buildHomeLink(deck.dataset.home);
    const { sizer, themeBtn } = buildTopBar();
    buildBrand(deck.dataset.brand, deck.dataset.repo);
    const cur = buildPager(slides.length);

    // Features independientes
    setupCopyButtons(deck);
    setupTheme(themeBtn);
    setupSizing(sizer);

    // Navegación + filmstrip (resuelven su dependencia mutua vía `state`)
    const state = { i: 0, thumbs: [] };
    const show = makeShow(slides, state, { progress, cur });
    state.thumbs = buildFilmstrip(slides, show);
    setupInput(show, slides, state);
  }

  ready(init);
})();
