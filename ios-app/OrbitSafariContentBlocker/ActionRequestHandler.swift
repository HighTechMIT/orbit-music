import Foundation

final class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    private let appGroupIdentifier = "group.com.hightechmit.orbitmusic"
    private let enabledPreferenceKey = "orbitBlockingEnabled"
    private let contentBlockerType = "com.apple.Safari.content-blocker-list"

    func beginRequest(with context: NSExtensionContext) {
        let enabled = UserDefaults(suiteName: appGroupIdentifier)?
            .bool(forKey: enabledPreferenceKey) ?? true

        let rulesData: Data
        if enabled,
           let rulesURL = Bundle.main.url(forResource: "BlockerList", withExtension: "json"),
           let data = try? Data(contentsOf: rulesURL) {
            rulesData = data
        } else {
            rulesData = Data("[]".utf8)
        }

        let responseItem = NSExtensionItem()
        let provider = NSItemProvider(
            item: rulesData as NSData,
            typeIdentifier: contentBlockerType
        )
        responseItem.attachments = [provider]
        context.completeRequest(returningItems: [responseItem], completionHandler: nil)
    }
}
