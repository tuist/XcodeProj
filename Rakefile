#!/usr/bin/rake

require 'semantic'
require 'colorize'

### HELPERS ###

def generate_docs
  print "> Executing tests"
  sh "swift package generate-xcodeproj"
  sh "jazzy --clean --sdk macosx --xcodebuild-arguments -scheme,xcodeproj --skip-undocumented --no-download-badge"
end

def any_git_changes?
  !`git status -s`.empty?
end

def build
  sh "swift build"
end

def current_version
  last_tag = `git describe --abbrev=0 --tags`
  Semantic::Version.new last_tag
end

def next_version
  current_version.increment! :patch
end

def bump_to_version(from, to)
  File.open("xcodeproj.podspec", "w"){|f| f.write(content.sub(from, to)) }
  `git add .`
  `git commit -m "Bump version to #{to}"`
  `git tag #{to}`
  `git push origin --tags`
end

def print(message)
  puts message.colorize(:yellow)
end

### TASKS ###

desc "Removes the build folder"
task :clean do
  print "> Cleaning build/ folder"
  `rm -rf build`
end

desc "Executes all the validation steps for CI"
task :ci => [:clean] do
  print "> Linting project"
  sh "swiftlint"
  print "> Building the project"
  sh "swift build"
  print "> Executing tests"
  sh "swift test"
end

desc "Bumps the version of xcodeprojlint. It creates a new tagged commit and archives the binary to be published with the release"
task :release => [:clean] do
  abort '> Commit all your changes before starting the release' unless !any_git_changes?
  build
  print "> xcodeproj built"
  generate_docs
  print "> Documentation generated"
  version = next_version
  bump_to_version(current_version, next_version)
  print "> Commit created and tagged with version: #{version}"
  print "> Pushing new version to CocoaPods"
  sh "bundle exec pod trunk push --verbose --allow-warnings"
end

task :docs do
  generate_docs
end
