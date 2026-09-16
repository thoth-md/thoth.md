# CLAUDE.md

Guidance for Claude Code (and humans) working on this repository.

## What this repo is

A single static landing page for **Thoth**, a markdown-extended-for-scale project. The whole site is two files at the repo root:

- [index.html](index.html) — full page markup, inline SVG sprites for the lockup and theme icons, and a ~15-line inline `<script>` for the theme toggle.
- [styles.css](styles.css) — design tokens for both themes, every section's styles, and responsive breakpoints.

There is no build step, no framework, and no JS runtime dependency. The fonts (Inter, Inter Tight, Instrument Serif, JetBrains Mono) are self-hosted: the WOFF2 files live in [fonts/](fonts/) and the `@font-face` declarations are in [fonts.css](fonts.css). Latin subset only — no calls to `fonts.googleapis.com` or `fonts.gstatic.com` at runtime, which keeps visitor IPs out of Google's hands.

### Adding a weight or refreshing the font files

If you add a new weight, italic style, or font family — or simply want to re-pull the latest WOFF2s from Google — run this from the repo root. It updates [fonts.css](fonts.css) and the files in [fonts/](fonts/) in place:

```sh
mkdir -p fonts && python3 - <<'PY'
import re, os, urllib.request
URL = ('https://fonts.googleapis.com/css2'
       '?family=Inter:wght@400;500;600;700'
       '&family=Inter+Tight:wght@400;500;600'
       '&family=Instrument+Serif:ital@0;1'
       '&family=JetBrains+Mono:wght@400;500;600'
       '&display=swap')
UA  = ('Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
       '(KHTML, like Gecko) Chrome/120.0 Safari/537.36')
KEEP = {'latin'}
css = urllib.request.urlopen(urllib.request.Request(URL, headers={'User-Agent': UA})).read().decode()
parts = re.split(r'/\*\s*([\w-]+)\s*\*/', css)
out = ['/* Self-hosted from Google Fonts (latin subset). */\n']
i = 1
while i < len(parts):
    subset, block = parts[i].strip(), parts[i+1]
    if subset in KEEP:
        fam = re.search(r"font-family:\s*'([^']+)'", block).group(1)
        wt  = re.search(r'font-weight:\s*(\d+)', block).group(1)
        sty = re.search(r'font-style:\s*(\w+)', block).group(1)
        url = re.search(r'url\((https://[^)]+)\)', block).group(1)
        name = f'{fam.lower().replace(" ","-")}-{wt}-{sty}.woff2'
        with open(f'fonts/{name}', 'wb') as f:
            f.write(urllib.request.urlopen(urllib.request.Request(url, headers={'User-Agent': UA})).read())
        out.append(f'/* {fam} · {wt} · {sty} */\n@font-face' + block.replace(url, f'fonts/{name}'))
    i += 2
open('fonts.css', 'w').write('\n'.join(out))
PY
```

To add a new weight, edit the `family=` parameters in `URL` before running. To include accented Latin chars (`ä`, `ç`, `ß`, etc.), add `'latin-ext'` to the `KEEP` set — it ~doubles the font payload but covers every European Latin script.

## Where the design came from

The visuals were produced in [Claude Design](https://claude.ai/design) and exported as a handoff bundle. That bundle lives unchanged in [design/](design/):

- [design/README.md](design/README.md) — the original handoff README from Claude Design (instructs coding agents to read the chat first, then the primary HTML file).
- [design/chats/chat1.md](design/chats/chat1.md) — the full transcript between the user and the Claude Design assistant. **Read this before making non-trivial visual changes** — it's where the typographic system, color treatment, and composition stance were decided, and it captures every iteration of feedback (e.g. why sub-section numbers are `04.1` rather than `04 / 01` or `04·a`).
- [design/project/Thoth Landing Page.html](design/project/Thoth%20Landing%20Page.html) — the original prototype's entry HTML (loads React + Babel from CDN at runtime, then renders the JSX components).
- [design/project/styles.css](design/project/styles.css) — the prototype's stylesheet. Most of [styles.css](styles.css) at the repo root is derived from this; reach for it when you need an exact value or a section that wasn't yet ported.
- [design/project/page-sections.jsx](design/project/page-sections.jsx) — copy and structure for every section (Nav, Hero, Philosophy, Duality, ThreeFixes, SyntaxGallery, Stance, Audience, EndCard). **This is the canonical source for the page's copy.**
- [design/project/code-blocks.jsx](design/project/code-blocks.jsx) — every code sample shown on the page, hand-tokenized (`tok-hd`, `tok-str`, `tok-ref`, etc.). When the production HTML's `<pre class="code">` blocks need to change, mirror the structure here.
- [design/project/brand-marks.jsx](design/project/brand-marks.jsx) — the Thoth mark and lockup as SVG primitives, plus `svgString_*` helpers for downloadable variants (rounded square, circle, padded canvas). The mark inlined in [index.html](index.html) was lifted directly from `ThothBars` and `ThothLockup` here.
- [design/project/ref-strip.jsx](design/project/ref-strip.jsx) — a designer-facing type/color reference; **not** part of the production page.

The original source URL the bundle came from is in the chat: a Claude Design project at `claude.ai/design/p/019dd037-94ab-7880-a322-5f55d26b9fdd`. That URL is owned by the user's Claude account.

## How the production page differs from the prototype

The prototype was a design canvas, not production code. When you compare [design/project/Thoth Landing Page.html](design/project/Thoth%20Landing%20Page.html) to [index.html](index.html), you'll see four deliberate departures:

1. **No React, no Babel.** The prototype loaded `react`, `react-dom`, and `@babel/standalone` from a CDN and compiled the four JSX files in-browser. Production is static HTML with the JSX content inlined as markup. Theme toggle is vanilla JS.
2. **No canvas chrome.** The prototype rendered two artboards (1440 desktop and 390 mobile) side-by-side, plus a fixed canvas toolbar and a designer-facing reference strip. None of those exist in production — `index.html` is just the page.
3. **Responsive instead of duplicated.** The prototype rendered desktop and mobile as separate component trees and hid Philosophy / Duality / Stance / Audience on mobile (the mobile artboard label said "hero / 3-fixes / gallery" — a partial showcase). Production keeps every section and uses media queries at 1080 / 900 / 560 px so the full page flows on any width.
4. **Theme persistence.** The prototype's toggle reset on every reload. Production stores the choice in `localStorage` under `thoth-theme` and applies it via an inline boot script in `<head>` to avoid a flash.

## Design system in one paragraph

Type: Inter Tight (display, -0.025em tracking), Inter (body), Instrument Serif italic (philosophy + end-card heading only), JetBrains Mono (code, eyebrows, metadata). Color is theme-tokenized via `data-theme="light|dark"` on `<html>`: dark uses Kohl `#0D1117` ground / Carnelian `#FF6A00` accent / Slate `#151B23` surface; light uses Linen `#F7F7F5` ground / muted Carnelian `#D8551A` accent / white surface, with code blocks staying dark in both modes (a "load-bearing" visual). Section numerals (`02 ·`, `03 ·`) and sub-numerals (`04.1`, `05.2`, `06.3`) are mono and accent-colored. The end-card stays Kohl-dark even when the rest of the page is light — the deliberate landing moment, with hardcoded colors in `.endcard*` rules and explicit `.endcard .lm-mark` / `.endcard .lm-word` overrides on the lockup. The full token set is at the top of [styles.css](styles.css); changing a token cascades through the whole page (the end-card excepted).

## Common edits

### Changing copy

All page copy is in [index.html](index.html). The original copy also lives in [design/project/page-sections.jsx](design/project/page-sections.jsx) — keep them roughly in sync if you want the design bundle to remain a faithful reference, but the production HTML wins.

### Adjusting colors / typography

Edit the token blocks at the top of [styles.css](styles.css) (`:root, [data-theme="dark"]` and `[data-theme="light"]`). Don't hardcode colors in component selectors — every visible color should resolve to a token. The end-card is the one exception: it's hardcoded to dark colors in both themes, by design.

### Adding a new section

1. Add the markup to [index.html](index.html) following the existing `<section class="section"><div class="container">…</div></section>` pattern.
2. Use a `<span class="section-num">` eyebrow with the next two-digit number and a `<h2 class="section-title">` (or `.serif` variant for an editorial moment).
3. If the section needs new visual primitives, add a styled block to [styles.css](styles.css) under the existing `/* ===== … ===== */` divider style, and check it at all three breakpoints.
4. Update the nav link list in [index.html](index.html) if the section deserves a top-level link.

### Swapping the brand mark

The lockup is an inline `<symbol id="thoth-lockup">` in [index.html](index.html). The original SVG primitives are in [design/project/brand-marks.jsx](design/project/brand-marks.jsx) — `ThothBars` (the mark itself) and the inline `<path>`s for the wordmark glyphs. CSS classes `.lm-mark` and `.lm-word` control fill colors so the lockup re-skins automatically when the theme changes.

### Editing code samples

Each `<pre class="code">` block in [index.html](index.html) is hand-tokenized with `<span class="tok-…">` tags. The full token palette is `tok-hd, tok-str, tok-com, tok-num, tok-fn, tok-tag, tok-ref, tok-id, tok-pipe, tok-dim`. Reference [design/project/code-blocks.jsx](design/project/code-blocks.jsx) for the canonical structure of each sample.

### Changing the default theme

The default is dark, set in two places that must agree:

- The `data-theme="dark"` attribute on `<html>` in [index.html](index.html).
- The fallback in the inline boot script (`if (saved === 'light' || saved === 'dark') …`) — change it to flip the implicit default.

The chat transcript records the user's explicit ask for "default to dark" — don't quietly change this without checking back.

## Verification

There's no automated test suite. Before declaring a change done, manually verify:

- Both themes render correctly (toggle persists across reload).
- Layout doesn't break at 1080 / 900 / 560 px breakpoints.
- Code samples wrap rather than horizontally scroll on narrow widths.
- The hero demo's source / rendered split fits inside its panes (the table cells especially — the prototype iteration log shows two rounds of overflow fixes here).
- The "in active development" pulse animates and respects `prefers-reduced-motion`.

## When in doubt

Read [design/chats/chat1.md](design/chats/chat1.md). The user iterated on this with the design assistant through several rounds — section-number formatting, table padding, mobile code-wrap behavior, end-card overflow — and the rationale for each decision is in there.
