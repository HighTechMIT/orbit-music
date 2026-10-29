import SwiftUI
import AppKit
import Foundation

@main
struct OrbitMusicApp: App {
    var body: some Scene {
        WindowGroup {
            OrbitHomeView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 600, height: 720)
    }
}

struct OrbitHomeView: View {
    @State private var isEnabled = false
    @State private var pendingState: Bool?
    @State private var isBusy = false
    @State private var status = "Protection is off. Turn it on to block selected ad and tracking domains."
    @State private var errorMessage = ""
    @State private var showingError = false

    private var displayedToggleState: Binding<Bool> {
        Binding(
            get: { pendingState ?? isEnabled },
            set: { setBlocking($0) }
        )
    }

    var body: some View {
        ZStack {
            Color(red: 0.055, green: 0.075, blue: 0.062).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    musicCard
                    blockerCard
                    limitationsCard
                    footer
                }
                .padding(26)
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
        }
        .frame(minWidth: 520, minHeight: 620)
        .task {
            isEnabled = HostsBlocker.isEnabled()
            status = isEnabled
                ? "Protection is on. Orbit's managed blocklist is active system-wide."
                : "Protection is off. No Orbit blocklist is currently active."
        }
        .alert("Could not update ad blocking", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 17)
                    .fill(Color(red: 0.12, green: 0.84, blue: 0.36))
                    .frame(width: 56, height: 56)
                Image(systemName: "music.note.list")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(Color.black.opacity(0.85))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Orbit Music")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Spotify launcher + system ad filter")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.65))
            }
            Spacer()
            Text("FOR MAC")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .tracking(1.1)
                .foregroundStyle(Color(red: 0.55, green: 0.94, blue: 0.67))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.white.opacity(0.07), in: Capsule())
        }
        .padding(.top, 8)
    }

    private var musicCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("YOUR MUSIC, ONE TAP AWAY")
                .font(.system(size: 11, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(Color(red: 0.40, green: 0.91, blue: 0.56))
            Text("Press play.\nStay in orbit.")
                .font(.system(size: 35, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Text("Open Spotify Web Player, your Liked Songs, or search without needing a browser extension.")
                .font(.system(size: 14))
                .foregroundStyle(Color.white.opacity(0.68))
                .lineSpacing(3)
            HStack(spacing: 10) {
                Button(action: { openSpotify("https://open.spotify.com/") }) {
                    Label("Open Spotify", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(OrbitPrimaryButtonStyle())

                Button(action: { openSpotify("https://open.spotify.com/collection/tracks") }) {
                    Label("Liked Songs", systemImage: "heart.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(OrbitSecondaryButtonStyle())
            }
            Button(action: { openSpotify("https://open.spotify.com/search") }) {
                Label("Search Spotify", systemImage: "magnifyingglass")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(OrbitSecondaryButtonStyle())
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [Color(red: 0.105, green: 0.18, blue: 0.13), Color(red: 0.085, green: 0.11, blue: 0.09)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24)
        )
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.09), lineWidth: 1))
    }

    private var blockerCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(red: 0.40, green: 0.91, blue: 0.56))
                Text("System ad blocker")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                Text(isEnabled ? "ON" : "OFF")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(isEnabled ? Color(red: 0.58, green: 0.98, blue: 0.68) : Color.white.opacity(0.55))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(isEnabled ? Color.green.opacity(0.14) : Color.white.opacity(0.07), in: Capsule())
            }

            Text("Block selected advertising and tracking domains across browsers and other apps using a managed macOS hosts-file blocklist.")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.68))
                .lineSpacing(3)

            Toggle(isOn: displayedToggleState) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enable ad and tracker blocking")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(isBusy ? "Waiting for macOS authorization…" : "Administrator approval is required to change system settings.")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white.opacity(0.55))
                }
            }
            .toggleStyle(.switch)
            .tint(Color(red: 0.12, green: 0.84, blue: 0.36))
            .disabled(isBusy)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: isEnabled ? "checkmark.circle.fill" : "info.circle.fill")
                    .foregroundStyle(isEnabled ? Color.green : Color(red: 0.92, green: 0.80, blue: 0.43))
                Text(status)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.white.opacity(0.76))
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(Color.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))
        }
        .padding(22)
        .background(Color(red: 0.085, green: 0.11, blue: 0.09), in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.09), lineWidth: 1))
    }

    private var limitationsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Know what it blocks", systemImage: "info.circle")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
            Text("This is domain-level filtering, not a full browser content blocker. Some sites may lose ads, analytics, or embedded features when their domains are blocked.")
                .font(.system(size: 12))
                .foregroundStyle(Color.white.opacity(0.65))
                .lineSpacing(3)
            Text("Spotify limitation: Spotify can serve audio ads from its own playback infrastructure. This app deliberately does not block Spotify's core domains, so it cannot guarantee removal of Spotify audio ads.")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(red: 0.94, green: 0.88, blue: 0.62))
                .lineSpacing(3)
        }
        .padding(19)
        .background(Color(red: 0.14, green: 0.14, blue: 0.095), in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.yellow.opacity(0.16), lineWidth: 1))
    }

    private var footer: some View {
        Text("Orbit only removes lines between its own markers in /etc/hosts. Other hosts-file entries are preserved. No browsing history is collected.")
            .font(.system(size: 11))
            .foregroundStyle(Color.white.opacity(0.42))
            .lineSpacing(3)
            .padding(.horizontal, 4)
    }

    private func openSpotify(_ address: String) {
        guard let url = URL(string: address) else { return }
        NSWorkspace.shared.open(url)
    }

    private func setBlocking(_ enabled: Bool) {
        guard !isBusy else { return }
        pendingState = enabled
        isBusy = true
        status = enabled
            ? "Requesting administrator authorization to enable the blocklist…"
            : "Requesting administrator authorization to remove Orbit's blocklist…"

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try HostsBlocker.setEnabled(enabled)
                let actualState = HostsBlocker.isEnabled()
                DispatchQueue.main.async {
                    isEnabled = actualState
                    pendingState = nil
                    isBusy = false
                    status = actualState
                        ? "Protection is on. \(HostsBlocker.domains.count) ad/tracker domains are blocked system-wide."
                        : "Protection is off. Orbit's managed blocklist has been removed."
                }
            } catch {
                DispatchQueue.main.async {
                    pendingState = nil
                    isBusy = false
                    status = "No change was made. You can try again or cancel the macOS authorization prompt."
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
        }
    }
}

struct OrbitPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(Color.black.opacity(0.9))
            .padding(.horizontal, 15)
            .padding(.vertical, 13)
            .background(Color(red: 0.12, green: 0.84, blue: 0.36).opacity(configuration.isPressed ? 0.75 : 1), in: Capsule())
    }
}

struct OrbitSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 15)
            .padding(.vertical, 13)
            .background(Color.white.opacity(configuration.isPressed ? 0.14 : 0.07), in: Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.10), lineWidth: 1))
    }
}

private enum HostsBlocker {
    static let beginMarker = "# BEGIN ORBIT MUSIC AD BLOCK"
    static let endMarker = "# END ORBIT MUSIC AD BLOCK"

    static let domains = [
        "doubleclick.net",
        "ad.doubleclick.net",
        "googleads.g.doubleclick.net",
        "securepubads.g.doubleclick.net",
        "stats.g.doubleclick.net",
        "pagead.l.doubleclick.net",
        "googleadservices.com",
        "www.googleadservices.com",
        "googlesyndication.com",
        "pagead2.googlesyndication.com",
        "tpc.googlesyndication.com",
        "adservice.google.com",
        "adnxs.com",
        "ib.adnxs.com",
        "secure.adnxs.com",
        "appnexus.com",
        "adsrvr.org",
        "pixel.adsrvr.org",
        "adform.net",
        "s1.adform.net",
        "criteo.com",
        "criteo.net",
        "scorecardresearch.com",
        "sb.scorecardresearch.com",
        "taboola.com",
        "trc.taboola.com",
        "cdn.taboola.com",
        "outbrain.com",
        "widgets.outbrain.com",
        "pubmatic.com",
        "ads.pubmatic.com",
        "openx.net",
        "rubiconproject.com",
        "pixel.rubiconproject.com",
        "serving-sys.com",
        "quantserve.com",
        "pixel.quantserve.com",
        "casalemedia.com",
        "ads.casalemedia.com",
        "advertising.com",
        "adsafeprotected.com",
        "pixel.adsafeprotected.com",
        "moatads.com",
        "smartadserver.com",
        "ads.smartadserver.com",
        "media.net",
        "bidswitch.net",
        "yieldmo.com",
        "sharethrough.com",
        "triplelift.com",
        "demdex.net",
        "omtrdc.net"
    ]

    static func isEnabled() -> Bool {
        guard let hosts = try? String(contentsOfFile: "/etc/hosts", encoding: .utf8) else { return false }
        return hosts.components(separatedBy: .newlines).contains(beginMarker)
    }

    static func setEnabled(_ enabled: Bool) throws {
        let domainLiteral = domains.map { "'\($0)'" }.joined(separator: ", ")
        let pythonScript = """
        import os
        import stat
        import subprocess
        import tempfile

        hosts_path = "/etc/hosts"
        begin = "\(beginMarker)"
        end = "\(endMarker)"
        enabled = \(enabled ? "True" : "False")
        domains = [\(domainLiteral)]

        with open(hosts_path, "r", encoding="utf-8") as file:
            original = file.read()
        lines = original.splitlines()
        starts = [i for i, line in enumerate(lines) if line == begin]
        ends = [i for i, line in enumerate(lines) if line == end]

        if len(starts) != len(ends) or len(starts) > 1:
            raise SystemExit("Orbit's hosts-file markers are inconsistent. No changes were made.")
        if starts and ends and ends[0] < starts[0]:
            raise SystemExit("Orbit's hosts-file markers are out of order. No changes were made.")
        if starts:
            lines = lines[:starts[0]] + lines[ends[0] + 1:]
        elif not enabled:
            print("Orbit's blocklist is already disabled.")
            raise SystemExit(0)

        if enabled:
            if lines and lines[-1] != "":
                lines.append("")
            lines.append(begin)
            lines.extend("0.0.0.0 " + domain for domain in domains)
            lines.append(end)

        new_text = "\\n".join(lines).rstrip("\\n") + "\\n"
        original_stat = os.stat(hosts_path)
        fd, temp_path = tempfile.mkstemp(prefix=".orbit-music-hosts-", dir="/etc")
        try:
            with os.fdopen(fd, "w", encoding="utf-8") as file:
                file.write(new_text)
            os.chown(temp_path, original_stat.st_uid, original_stat.st_gid)
            os.chmod(temp_path, stat.S_IMODE(original_stat.st_mode))
            os.replace(temp_path, hosts_path)
        finally:
            if os.path.exists(temp_path):
                os.unlink(temp_path)

        subprocess.run(["/usr/bin/dscacheutil", "-flushcache"], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(["/usr/bin/killall", "-HUP", "mDNSResponder"], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        """

        let encoded = Data(pythonScript.utf8).base64EncodedString()
        let shellCommand = "/usr/bin/printf '%s' '\(encoded)' | /usr/bin/base64 -D | /usr/bin/python3"
        let appleScriptSource = "do shell script \"\(shellCommand)\" with administrator privileges"

        guard let script = NSAppleScript(source: appleScriptSource) else {
            throw HostsBlockerError.authorizationFailed("macOS could not create the authorization request.")
        }

        var errorInfo: NSDictionary?
        _ = script.executeAndReturnError(&errorInfo)
        if let errorInfo {
            let message = errorInfo["NSAppleScriptErrorMessage"] as? String
                ?? "Administrator authorization was cancelled or failed."
            throw HostsBlockerError.authorizationFailed(message)
        }
    }
}

private enum HostsBlockerError: LocalizedError {
    case authorizationFailed(String)

    var errorDescription: String? {
        switch self {
        case .authorizationFailed(let message):
            return message
        }
    }
}
