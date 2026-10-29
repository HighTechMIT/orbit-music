# Orbit Music

Orbit Music has two related parts:
- **PWA / GitHub Pages website:** a Spotify launcher with an **Ad Block** switch. In desktop Chrome, the switch can control the installed Orbit Chrome extension.
- **Chrome extension:** performs the actual network ad/tracker blocking in the background. No Voidy installation is required.

## Use the Ad Block switch on the GitHub page

1. Install the Chrome extension using the steps below.
2. Open the PWA at https://hightechmit.github.io/orbit-music/ in the **same desktop Chrome profile**.
3. Use the **Enable ad and tracker blocking** switch. It sets the extension to Full or Off mode. There is no separate connection-check button.
4. If the switch says the extension was not detected, reload the extension and refresh the website.

The website toggle cannot block ads by itself. It only sends a message to the installed Chrome extension. It does not work from iPhone/iPad Safari or inside the Spotify app.

## Install the combined Chrome extension

1. Download this repository using **Code → Download ZIP** and extract it.
2. Open `chrome://extensions` in desktop Chrome.
3. Turn on **Developer mode**.
4. Click **Load unpacked** and select the `chrome-extension` folder.
5. Pin **Orbit Music — Spotify & Ad Shield** to the toolbar.

If you already installed an earlier unpacked version, keep using the same extracted folder path. Replace/reload the extension from that same `chrome-extension` folder so Chrome keeps its path-based unpacked ID. The GitHub Pages switch is configured to communicate with the extension ID you supplied.

The extension has Full, Lite, and Off modes, shortcuts to Spotify Liked Songs and Search, a saved Spotify destination, and an opt-in setting to open Spotify when Chrome starts.

## Important limitations

- Orbit Music does not use Voidy's source code and does not require the Voidy extension.
- It blocks a curated list of common third-party ad/tracker domains and hides some clearly labeled ad placements on Spotify.
- Spotify can serve audio ads through its own playback systems. Blocking those requests may break playback, so Orbit deliberately does not block Spotify's core playback/API domains. Complete Spotify in-stream ad removal is not guaranteed.
- Full mode may break third-party widgets or analytics; switch to Lite or Off if a site stops working.
- Settings stay in Chrome local storage; there is no analytics or browsing-history collection.

## PWA and GitHub Pages

The PWA is published at `https://hightechmit.github.io/orbit-music/`. It can launch Spotify and provide shortcuts. A browser page cannot independently intercept another site's network traffic; ad blocking is performed by the Chrome extension.

The `.github/workflows/pages.yml` workflow deploys the PWA when GitHub Pages is configured to use **GitHub Actions** as its source.
