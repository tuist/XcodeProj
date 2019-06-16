import Foundation

/// This element is an abstract parent for specialized targets.
public class XCRemoteSwiftPackageReference: PBXContainerItem, PlistSerializable {
    /// It represents the version rules for a Swift Package.
    ///
    /// - upToNextMajorVersion: The package version can be bumped up to the next major version.
    /// - upToNextMinorVersion: The package version can be bumped up to the next minor version.
    /// - range: The package version needs to be in the given range.
    /// - exact: The package version needs to be the given version.
    /// - branch: To use a specific branch of the git repository.
    /// - revision: To use an specific revision of the git repository.
    public enum VersionRules: Decodable, Equatable {
        case upToNextMajorVersion(String)
        case upToNextMinorVersion(String)
        case range(from: String, to: String)
        case exact(String)
        case branch(String)
        case revision(String)

        enum CodingKeys: String, CodingKey {
            case kind
            case revision
            case branch
            case minimumVersion
            case maximumVersion
            case version
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let kind: String = try container.decode(String.self, forKey: .kind)
            if kind == "revision" {
                let revision = try container.decode(String.self, forKey: .revision)
                self = .revision(revision)
            } else if kind == "branch" {
                let branch = try container.decode(String.self, forKey: .branch)
                self = .branch(branch)
            } else if kind == "exactVersion" {
                let version = try container.decode(String.self, forKey: .version)
                self = .exact(version)
            } else if kind == "versionRange" {
                let minimumVersion = try container.decode(String.self, forKey: .minimumVersion)
                let maximumVersion = try container.decode(String.self, forKey: .maximumVersion)
                self = .range(from: minimumVersion, to: maximumVersion)
            } else if kind == "upToNextMinorVersion" {
                let version = try container.decode(String.self, forKey: .minimumVersion)
                self = .upToNextMinorVersion(version)
            } else if kind == "upToNextMajorVersion" {
                let version = try container.decode(String.self, forKey: .minimumVersion)
                self = .upToNextMajorVersion(version)
            } else {
                fatalError("XCRemoteSwiftPackageReference kind '\(kind)' not supported")
            }
        }

        func plistValues() -> [CommentedString: PlistValue] {
            switch self {
            case let .revision(revision):
                return [
                    "kind": "revision",
                    "revision": .string(.init(revision)),
                ]
            case let .branch(branch):
                return [
                    "kind": "branch",
                    "branch": .string(.init(branch)),
                ]
            case let .exact(version):
                return [
                    "kind": "exactVersion",
                    "version": .string(.init(version)),
                ]
            case let .range(from, to):
                return [
                    "kind": "versionRange",
                    "minimumVersion": .string(.init(from)),
                    "maximumVersion": .string(.init(to)),
                ]
            case let .upToNextMinorVersion(version):
                return [
                    "kind": "upToNextMinorVersion",
                    "minimumVersion": .string(.init(version)),
                ]
            case let .upToNextMajorVersion(version):
                return [
                    "kind": "upToNextMajorVersion",
                    "minimumVersion": .string(.init(version)),
                ]
            }
        }

        public static func == (lhs: VersionRules, rhs: VersionRules) -> Bool {
            switch (lhs, rhs) {
            case let (.revision(lhsRevision), .revision(rhsRevision)):
                return lhsRevision == rhsRevision
            case let (.branch(lhsBranch), .branch(rhsBranch)):
                return lhsBranch == rhsBranch
            case let (.exact(lhsVersion), .exact(rhsVersion)):
                return lhsVersion == rhsVersion
            case let (.range(lhsFrom, lhsTo), .range(rhsFrom, rhsTo)):
                return lhsFrom == rhsFrom && lhsTo == rhsTo
            case let (.upToNextMinorVersion(lhsVersion), .upToNextMinorVersion(rhsVersion)):
                return lhsVersion == rhsVersion
            case let (.upToNextMajorVersion(lhsVersion), .upToNextMajorVersion(rhsVersion)):
                return lhsVersion == rhsVersion
            default:
                return false
            }
        }
    }

    /// Repository url.
    public var repositoryURL: String?

    /// Version rules.
    public var versionRules: VersionRules?

    /// Initializes the remote swift package reference with its attributes.
    ///
    /// - Parameters:
    ///   - repositoryURL: Package repository url.
    ///   - versionRules: Package version rules.
    public init(repositoryURL: String,
         versionRules: VersionRules? = nil) {
        self.repositoryURL = repositoryURL
        self.versionRules = versionRules
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case requirement
        case repositoryURL
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        repositoryURL = try container.decodeIfPresent(String.self, forKey: .repositoryURL)
        versionRules = try container.decodeIfPresent(VersionRules.self, forKey: .requirement)

        try super.init(from: decoder)
    }

    /// It returns the name of the package reference.
    public var name: String? {
        return repositoryURL?.split(separator: "/").last?.replacingOccurrences(of: ".git", with: "")
    }

    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary = try super.plistValues(proj: proj, reference: reference)
        dictionary["isa"] = .string(CommentedString(XCRemoteSwiftPackageReference.isa))
        if let repositoryURL = repositoryURL {
            dictionary["repositoryURL"] = .string(.init(repositoryURL))
        }
        if let versionRules = versionRules {
            dictionary["requirement"] = PlistValue.dictionary(versionRules.plistValues())
        }
        return (key: CommentedString(reference, comment: "XCRemoteSwiftPackageReference \"\(name ?? "")\""),
                value: .dictionary(dictionary))
    }

    // MARK: - Equatable

    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCRemoteSwiftPackageReference else { return false }
        if repositoryURL != rhs.repositoryURL { return false }
        if versionRules != rhs.versionRules { return false }
        return super.isEqual(to: rhs)
    }
}
