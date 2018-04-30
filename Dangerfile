require_relative "Danger/carthage"

danger.import_dangerfile(gem: 'danger-xcodeswift')

Danger::Plugins::Carthage.new(self).execute

# WIP
warn "PR is classed as Work in Progress" if github.pr_title.include? "[WIP]"