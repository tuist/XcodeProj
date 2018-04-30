#!/usr/bin/rake

require 'semantic'
require 'colorize'
require 'fileutils'
require 'git'

DESTINATION = "platform=iOS Simulator,name=iPhone 6,OS=11.3"
XCODEGEN_VERSION = "1.8.0"
SOURCERY_VERSION = "0.13.0"

def git
  Git.open(".")
end

def generate_docs
  print "Generating docs"
  sh "swift package generate-xcodeproj"
  sh "jazzy --clean --sdk macosx --xcodebuild-arguments -project,xcproj.xcodeproj,-scheme,xcproj-Package --skip-undocumented"
end

def any_git_changes?
  !git.status.changed.empty?
end

def command?(name)
  `which #{name}`
  $?.success?
end

def build
  sh "swift build"
end

def build_carthage_project
  sh "xcodebuild -project Carthage.xcodeproj -scheme xcproj_macOS -config Debug clean build"
  sh "xcodebuild -project Carthage.xcodeproj -scheme xcproj_iOS -config Debug -destination '#{DESTINATION}' clean build"
end

task :carthage do
  build_carthage_project()
end

def test_swift
  sh "xcodebuild -project xcproj.xcodeproj -scheme xcproj-Package -only-testing:xcprojTests -config Debug test -enableCodeCoverage YES"
end

def test_swift_integration
  sh "swift test --filter xcprojIntegrationTests"
end

def test_ruby
  sh "bundle exec rspec"
end

def current_version
  last_tag = `git describe --tags $(git rev-list --tags --max-count=1)`
  Semantic::Version.new last_tag
end

def next_version(type)
  current_version.increment! type
end

def bump_to_version(from, to)
  spec_path = "xcproj.podspec"
  content = File.read(spec_path)
  File.open(spec_path, "w"){|f| f.write(content.sub(from.to_s, to.to_s)) }
end

def pod_lint
  sh "bundle exec pod install --project-directory=CocoaPods/"
  sh "xcodebuild -workspace CocoaPods/CocoaPods.xcworkspace -scheme macOS -config Debug clean build"
  sh "xcodebuild -workspace CocoaPods/CocoaPods.xcworkspace -scheme iOS -config Debug -destination '#{DESTINATION}' clean build"
end

def commit_changes_and_push(tag)
  git.add "."
  git.commit "Bump version to #{tag.to_string}"
  if tag
    git.add_tag(tag.to_string)
  end
  git.push('origin', "refs/tags/#{tag.to_string}")
end

def generate_carthage_project
  throw "Mint is necessary. Make sure it's installed in your system" unless command?("mint")
  sh "mint run yonaskolb/xcodegen@#{XCODEGEN_VERSION} 'xcodegen --spec carthage-project.yml'"
end

def is_macos
  !ENV["TRAVIS_OS_NAME"] || ENV["TRAVIS_OS_NAME"] == "osx"
end

def print(message)
  puts "> #{message.colorize(:yellow)}"
end

desc "Generates the Carthage project"
task :generate_carthage_project do
  generate_carthage_project()
end

desc "Executes all the validation steps for CI"
task :ci do
  print "Generate Xcode project"
  sh "swift package generate-xcodeproj"
  print "Linting project"
  sh "swiftlint" if is_macos
  print "CocoaPods linting"
  pod_lint() if is_macos
  print "Building Carthage project"
  build_carthage_project() if is_macos
  print "Building the project"
  build()
  print "Executing tests"
  test_swift()
  test_ruby()
  if git.current_branch == "integration" || ENV["TRAVIS_BRANCH"] == "integration"
    print "Executing integration tests"
    test_swift_integration()
  end
end

desc "Branches off master into integration and pushes it to origin (only executable from master)"
task :deploy_to_integration do
   if git.current_branch == "master" || ENV["TRAVIS_BRANCH"] == "master"
    token = ENV["GITHUB_TOKEN"]
    return abort("GITHUB_TOKEN environment variable is missing") unless token
    git.add_remote("origin-travis", "https://#{token}@github.com/xcodeswift/xcproj.git")
    git.push("origin-travis", "master:integration")
   end
end

desc "Bumps the version of xcproj. It creates a new tagged commit and archives the binary to be published with the release"
task :release do
  abort "You should specify the type (e.g. RELEASE_TYPE=minor rake task release)" unless ENV["RELEASE_TYPE"]
  # abort 'Commit all your changes before starting the release' unless !any_git_changes?
  print("Building xcproj")
  build
  print "Generating Carthage project"
  generate_carthage_project()
  print "Building Carthage project"
  build_carthage_project()
  print "Generating docs"
  generate_docs
  version = next_version(ENV["RELEASE_TYPE"].to_sym)
  print "Bumping version to #{version}"
  bump_to_version(current_version, version)
  print "Commiting and pushing changes to GitHub"
  commit_changes_and_push(version)
  print "Pushing new version to CocoaPods"
  sh "bundle exec pod trunk push --verbose --allow-warnings"
end

desc "Runs sourcery"
task :sourcery do
  throw "Mint is necessary. Make sure it's installed in your system" unless command?("mint")
  sh "mint run krzysztofzablocki/Sourcery@#{SOURCERY_VERSION} 'sourcery --config sourcery.yml'"
end

task :docs do
  generate_docs
end
