
extension PBXProject {

    @available(*, deprecated, message: "Use projectRoots instead")
    public var projectRoot: String {
        get {
            return projectRoots.first ?? ""
        }
        set {
            if projectRoots.count == 0 {
                projectRoots.append(newValue)
            } else {
                projectRoots[0] = newValue
            }
        }
    }

    @available(*, deprecated, message: "init(name:buildConfigurationList:compatibilityVersion:mainGroup:developmentRegion:hasScannedForEncodings:knownRegions:productRefGroup:projectDirPath:projectReferences:projectRoots:targets:attributes:) instead")
    convenience init(name: String,
                buildConfigurationList: String,
                compatibilityVersion: String,
                mainGroup: String,
                developmentRegion: String? = nil,
                hasScannedForEncodings: Int = 0,
                knownRegions: [String] = [],
                productRefGroup: String? = nil,
                projectDirPath: String = "",
                projectReferences: [[String : String]] = [],
                projectRoot: String,
                targets: [String] = [],
                attributes: [String: Any] = [:]) {
        self.init(name: name,
                  buildConfigurationList: buildConfigurationList,
                  compatibilityVersion: compatibilityVersion,
                  mainGroup: mainGroup,
                  developmentRegion: developmentRegion,
                  hasScannedForEncodings: hasScannedForEncodings,
                  knownRegions: knownRegions,
                  productRefGroup: productRefGroup,
                  projectDirPath: projectDirPath,
                  projectReferences: projectReferences,
                  projectRoots: projectRoot != "" ? [projectRoot] : [],
                  targets: targets,
                  attributes: attributes)
    }
}
