#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint izooto_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'izooto_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://izooto.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Amit Kumar Gupta' => 'amit@datability.co' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
 s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'
s.dependency 'iZootoiOSSDK','1.1.8'


  s.ios.deployment_target = '10.0'
  s.static_framework = true
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
