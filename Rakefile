#!/usr/bin/rake

require 'fileutils'
require 'colorize'

task :style_correct do
  system("swiftformat .")
  system("swiftlint autocorrect")
end

task :release_check do
  puts "Running tests".colorize(:cyan)
  system("swift test")

  puts "Building for release".colorize(:cyan)
  system("swift build -c release")
end

def system(*args)
  Kernel.system(*args) || abort
end
