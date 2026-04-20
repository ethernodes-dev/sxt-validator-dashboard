# SXT Branding Assets

This directory contains the Space and Time brand assets used to theme the
dashboard. Everything in this tree is mounted read-only into the Grafana
container at `/usr/share/grafana/public/sxt-branding/`, which means it is
accessible from the browser via URLs of the form:

    /public/sxt-branding/logos/icon-color.svg
    /public/sxt-branding/fonts/Inter-SemiBold.ttf
    /public/sxt-branding/css/sxt-theme.css

## Structure

    branding/
    ├── css/
    │   └── sxt-theme.css        Global theme (CSS vars, fonts, card classes, animations)
    ├── fonts/
    │   ├── Inter-Regular.ttf
    │   ├── Inter-SemiBold.ttf
    │   ├── Inter-Bold.ttf
    │   ├── JetBrainsMono-Regular.ttf
    │   ├── JetBrainsMono-Medium.ttf
    │   └── JetBrainsMono-Bold.ttf
    └── logos/
        ├── icon-color.svg       Hexasphere symbol, gradient (use on dark bg)
        ├── icon-white.svg       Hexasphere symbol, white (use on dark bg)
        ├── icon-black.svg       Hexasphere symbol, black (use on light bg)
        ├── logo-main-color.svg  Full logo + wordmark, gradient
        ├── logo-main-white.svg  Full logo + wordmark, white
        └── logo-main-black.svg  Full logo + wordmark, black

## How the CSS is applied

`docker-compose.yml` sets:

    GF_SERVER_CUSTOM_CSS_PATH=/usr/share/grafana/public/sxt-branding/css/sxt-theme.css

Grafana injects a `<link rel="stylesheet">` to that file on every page. The
stylesheet defines CSS custom properties (`--sxt-*`) and reusable class names
(`.sxt-card`, `.sxt-num`, `.sxt-delta`, etc.) that every Business Text panel
in the dashboard consumes.

## How to use the brand tokens inside a Business Text panel

Every panel's HTML can use the `--sxt-*` variables and the `.sxt-*` classes
directly. Example:

    <div class="sxt-card sxt-card--hero">
      <p class="sxt-label">SXT / USD</p>
      <p class="sxt-num sxt-num--xl sxt-num--gradient">$0.0234</p>
      <span class="sxt-delta sxt-delta--up">▲ 4.12%</span>
    </div>

Do NOT inline colors (`color: #5000BF`) — always reference tokens
(`color: var(--sxt-electric-purple)`). This keeps the theme consistent and
makes future palette shifts a one-file change.

## Source of the assets

All files in `logos/` and `fonts/` are copied verbatim from the official
Space and Time brand kit at:

    https://github.com/SxT-Community/sxt-brand-kit

(snapshot taken: January 2025 brand guide)

The ZIP from that repo also contains `backgrounds/` (40+ PNG backdrops for
presentations/social). These are intentionally NOT checked into this repo
because they total ~121 MB. Refer to them directly from the upstream repo if
you ever need them for external collateral.
