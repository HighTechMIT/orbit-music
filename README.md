# Orbit Music

Orbit Music is a phone-first PWA for listening to music with an embedded alternative YouTube / YouTube Music audio player.

## Open on your phone

https://hightechmit.github.io/orbit-music/

- iPhone: open the link in Safari → Share → Add to Home Screen.
- Android: open the link in Chrome → browser menu → Install app / Add to Home Screen.

## Music player and sponsor skipping

The page embeds [Ytify](https://ytify.pp.ua/), an independent audio player that searches YouTube and YouTube Music and supports playlists, queueing, and audio playback. If the embedded player does not load, use the **Open full music player** link in Orbit.

Ytify has a SponsorBlock setting for non-music content. Open the player's own Settings and enable it there. The Orbit wrapper cannot control a third-party player's settings because it is hosted on another origin.

The alternative audio frontend does not use the official YouTube Music page, which can avoid the official video-ad player, but Orbit does not guarantee ad-free playback. Availability and behavior depend on the third-party service. The official YouTube Music button remains available as an alternative.

## Important technical limitation

Orbit's GitHub Pages code cannot intercept requests inside another origin or install browser extensions. The player is embedded from a separate service; Orbit itself is a lightweight wrapper/PWA, not a network-level ad blocker.

## Other source folders

- `ios-app/`: optional native iOS Safari Content Blocker source project.
- `chrome-extension/`: optional desktop Chrome extension.
- `macos-app/`: optional native macOS source.
