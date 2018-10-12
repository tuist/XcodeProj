#!/usr/bin/rake

require 'fileutils'
require 'colorize'

task :release_check do
  puts "Linting code".colorize(:cyan)
  system("swiftlint") || abort

  puts "Running tests".colorize(:cyan)
  system("swift test") || abort

  puts "Building for release".colorize(:cyan)
  system("swift build -c release") || abort

  puts "Compiling Carthage project".colorize(:cyan)
  system("xcodeproj -project xcodeproj-Carthage.xcodeproj -scheme xcodeproj") || abort
end

task :carthage_update_dependencies do
  system("carthage update --platform macOS") || abort
end
