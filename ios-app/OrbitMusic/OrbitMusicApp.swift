import SwiftUI
import SafariServices
import UIKit

private enum OrbitConfig {
    static let appGroup = "group.com.hightechmit.orbitmusic"
    static let blockerBundleID = "com.hightechmit.orbitmusic.SafariContentBlocker"
    static let blockingKey = "orbitBlockingEnabled"
}

@main
struct OrbitMusicApp: App {
    @StateObject private var blocker = BlockerModel()

    var body: some Scene {
        WindowGroup {
            OrbitHomeView()
                .environmentObject(blocker)
                .preferredColorScheme(.dark)
        }
    }
}

@MainActor
final class BlockerModel: ObservableObject {
    @Published var isBlockingEnabled: Bool
    @Published var extensionEnabled: Bool?
    @Published var statusMessage = "Checking Safari extension status…"
    @Published var isUpdating = false

    private let sharedDefaults = UserDefaults(suiteName: OrbitConfig.appGroup)

    init() {
        let storedValue = sharedDefaults?.object(forKey: OrbitConfig.blockingKey) as? Bool
        isBlockingEnabled = storedValue ?? true
        if storedValue == nil {
            sharedDefaults?.set(true, forKey: OrbitConfig.blockingKey)
        }
        refreshSafariState()
    }

    func setBlocking(_ enabled: Bool) {
        guard !isUpdating else { return }
        isBlockingEnabled = enabled
        sharedDefaults?.set(enabled, forKey: OrbitConfig.blockingKey)
        isUpdating = true
        statusMessage = "Updating Safari's content-blocking rules…"

        SFContentBlockerManager.reloadContentBlocker(withIdentifier: OrbitConfig.blockerBundleID) { [weak self] error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isUpdating = false

                if let error {
                    self.statusMessage = """
                    Your preference was saved, but Safari could not reload the blocker. Make sure Orbit's extension is enabled in Settings → Apps → Safari → Extensions, then return here and try again. (\(error.localizedDescription))
                    """
                    self.refreshSafariState()
                    return
                }

                self.statusMessage = enabled
                    ? "Orbit's ad and tracker rules have been reloaded. They apply in Safari when the Orbit extension is enabled."
                    : "Orbit's rules are switched off. Safari will no longer apply Orbit's filter list."
                self.refreshSafariState()
            }
        }
    }

    func refreshSafariState() {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: OrbitConfig.blockerBundleID) { [weak self] state, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.extensionEnabled = state?.isEnabled

                if let state, state.isEnabled {
                    self.statusMessage = self.isBlockingEnabled
                        ? "Safari extension is enabled. Orbit's filter list is ON."
                        : "Safari extension is enabled, but Orbit filtering is OFF."
                } else if error != nil || state?.isEnabled == false || state == nil {
                    self.statusMessage = "Enable Orbit in Settings → Apps → Safari → Extensions. Then return here to control its filter list."
                }
            }
        }
    }
}

struct OrbitHomeView: View {
    @EnvironmentObject private var blocker: BlockerModel
    @State private var showingSafari = false
    @State private var selectedURL = URL(string: "https://open.spotify.com/")!

    private let green = Color(red: 0.12, green: 0.84, blue: 0.36)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    playerCard
                    blockerCard
                    limitationsCard
                }
                .padding(18)
                .frame(maxWidth: 620)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.055, green: 0.075, blue: 0.062))
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingSafari) {
                SafariPlayerView(url: selectedURL)
                    .ignoresSafeArea()
            }
            .onAppear {
                blocker.refreshSafariState()
            }
        }
        .tint(green)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "music.note.list")
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(.black)
                .frame(width: 52, height: 52)
                .background(green, in: RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 3) {
                Text("Orbit Music")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Spotify Web Player + Safari blocker")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.62))
            }
            Spacer(minLength: 0)
        }
        .padding(.top, 8)
    }

    private var playerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("MUSIC, IN SAFARI")
                .font(.system(size: 11, weight: .heavy))
                .tracking(1.4)
                .foregroundStyle(green)
            Text("Press play.\nStay in orbit.")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Text("Open Spotify's web player in a Safari-powered browser view so your enabled Safari content blockers can apply.")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.68))
                .lineSpacing(3)

            Button {
                openPlayer("https://open.spotify.com/")
            } label: {
                Label("Open Spotify Web Player", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(OrbitPrimaryButtonStyle())

            HStack(spacing: 10) {
                Button {
                    openPlayer("https://open.spotify.com/collection/tracks")
                } label: {
                    Label("Liked Songs", systemImage: "heart.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(OrbitSecondaryButtonStyle())

                Button {
                    openPlayer("https://open.spotify.com/search")
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(OrbitSecondaryButtonStyle())
            }
        }
        .padding(21)
        .background(
            LinearGradient(
                colors: [Color(red: 0.105, green: 0.18, blue: 0.13), Color(red: 0.085, green: 0.11, blue: 0.09)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24)
        )
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.09), lineWidth: 1))
    }

    private var blockerCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Label("Safari ad blocker", systemImage: "shield.lefthalf.filled")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                Text(blocker.isBlockingEnabled ? "ON" : "OFF")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(blocker.isBlockingEnabled ? green : .white.opacity(0.6))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background((blocker.isBlockingEnabled ? green : .white).opacity(0.13), in: Capsule())
            }

            Toggle(isOn: Binding(
                get: { blocker.isBlockingEnabled },
                set: { blocker.setBlocking($0) }
            )) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enable ad and tracker blocking")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                    Text("Applies the bundled filter list in Safari.")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.58))
                }
            }
            .tint(green)
            .disabled(blocker.isUpdating)

            HStack(alignment: .top, spacing: 9) {
                Image(systemName: blocker.extensionEnabled == true ? "checkmark.circle.fill" : "info.circle.fill")
                    .foregroundStyle(blocker.extensionEnabled == true ? green : Color.yellow)
                Text(blocker.statusMessage)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.78))
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))

            Button {
                blocker.refreshSafariState()
            } label: {
                Label("Refresh extension status", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(OrbitSecondaryButtonStyle())

            Text("First-time setup: Settings → Apps → Safari → Extensions → Orbit Music Content Blocker → Allow Extension.")
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.62))
                .lineSpacing(3)
        }
        .padding(20)
        .background(Color(red: 0.085, green: 0.11, blue: 0.09), in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.09), lineWidth: 1))
    }

    private var limitationsCard: some View {
        VStack(alignment: .leading, spacing: 9) {
            Label("What this can and can't block", systemImage: "info.circle")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
            Text("Orbit's Safari extension blocks requests matching its bundled list of third-party advertising and tracking domains. It cannot block ads everywhere on your phone or inside the separate Spotify app.")
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.7))
                .lineSpacing(3)
            Text("Spotify limitation: audio ads may be delivered through Spotify's own playback infrastructure. Orbit does not block Spotify's core domains and cannot guarantee removal of Spotify audio ads.")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(red: 0.94, green: 0.88, blue: 0.62))
                .lineSpacing(3)
        }
        .padding(18)
        .background(Color(red: 0.14, green: 0.14, blue: 0.095), in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.yellow.opacity(0.16), lineWidth: 1))
    }

    private func openPlayer(_ address: String) {
        guard let url = URL(string: address) else { return }
        selectedURL = url
        showingSafari = true
    }
}

struct SafariPlayerView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = false
        return SFSafariViewController(url: url, configuration: configuration)
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}

struct OrbitPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.black.opacity(0.9))
            .padding(.horizontal, 15)
            .padding(.vertical, 14)
            .background(Color(red: 0.12, green: 0.84, blue: 0.36).opacity(configuration.isPressed ? 0.75 : 1), in: Capsule())
    }
}

struct OrbitSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 13)
            .padding(.vertical, 13)
            .background(.white.opacity(configuration.isPressed ? 0.14 : 0.07), in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.1), lineWidth: 1))
    }
}
