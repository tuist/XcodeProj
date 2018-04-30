require_relative "Danger/carthage"

# Organization Dangerfile
danger.import_dangerfile(gem: 'danger-xcodeswift')

# Carthage
Danger::Plugins::Carthage.new(self).execute

# WIP
warn "PR is classed as Work in Progress" if github.pr_title.include? "[WIP]"

# Swiftlint
swiftlint.lint_files