#!/usr/bin/rake

require 'semantic'
require 'colorize'

### HELPERS ###

def generate_docs
  sh "jazzy --clean --sdk macosx --xcodebuild-arguments -scheme,xcodeproj --skip-undocumented --no-download-badge"
end

def any_git_changes?
  !`git status -s`.empty?
end

def build
  sh "swift build"
end

def commit_and_push
  last_tag = `git describe --abbrev=0 --tags`
  current_version = Semantic::Version.new last_tag
  new_version = current_version.increment! :patch
  `git add .`
  `git commit -m "Bump version to #{new_version}"`
  `git tag #{new_version}`
  `git push origin --tags`
  new_version
end

def print(message)
  puts message.colorize(:yellow)
end

### TASKS ###

desc "Bumps the version of xcodeprojlint. It creates a new tagged commit and archives the binary to be published with the release"
task :release => [:clean] do
  abort '> Commit all your changes before starting the release' unless !any_git_changes?
  build
  print "> xcodeproj built"
  generate_docs
  print "> Documentation generated"
  version = commit_and_push
  print "> Commit created and tagged with version: #{version}"
end

task :docs do
  generate_docs
end
