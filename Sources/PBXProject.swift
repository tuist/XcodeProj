import Foundation
import Unbox

// This is the element for a build target that produces a binary content (application or library).
public class PBXProject: ProjectElement, PlistSerializable {

    // MARK: - Attributes

    public static var isa: String = "PBXProject"

    // The object is a reference to a XCConfigurationList element.
    public var buildConfigurationList: String

    // A string representation of the XcodeCompatibilityVersion.
    public var compatibilityVersion: String

    // The region of development.
    public var developmentRegion: String?

    // Whether file encodings have been scanned.
    public var hasScannedForEncodings: Int?

    // The known regions for localized files.
    public var knownRegions: [String]

    // The object is a reference to a PBXGroup element.
    public var mainGroup: String

    // The object is a reference to a PBXGroup element.
    public var productRefGroup: String?

    // The relative path of the project.
    public var projectDirPath: String?

    /// Project references.
    public var projectReferences: [Any]

    // The relative root path of the project.
    public var projectRoot: String?

    // The objects are a reference to a PBXTarget element.
    public var targets: [String]

    /// Project attributes.
    public var attributes: [String: Any]

    // MARK: - Init

    /// Initializes the project with its attributes
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - buildConfigurationList: project build configuration list.
    ///   - compatibilityVersion: project compatibility version.
    ///   - mainGroup: project main group.
    ///   - developmentRegion: project has development region.
    ///   - hasScannedForEncodings: project has scanned for encodings.
    ///   - knownRegions: project known regions.
    ///   - productRefGroup: product reference group.
    ///   - projectDirPath: project dir path.
    ///   - projectReferences: project references.
    ///   - projectRoot: project root.
    ///   - targets: project targets.
    ///   - attributes: project attributes.
    public init(reference: String,
                buildConfigurationList: String,
                compatibilityVersion: String,
                mainGroup: String,
                developmentRegion: String? = nil,
                hasScannedForEncodings: Int? = nil,
                knownRegions: [String] = [],
                productRefGroup: String? = nil,
                projectDirPath: String? = nil,
                projectReferences: [Any] = [],
                projectRoot: String? = nil,
                targets: [String] = [],
                attributes: [String: Any] = [:]) {
        self.buildConfigurationList = buildConfigurationList
        self.compatibilityVersion = compatibilityVersion
        self.mainGroup = mainGroup
        self.developmentRegion = developmentRegion
        self.hasScannedForEncodings = hasScannedForEncodings
        self.knownRegions = knownRegions
        self.productRefGroup = productRefGroup
        self.projectDirPath = projectDirPath
        self.projectReferences = projectReferences
        self.projectRoot = projectRoot
        self.targets = targets
        self.attributes = attributes
        super.init(reference: reference)
    }

    /// Constructor that initializes the project element with the reference and a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: throws an error in case any of the propeties are missing or they have the wrong type.
    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildConfigurationList = try unboxer.unbox(key: "buildConfigurationList")
        self.compatibilityVersion = try unboxer.unbox(key: "compatibilityVersion")
        self.developmentRegion = unboxer.unbox(key: "developmentRegion")
        self.hasScannedForEncodings = unboxer.unbox(key: "hasScannedForEncodings")
        self.knownRegions = (unboxer.unbox(key: "knownRegions")) ?? []
        self.mainGroup = try unboxer.unbox(key: "mainGroup")
        self.productRefGroup = unboxer.unbox(key: "productRefGroup")
        self.projectDirPath = unboxer.unbox(key: "projectDirPath")
        self.projectReferences = (unboxer.unbox(key: "projectReferences")) ?? []
        self.projectRoot = unboxer.unbox(key: "projectRoot")
        self.targets = (unboxer.unbox(key: "targets")) ?? []
        self.attributes = (try? unboxer.unbox(key: "attributes")) ?? [:]
        try super.init(reference: reference, dictionary: dictionary)
    }

    // MARK: - Hashable

    public static func == (lhs: PBXProject,
                           rhs: PBXProject) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildConfigurationList == rhs.buildConfigurationList &&
            lhs.compatibilityVersion == rhs.compatibilityVersion &&
            lhs.developmentRegion == rhs.developmentRegion &&
            lhs.hasScannedForEncodings == rhs.hasScannedForEncodings &&
            lhs.knownRegions == rhs.knownRegions &&
            lhs.mainGroup == rhs.mainGroup &&
            lhs.productRefGroup == rhs.productRefGroup &&
            lhs.projectDirPath == rhs.projectDirPath &&
            NSArray(array: lhs.projectReferences).isEqual(to: NSArray(array: rhs.projectReferences)) &&
            lhs.projectRoot == rhs.projectRoot &&
            lhs.targets == rhs.targets &&
            NSDictionary(dictionary: lhs.attributes).isEqual(to: NSDictionary(dictionary: rhs.attributes))
    }

    // MARK: - PlistSerializable

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXProject.isa))
        let buildConfigurationListComment = "Build configuration list for PBXProject"
        let buildConfigurationListCommentedString = CommentedString(buildConfigurationList,
                                                                                comment: buildConfigurationListComment)
        dictionary["buildConfigurationList"] = .string(buildConfigurationListCommentedString)
        dictionary["compatibilityVersion"] = .string(CommentedString(compatibilityVersion))
        if let developmentRegion = developmentRegion {
            dictionary["developmentRegion"] = .string(CommentedString(developmentRegion))
        }
        if let hasScannedForEncodings = hasScannedForEncodings {
            dictionary["hasScannedForEncodings"] = .string(CommentedString("\(hasScannedForEncodings)"))
        }
        dictionary["knownRegions"] = PlistValue.array(knownRegions
            .map {.string(CommentedString("\($0)")) })

        dictionary["mainGroup"] = .string(CommentedString(mainGroup))
        if let productRefGroup = productRefGroup {
            dictionary["productRefGroup"] = .string(CommentedString(productRefGroup,
                                                                                comment: "Products"))
        }
        if let projectDirPath = projectDirPath {
            dictionary["projectDirPath"] = .string(CommentedString(projectDirPath))
        }
        if let projectRoot = projectRoot {
            dictionary["projectRoot"] = .string(CommentedString(projectRoot))
        }
        dictionary["targets"] = PlistValue.array(targets
            .map { target in
                return .string(CommentedString(target,
                                                           comment: nativeTarget(from: target, proj: proj)))
        })
        dictionary["attributes"] = attributes.plist()
        return (key: CommentedString(self.reference,
                                                 comment: "Project object"),
                value: .dictionary(dictionary))
    }

    private func nativeTarget(from reference: String, proj: PBXProj) -> String? {
        return proj.objects.nativeTargets
            .filter { $0.reference == reference }
            .map { $0.name }
            .first
    }

}
