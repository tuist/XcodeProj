# Introduction

### Welcome dear contributor!

First off, thank you for considering contributing to xcodeproj. It's people like you that make xcodeproj such a great tool.

### Why reading the guidelines is important

Following these guidelines helps to communicate that you respect the time of the developers managing and developing this open source project. In return, they should reciprocate that respect in addressing your issue, assessing changes, and helping you finalize your pull requests.

### A good contribution

xcodeproj is an open source project and we love to receive contributions from our community — you! There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests or writing code which can be incorporated into xcodeproj itself.

# Ground Rules

* Ensure that changes in the project are tested.
* Before merging, all the checks on GitHub should pass.
* Create issues for any major changes and enhancements that you wish to make. Discuss things transparently and get community feedback.
* Don't add any classes to the codebase unless absolutely needed.
* Keep feature versions as small as possible, preferably one new feature per version.
* Be welcoming to newcomers and encourage diverse new contributors from all backgrounds.
* Comply the [code of conduct](https://github.com/swift-xcode/xcodeproj/blob/master/CODE_OF_CONDUCT.md) when you participate in the project.

# Your First Contribution

Unsure where to begin contributing to xcodeproj? You can start by looking through these easy and thread issues:

- **difficulty:easy** - issues which should only require a few lines of code, and a test or two.
- **type:thread** - issues which should be a bit more involved than beginner issues.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

Working on your first Pull Request? You can learn how from this *free* series, [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github).

At this point, you're ready to make your changes! Feel free to ask for help; everyone is a beginner at first :smile_cat:

# Getting started

1. Create your own fork of the code and follow the steps in the `README` to set it up.
2. Do the changes in your fork
3. If you like the change and think the project could use it:
    * Be sure you have followed the code style for the project.
    * Make sure `bundle exec rake ci` passes.

As a rule of thumb, changes are obvious fixes if they do not introduce any new functionality or creative thinking. As long as the change does not affect functionality, some likely examples include the following:

* Spelling / grammar fixes
* Typo correction, white space and formatting changes
* Comment clean up
* Bug fixes that change default return values or error codes stored in constants
* Adding logging messages or debugging output
* Changes to ‘metadata’ files like Gemfile, .gitignore, build scripts, etc.
* Moving source files from one directory or package to another

# How to report a bug

If you find a security vulnerability, do NOT open an issue. Email [pepibumur@gmail.com](mailto://pepibumur@gmail.com) instead.

If you don’t want to use your personal contact information, set up a “security@” email address. Larger projects might have more formal processes for disclosing security, including encrypted communication.

### How to file a bug report

When filing an issue, make sure to answer these five questions:

1. What version of Xcode/Swift are you using?
2. What operating system and processor architecture are you using?
3. What did you do?
4. What did you expect to see?
5. What did you see instead?

# How to suggest a feature or enhancement

Before suggesting a new feature, make sure that it aligns with the project philosophy, providing an API to interact with Xcode projects files.

If you find yourself wishing for a feature that doesn't exist in xcodeproj, you are probably not alone. There are bound to be others out there with similar needs. Many of the features that xcodeproj has today have been added because our users saw the need. Open an issue on our issues list on GitHub which describes the feature you would like to see, why you need it, and how it should work.

# Code review process

The core team looks at Pull Requests on a regular basis.

After feedback has been given we expect responses within two weeks. After two weeks we may close the pull request if it isn't showing any activity.

# Community

You can chat with the core team on Slack. You can join the group on the [following link](https://swift-xcode.herokuapp.com).

# Conventions

### Commit message
- Commit message should include the issue number together with the commit message: `[#number] commit message`.
