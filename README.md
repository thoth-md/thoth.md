# thoth.md

Landing page for **Thoth** — markdown, extended for scale.

A single static HTML page with one stylesheet and a small inline theme-toggle script. No build step, no dependencies, no framework.

## Files

- [index.html](index.html) — the page (nav, hero with source/rendered split, philosophy, is/isn't, three fixes, syntax gallery, stance, audience, end-card).
- [styles.css](styles.css) — design tokens + every section's styles + responsive breakpoints at 1080 / 900 / 560 px.
- [design/](design/) — original Claude Design handoff bundle (kept in-tree as the source of truth for visuals, copy, and code samples).
- [CLAUDE.md](CLAUDE.md) — how this site was built, where the design came from, and how to update it.

## Running locally

The site is plain static files (HTML + CSS + self-hosted WOFF2 fonts in [fonts/](fonts/) — no third-party requests at runtime). Any HTTP server works; opening `index.html` directly via `file://` also renders.

```sh
python3 -m http.server 8000
# then open http://localhost:8000/
```

Or with Node:

```sh
npx --yes serve .
```

## Testing

There is no test suite. Verify changes by eye:

1. **Both themes.** Toggle the sun/moon control in the nav and confirm the change persists on reload (it's stored in `localStorage` under `thoth-theme`). The default for a fresh visitor is dark.
2. **Three breakpoints.** Resize the browser past **1080 px** (stance grid collapses 4→2, audience 2→1), **900 px** (nav links hide, hero stacks, code panels stack, fix-rows become single-column), and **560 px** (signup form stacks, hero font shrinks, demo source/rendered stack vertically).
3. **Code samples render unbroken.** The hero demo's table and rendered preview should fit inside their pane with no horizontal scroll. All code blocks wrap rather than scroll horizontally.
4. **The "in active development" pulse animates** in the nav (and respects `prefers-reduced-motion`).

## Deploying

Drop `index.html`, `styles.css`, and (optionally) `design/` onto any static host: GitHub Pages, Netlify, Cloudflare Pages, S3 + CloudFront, Vercel. The `design/` folder is reference material; you can exclude it from the deployed bundle if you prefer.

## Making changes

See [CLAUDE.md](CLAUDE.md) for the design origin, the rationale behind the static-HTML implementation, and a guide to common edits (copy changes, color changes, adding sections, swapping the brand mark).
