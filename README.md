# Orbit Music

Orbit Music is a lightweight, installable phone PWA that opens the official YouTube Music website.

## Open on your phone

https://hightechmit.github.io/orbit-music/

- iPhone: open the link in Safari → Share → Add to Home Screen.
- Android: open the link in Chrome → browser menu → Install app / Add to Home Screen.

The Launch YouTube Music button navigates to https://music.youtube.com/ in the current tab. Sign-in, library, playlists, playback, and ads are handled by YouTube Music.

## Ad blocking limitation

Orbit is a GitHub Pages website and cannot intercept or modify requests made by YouTube Music after navigation. A real ad blocker must run as a browser content blocker or device-level filter. Orbit does not show a fake ON/OFF switch.

## Other source folders

- `ios-app/`: optional native iOS Safari Content Blocker source project.
- `chrome-extension/`: optional desktop Chrome extension.
- `macos-app/`: optional native macOS source.
