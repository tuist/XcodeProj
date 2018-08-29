import Foundation

public final class PBXProject: PBXObject {

    // MARK: - Attributes

    /// xcodeproj's name
    public var name: String

    /// The object is a reference to a XCConfigurationList element.
    public var buildConfigurationListReference: PBXObjectReference

    /// A string representation of the XcodeCompatibilityVersion.
    public var compatibilityVersion: String

    /// The region of development.
    public var developmentRegion: String?

    /// Whether file encodings have been scanned.
    public var hasScannedForEncodings: Int

    /// The known regions for localized files.
    public var knownRegions: [String]

    /// The object is a reference to a PBXGroup element.
    public var mainGroupReference: PBXObjectReference

    /// The object is a reference to a PBXGroup element.
    public var productsGroupReference: PBXObjectReference?

    /// The relative path of the project.
    public var projectDirPath: String

    /// Project references.
    public var projectReferences: [[String: PBXObjectReference]]

    /// The relative root paths of the project.
    public var projectRoots: [String]

    /// The objects are a reference to a PBXTarget element.
    public var targetReferences: [PBXObjectReference]

    /// Project attributes.
    public var attributes: [String: Any]

    // MARK: - Init

    /// Initializes the project with its attributes
    ///
    /// - Parameters:
    ///   - name: xcodeproj's name.
    ///   - buildConfigurationListReference: project build configuration list.
    ///   - compatibilityVersion: project compatibility version.
    ///   - mainGroupReference: project main group.
    ///   - developmentRegion: project has development region.
    ///   - hasScannedForEncodings: project has scanned for encodings.
    ///   - knownRegions: project known regions.
    ///   - productsGroupReference: product reference group.
    ///   - projectDirPath: project dir path.
    ///   - projectReferences: project references.
    ///   - projectRoots: project roots.
    ///   - targetReferences: project targets.
    ///   - attributes: project attributes.
    public init(name: String,
                buildConfigurationListReference: PBXObjectReference,
                compatibilityVersion: String,
                mainGroupReference: PBXObjectReference,
                developmentRegion: String? = nil,
                hasScannedForEncodings: Int = 0,
                knownRegions: [String] = [],
                productsGroupReference: PBXObjectReference? = nil,
                projectDirPath: String = "",
                projectReferences: [[String: PBXObjectReference]] = [],
                projectRoots: [String] = [],
                targetReferences: [PBXObjectReference] = [],
                attributes: [String: Any] = [:]) {
        self.name = name
        self.buildConfigurationListReference = buildConfigurationListReference
        self.compatibilityVersion = compatibilityVersion
        self.mainGroupReference = mainGroupReference
        self.developmentRegion = developmentRegion
        self.hasScannedForEncodings = hasScannedForEncodings
        self.knownRegions = knownRegions
        self.productsGroupReference = productsGroupReference
        self.projectDirPath = projectDirPath
        self.projectReferences = projectReferences
        self.projectRoots = projectRoots
        self.targetReferences = targetReferences
        self.attributes = attributes
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case name
        case buildConfigurationList
        case compatibilityVersion
        case developmentRegion
        case hasScannedForEncodings
        case knownRegions
        case mainGroup
        case productRefGroup
        case projectDirPath
        case projectReferences
        case projectRoot
        case projectRoots
        case targets
        case attributes
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let referenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        name = (try container.decodeIfPresent(.name)) ?? ""
        let buildConfigurationListReference: String = try container.decode(.buildConfigurationList)
        self.buildConfigurationListReference = referenceRepository.getOrCreate(reference: buildConfigurationListReference, objects: objects)
        compatibilityVersion = try container.decode(.compatibilityVersion)
        developmentRegion = try container.decodeIfPresent(.developmentRegion)
        let hasScannedForEncodingsString: String? = try container.decodeIfPresent(.hasScannedForEncodings)
        hasScannedForEncodings = hasScannedForEncodingsString.flatMap({ Int($0) }) ?? 0
        knownRegions = (try container.decodeIfPresent(.knownRegions)) ?? []
        let mainGroupReference: String = try container.decode(.mainGroup)
        self.mainGroupReference = referenceRepository.getOrCreate(reference: mainGroupReference, objects: objects)
        if let productRefGroupReference: String = try container.decodeIfPresent(.productRefGroup) {
            productsGroupReference = referenceRepository.getOrCreate(reference: productRefGroupReference, objects: objects)
        } else {
            productsGroupReference = nil
        }
        projectDirPath = try container.decodeIfPresent(.projectDirPath) ?? ""
        let projectReferences: [[String: String]] = (try container.decodeIfPresent(.projectReferences)) ?? []
        self.projectReferences = projectReferences.map({ references in
            references.mapValues({ referenceRepository.getOrCreate(reference: $0, objects: objects) })
        })
        if let projectRoots: [String] = try container.decodeIfPresent(.projectRoots) {
            self.projectRoots = projectRoots
        } else if let projectRoot: String = try container.decodeIfPresent(.projectRoot) {
            projectRoots = [projectRoot]
        } else {
            projectRoots = []
        }
        let targetReferences: [String] = (try container.decodeIfPresent(.targets)) ?? []
        self.targetReferences = targetReferences.map({ referenceRepository.getOrCreate(reference: $0, objects: objects) })
        attributes = try container.decodeIfPresent([String: Any].self, forKey: .attributes) ?? [:]
        try super.init(from: decoder)
    }
}

// MARK: - PlistSerializable

extension PBXProject: PlistSerializable {
    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXProject.isa))
        let buildConfigurationListComment = "Build configuration list for PBXProject \"\(name)\""
        let buildConfigurationListCommentedString = CommentedString(buildConfigurationListReference.value,
                                                                    comment: buildConfigurationListComment)
        dictionary["buildConfigurationList"] = .string(buildConfigurationListCommentedString)
        dictionary["compatibilityVersion"] = .string(CommentedString(compatibilityVersion))
        if let developmentRegion = developmentRegion {
            dictionary["developmentRegion"] = .string(CommentedString(developmentRegion))
        }
        dictionary["hasScannedForEncodings"] = .string(CommentedString("\(hasScannedForEncodings)"))

        if !knownRegions.isEmpty {
            dictionary["knownRegions"] = PlistValue.array(knownRegions
                .map { .string(CommentedString("\($0)")) })
        }
        let mainGroupObject: PBXGroup? = try? mainGroupReference.object()
        dictionary["mainGroup"] = .string(CommentedString(mainGroupReference.value, comment: mainGroupObject?.fileName()))
        if let productsGroupReference = productsGroupReference {
            let productRefGroupObject: PBXGroup? = try? productsGroupReference.object()
            dictionary["productRefGroup"] = .string(CommentedString(productsGroupReference.value,
                                                                    comment: productRefGroupObject?.fileName()))
        }
        dictionary["projectDirPath"] = .string(CommentedString(projectDirPath))
        if projectRoots.count > 1 {
            dictionary["projectRoots"] = projectRoots.plist()
        } else {
            dictionary["projectRoot"] = .string(CommentedString(projectRoots.first ?? ""))
        }
        if let projectReferences = try projectReferencesPlistValue(proj: proj) {
            dictionary["projectReferences"] = projectReferences
        }
        dictionary["targets"] = PlistValue.array(targetReferences
            .map { targetReference in
                let target: PBXTarget? = try? targetReference.object()
                return .string(CommentedString(targetReference.value, comment: target?.name))
        })
        dictionary["attributes"] = attributes.plist()
        return (key: CommentedString(reference,
                                     comment: "Project object"),
                value: .dictionary(dictionary))
    }

    private func projectReferencesPlistValue(proj _: PBXProj) throws -> PlistValue? {
        guard projectReferences.count > 0 else {
            return nil
        }
        return .array(projectReferences.compactMap { reference in
            guard let productGroupReference = reference["ProductGroup"], let projectRef = reference["ProjectRef"] else {
                return nil
            }
            let producGroup: PBXGroup? = try? productGroupReference.object()
            let groupName = producGroup?.fileName()
            let project: PBXFileElement? = try? projectRef.object()
            let fileRefName = project?.fileName()

            return [
                CommentedString("ProductGroup"): PlistValue.string(CommentedString(productGroupReference.value, comment: groupName)),
                CommentedString("ProjectRef"): PlistValue.string(CommentedString(projectRef.value, comment: fileRefName)),
            ]
        })
    }
}
