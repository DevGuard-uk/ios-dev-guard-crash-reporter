# DevGuardCrashReporter (native iOS)

Standalone crash telemetry module for native iOS apps.

**Status:** Sources and `DevGuardCrashReporter.podspec` live in this folder for a future CocoaPods release. The pod is **not published on the CocoaPods trunk yet** (`cocoapods.org/pods/DevGuardCrashReporter` will 404 until trunk accept).

## Recommended path today

Use **`DevGuardSDK`** — built-in plugin crash telemetry ships with the main licensing pod:

```ruby
pod 'DevGuardSDK', '~> 1.0'
```

Public repo: [github.com/DevGuard-uk/ios-dev-guard-sdk](https://github.com/DevGuard-uk/ios-dev-guard-sdk)

## Standalone (from git, pre-trunk)

When you need the module without the full licensing SDK:

```ruby
pod 'DevGuardCrashReporter', :git => 'https://github.com/DevGuard-uk/ios-dev-guard-crash-reporter.git', :tag => 'v1.0.0'
```

```swift
PluginCrashReporter.configure(
    projectId: "your_project_id",
    secret: "YOUR_MASTER_SECRET"
)
```

## Support

- **Issues:** prefer the main SDK issues tracker until the crash-only GitHub remote is published
- **Docs:** [devguard.uk/docs](https://devguard.uk/docs)
