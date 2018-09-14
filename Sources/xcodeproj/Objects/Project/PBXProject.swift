import Foundation

public final class PBXProject: PBXObject {
    // MARK: - Attributes

    /// Project name
    public var name: String

    /// Build configuration list reference.
    var buildConfigurationListReference: PBXObjectReference

    /// Build configuration list.
    public var buildConfigurationList: XCConfigurationList {
        set {
            buildConfigurationListReference = newValue.reference
        }
        get {
            // swiftlint:disable:next force_try
            return try! buildConfigurationListReference.object()
        }
    }

    /// A string representation of the XcodeCompatibilityVersion.
    public var compatibilityVersion: String

    /// The region of development.
    public var developmentRegion: String?

    /// Whether file encodings have been scanned.
    public var hasScannedForEncodings: Int

    /// The known regions for localized files.
    public var knownRegions: [String]

    /// The object is a reference to a PBXGroup element.
    var mainGroupReference: PBXObjectReference

    /// Project main group.
    public var mainGroup: PBXGroup {
        set {
            mainGroupReference = mainGroup.reference
        }
        get {
            // swiftlint:disable:next force_try
            return try! mainGroupReference.object()
        }
    }

    /// The object is a reference to a PBXGroup element.
    var productsGroupReference: PBXObjectReference?

    /// Products group.
    public var productsGroup: PBXGroup? {
        set {
            productsGroupReference = productsGroup?.reference
        }
        get {
            // swiftlint:disable:next force_try
            return try! productsGroupReference?.object()
        }
    }

    /// The relative path of the project.
    public var projectDirPath: String

    /// Project references.
    var projectReferences: [[String: PBXObjectReference]]

    /// Project projects.
    //    {
    //        ProductGroup = B900DB69213936CC004AEC3E /* Products group reference */;
    //        ProjectRef = B900DB68213936CC004AEC3E /* Project file reference  */;
    //    },
    public var projects: [[String: PBXFileElement]] {
        set {
            projectReferences = newValue.map { project in
                project.mapValues({ $0.reference })
            }
        }
        get {
            return projectReferences.map { project in
                // swiftlint:disable:next force_try
                project.mapValues({ try! $0.object() })
            }
        }
    }

    /// The relative root paths of the project.
    public var projectRoots: [String]

    /// The objects are a reference to a PBXTarget element.
    var targetReferences: [PBXObjectReference]

    /// Project targets.
    public var targets: [PBXTarget] {
        set {
            targetReferences = newValue.map({ $0.reference })
        }
        get {
            // swiftlint:disable:next force_try
            return targetReferences.map({ try! $0.object() })
        }
    }

    /// Project attributes.
    var attributeReferences: [PBXObjectReference: [String: Any]]

    /// Sets the attributes for the given target.
    ///
    /// - Parameters:
    ///   - attributes: attributes that will be set.
    ///   - target: target.
    public func setAttributes(_ attributes: [String: Any], target: PBXTarget) {
        attributeReferences[target.reference] = attributes
    }

    /// Removes the attributes for the given target.
    ///
    /// - Parameter target: target whose attributes will be removed.
    public func removeAttributes(target: PBXTarget) {
        attributeReferences.removeValue(forKey: target.reference)
    }

    /// Returns the attributes of a given target.
    ///
    /// - Parameter target: target whose attributes will be returned.
    /// - Returns: target attributes.
    public func attributes(target: PBXTarget) -> [String: Any]? {
        return attributeReferences[target.reference]
    }

    // MARK: - Init

    /// Initializes the project with its attributes
    ///
    /// - Parameters:
    ///   - name: xcodeproj's name.
    ///   - buildConfigurationList: project build configuration list.
    ///   - compatibilityVersion: project compatibility version.
    ///   - mainGroup: project main group.
    ///   - developmentRegion: project has development region.
    ///   - hasScannedForEncodings: project has scanned for encodings.
    ///   - knownRegions: project known regions.
    ///   - productsGroup: products group.
    ///   - projectDirPath: project dir path.
    ///   - projects: projects.
    ///   - projectRoots: project roots.
    ///   - targets: project targets.
    public init(name: String,
                buildConfigurationList: XCConfigurationList,
                compatibilityVersion: String,
                mainGroup: PBXGroup,
                developmentRegion: String? = nil,
                hasScannedForEncodings: Int = 0,
                knownRegions: [String] = [],
                productsGroup: PBXGroup? = nil,
                projectDirPath: String = "",
                projects: [[String: PBXFileElement]] = [],
                projectRoots: [String] = [],
                targets: [PBXTarget] = []) {
        self.name = name
        buildConfigurationListReference = buildConfigurationList.reference
        self.compatibilityVersion = compatibilityVersion
        mainGroupReference = mainGroup.reference
        self.developmentRegion = developmentRegion
        self.hasScannedForEncodings = hasScannedForEncodings
        self.knownRegions = knownRegions
        productsGroupReference = productsGroup?.reference
        self.projectDirPath = projectDirPath
        projectReferences = projects.map({ project in project.mapValues({ $0.reference }) })
        self.projectRoots = projectRoots
        targetReferences = targets.map({ $0.reference })
        attributeReferences = [:]
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

        let dictionaryAttributes = (try container.decodeIfPresent([String: Any].self, forKey: .attributes) ?? [:]) as? [String: [String: Any]]
        var attributeReferences: [PBXObjectReference: [String: Any]] = [:]
        dictionaryAttributes?.forEach { attributeReferences[referenceRepository.getOrCreate(reference: $0.key, objects: objects)] = $0.value }
        self.attributeReferences = attributeReferences

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

        var plistAttributes: [String: [String: Any]] = [:]
        attributeReferences.forEach({ plistAttributes[$0.key.value] = $0.value })

        dictionary["attributes"] = plistAttributes.plist()
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
