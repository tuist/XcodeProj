import Foundation

/// This element is an abstract parent for specialized targets.
public class XCRemoteSwiftPackageReference: PBXContainerItem {
    
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
                let version = try container.decode(String.self, forKey: .minimumVersion)
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
        
        func plistValues() throws -> [CommentedString : PlistValue] {
            switch self {
            case .revision(let revision):
                return [
                    "kind": "revision",
                    "revision": .string(.init(revision))
                ]
            case .branch(let branch):
                return [
                    "kind": "branch",
                    "branch": .string(.init(branch))
                ]
            case .exact(let version):
                return [
                    "kind": "exactVersion",
                    "minimumVersion": .string(.init(version))
                ]
            case .range(let from, let to):
                return [
                    "kind": "versionRange",
                    "minimumVersion": .string(.init(from)),
                    "maximumVersion": .string(.init(to)),
                ]
            case .upToNextMinorVersion(let version):
                return [
                    "kind": "upToNextMinorVersion",
                    "minimumVersion": .string(.init(version))
                ]
            case .upToNextMajorVersion(let version):
                return [
                    "kind": "upToNextMajorVersion",
                    "minimumVersion": .string(.init(version))
                ]
            }
        }
        
        public static func == (lhs: VersionRules, rhs: VersionRules) -> Bool {
            switch (lhs, rhs) {
            case (.revision(let lhsRevision), .revision(let rhsRevision)):
                return lhsRevision == rhsRevision
            case (.branch(let lhsBranch), .branch(let rhsBranch)):
                return lhsBranch == rhsBranch
            case (.exact(let lhsVersion), .exact(let rhsVersion)):
                return lhsVersion == rhsVersion
            case (.range(let lhsFrom, let lhsTo), .range(let rhsFrom, let rhsTo)):
                return lhsFrom == rhsFrom && lhsTo == rhsTo
            case (.upToNextMinorVersion(let lhsVersion), .upToNextMinorVersion(let rhsVersion)):
                return lhsVersion == rhsVersion
            case (.upToNextMajorVersion(let lhsVersion), .upToNextMajorVersion(let rhsVersion)):
                return lhsVersion == rhsVersion
            default:
                return false
            }
        }
    }
    
    /// Repository url.
    var repositoryURL: String?
    
    /// Version rules.
    var versionRules: VersionRules?
    
    /// Initializes the remote swift package reference with its attributes.
    ///
    /// - Parameters:
    ///   - repositoryURL: Package repository url.
    ///   - versionRules: Package version rules.
    init(repositoryURL: String,
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
        let objects = decoder.context.objects
        let repository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        try super.init(from: decoder)
    }
    
    var name: String {
        return "TODO"
    }
    
    override func plistValues(proj: PBXProj, reference: String) throws -> [CommentedString : PlistValue] {
        return [:]
    }
    
    // MARK: - Equatable
    
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCRemoteSwiftPackageReference else { return false }
        if repositoryURL != rhs.repositoryURL { return false }
        if versionRules != rhs.versionRules { return false }
        return super.isEqual(to: rhs)
    }

}
