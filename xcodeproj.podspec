
Pod::Spec.new do |s|
  s.name             = "xcodeproj"
  s.version          = "6.1.0"
  s.summary          = "Read/Modify/Write your Xcode projects"
  s.homepage         = "https://github.com/tuist/xcodeproj"
  s.social_media_url = 'https://twitter.com/tuistapp'
  s.license          = 'MIT'
  s.source           = { :git => "https://github.com/tuist/xcodeproj.git", :tag => s.version.to_s }
  s.requires_arc = true

  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '8.0'

  s.source_files = "Sources/**/*.{swift}"

  s.dependency "PathKit", "~> 0.9.2"
  s.dependency "AEXML", "~> 4.3.3"
  s.dependency "SwiftShell", "~> 4.1.2"
end
