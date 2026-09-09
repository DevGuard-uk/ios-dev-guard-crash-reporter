import Foundation

enum StatusUrlResolver {
    static var defaultApiURL: String { CrashNativeBridge.defaultStatusUrl() }

    private static let invalidMessage =
        "statusUrl must be an HTTPS endpoint on the allowed API host."

    static func resolve(_ statusUrl: String?) throws -> String {
        let candidate: String
        if let raw = statusUrl?.trimmingCharacters(in: .whitespacesAndNewlines), !raw.isEmpty {
            candidate = raw
        } else {
            candidate = CrashNativeBridge.defaultStatusUrl()
        }

        guard isAllowed(candidate) else {
            throw NSError(
                domain: "CrashReporter",
                code: 403,
                userInfo: [NSLocalizedDescriptionKey: invalidMessage]
            )
        }
        return candidate
    }

    static func isAllowed(_ url: String) -> Bool {
        CrashNativeBridge.isAllowedStatusUrl(url.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
