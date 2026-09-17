# Documentation

In the following pages you'll find documentation that will help you understand Xcode projects and how to interact with them using xcodeproj.

- [Getting started](getting-started.md): If you are the type of person that likes to get the hands a bit dirty before reading documentation, this is a good place to start from to get a sense of what the interface of the library looks like. 
- [The JSON project format](json-project-format.md) *(experimental)*: Xcode 27.2 can store a project as JSON in `project.xcproj` instead of the property list in `project.pbxproj`. This document covers how xcodeproj reads and writes both, how to convert between them, and what a conversion does not carry over.
- [Migration guides](migration-guides.md): If you are already using a version of xcodeproj and would like to migrate to the newest version, this document describes the necessary steps that you need to take to migrate between versions.

<!-- - [Xcode projects](xcode-projects.md): It's crucial that one understands some basics around Xcode projects. xcodeproj makes it easy to modify those files providing a Swift API but doesn't prevent prevent you from having to learn about Xcode projects. -->
