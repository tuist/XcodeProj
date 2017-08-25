import Foundation
import Unbox

// This is the element for the sources compilation build phase.
public class PBXSourcesBuildPhase: PBXBuildPhase, Hashable {
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXSourcesBuildPhase,
                           rhs: PBXSourcesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.buildActionMask == rhs.buildActionMask &&
        lhs.files == rhs.files &&
        lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
}

extension PBXSourcesBuildPhase: PlistSerializable {

    // MARK: - PlistSerializable
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXSourcesBuildPhase.isa))
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["files"] = .array(files.map { file in
            var comment: String? = nil
            if let buildFile = proj.buildFiles.getReference(file),
                let fileString = proj.fileReferences.getReference(buildFile.reference)?.path {
                comment = "\(fileString) in Sources"
            }
            return PlistValue.string(CommentedString(file, comment: comment))
        })
        
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        return (key: CommentedString(self.reference,
                                                 comment: "Sources"),
                value: .dictionary(dictionary))
    }
    
}
