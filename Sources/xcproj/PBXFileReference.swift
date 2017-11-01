import Foundation
import PathKit

///  A PBXFileReference is used to track every external file referenced by
///  the project: source files, resource files, libraries, generated application files, and so on.
public class PBXFileReference: PBXObject, Hashable {
 
    // MARK: - Attributes
    
    /// Element file encoding.
    public var fileEncoding: Int?
    
    /// Element explicit file type.
    public var explicitFileType: String?
    
    /// Element last known file type.
    public var lastKnownFileType: String?
    
    /// Element include in index.
    public var includeInIndex: Int?
    
    /// Element name.
    public var name: String?
    
    /// Element path.
    public var path: String?
 
    /// Element source tree.
    public var sourceTree: PBXSourceTree?
    
    /// Element uses tabs.
    public var usesTabs: Int?
    
    /// Element line ending.
    public var lineEnding: Int?
    
    /// Element xc language specification identifier
    public var xcLanguageSpecificationIdentifier: String?
    
    // MARK: - Init
    
    public init(reference: String,
                sourceTree: PBXSourceTree? = nil,
                name: String? = nil,
                fileEncoding: Int? = nil,
                explicitFileType: String? = nil,
                lastKnownFileType: String? = nil,
                path: String? = nil,
                includeInIndex: Int? = nil,
                usesTabs: Int? = nil,
                lineEnding: Int? = nil,
                xcLanguageSpecificationIdentifier: String? = nil) {
        self.fileEncoding = fileEncoding
        self.explicitFileType = explicitFileType
        self.lastKnownFileType = lastKnownFileType
        self.name = name
        self.path = path
        self.sourceTree = sourceTree
        self.includeInIndex = includeInIndex
        self.usesTabs = usesTabs
        self.lineEnding = lineEnding
        self.xcLanguageSpecificationIdentifier = xcLanguageSpecificationIdentifier
        super.init(reference: reference)
    }

    public static func == (lhs: PBXFileReference,
                           rhs: PBXFileReference) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.fileEncoding == rhs.fileEncoding &&
            lhs.explicitFileType == rhs.explicitFileType &&
            lhs.lastKnownFileType == rhs.lastKnownFileType &&
            lhs.name == rhs.name &&
            lhs.path == rhs.path &&
            lhs.sourceTree == rhs.sourceTree &&
            lhs.includeInIndex == rhs.includeInIndex &&
            lhs.usesTabs == rhs.usesTabs &&
            lhs.lineEnding == rhs.lineEnding &&
            lhs.xcLanguageSpecificationIdentifier == rhs.xcLanguageSpecificationIdentifier
    }
    
    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case fileEncoding
        case explicitFileType
        case lastKnownFileType
        case name
        case path
        case sourceTree
        case includeInIndex
        case usesTabs
        case lineEnding
        case xcLanguageSpecificationIdentifier
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fileEncodingString: String? = try container.decodeIfPresent(.fileEncoding)
        self.fileEncoding = fileEncodingString.flatMap(Int.init)
        self.explicitFileType = try container.decodeIfPresent(.explicitFileType)
        self.lastKnownFileType = try container.decodeIfPresent(.lastKnownFileType)
        let includeInIndexString: String? = try container.decodeIfPresent(.includeInIndex)
        self.includeInIndex = includeInIndexString.flatMap({Int($0)})
        self.name = try container.decodeIfPresent(.name)
        self.path = try container.decodeIfPresent(.path)
        self.sourceTree = try container.decodeIfPresent(.sourceTree)
        let usesTabString: String? = try container.decodeIfPresent(.usesTabs)
        self.usesTabs = usesTabString.flatMap(Int.init)
        let lineEndingString: String? = try container.decodeIfPresent(.lineEnding)
        self.lineEnding = lineEndingString.flatMap(Int.init)
        self.xcLanguageSpecificationIdentifier = try container.decodeIfPresent(.xcLanguageSpecificationIdentifier)
        try super.init(from: decoder)
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
    public static func fileType(path: Path) -> String? {
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
        if let usesTabs = usesTabs {
            dictionary["usesTabs"] = .string(CommentedString("\(usesTabs)"))
        }
        if let lineEnding = lineEnding {
            dictionary["lineEnding"] = .string(CommentedString("\(lineEnding)"))
        }
        if let xcLanguageSpecificationIdentifier = xcLanguageSpecificationIdentifier {
            dictionary["xcLanguageSpecificationIdentifier"] = .string(CommentedString(xcLanguageSpecificationIdentifier))
        }
        if let sourceTree = sourceTree {
            dictionary["sourceTree"] = sourceTree.plist()
        }
        return (key: CommentedString(self.reference, comment: name ?? path),
                value: .dictionary(dictionary))
    }
}
