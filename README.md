# Orbit Music

Orbit Music now has two related parts:
- **Chrome extension (recommended for ad/tracker blocking):** one toolbar popup that launches Spotify and runs blocking rules in the background. No Voidy installation is required.
- **PWA:** a standalone Spotify launcher published through GitHub Pages. A PWA cannot block requests made by other sites, so it cannot replace the extension for ad blocking.

## Install the combined Chrome extension

1. Download this repository using **Code → Download ZIP** and extract it.
2. Open `chrome://extensions` in Chrome.
3. Turn on **Developer mode**.
4. Click **Load unpacked** and select the `chrome-extension` folder.
5. Pin **Orbit Music — Spotify & Ad Shield** to the toolbar.

The extension has Full, Lite, and Off modes, shortcuts to Spotify Liked Songs and Search, a saved Spotify destination, and an opt-in setting to open Spotify when Chrome starts.

## Important limitations

- Orbit Music does not use Voidy's source code and does not require the Voidy extension.
- It blocks a curated list of common third-party ad/tracker domains and hides some clearly labeled ad placements on Spotify.
- Spotify can serve audio ads through its own playback systems. Blocking those requests may break playback, so Orbit deliberately does not block Spotify's core playback/API domains. Complete Spotify in-stream ad removal is not guaranteed.
- Full mode may break third-party widgets or analytics; switch to Lite or Off if a site stops working.
- Settings stay in Chrome local storage; there is no analytics or browsing-history collection.

## PWA version

The PWA is published at `https://hightechmit.github.io/orbit-music/`. It can launch Spotify and provide shortcuts, but browsers isolate PWAs from other websites' network traffic. Use the Chrome extension for ad/tracker blocking.

## GitHub Pages

The `.github/workflows/pages.yml` workflow deploys the PWA when GitHub Pages is configured to use **GitHub Actions** as its source.