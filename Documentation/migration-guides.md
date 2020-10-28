# Migration guides

## To xcodeproj 6

xcodeproj 6 is the final step towards hiding the Xcode project implementation details. One of those details was the object unique identifiers, which you used to manage yourself with previous versions. Now, xcodeproj does it for you, so you don't have to pass them around to set dependencies between objects.

This improvement makes the API easier, safer and more convenient, but at the cost of introducing some breaking changes in the library. If want to migrate your project to use xcodeproj 6, these are the things that you should look at:

- `PBXObjectReference` is an internal class now. Object references to other objects are attributes with the type of the object that is being referred. For example, a `XCConfigurationList` object has an attribute `buildConfigurations` of type `XCBuildConfiguration`. Adding a new configuration is as easy as calling `list.buildConfigurations.append(config)`.
- Note that object references have different types of optionals based on the type of attribute:
  - **Implicitly unwrapped optional:** When the attribute is required by Xcode. [Example](https://github.com/tuist/xcodeproj/blob/main/Sources/XcodeProj/Objects/Project/PBXProject.swift#L38)
  - **Explicitly unwrapped optional:** When the attribute is optional by Xcode. [Example](https://github.com/tuist/xcodeproj/blob/main/Sources/XcodeProj/Objects/Targets/PBXTargetDependency.swift#L11)
- `PBXObjects` has also been made internal. It was exposed through the attribute `objects` on the `PBXProj` class. If you used to use this class for adding, removing, or getting objects, those methods have been moved to the `PBXProj` class - [Public helpers](https://github.com/tuist/xcodeproj/blob/main/Sources/XcodeProj/Objects/Project/PBXProj.swift#L85)

**And yes, in case you are wondering, it fully supports Xcode 10 🎉**

## To xcodeproj 5

`xcodeproj` 5 is a major release with important changes in the API focused on making it more convenient, and simplify the references handling. This version hasn't been officially released yet but you can already start updating your project for the new version. These are the changes you'd need to make in your projects:

- `xcproj` has been renamed to `xcodeproj` so you need to update all your import statements to use the new name.
- There's no support for Carthage nor CocoaPods anymore, if you were using them for fetching `xcodeproj`, you can use the Swift Package Manager and manually setup the dependency.
- We've replaced `Path` with `AbsolutePath` and `RelativePath` from the Swift Package Manager's `Basic` framework. You might need to change some of the usages to use the new type.
- Reference attributes have been renamed to use the naming convention `attributeReference` where `attribute` is the name of the attribute. If you are interested in materializing the reference to get the object, objects provide convenient getters that you can use for that purpose. Those getters throw if the object is not found in the project.

There are some useful additions to the API that you can check out on the [CHANGELOG](https://github.com/tuist/xcodeproj/blob/main/CHANGELOG.md).

One of those additions is an improvement on how references are managed.
When new objects are added to the project, you get the object reference. The reference is an instance that should be used to refer that object from any other. **The value of that reference is an implementation detail that has been abstracted away from you.**
