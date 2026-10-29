# Orbit Music Chrome Extension

A single Chrome extension that opens Spotify and applies network ad/tracker blocking in the background. It does not depend on Voidy.

## Install
1. Open this repository on GitHub and choose **Code → Download ZIP**, then extract it.
2. Open `chrome://extensions` in Chrome.
3. Turn on **Developer mode**.
4. Click **Load unpacked** and select the `chrome-extension` folder inside the extracted repository.
5. Pin **Orbit Music — Spotify & Ad Shield** to the toolbar.

Do not select the repository root; select the folder containing this `manifest.json`.

## Modes
- **Full:** core and extended third-party ad/tracker domain rules.
- **Lite:** core rules only.
- **Off:** disables network rules and cosmetic hiding.
- **Open Spotify when Chrome starts:** opt-in; opens the saved Spotify destination when Chrome starts.
- **Cosmetic filtering:** hides clearly labeled ad placements in Spotify's webpage when identifiable.

## Important limitations
- This is a first-party independent implementation, not Voidy's source code.
- The extension deliberately does not block Spotify's core playback/API domains because doing so can break playback.
- Spotify may deliver audio ads through Spotify-owned systems, so this cannot guarantee removal of in-stream ads. Cosmetic filtering can only hide labeled webpage elements.
- Static rules cover a curated list of common third-party ad/tracker domains; they are not an automatically updated filter list.
- Full mode may break some third-party widgets or analytics. Switch to Lite or Off if a site stops working.
- The extension does not collect or transmit browsing history.
