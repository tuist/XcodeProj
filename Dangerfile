require_relative "Danger/carthage"

# Carthage
Danger::Plugins::Carthage.new(self).execute

# WIP
warn "PR is classed as Work in Progress" if github.pr_title.include? "[WIP]"

# Swiftlint
swiftlint.lint_files