import Foundation
import UIKit

private func devguardPluginUncaughtHandler(_ exception: NSException) {
    let error = NSError(
        domain: exception.name.rawValue,
        code: 0,
        userInfo: [
            NSLocalizedDescriptionKey: exception.reason ?? "Uncaught exception",
            "callStackSymbols": exception.callStackSymbols,
        ]
    )
    PluginCrashReporter.report(
        error: error,
        stackTrace: exception.callStackSymbols.joined(separator: "\n"),
        context: "uncaught",
        isFatal: true,
        crashType: "native_crash"
    )
}

public typealias PluginCrashMetadataProvider = () async -> [String: Any]?

/// Fire-and-forget plugin crash telemetry to the DevGuard API.
/// Publishable separately as the `DevGuardCrashReporter` CocoaPod.
public enum PluginCrashReporter {
    private static var projectId: String?
    private static var secret: String?
    private static var baseUrl = CrashReporterConstants.defaultApiURL
    private static var metadataProvider: PluginCrashMetadataProvider?
    private static var uncaughtHandlerInstalled = false

    public static func configure(
        projectId: String,
        secret: String? = nil,
        baseUrl: String? = nil,
        metadataProvider: PluginCrashMetadataProvider? = nil,
        installUncaughtHandler: Bool = true
    ) {
        self.projectId = projectId
        self.secret = secret
        if let resolved = try? StatusUrlResolver.resolve(baseUrl) {
            self.baseUrl = resolved
        }
        self.metadataProvider = metadataProvider
        if installUncaughtHandler && !uncaughtHandlerInstalled {
            registerUncaughtHandler()
        }
    }

    public static func report(
        error: Error,
        stackTrace: String? = nil,
        context: String? = nil,
        isFatal: Bool = false,
        crashType: String = "sdk_internal"
    ) {
        guard let projectId else { return }
        Task {
            do {
                guard StatusUrlResolver.isAllowed(baseUrl) else { return }
                let metadata = await metadataProvider?() ?? [:]
                let deviceId = metadata["deviceId"] as? String
                guard let deviceId, !deviceId.isEmpty else { return }

                let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
                let signature = CrashNativeBridge.generateSignature(projectId: projectId, timestamp: timestamp)

                var body: [String: Any] = [
                    "projectId": projectId,
                    "deviceId": deviceId,
                    "errorMessage": error.localizedDescription,
                    "errorName": String(describing: type(of: error)),
                    "crashType": crashType,
                    "isFatal": isFatal,
                    "sdkRuntime": metadata["sdkRuntime"] as? String ?? SdkIdentity.sdkRuntime,
                    "sdkVersion": metadata["sdkVersion"] as? String ?? SdkIdentity.sdkVersion,
                    "hostPlatform": metadata["hostPlatform"] as? String ?? "ios",
                    "hostPlatformVersion": metadata["hostPlatformVersion"] as? String ?? UIDevice.current.systemVersion,
                    "occurredAt": ISO8601DateFormatter().string(from: Date()),
                ]
                if let stackTrace {
                    body["stackTrace"] = stackTrace
                } else if let symbols = Thread.callStackSymbols.joined(separator: "\n") as String? {
                    body["stackTrace"] = symbols
                }
                if let version = metadata["version"] {
                    body["appVersion"] = version
                }
                if let context {
                    body["clientMeta"] = ["context": context]
                }

                guard let url = URL(string: telemetryUrl()) else { return }
                var request = URLRequest(url: url, timeoutInterval: 8)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(signature, forHTTPHeaderField: CrashReporterConstants.hdrSig)
                request.setValue(String(timestamp), forHTTPHeaderField: CrashReporterConstants.hdrTs)
                request.setValue(secret ?? "", forHTTPHeaderField: CrashReporterConstants.hdrApiKey)
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
                _ = try await URLSession.shared.data(for: request)
            } catch {
                // Never block app flows on crash telemetry.
            }
        }
    }

    private static func registerUncaughtHandler() {
        uncaughtHandlerInstalled = true
        NSSetUncaughtExceptionHandler(devguardPluginUncaughtHandler)
    }

    private static func telemetryUrl() -> String {
        let base = baseUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if base.hasSuffix("/devguard") {
            return base.replacingOccurrences(of: "/devguard", with: "/api/v1/telemetry/plugin-crash")
        }
        return "\(base)/api/v1/telemetry/plugin-crash"
    }
}
