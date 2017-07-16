import Foundation
import Unbox
import PathKit

//  A PBXFileReference is used to track every external file referenced by 
//  the project: source files, resource files, libraries, generated application files, and so on.
public struct PBXFileReference {
 
    // MARK: - Attributes
    
    /// Element reference.
    public let reference: UUID
    
    /// Element file encoding.
    public let fileEncoding: Int?
    
    /// Element explicit file type.
    public let explicitFileType: String?
    
    /// Element last known file type.
    public let lastKnownFileType: String?
    
    /// Element include in index.
    public let includeInIndex: Int?
    
    /// Element name.
    public let name: String?
    
    /// Element path.
    public let path: String?
 
    /// Element source tree.
    public let sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    public init(reference: UUID,
                sourceTree: PBXSourceTree,
                name: String? = nil,
                fileEncoding: Int? = nil,
                explicitFileType: String? = nil,
                lastKnownFileType: String? = nil,
                path: String? = nil,
                includeInIndex: Int? = nil) {
        self.reference = reference
        self.fileEncoding = fileEncoding
        self.explicitFileType = explicitFileType
        self.lastKnownFileType = lastKnownFileType
        self.name = name
        self.path = path
        self.sourceTree = sourceTree
        self.includeInIndex = includeInIndex
    }
    
}

// MARK: - PBXFileReference Extension (ProjectElement)

extension PBXFileReference: ProjectElement {
    
    public static var isa: String = "PBXFileReference"

    public static func == (lhs: PBXFileReference,
                           rhs: PBXFileReference) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.fileEncoding == rhs.fileEncoding &&
            lhs.explicitFileType == rhs.explicitFileType &&
            lhs.lastKnownFileType == rhs.lastKnownFileType &&
            lhs.name == rhs.name &&
            lhs.path == rhs.path &&
            lhs.sourceTree == rhs.sourceTree &&
            lhs.includeInIndex == rhs.includeInIndex
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.fileEncoding = unboxer.unbox(key: "fileEncoding")
        self.explicitFileType = unboxer.unbox(key: "explicitFileType")
        self.lastKnownFileType = unboxer.unbox(key: "lastKnownFileType")
        self.name = unboxer.unbox(key: "name")
        self.path = unboxer.unbox(key: "path")
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
        self.includeInIndex = unboxer.unbox(key: "includeInIndex")
    }
    
}

fileprivate let fileTypeHash: [String: String] = [
    "a": "archive.ar",
    "apns": "text",
    "app": "wrapper.application",
    "appex": "wrapper.app-extension",
    "bundle": "wrapper.plug-in",
    "dylib": "compiled.mach-o.dylib",
    "entitlements": "text.plist.entitlements",
    "framework": "wrapper.framework",
    "gif": "image.gif",
    "gpx": "text.xml",
    "h": "sourcecode.c.h",
    "m": "sourcecode.c.objc",
    "markdown": "text",
    "mdimporter": "wrapper.cfbundle",
    "mov": "video.quicktime",
    "mp3": "audio.mp3",
    "octest": "wrapper.cfbundle",
    "pch": "sourcecode.c.h",
    "plist": "text.plist.xml",
    "png": "image.png",
    "sh": "text.script.sh",
    "sks": "file.sks",
    "storyboard": "file.storyboard",
    "strings": "text.plist.strings",
    "swift": "sourcecode.swift",
    "xcassets": "folder.assetcatalog",
    "xcconfig": "text.xcconfig",
    "xcdatamodel": "wrapper.xcdatamodel",
    "xcodeproj": "wrapper.pb-project",
    "xctest": "wrapper.cfbundle",
    "xib": "file.xib",
    "zip": "archive.zip"
]

// MARK: - PBXFileReference Extension (Extras)

extension PBXFileReference {
    
    /// Returns the file type for a given path.
    ///
    /// - Parameter path: path whose file type will be returned.
    /// - Returns: file type (if supported).
    static func fileType(path: Path) -> String? {
        return path.extension.flatMap({fileTypeHash[$0]})
    }
    
}

// MARK: - PBXFileReference Extension (PlistSerializable)

extension PBXFileReference: PlistSerializable {
    
    var multiline: Bool { return false }
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXFileReference.isa))
        if let lastKnownFileType = lastKnownFileType {
            dictionary["lastKnownFileType"] = .string(CommentedString(lastKnownFileType))
        }
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        if let path = path {
            dictionary["path"] = .string(CommentedString(path))
        }
        if let fileEncoding = fileEncoding {
            dictionary["fileEncoding"] = .string(CommentedString("\(fileEncoding)"))
        }
        if let explicitFileType = self.explicitFileType {
            dictionary["explicitFileType"] = .string(CommentedString(explicitFileType))
        }
        if let includeInIndex = includeInIndex {
            dictionary["includeInIndex"] = .string(CommentedString("\(includeInIndex)"))
        }
        dictionary["sourceTree"] = sourceTree.plist()
        return (key: CommentedString(self.reference, comment: name ?? path),
                value: .dictionary(dictionary))
    }
}
