# Getting started

If you want to use xcodeproj in your projects, you need to add the library as a dependency. xcodeproj supports the 3 major package/dependency managers used by the community: CocoaPods, Carthage and the SwiftPM. Depending on where you plan to use xcodeproj you might prefer one over the other, so that's a call that you need to make.

## 1. Adding the dependency/package

### CocoaPods

If you would like to integrate xcodeproj into your project using CocoaPods, you only need to add the following line to your `Podfile`:

```ruby
pod 'xcodeproj'
```

After that, you can run `pod install` *(or `bundle install` if you are using Bundler for managing your gems)* and you should get the latest version of xcodeproj integrated into your project.

### Carthage

If you are using Carthage instead, you can add the following file to the project `Cartfile`:

```bash
github "tuist/xcodeproj"
```

Then run `carthage update`. It'll pull the latest version available and compile a dynamic framework that you can link from your apps.

### Swift Package Manager

If you are developing a package instead *(with the SwiftPM)* you can integrate xcodeproj by adding the following line to the dependencies list of your `Package.swift`:

```
.package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.6.0")),
```

And update your target to include `xcodeproj` as a dependency. After that, you can run `swift build` or `swift package generate-xcodeproj` to check if the dependency was integrated properly.

### Bonus: swift-sh

Optionally, if you only plan to play with the library, you can do some scripting in a Swift file, and use [swift-sh](ttps://github.com/mxcl/swift-sh) that will make it possible to define xcodeproj as a third party dependency. Once you have swift-sh installed, you can create a Swift file and add the following lines at the top:

```swift
#!/usr/bin/swift sh
import Foundation
import XcodeProj  // @tuist
import PathKit
```

If you try to run the script from your terminal, the dependency will be fetch automatically and made available to the Swift file.

## 2. Read a project

The first thing that we are going to do is reading an existing project. A project is read using the `XcodeProj` class, whose constructor takes the path to the project that is being initialized:

```swift
import Foundation
import PathKit
import XcodeProj

let path = Path("/path/to/my/Project.xcodeproj") // Your project path
let xcodeproj = XcodeProj(path: path)
```

xcodeproj will parse and map the project structure into Swift classes that you can interact with.

## 3. Output the project targets

We the project already in memory, we are going to output all the targets that are part of the project:

```swift
let pbxproj = xcodeproj.pbxproj // Returns a PBXProj
pbxproj.nativeTargets.each { target in
  print(target.name)
}
```

Note that we are accessing the `pbxproj` from the project. Since the `project.pbxproj` file inside the `.xcodeproj` directory is the actual file that defines the project, xcodeproj follows the same hierarchy of files. Most of the time you'll be working with the `pbxproj` attribute of the project.

## 4. Create a new root group

Let's say we'd like to add a new group to the root of the project. First we'd need to obtain the representation of the project from the aforementioned `pbxproj` attribute:

```swift
let project = pbxproj.projects.first! // Returns a PBXProject
```

Unless a project has been malformated, `pbxproj` should contains at least the definition of the project in which the `pbxproj` is contained. As we'll see later, there can be more than one project.

A project object has attributes like the targets, the main group, or the build configuration. In this example we are adding the new group to the root of the project so we need to add is as a child of the project's root group:

```swift
let mainGroup = project.mainGroup
mainGroup.addGroup(named: "MyGroup")
```

Xcode will expect the `MyGroup` folder in the system to be relative from the project root directory. If the `MyGroup` directory doesn't exist, xcodeproj won't fail but you'll get a missing reference on Xcode when you look at the group in the project navigator section.

## 5. Write changes to disk

xcodeproj holds the changes in memory and they only get persisted when the developer indicates to do so. To write the project back to disk, the both the `xcodeproj` and `pbxproj` objects have a function, `write` that can be used to persist the changes. 

```swift
try xcodeproj.write(path: path)
```

If something goes wrong during the project writing, `write` will throw an error. In most cases, writing issues are related to misconfigured projects. For that reason it's important that you understand the modifications that we are introducing to your projects.

**Bear in mind that xcodeproj makes the process of configuring Xcode project more convenient, but doesn't prevent you from having to read and understand the Xcode project structure**