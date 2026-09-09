# DevGuardCrashReporter (native iOS)

Standalone crash telemetry for native iOS apps — **not** the licensing `DevGuardSDK`.

This pod only signs and POSTs to `/api/v1/telemetry/plugin-crash` (Admin → Plugin Crashes). It does **not** provide lock screens, heartbeats, or governance.

**Status:** Sources + `DevGuardCrashReporter.podspec` in this repo. Not on CocoaPods trunk yet.

## Install (crash-only)

```ruby
pod 'DevGuardCrashReporter', :git => 'https://github.com/DevGuard-uk/ios-dev-guard-crash-reporter.git', :tag => 'v1.0.0'
```

```swift
// projectId + secret authenticate the crash API (same portal credentials).
// They do not pull in DevGuardSDK.
PluginCrashReporter.configure(
    projectId: "your_project_id",
    secret: "YOUR_MASTER_SECRET"
)

PluginCrashReporter.report(
    error: NSError(domain: "App", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "Something failed",
    ]),
    context: "my_feature",
    crashType: "sdk_internal"
)
```

## Why credentials?

| Value | Used for |
|-------|----------|
| `projectId` | Attribute the crash to your portal project |
| `secret` (master secret) | `X-DevGuard-Api-Key` + HMAC headers on the telemetry POST |

No licensing SDK install is required.

## Host-app UX

`PluginCrashReporter.report` is fire-and-forget. Capture message / context / type in your UI (or logs) so developers can copy or forward the text:

```swift
let message = "Something failed"
PluginCrashReporter.report(
    error: NSError(domain: "App", code: 1, userInfo: [
        NSLocalizedDescriptionKey: message,
    ]),
    context: "my_feature",
    crashType: "sdk_internal"
)
// Show on screen, e.g.:
// lastCrashText = "message: \(message)\ncontext: my_feature\ntype: sdk_internal"
```

## Already using `DevGuardSDK`?

The main licensing pod already includes built-in crash telemetry. Prefer that path if you already depend on `DevGuardSDK` — do not add this pod twice.

## Support

- **Issues:** [github.com/DevGuard-uk/ios-dev-guard-crash-reporter](https://github.com/DevGuard-uk/ios-dev-guard-crash-reporter)
- **Docs:** [devguard.uk/docs](https://devguard.uk/docs)
