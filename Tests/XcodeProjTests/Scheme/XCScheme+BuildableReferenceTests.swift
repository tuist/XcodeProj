@testable import XcodeProj
import XCTest

final class XCSchemeBuildableReferenceTests: XCTestCase {
    func test_hash() throws {
        // Values that are equal must generate the same hash value
        let aBuildRef = XCScheme.BuildableReference(
            referencedContainer: "container ref",
            blueprint: nil,
            buildableName: "buildable name",
            blueprintName: "blueprint name"
        )
        let bBuildRef = XCScheme.BuildableReference(
            referencedContainer: "container ref",
            blueprint: nil,
            buildableName: "buildable name",
            blueprintName: "blueprint name"
        )
        XCTAssertEqual(aBuildRef, bBuildRef)

        let buildRefs: Set<XCScheme.BuildableReference> = [aBuildRef]
        XCTAssertTrue(buildRefs.contains(bBuildRef))
    }
}
