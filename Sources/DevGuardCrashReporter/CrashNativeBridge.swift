import Foundation

enum CrashReporterConstants {
    static let defaultApiURL = StatusUrlResolver.defaultApiURL
    static let hdrSig = "X-DevGuard-Signature"
    static let hdrTs = "X-DevGuard-Timestamp"
    static let hdrApiKey = "X-DevGuard-Api-Key"
}

enum CrashNativeBridge {
    static func generateSignature(projectId: String, timestamp: Int64) -> String {
        var output = [CChar](repeating: 0, count: 65)
        projectId.withCString { ptr in
            dg_x9(ptr, timestamp, &output)
        }
        return String(cString: output)
    }

    static func defaultStatusUrl() -> String {
        var output = [CChar](repeating: 0, count: 128)
        dg_u1(&output)
        return String(cString: output)
    }

    static func isAllowedStatusUrl(_ url: String) -> Bool {
        #if DEBUG
        if url.hasPrefix("http://127.0.0.1") || url.hasPrefix("http://localhost") || url.hasPrefix("http://10.0.2.2") ||
           url.hasPrefix("http://192.168.") || url.hasPrefix("http://10.") || url.hasPrefix("http://172.") {
            return true
        }
        #endif
        return url.withCString { dg_u2($0) == 1 }
    }
}

public enum SdkIdentity {
    public static let sdkRuntime = "native_ios"
    public static let sdkVersion = "1.0.0"
}
