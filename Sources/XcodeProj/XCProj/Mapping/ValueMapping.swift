import Foundation
import XcodeProjectFormat

// MARK: - Marketing version

extension XCSchema.MarketingVersion {
    /// Parses the four digit form Xcode writes into project attributes such as `LastUpgradeCheck`.
    ///
    /// Xcode packs the version as two digits of major, one of minor and one of update, so `1600`
    /// is 16.0 and `0920` is 9.2.
    init?(projectAttributeValue value: String) {
        guard let packed = Int(value), packed >= 0 else { return nil }
        self.init(major: packed / 100, minor: (packed / 10) % 10, update: packed % 10)
    }

    /// The four digit form Xcode writes into project attributes.
    var projectAttributeValue: String {
        String(format: "%04d", major * 100 + minor * 10 + update)
    }
}

// MARK: - Text encoding

extension XCSchema.TextEncoding {
    init(fileEncoding: UInt) {
        self.init(rawValue: String.Encoding(rawValue: fileEncoding))
    }

    var fileEncoding: UInt {
        rawValue.rawValue
    }
}

// MARK: - Line ending

extension XCSchema.LineEnding {
    /// The values Xcode writes for the `lineEnding` key of a file reference.
    ///
    /// Only the three concrete styles have a known numeric counterpart. `preserve` has no verified
    /// encoding, so it is rejected rather than guessed at.
    init(fileReferenceValue value: UInt) throws {
        switch value {
        case 0: self = .lineFeed
        case 1: self = .carriageReturn
        case 2: self = .carriageReturnLineFeed
        default: throw XCProjError.unsupportedLineEnding(String(value))
        }
    }

    func fileReferenceValue() throws -> UInt {
        switch self {
        case .lineFeed: 0
        case .carriageReturn: 1
        case .carriageReturnLineFeed: 2
        case .preserve: throw XCProjError.unsupportedLineEnding(rawValue)
        }
    }
}

// MARK: - Product type

extension XCSchema.ProductTypeID {
    init?(productType: PBXProductType?) {
        guard let productType, productType != .none else { return nil }
        self.init(productTypeID: productType.rawValue)
    }

    var pbxProductType: PBXProductType {
        PBXProductType(rawValue: productTypeID) ?? .none
    }
}

// MARK: - Swift package version constraint

extension XCSchema.SwiftPackageVersionConstraint {
    init(versionRequirement: XCRemoteSwiftPackageReference.VersionRequirement) {
        switch versionRequirement {
        case let .revision(value): self = .revision(value)
        case let .branch(value): self = .branch(value)
        case let .exact(value): self = .version(value)
        case let .range(from, to): self = .versionRange(min: from, max: to)
        case let .upToNextMinorVersion(value): self = .upToNextMinorVersion(value)
        case let .upToNextMajorVersion(value): self = .upToNextMajorVersion(value)
        }
    }

    var versionRequirement: XCRemoteSwiftPackageReference.VersionRequirement {
        switch self {
        case let .revision(value): .revision(value)
        case let .branch(value): .branch(value)
        case let .version(value): .exact(value)
        case let .versionRange(min, max): .range(from: min, to: max)
        case let .upToNextMinorVersion(value): .upToNextMinorVersion(value)
        case let .upToNextMajorVersion(value): .upToNextMajorVersion(value)
        }
    }
}

// MARK: - Copy files destination

enum CopyFilesDestinationMapping {
    /// The destinations Xcode offers in a copy files build phase, paired with the numeric
    /// `dstSubfolderSpec` it writes.
    ///
    /// The schema also models bundle locations that have no verified `dstSubfolderSpec`, such as the
    /// headers directories and the Info.plist file. Those are rejected rather than guessed at.
    private static var table: [(XCSchema.BundleBasePath, PBXCopyFilesBuildPhase.SubFolder)] {
        [
            (.root, .wrapper),
            (.productDir, .productsDirectory),
            (.executablesDir, .executables),
            (.resourcesDir, .resources),
            (.javaDir, .javaResources),
            (.frameworksDir, .frameworks),
            (.sharedFrameworksDir, .sharedFrameworks),
            (.sharedSupportDir, .sharedSupport),
            (.plugInsDir, .plugins),
        ]
    }

    /// Converts a schema bundle base path into a `dstSubfolderSpec`.
    ///
    /// A `nil` base path means the destination is an absolute path.
    static func subFolder(for bundleBasePath: XCSchema.BundleBasePath?) throws -> PBXCopyFilesBuildPhase.SubFolder {
        guard let bundleBasePath else { return .absolutePath }
        guard let match = table.first(where: { $0.0 == bundleBasePath }) else {
            throw XCProjError.unsupportedCopyFilesDestination(bundleBasePath.rawValue)
        }
        return match.1
    }

    /// Converts a `dstSubfolderSpec` into a schema bundle base path.
    static func bundleBasePath(for subFolder: PBXCopyFilesBuildPhase.SubFolder?) throws -> XCSchema.BundleBasePath? {
        guard let subFolder, subFolder != .absolutePath else { return nil }
        guard let match = table.first(where: { $0.1 == subFolder }) else {
            throw XCProjError.unsupportedCopyFilesDestination(String(subFolder.rawValue))
        }
        return match.0
    }
}
