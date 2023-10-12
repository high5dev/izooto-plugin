
Pod::Spec.new do |s|
  s.name             = 'izooto_plugin'
  s.version          = '2.3.2'
  s.summary          = 'The iZooto Flutter SDK'
  s.description      = 'Allows you to easily add iZooto to your flutter projects, to make sending and handling push notifications easy'
  s.homepage         = 'http://izooto.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Amit Kumar Gupta' => 'amit@datability.co' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
 s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  s.dependency 'iZootoiOSSDK'

  s.ios.deployment_target = '11.0'
  
  s.static_framework = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
