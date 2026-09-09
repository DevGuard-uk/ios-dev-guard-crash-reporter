Pod::Spec.new do |s|
  s.name             = 'DevGuardCrashReporter'
  s.version          = '1.0.0'
  s.summary          = 'Standalone crash logging plugin for native iOS apps.'
  s.description      = 'Fire-and-forget crash telemetry to Admin (plugin-crash). Optional projectId + master secret authenticate the crash API.'
  s.homepage         = 'https://github.com/DevGuard-uk/ios-dev-guard-crash-reporter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DevGuard UK' => 'support@devguard.uk' }
  s.source           = { :git => 'https://github.com/DevGuard-uk/ios-dev-guard-crash-reporter.git', :tag => "v#{s.version}" }
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.9'
  s.source_files     = 'Sources/DevGuardCrashReporter/**/*.{swift,h}'
  s.public_header_files = 'Sources/DevGuardCrashReporter/devguard_core.h'
  s.vendored_frameworks = 'Frameworks/devguard_core.xcframework'
  s.frameworks       = 'UIKit'
  s.module_name      = 'DevGuardCrashReporter'
end
