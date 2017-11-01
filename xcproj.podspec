Pod::Spec.new do |s|
  s.name             = "xcproj"
  s.version          = "1.3.0"
  s.summary          = "Read/Modify/Write your Xcode projects"
  s.homepage         = "https://github.com/xcodeswift/xcproj"
  s.license          = 'MIT'
  s.author           = "Pedro Pinñera", "Yonas Kolb"
  s.source           = { :git => "https://github.com/xcodeswift/xcproj.git", :tag => s.version.to_s }
  s.requires_arc = true

  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '8.0'

  s.source_files = "Sources/**/*.{swift}"

  s.dependency "PathKit", "~> 0.8"
  s.dependency "AEXML", "~> 4.1"
end
