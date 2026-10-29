# Orbit Music

An installable Progressive Web App that opens Spotify Web Player and provides shortcuts to Liked Songs and Search.

## Features
- Open Spotify Web Player from one tap.
- Quick links to Liked Songs and Spotify Search.
- Optional launch preference (browser may still require a user gesture).
- Installable app shell with offline caching for the interface only.
- Preferences stored locally; no analytics or backend.

## Important
Orbit Music does not install or control the Voidy Chrome extension. Install Voidy separately in the same Chrome profile. Whether Spotify ads are blocked depends on Voidy's compatibility; this app does not bypass Spotify Premium restrictions or force playback.

## Publish with GitHub Pages
1. In repository Settings → Pages, choose **GitHub Actions** as the build and deployment source.
2. The workflow in `.github/workflows/pages.yml` deploys the repository to Pages on pushes to `main`.
3. Wait for the workflow to finish, then open `https://HighTechMIT.github.io/orbit-music/` in Chrome.
4. Use Chrome's install option to add Orbit Music as an app.

The app requires HTTPS (GitHub Pages provides it) for service workers and PWA installation.