import Foundation

// This is the element for a build target that produces a binary content (application or library).
public struct PBXProject {
    
    // MARK: - Attributes
    
    public let reference: UUID
    
    public let isa: String = "PBXProject"
    
    // The object is a reference to a XCConfigurationList element.
    public let buildConfigurationList: UUID
    
    // A string representation of the XcodeCompatibilityVersion.
    public let compatibilityVersion: String
    
    // The region of development.
    public let developmentRegion: String
    
    // Whether file encodings have been scanned.
    public let hasScannedForEncodings: Int
    
    // The known regions for localized files.
    public let knownRegions: [String]
    
    // The object is a reference to a PBXGroup element.
    public let mainGroup: UUID
    
    // The object is a reference to a PBXGroup element.
    public let productRefGroup: UUID
    
    // The relative path of the project.
    public let projectDirPath: String
    
    public let projectReferences: [Any]
    
    // The relative root path of the project.
    public let projectRoot: String
    
    // The objects are a reference to a PBXTarget element.
    public let targets: Set<UUID>
}

// Example

///* Begin PBXProject section */
//23766C0A1EAA3484007A9026 /* Project object */ = {
//    isa = PBXProject;
//    attributes = {
//        LastSwiftUpdateCheck = 0830;
//        LastUpgradeCheck = 0830;
//        ORGANIZATIONNAME = es.ppinera;
//        TargetAttributes = {
//            23766C111EAA3484007A9026 = {
//                CreatedOnToolsVersion = 8.3.1;
//                ProvisioningStyle = Automatic;
//            };
//            23766C251EAA3484007A9026 = {
//                CreatedOnToolsVersion = 8.3.1;
//                ProvisioningStyle = Automatic;
//                TestTargetID = 23766C111EAA3484007A9026;
//            };
//        };
//    };
//    buildConfigurationList = 23766C0D1EAA3484007A9026 /* Build configuration list for PBXProject "Project" */;
//    compatibilityVersion = "Xcode 3.2";
//    developmentRegion = English;
//    hasScannedForEncodings = 0;
//    knownRegions = (
//				en,
//				Base,
//    );
//    mainGroup = 23766C091EAA3484007A9026;
//    productRefGroup = 23766C131EAA3484007A9026 /* Products */;
//    projectDirPath = "";
//    projectRoot = "";
//    targets = (
//				23766C111EAA3484007A9026 /* iOS */,
//				23766C251EAA3484007A9026 /* iOSTests */,
//    );
//};
///* End PBXProject section */
