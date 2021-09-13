Pod::Spec.new do |s|
  s.name             = 'xcodeproj'
  s.version          = '8.1.0'
  s.summary          = 'Read/Modify/Write your Xcode projects'
  s.homepage         = 'https://github.com/tuist/xcodeproj'
  s.license          = 'MIT'
  s.source           = { git: 'https://github.com/tuist/xcodeproj.git', tag: s.version.to_s }
  s.requires_arc = true
  s.authors = 'Tuist'
  s.swift_version = '5.1'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Sources/**/*.{swift}'

  s.module_name = 'XcodeProj'

  s.dependency 'PathKit', '~> 1.0.0'
  s.dependency 'AEXML', '~> 4.6.0'
end
