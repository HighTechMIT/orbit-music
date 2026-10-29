# Orbit Music

Orbit Music is a phone-first installable PWA that provides quick Spotify links and saves a playlist destination locally in your browser.

## Open Orbit Music on your phone

Published app: https://hightechmit.github.io/orbit-music/

### Install on iPhone

1. Open the app link in Safari.
2. Tap Share.
3. Choose Add to Home Screen.
4. If offered, enable Open as Web App, then tap Add.

Orbit will appear on your Home Screen like an app. Spotify sign-in and music playback are handled by Spotify.

### Install on Android

Open the app link in Chrome, open the browser menu, and choose Install app or Add to Home screen if offered.

## Phone ad filtering

The PWA itself cannot intercept network traffic from other apps or change system DNS settings. On iPhone, the page includes a link to the official AdGuard DNS setup page for optional DNS-level filtering. That setup is separate from Orbit and requires the user to install and approve the DNS configuration in iOS Settings.

DNS filtering can block selected ad and tracker domains, but cannot reliably remove Spotify's own audio ads. DNS profiles may also conflict with some VPN configurations.

## Desktop extension

The repository still includes a Chrome extension in the chrome-extension folder for people who want Orbit's separate desktop browser-blocking features. The PWA no longer displays a desktop-extension toggle, because that control cannot function on iPhone or block traffic by itself.

To install the extension in desktop Chrome:
1. Download this repository ZIP and extract it.
2. Open chrome://extensions.
3. Enable Developer mode.
4. Click Load unpacked and select the chrome-extension folder.

## Privacy

Saved Spotify destinations are stored in local browser storage. Orbit has no analytics backend and does not collect browsing history.

## Standalone macOS source

The optional native macOS source remains in the macos-app folder. It is separate from the phone PWA and is not needed to use Orbit on a phone.
