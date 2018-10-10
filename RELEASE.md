# Releasing

In this documents you'll find all the necessary steps to release a new version of `xcodeproj`.

> Although some of the steps have been automated, there are some of them that need to be executed manually.

1. Validate the state of the project by running `bundle exec rake ci`
2. Update the `CHANGELOG.md` adding a new entry at the top with the next version. Make sure that all the changes in the version that is about to be released are properly formatted. Commit the changes in `CHANGELOG.md`.
3. Generate the documentation by running [this script](https://github.com/tuist/jazzy-theme).
4. Commit, tag and push the changes to GitHub.
5. Create a new release on [GitHub](https://github.com/tuist/xcodeproj) including the information from the last entry in the `CHANGELOG.md`.

### Notes
- If any of the steps above is not clear above do not hesitate to propose improvements.
- Release should be done only by authorized people that have rights to crease releases in this repository and commiting changes to the Tap repository.
