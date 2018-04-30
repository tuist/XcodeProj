require_relative "Danger/carthage"

# Organization Dangerfile
danger.import_dangerfile(gem: 'danger-xcodeswift')

# Carthage
Danger::Plugins::Carthage.new(self).execute

# Swiftlint
swiftlint.lint_files