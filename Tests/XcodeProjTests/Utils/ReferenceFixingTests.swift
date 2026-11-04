import Foundation
import PathKit
import Testing
@testable import XcodeProj

/// Covers the bookkeeping that runs when temporary references are made permanent before a project is written: the
/// collection each object lives in, the generated reference values, and the digests and type names they are made of.
struct ReferenceFixingTests {
    @Test func md5_matchesKnownDigests() {
        // RFC 1321 test suite, plus multi-byte UTF-8 strings checked with `md5 -s`.
        #expect("".md5 == "d41d8cd98f00b204e9800998ecf8427e")
        #expect("abc".md5 == "900150983cd24fb0d6963f7d28e17f72")
        #expect("message digest".md5 == "f96b697d7cb7938d525a2f31aaf161d0")
        #expect("é".md5 == "66ddcd97cfdeabb2f6fb8a999b4bc76f")
        #expect("PBXBuildFile-Target-Ünïcödé-🚀".md5 == "74d6591936a96f0ff81738e1b8e80f6d")
    }

    @Test func md5_hashesBridgedStringsByTheirUTF8Bytes() {
        let bridged = NSMutableString(string: "PBXBuildFile-Target-")
        bridged.append("Ünïcödé-🚀")

        #expect((bridged as String).md5 == "74d6591936a96f0ff81738e1b8e80f6d")
    }

    @Test func isa_isTheUnqualifiedClassName() {
        #expect(PBXObject.isa == "PBXObject")
        #expect(PBXBuildFile.isa == "PBXBuildFile")
        #expect(PBXVariantGroup.isa == "PBXVariantGroup")
        #expect(XCVersionGroup.isa == "XCVersionGroup")
        #expect(PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet.isa == "PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet")
        let groupType: PBXFileElement.Type = PBXVariantGroup.self
        #expect(groupType.isa == "PBXVariantGroup")
    }

    #if os(macOS) || (os(Linux) && compiler(>=6.1))
        /// Writing a project whose references are all temporary moves every object it decodes to a permanent reference.
        @Test(arguments: [
            "iOS/Project.xcodeproj",
            "iOS/AppWithExtensions/AppWithExtensions.xcodeproj",
            "iOS/ProjectWithXCLocalSwiftPackageReferences.xcodeproj",
            "SynchronizedRootGroups/SynchronizedRootGroups.xcodeproj",
            "TargetWithCustomBuildRules/TargetWithCustomBuildRules.xcodeproj",
            "Xcode16ProjectReferenceOrder/Test.xcodeproj",
        ])
        func writingAProjectWithTemporaryReferences_keepsEveryObject(fixture: String) throws {
            let pbxproj = try PBXProj(path: fixturesPath() + fixture + "project.pbxproj")
            let objects = objectCountsByType(pbxproj.objects)
            pbxproj.objects.invalidateReferences()

            let data = try #require(try pbxproj.dataRepresentation())
            let written = try PBXProj(data: data)

            #expect(objectCountsByType(written.objects) == objects)
            #expect(!String(decoding: data, as: UTF8.self).contains("TEMP_"))
        }
    #endif

    @Test func fixingReferences_movesEachObjectToItsNewReference() throws {
        let pbxproj = PBXProj()
        let objects = makeOneObjectOfEachType()
        objects.forEach { pbxproj.add(object: $0.object) }
        // One generator for every type, so the type name and prefix it caches for one type can't leak into another.
        let generator = ReferenceGenerator(outputSettings: PBXOutputSettings(projReferenceFormat: .withPrefixAndSuffix))

        for (object, typeName, acronym) in objects {
            let temporaryValue = object.reference.value
            generator.fixReference(for: object, identifiers: ["id"])

            #expect(object.reference.value == "\(acronym)_\("\(typeName)-id".md5.uppercased())")
            #expect(pbxproj.objects.get(reference: PBXObjectReference(object.reference.value)) === object)
            #expect(pbxproj.objects.get(reference: PBXObjectReference(temporaryValue)) == nil)
        }
        #expect(objectCount(pbxproj.objects) == objects.count)
    }

    @Test func fixingAReference_whoseObjectTypeHasNoCollection_leavesTheCollectionsUnchanged() {
        let pbxproj = PBXProj()
        pbxproj.add(object: PBXFileReference(name: "A.swift"))
        let element = PBXFileElement(name: "Element")
        element.reference.objects = pbxproj.objects

        element.reference.fix("ELEMENT")

        #expect(element.reference.value == "ELEMENT")
        #expect(pbxproj.objects.get(reference: PBXObjectReference("ELEMENT")) == nil)
        #expect(objectCount(pbxproj.objects) == 1)
    }

    @Test func referenceHash_followsItsValue() throws {
        let reference = PBXObjectReference()

        reference.fix("A")
        #expect(reference.hash == PBXObjectReference("A").hash)
        #expect(Set([PBXObjectReference("A")]).contains(reference))

        reference.invalidate()
        #expect(reference.hash == PBXObjectReference(reference.value).hash)
        #expect(!Set([PBXObjectReference("A")]).contains(reference))

        let copy = try #require(reference.copy() as? PBXObjectReference)
        #expect(copy == reference)
        #expect(copy.hash == reference.hash)
    }

    @Test func buildPhaseFile_hasOneEntryPerBuildFile_inAPhaseThatListsIt() throws {
        let pbxproj = PBXProj()
        let fileA = PBXFileReference(name: "A.swift")
        let fileB = PBXFileReference(name: "B.png")
        let buildFileA = PBXBuildFile(file: fileA)
        let buildFileB = PBXBuildFile(file: fileB)
        let sources = PBXSourcesBuildPhase(files: [buildFileA, buildFileB, buildFileA])
        let resources = PBXResourcesBuildPhase(files: [buildFileB])
        [fileA, fileB, buildFileA, buildFileB, sources, resources].forEach { pbxproj.add(object: $0) }

        let buildPhaseFile = pbxproj.objects.buildPhaseFile

        #expect(buildPhaseFile.count == 2)
        #expect(buildPhaseFile[buildFileA.reference]?.buildFile === buildFileA)
        #expect(buildPhaseFile[buildFileA.reference]?.buildPhase === sources)
        let phaseOfB = try #require(buildPhaseFile[buildFileB.reference]?.buildPhase)
        #expect(phaseOfB === sources || phaseOfB === resources)
    }

    // MARK: - Helpers

    private func objectCountsByType(_ objects: PBXObjects) -> [String: Int] {
        var counts: [String: Int] = [:]
        objects.forEach { counts[String(describing: type(of: $0)), default: 0] += 1 }
        return counts
    }

    private func objectCount(_ objects: PBXObjects) -> Int {
        var count = 0
        objects.forEach { _ in count += 1 }
        return count
    }

    /// One object of every type `PBXObjects` stores, with the type name and reference prefix the generator should use.
    private func makeOneObjectOfEachType() -> [(object: PBXObject, typeName: String, acronym: String)] {
        let fileReference = PBXFileReference(name: "A.swift")
        let target = PBXNativeTarget(name: "App")
        let sourcesBuildPhase = PBXSourcesBuildPhase()
        let configurationList = XCConfigurationList()
        let remotePackage = XCRemoteSwiftPackageReference(repositoryURL: "https://example.com/package")
        let containerItemProxy = PBXContainerItemProxy(containerPortal: .fileReference(fileReference))
        return [
            (fileReference, "PBXFileReference", "FR"),
            (target, "PBXNativeTarget", "NT"),
            (sourcesBuildPhase, "PBXSourcesBuildPhase", "SBP"),
            (configurationList, "XCConfigurationList", "CL"),
            (remotePackage, "XCRemoteSwiftPackageReference", "RSPR"),
            (containerItemProxy, "PBXContainerItemProxy", "CIP"),
            (PBXBuildFile(file: fileReference), "PBXBuildFile", "BF"),
            (PBXAggregateTarget(name: "Aggregate"), "PBXAggregateTarget", "AT"),
            (PBXLegacyTarget(name: "Legacy"), "PBXLegacyTarget", "LT"),
            (PBXCopyFilesBuildPhase(), "PBXCopyFilesBuildPhase", "CFBP"),
            (PBXGroup(), "PBXGroup", "G"),
            (PBXVariantGroup(), "PBXVariantGroup", "VG"),
            (XCVersionGroup(), "XCVersionGroup", "VG"),
            (XCBuildConfiguration(name: "Debug"), "XCBuildConfiguration", "BC"),
            (PBXTargetDependency(target: target), "PBXTargetDependency", "TD"),
            (PBXShellScriptBuildPhase(), "PBXShellScriptBuildPhase", "SSBP"),
            (PBXResourcesBuildPhase(), "PBXResourcesBuildPhase", "RBP"),
            (PBXFrameworksBuildPhase(), "PBXFrameworksBuildPhase", "FBP"),
            (PBXHeadersBuildPhase(), "PBXHeadersBuildPhase", "HBP"),
            (PBXRezBuildPhase(), "PBXRezBuildPhase", "RBP"),
            (PBXProject(
                name: "Project",
                buildConfigurationList: configurationList,
                compatibilityVersion: nil,
                preferredProjectObjectVersion: nil,
                minimizedProjectReferenceProxies: nil,
                mainGroup: PBXGroup()
            ), "PBXProject", "P"),
            (PBXReferenceProxy(remote: containerItemProxy), "PBXReferenceProxy", "RP"),
            (PBXBuildRule(compilerSpec: "spec", fileType: "type"), "PBXBuildRule", "BR"),
            (XCLocalSwiftPackageReference(relativePath: "Package"), "XCLocalSwiftPackageReference", "LSPR"),
            (XCSwiftPackageProductDependency(productName: "Product", package: remotePackage), "XCSwiftPackageProductDependency", "SPPD"),
            (PBXFileSystemSynchronizedRootGroup(path: "Sources"), "PBXFileSystemSynchronizedRootGroup", "FSSRG"),
            (PBXFileSystemSynchronizedBuildFileExceptionSet(
                target: target,
                membershipExceptions: nil,
                publicHeaders: nil,
                privateHeaders: nil,
                additionalCompilerFlagsByRelativePath: nil,
                attributesByRelativePath: nil
            ), "PBXFileSystemSynchronizedBuildFileExceptionSet", "FSSBFES"),
            (PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet(
                buildPhase: sourcesBuildPhase,
                membershipExceptions: nil,
                attributesByRelativePath: nil
            ), "PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet", "FSSGBPMES"),
        ]
    }
}
