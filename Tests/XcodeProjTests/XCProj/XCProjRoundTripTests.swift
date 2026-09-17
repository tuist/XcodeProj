import Foundation
import PathKit
import Testing
import XcodeProjectFormat
@testable import XcodeProj

/// Reads a `project.xcproj`, converts it to a `PBXProj` and back, and checks that nothing changed.
///
/// The fixture is already in the canonical form `xcprojformatter` produces, so a byte comparison is
/// a fair test of the whole pipeline.
@Suite struct XCProjRoundTripTests {
    @Test func roundTripProducesAnIdenticalFile() throws {
        let original = try Data(contentsOf: everythingXCProjPath.url)
        let proj = try PBXProj(xcprojData: original, projectName: "Everything")
        let rewritten = try proj.xcprojData()

        #expect(String(data: rewritten, encoding: .utf8) == String(data: original, encoding: .utf8))
    }

    @Test func roundTripPreservesTheSchemaModel() throws {
        let data = try Data(contentsOf: everythingXCProjPath.url)
        let original = try XCSchema.Project(jsonRepresentation: data)
        let proj = try PBXProj(xcprojData: data, projectName: "Everything")
        let rewritten = try XCProjEncoder(proj: proj, settings: .default).encode()

        #expect(rewritten == original)
    }

    @Test func roundTripWithPreservedIdentifiersIsStillReadable() throws {
        let proj = try PBXProj(xcprojPath: everythingXCProjPath)
        let withIDs = try proj.xcprojData(settings: XCProjOutputSettings(objectIDPolicy: .preserveAll))

        // Every object now carries its UUID, and the file still decodes into the same project.
        let reread = try PBXProj(xcprojData: withIDs, projectName: "Everything")
        #expect(reread.rootObject?.targets.map(\.name) == proj.rootObject?.targets.map(\.name))
        #expect(
            reread.rootObject?.mainGroup.children.map { XCProjEncoder.name(of: $0) }
                == proj.rootObject?.mainGroup.children.map { XCProjEncoder.name(of: $0) }
        )
    }
}

/// Round trips a `project.xcproj` shaped the way Xcode writes one for a new iOS app: a synchronized
/// folder, a products group with no path, a product addressed through the `<PRODUCTS>` base, and
/// build settings conditional on the SDK.
@Suite struct XCProjXcodeShapedRoundTripTests {
    @Test func roundTripProducesAnIdenticalFile() throws {
        let original = try Data(contentsOf: xcodeGeneratedXCProjPath.url)
        let proj = try PBXProj(xcprojData: original, projectName: "SampleApp")
        #expect(try String(data: proj.xcprojData(), encoding: .utf8) == String(data: original, encoding: .utf8))
    }

    @Test func decodeReadsTheShapeXcodeWrites() throws {
        let proj = try PBXProj(xcprojPath: xcodeGeneratedXCProjPath)
        let project = try #require(proj.rootObject)

        // A products group carries a name and no path.
        let products = try #require(project.mainGroup.children.last as? PBXGroup)
        #expect(products.name == "Products")
        #expect(products.path == nil)

        // The product lives in the build products directory and is kept out of the index.
        let target = try #require(project.targets.first)
        #expect(target.product?.path == "SampleApp.app")
        #expect(target.product?.sourceTree == .buildProductsDir)
        #expect(target.product?.includeInIndex == false)
        #expect(target.product?.uuid == "000000000000000000000120")

        // The whole source tree is one synchronized folder.
        #expect(target.fileSystemSynchronizedGroups?.map(\.path) == ["SampleApp"])

        // A setting conditional on the SDK keeps its condition and reaches every configuration.
        let debug = try #require(target.buildConfigurationList?.buildConfigurations.first { $0.name == "Debug" })
        let release = try #require(target.buildConfigurationList?.buildConfigurations.first { $0.name == "Release" })
        let key = "INFOPLIST_KEY_UIStatusBarStyle[sdk=iphoneos*]"
        #expect(debug.buildSettings[key] == .string("UIStatusBarStyleDefault"))
        #expect(release.buildSettings[key] == .string("UIStatusBarStyleDefault"))

        // A setting conditional on the configuration reaches only that one.
        let projectDebug = try #require(project.buildConfigurationList?.buildConfigurations.first { $0.name == "Debug" })
        let projectRelease = try #require(project.buildConfigurationList?.buildConfigurations.first { $0.name == "Release" })
        #expect(projectDebug.buildSettings["SWIFT_OPTIMIZATION_LEVEL"] == .string("-Onone"))
        #expect(projectRelease.buildSettings["SWIFT_OPTIMIZATION_LEVEL"] == nil)
    }

    @Test func encodeAlwaysIdentifiesTargetProducts() throws {
        // Another project can refer to a product, and such references are always identifier based,
        // so the identifier is written even though nothing inside this project needs it.
        let proj = try PBXProj(path: fixturesPath() + "iOS/Project.xcodeproj/project.pbxproj")
        let encoded = try XCProjEncoder(proj: proj, settings: .default).encode()
        for target in encoded.targets {
            guard let product = target.commonProperties.product else { continue }
            // The reference itself stays a readable name path.
            guard case .namePath = product else {
                Issue.record("Expected a name path for the product of \(target.name)")
                continue
            }
        }
        let productIDs = Self.productIdentifiers(in: encoded.topLevelReferences)
        #expect(productIDs.count == proj.rootObject?.targets.compactMap(\.product).count)
    }

    private static func productIdentifiers(in references: [XCSchema.Reference]) -> [XCSchema.ObjectID] {
        references.flatMap { reference -> [XCSchema.ObjectID] in
            switch reference {
            case let .group(group) where group.name == "Products":
                group.children.compactMap { child in
                    guard case let .fileReference(file) = child else { return nil }
                    return file.objectID
                }
            case let .group(group):
                productIdentifiers(in: group.children)
            default:
                []
            }
        }
    }
}

/// Converts a `project.pbxproj` to JSON and straight back, and checks that the object graph comes
/// out with the same identifiers.
///
/// This is the counterpart of the JSON round trip: together they show that neither direction is the
/// one that quietly loses information. Identifiers are the one thing the JSON format deliberately
/// leaves out, so `preserveAll` is what makes the comparison possible at all.
@Suite struct XCProjPropertyListRoundTripTests {
    static let fixtures = [
        "SynchronizedRootGroups/SynchronizedRootGroups.xcodeproj",
        "Xcode16BuildConfigurations/Xcode16BuildConfigurations.xcodeproj",
        "iOS/Project.xcodeproj",
    ]

    @Test(arguments: fixtures)
    func roundTripThroughJSONKeepsEveryIdentifier(fixture: String) throws {
        let projectPath = fixturesPath() + fixture
        let original = try XcodeProj(path: projectPath)

        let temporary = try Path.uniqueTemporary()
        let asJSON = temporary + "AsJSON.xcodeproj"
        try original.write(
            path: asJSON,
            format: .xcproj,
            xcprojOutputSettings: XCProjOutputSettings(objectIDPolicy: .preserveAll)
        )
        let reread = try XcodeProj(path: asJSON)

        #expect(Self.identifiers(of: original.pbxproj) == Self.identifiers(of: reread.pbxproj))
    }

    /// The `PBXProj` types the schema gives no identifier of their own, whichever policy is used.
    ///
    /// These exist only in the property list model: the JSON format expresses the same relations
    /// inline, so there is nothing to hang an identifier on and theirs are regenerated.
    private static let typesWithoutSchemaIdentifiers: Set<String> = [
        "PBXFileSystemSynchronizedBuildFileExceptionSet",
        "PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet",
        "PBXContainerItemProxy",
        "PBXTargetDependency",
        "XCRemoteSwiftPackageReference",
        "XCLocalSwiftPackageReference",
    ]

    private static func identifiers(of proj: PBXProj) -> [String: Set<String>] {
        var result: [String: Set<String>] = [:]
        // swiftformat:disable:next preferForLoop
        proj.objects.forEach { object in
            let kind = String(describing: type(of: object))
            guard !typesWithoutSchemaIdentifiers.contains(kind) else { return }
            result[kind, default: []].insert(object.uuid)
        }
        return result
    }
}
