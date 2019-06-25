# Releasing

In this document you'll find all the necessary steps to release a new version of `xcodeproj`:

1. Re-generate the Carthage project with `tuist generate` *(Install [Tuist](https://github.com/tuist/tuist) if you don't have it installed already)*.
2. Update Carthage dependencies if they are outdated with `bundle exec rake carthage_update_dependencies`.
3. Validate the state of the project by running `bundle exec rake release_check`
4. Update the `CHANGELOG.md` adding a new entry at the top with the next version. Make sure that all the changes in the version that is about to be released are properly formatted.
5. Update the version in the `xcodeproj.podspec` and `README.md` files.
7. Commit, tag and push the changes to GitHub.
8. Create a new release on [GitHub](https://github.com/tuist/XcodeProj) including the information from the last entry in the `CHANGELOG.md`.
9. Push the changes to CocoaPods: `bundle exec pod trunk push --allow-warnings --verbose`.
10. Archive the Carthage framework by running `bundle exec rake arhive_carthage` and attach the `XcodeProj.framework.zip` to the GitHub release.
