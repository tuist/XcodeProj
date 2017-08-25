Pod::Spec.new do |s|
  s.name             = "xcodeproj"
  s.version          = "0.1.0"
  s.summary          = "Read/Modify/Write your Xcode projects"
  s.homepage         = "https://github.com/carambalabs/xcodeproj"
  s.license          = 'MIT'
  s.author           = "Pedro Pinñera", "Yonas Kolb"
  s.source           = { :git => "https://github.com/carambalabs/xcodeproj.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/carambalabsEng'
  s.requires_arc = true

  s.platform = :osx
  s.osx.deployment_target = "10.10"

  s.source_files = "Sources/**/*.{swift}"

  s.dependency "PathKit", "~> 0.8"
  s.dependency "Unbox", "~> 2.5"
  s.dependency "AEXML", "~> 4.1"
end
