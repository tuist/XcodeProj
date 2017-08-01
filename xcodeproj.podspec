Pod::Spec.new do |s|
  s.name             = "xcodeproj"
  s.version          = "0.0.7"
  s.summary          = "Read/Modify/Write your Xcode projects"
  s.homepage         = "https://github.com/carambalabs/xcodeproj"
  s.license          = 'MIT'
  s.author           = "Pedro Pinñera", "Yonas Kolb"
  s.source           = { :git => "https://github.com/carambalabs/xcodeproj.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/carambalabsEng'
  s.requires_arc = true

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.subspec "xcodeproj" do |ss|
    ss.source_files = "Sources/xcodeproj/**/*.{swift}"
  end

  s.subspec "subs" do |ss|
    ss.source_files = "Sources/xcodeprojextensions/**/*.{swift}"
  end

  s.subspec do |ss|
    ss.source_files = "Sources/xcodeprojprotocols/**/*.{swift}"
  end

  s.dependency "PathKit", "~> 0.8"
  s.dependency "Unbox", "~> 2.5"
  s.dependency "CCommonCrypto", "~> 1.0"
  s.dependency "AEXML", "~> 4.1"
end
