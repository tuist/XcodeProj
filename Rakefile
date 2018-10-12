#!/usr/bin/rake

require 'fileutils'
require 'colorize'

desc "Last check before releasing the app"
task :ci do
  puts "Linting code".colorize(:cyan)
  system("swiftlint") || abort

  puts "Running tests".colorize(:cyan)
  system("swift test") || abort

  puts "Building for release".colorize(:cyan)
  system("swift build -c release") || abort

  puts "Linting podspec".colorize(:cyan)
  system("pod spec lint") || abort

  puts "Compiling Carthage project".colorize(:cyan)
  system("xcodeproj -project xcodeproj-Carthage.xcodeproj -scheme xcodeproj") || abort
end
