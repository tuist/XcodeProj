
# Add a CHANGELOG entry for app changes
if !git.modified_files.include?("CHANGELOG.md") && has_app_changes
  fail("Please include a CHANGELOG entry. \nYou can find it at [CHANGELOG.md](https://github.com/xcodeswift/xcproj/blob/master/CHANGELOG.md).")
end

# Ensure a clean commits history
if git.commits.any? { |c| c.message =~ /^Merge branch/ }
fail('Please rebase to get rid of the merge commits in this PR')
end
