import Foundation
import Unbox

// This is the element for the sources compilation build phase.
public class PBXSourcesBuildPhase: PBXBuildPhase {
    
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
            if let fileString = fileName(from: file, proj: proj) {
                comment = "\(fileString) in Sources"
            }
            return PlistValue.string(CommentedString(file, comment: comment))
        })
        
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        return (key: CommentedString(self.reference,
                                                 comment: "Sources"),
                value: .dictionary(dictionary))
    }
    
    private func fileName(from reference: String, proj: PBXProj) -> String? {
        return proj.objects.buildFiles
            .filter { $0.reference == reference }
            .flatMap { buildFile in
                return proj.objects.fileReferences.filter { $0.reference == buildFile.fileRef }.first?.path
            }
            .first
    }
    
}
