# iOS Crash Reporter

Standalone iOS crash logging plugin. Signs and POSTs crash reports to `/api/v1/telemetry/plugin-crash` (Admin → Plugin Crashes).

**Status:** Sources + CocoaPod in this repo. Not on CocoaPods trunk yet.

## Install

```ruby
pod 'DevGuardCrashReporter', :git => 'https://github.com/DevGuard-uk/ios-dev-guard-crash-reporter.git', :tag => 'v1.0.0'
```

```swift
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

## Credentials

| Value | Used for |
|-------|----------|
| `projectId` | Attribute the crash to your portal project |
| `secret` (master secret) | API key header + HMAC on the telemetry POST |

Both are optional API auth for remote triage. Use placeholders in committed samples.

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

## Support

- **Issues:** [github.com/DevGuard-uk/ios-dev-guard-crash-reporter](https://github.com/DevGuard-uk/ios-dev-guard-crash-reporter)
