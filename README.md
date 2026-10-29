# Orbit Music

Orbit Music includes a phone-first PWA and a native iOS app source project with a Safari Content Blocker extension.

## Phone web app

Published app: https://hightechmit.github.io/orbit-music/

- iPhone: open the link in Safari → Share → Add to Home Screen.
- Android: open the link in Chrome → browser menu → Install app / Add to Home Screen.

The PWA provides Spotify shortcuts and saved playlist links. It cannot itself filter traffic from other apps or enable iOS Safari extensions.

## Native iOS Safari blocker

Source project: https://github.com/HighTechMIT/orbit-music/tree/main/ios-app

The native app opens Spotify Web Player in an SFSafariViewController (a Safari-powered view that supports Safari content blocking) and includes an ON/OFF control for a starter list of third-party ad/tracker domains.

To install on an iPhone, build and sign the project with Xcode on a Mac, choose your Apple signing team for both targets, configure the shared App Group, install the app, then enable Orbit Music Content Blocker in Settings → Apps → Safari → Extensions. See ios-app/README.md for complete instructions.

Important limitations:
- The Safari blocker only applies in Safari and Safari-powered browser views, not the separate Spotify app or other apps.
- Spotify audio ads can use Spotify's own playback infrastructure; Orbit cannot guarantee that it will remove them.
- GitHub Pages hosts the website and source instructions; it cannot install or enable the native iOS extension.
- The included filter list is a starter list, not a comprehensive auto-updating subscription.

## Desktop Chrome extension

The repository also contains the optional desktop extension in chrome-extension/. For desktop Chrome, download the repository, extract it, open chrome://extensions, enable Developer mode, and select Load unpacked.

## Standalone macOS source

Optional native macOS source is in macos-app/. It is separate from the iPhone app.
