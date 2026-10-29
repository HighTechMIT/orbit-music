# Orbit Music for iPhone — Safari Content Blocker

Orbit Music is a native iOS app source project with a Safari Content Blocker extension. The app opens Spotify Web Player inside an SFSafariViewController, a Safari-powered browser view that supports Safari content blocking. It does not intentionally launch the separate Spotify app.

## What it does

- Opens Spotify Web Player, Liked Songs, and Search in a Safari-powered view.
- Includes an ON/OFF switch in Orbit. The app stores the setting in a shared App Group and calls SFContentBlockerManager.reloadContentBlocker(...) so the extension returns either the bundled filter list or an empty list.
- Includes a starter blocklist for selected third-party ad and tracking domains.
- Does not collect browsing history. Apple designed content blocker extensions so they don't receive a record of the pages Safari visits.

## Limitations

- The ON/OFF switch works after Orbit's Safari extension has been installed and enabled in iOS Settings. iOS does not let an app silently enable its own Safari extension.
- The blocker only applies in Safari and Safari-powered browser views. It does not filter requests from the standalone Spotify app or other apps.
- Spotify audio ads may be delivered from Spotify's own playback infrastructure. Orbit does not block Spotify's core domains and cannot guarantee that Spotify audio ads will be removed.
- The included filter list is a starter list, not a comprehensive or automatically updated filter subscription. Blocking third-party domains may occasionally break embedded content or site features.
- GitHub Pages cannot install this app or activate the extension. The source must be built and signed with Xcode.

## Build and install on your iPhone

Requirements: a Mac with Xcode, an iPhone, and an Apple signing team. A real-device install needs signing. App Groups must be enabled for your App ID and extension; depending on your developer account, App Groups may require Apple Developer Program membership.

1. Download or clone this repository and open the ios-app folder.
2. Install XcodeGen (brew install xcodegen) if needed.
3. In Terminal, run cd ios-app && xcodegen generate.
4. Open OrbitMusic.xcodeproj in Xcode.
5. Select the OrbitMusic app target and OrbitSafariContentBlocker extension target. Under Signing & Capabilities, choose your Team for both targets and enable App Groups with the same identifier shown in both entitlements files: group.com.hightechmit.orbitmusic. If your team can't register that group identifier, change it consistently in both entitlements, OrbitMusicApp.swift, and ActionRequestHandler.swift.
6. If the bundle IDs aren't available to your team, change both target bundle identifiers in project.yml to identifiers owned by your team. Update OrbitConfig.blockerBundleID to match the extension's final bundle ID.
7. Connect your iPhone, choose it as the run destination, and press Run. Trust the developer profile on the device if iOS asks.
8. On the iPhone, open Settings → Apps → Safari → Extensions → Orbit Music Content Blocker and enable Allow Extension.
9. Return to Orbit Music, switch Enable ad and tracker blocking on, and tap Open Spotify Web Player. The web player opens in a Safari-powered view so enabled content blockers can apply.

## Project layout

- OrbitMusic/OrbitMusicApp.swift: native UI, Safari player, and ON/OFF control.
- OrbitSafariContentBlocker/ActionRequestHandler.swift: returns the active rules to Safari.
- OrbitSafariContentBlocker/BlockerList.json: bundled rules.
- project.yml: XcodeGen project definition.
- *.entitlements: App Group configuration shared by the app and extension.

## Filter list maintenance

Edit OrbitSafariContentBlocker/BlockerList.json to add or remove rules. Safari compiles the list when the extension reloads. Keep rules specific and avoid blocking Spotify playback domains. See Apple's Creating a content blocker and SFContentBlockerManager documentation:
- https://developer.apple.com/documentation/safariservices/creating-a-content-blocker
- https://developer.apple.com/documentation/safariservices/sfcontentblockermanager
