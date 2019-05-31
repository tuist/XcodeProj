# Changelog
if !git.modified_files.include?("CHANGELOG.md")
  message = <<~MESSAGE
    Please include a CHANGELOG entry.
    You can find it at [CHANGELOG.md](https://github.com/tuist/xcodeproj/blob/master/CHANGELOG.md).
  MESSAGE
  fail(message, sticky: false)
end

# Linting
# swiftformat.additional_args = "--config .swiftformat"
# swiftformat.check_format(fail_on_error: true)
swiftlint.lint_files(fail_on_error: true)