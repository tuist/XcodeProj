# The JSON project format (`project.xcproj`)

> [!WARNING]
> This support is experimental. Xcode 27.2 is the first release that writes the format, so the
> mapping described here has only been verified against Apple's own library and hand written
> projects, not against a corpus of real Xcode output. The API and the conversion details may still
> change, and a converted project is worth checking before you commit it.

Xcode 27.2 can store a project as JSON in `project.xcproj` instead of the property list in
`project.pbxproj`. You turn it on in the file inspector, and projects that use it still open in
earlier Xcode 27 releases. Apple documents and implements the format in
[apple/xcode-project-format](https://github.com/apple/xcode-project-format).

XcodeProj reads and writes both formats through the same `PBXProj` object graph, so code that
already uses this library keeps working unchanged.

## Opening a project

`XcodeProj(path:)` looks for `project.pbxproj` first and falls back to `project.xcproj`. The format
it found is available as `projectFormat`.

```swift
let project = try XcodeProj(path: "MyApp.xcodeproj")
print(project.projectFormat)      // .pbxproj or .xcproj
print(project.pbxproj.rootObject?.targets.map(\.name) ?? [])
```

## Writing a project

`write(path:)` uses the format the project was read in, so an unchanged project is written back
byte for byte. Pass `format:` to convert.

```swift
// Keep whatever format the project already uses.
try project.write(path: "MyApp.xcodeproj")

// Convert an existing project to JSON.
try project.write(path: "MyApp.xcodeproj", format: .xcproj)

// Convert back.
try project.write(path: "MyApp.xcodeproj", format: .pbxproj)
```

Writing removes only the file it produces, so converting leaves the old file behind. Delete it
yourself, or write to a fresh directory.

`PBXProj` exposes the conversion directly when you do not need the surrounding bundle.

```swift
let proj = try PBXProj(xcprojPath: "MyApp.xcodeproj/project.xcproj")
let data = try proj.xcprojData()
```

## Object identifiers

The JSON format prefers name based references such as `"App/compile-sources"` over the UUIDs the
property list uses, which is most of what makes its diffs readable. XcodeProj writes an identifier
only where the format requires one, or where a name would be ambiguous, which matches what Xcode
itself produces.

Pass `.preserveAll` when you are migrating a project and want every existing UUID to survive the
conversion. The file gets considerably noisier, so this is meant for one-off migrations and
debugging rather than day to day use.

```swift
try project.write(
    path: "MyApp.xcodeproj",
    format: .xcproj,
    xcprojOutputSettings: XCProjOutputSettings(objectIDPolicy: .preserveAll)
)
```

Objects that arrive without an identifier get the same deterministic identifiers a generated
project would get, so converting to `project.pbxproj` produces stable output.

## Build settings

`project.xcproj` keeps one flat dictionary of build settings per project and per target, and marks
the values that differ between build configurations with a `config=` condition. `PBXProj` keeps one
dictionary per `XCBuildConfiguration`. XcodeProj moves that condition in and out of the key as it
converts.

| `project.xcproj`                    | `project.pbxproj`                                  |
| ----------------------------------- | -------------------------------------------------- |
| `"SDKROOT": "iphoneos"`             | `SDKROOT` in every configuration                    |
| `"ONLY_ACTIVE_ARCH[config=Debug]"`  | `ONLY_ACTIVE_ARCH` in the `Debug` configuration     |
| `"FLAGS[config=Debug][sdk=ios*]"`   | `FLAGS[sdk=ios*]` in the `Debug` configuration      |

A `config=` condition that names no configuration, such as the wildcard `config=*`, has no single
configuration to move to. It stays on the key and applies to every configuration.

## What does not survive a conversion

The two formats hold the same project model, but the property list carries a few values that the
JSON schema has no place for. Converting a `project.pbxproj` to `project.xcproj` drops them.

- The `name` of a file reference when it differs from the last component of its path. This is most
  visible on the children of a variant group, where Xcode uses the language as the name and derives
  it from the `.lproj` directory in the path instead.
- `lastKnownFileType`, which is Xcode's own guess from the file extension. An explicit
  `explicitFileType` is kept.
- The editor settings of a file element: `usesTabs`, `indentWidth`, `tabWidth` and `wrapsLines`.
- `productName` on a target, `buildActionMask` on a build phase and `isEditable` on a build rule.
- `compatibilityVersion`, `projectDirPath`, `projectRoot`, `hasScannedForEncodings` and
  `defaultConfigurationIsVisible`.
- The order of files inside a build phase. The JSON format records each membership on the file, so
  the order is rebuilt by walking the groups and files tree.
- `archiveVersion`, `objectVersion` and `preferredProjectObjectVersion`, which the JSON format does
  not store. A project read from `project.xcproj` gets object version 77.
- `CreatedOnToolsVersion` and `BuildIndependentTargetsInParallel` from the project attributes. The
  second one only records the default, so the behaviour is unchanged.
- The identifiers of the objects that exist only in the property list model: container item proxies,
  target dependencies, Swift package references and the exception sets of a synchronized folder. The
  JSON format expresses those relations inline, so there is nothing to hang an identifier on, and
  even `.preserveAll` regenerates them. The identifiers they *point at*, such as a remote target or
  an imported product, are kept.

Converting in the other direction keeps everything the property list can hold, with two caveats.

- `required-capabilities` has no place in `PBXProj`, so a project written back to `project.xcproj`
  loses the entries it arrived with. A capability this version of Apple's library does not
  recognise stops the read instead, with an error telling you which Xcode feature the project needs.
- A single `platformFilter` on a build file or dependency comes back as the plural
  `platformFilters` list Xcode uses today. The meaning is the same.

## What raises an error

A few things exist in one format and not the other. Rather than convert them to something close,
XcodeProj raises `XCProjError` so the gap is visible.

- The `apple-script` and `java-archive` build phases have no `PBXProj` type.
- The `code-generation-visibility` and `decompress` build file attributes have no established
  `project.pbxproj` spelling, and an `ATTRIBUTES` token this library does not know is rejected
  rather than guessed at. The known tokens are `Public`, `Private`, `Weak`, `CodeSignOnCopy`,
  `RemoveHeadersOnCopy`, `Client`, `Server` and `no_codegen`.
- Copy files destinations outside the ten Xcode offers in its build phase editor, such as the
  headers directories and the Info.plist file.
- The `preserve` line ending style.
- Asset tags in a synchronized folder's exception sets, and platform filters in its build phase
  exception sets, which the property list exception set types have no field for.
- A name based reference that matches no element, or more than one.

## Requirements

Apple's package needs Swift 6.1, macOS 14 and iOS 17, so XcodeProj now requires the same.
