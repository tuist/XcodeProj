# Releasing

In this document you'll find all the necessary steps to release a new version of `xcodeproj`:

1. Make sure you are in the `main` branch.
2. Determine the next version based on the unreleased changes.
3. Add the version section to the `CHANGELOG.md`, update the versions in the `README.md` and the `xcodeproj.podspec` file.
4. Commit the changes and tag them `git commit -m "Version x.y.z"` & `git tag x.y.z`.
5. Push the changes `git push origin main --tags`
6. Run the release checks by running `bundle exec rake release_check`.
8. Create the release on GitHub including the release notes from the `CHANGELOG.md`.
