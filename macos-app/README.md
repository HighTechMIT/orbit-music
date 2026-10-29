# Orbit Music for macOS

A standalone macOS app with a Spotify launcher and a system-wide domain blocklist. It does **not** require a Chrome extension, Voidy, a browser plugin, or a separate helper app.

## What the blocker does

When enabled, Orbit asks macOS for administrator authorization and adds a clearly marked blocklist to /etc/hosts. It maps a curated set of advertising/tracking hostnames to 0.0.0.0, blocking those hostnames for browsers and other applications on the Mac. It then flushes the macOS DNS cache.

When disabled, Orbit asks for authorization again and removes only the lines between its own BEGIN and END markers. Other hosts-file entries are preserved. If the markers are malformed or duplicated, Orbit stops rather than guessing.

The list includes common advertising and tracking endpoints. Domain-level filtering can break some ads, analytics, embedded widgets, or site features. Turn the switch off if a site stops working.

## Important limitations

- This is host/domain filtering, **not** a full URL, cosmetic, or HTTPS content filter.
- It cannot reliably remove Spotify audio ads served from Spotify's own playback infrastructure. Orbit does not block Spotify's core domains because that could break music playback.
- It cannot guarantee that every ad or tracker is blocked; advertisers can change domains and use first-party delivery.
- macOS administrator approval is required to modify /etc/hosts. Orbit does not collect or store the administrator password; authorization is handled by macOS.
- The first version is unsigned and not notarized. Build it locally on your Mac from source. Do not run it on a machine you do not administer.

## Build on your Mac

Requirements: macOS 13 or newer and Xcode Command Line Tools (for swiftc).

1. Download or clone this folder.
2. Open Terminal and change into the macos-app folder.
3. Run chmod +x build-app.sh
4. Run ./build-app.sh
5. The script builds and opens build/Orbit Music.app.
6. If Gatekeeper blocks this locally built unsigned app, Control-click it in Finder and choose Open. Only do this for source code you have reviewed and trust.

The source is in Sources/OrbitMusicApp.swift. The app uses SwiftUI and the native macOS authorization prompt. No Chrome extension or Network Extension entitlement is required.


## Download a prebuilt app

The repository builds the app on a macOS runner. Open the [Build Orbit Music macOS App workflow](https://github.com/HighTechMIT/orbit-music/actions/workflows/build-macos-app.yml), choose the latest successful run, and download the artifact named **Orbit-Music-macOS**. Extract the downloaded ZIP once; it contains the **Orbit Music.app** bundle.

Build artifacts are retained for 30 days. The app is not notarized, so macOS may require Control-click → Open on first launch.
