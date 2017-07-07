import Foundation

/// PBXProjPlist string that contains a comment.
struct PBXProjPlistCommentedString: Hashable, ExpressibleByStringLiteral {

    /// Entity string value.
    let string: String

    /// String comment.
    let comment: String?
    
    /// Initializes the commented string with the value and the comment.
    ///
    /// - Parameters:
    ///   - string: string value.
    ///   - comment: comment.
    init(_ string: String, comment: String? = nil) {
        self.string = string
        self.comment = comment
    }
    
    // MARK: - Hashable
    
    var hashValue: Int { return string.hashValue }
    static func == (lhs: PBXProjPlistCommentedString, rhs: PBXProjPlistCommentedString) -> Bool {
        return lhs.string == rhs.string && lhs.comment == rhs.comment
    }
    
    // MARK: - ExpressibleByStringLiteral
    
    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    
}

/// It represents a PBXProj Plist valid value.
///
/// - string: commented string.
/// - array: array of plist values.
/// - dictionary: dictionary where the keys are a commented strings and the values are a plist values.
enum PBXProjPlistValue: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral, ExpressibleByStringLiteral {
    case string(PBXProjPlistCommentedString)
    case array([PBXProjPlistValue])
    case dictionary([PBXProjPlistCommentedString: PBXProjPlistValue])
    var string: (PBXProjPlistCommentedString)? {
        switch self {
        case .string(let string): return string
        default: return nil
        }
    }
    var array: [PBXProjPlistValue]? {
        switch self {
        case .array(let array): return array
        default: return nil
        }
    }
    var dictionary: [PBXProjPlistCommentedString: PBXProjPlistValue]? {
        switch self {
        case .dictionary(let dictionary): return dictionary
        default: return nil
        }
    }
    
    // MARK: - ExpressibleByArrayLiteral
    
    public init(arrayLiteral elements: PBXProjPlistValue...) {
        self = .array(elements)
    }
    
    // MARK: - ExpressibleByDictionaryLiteral
    
    public init(dictionaryLiteral elements: (PBXProjPlistCommentedString, PBXProjPlistValue)...) {
        var dictionary: [PBXProjPlistCommentedString: PBXProjPlistValue] = [:]
        elements.forEach { dictionary[$0.0] = $0.1 }
        self = .dictionary(dictionary)
    }
    
    // MARK: - ExpressibleByStringLiteral
    
    public init(stringLiteral value: String) {
        self = .string(PBXProjPlistCommentedString(value))
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .string(PBXProjPlistCommentedString(value))
    }
    public init(unicodeScalarLiteral value: String) {
        self = .string(PBXProjPlistCommentedString(value))
    }
}

/// Protocol that defines that the element can return a plist element that represents itself.
protocol PBXProjPlistSerializable {
    func pbxProjPlistElement(proj: PBXProj) -> (key: PBXProjPlistCommentedString, value: PBXProjPlistValue)
}

/// Writes your PBXProj files
class PBXProjWriter {
    
    var indent: UInt = 0
    var output: String = ""
    
    func write(proj: PBXProj) -> String {
        writeUtf8()
        writeNewLine()
        writeDictionaryStart()
        write(dictionaryKey: "archiveVersion", dictionaryValue: .string(PBXProjPlistCommentedString("\(proj.archiveVersion)")))
        write(dictionaryKey: "classes", dictionaryValue: .array([]))
        write(dictionaryKey: "objectVersion", dictionaryValue: .string(PBXProjPlistCommentedString("\(proj.objectVersion)")))
        writeIndent()
        write(string: "objects = {")
        increaseIndent()
        writeNewLine()
        write(section: "PBXNativeTarget", proj: proj, object: proj.objects.nativeTargets)
        // PBXAggregateTarget
        // PBXBuildFile
        // PBXFileReference
        write(section: "PBXProject", proj: proj, object: proj.objects.projects)
        // PBXFileElement
        // PBXGroup
        // PBXHeadersBuildPhase
        // PBXFrameworksBuildPhase
        // PBXResourcesBuildPhase
        write(section: "PBXShellScriptBuildPhase", proj: proj, object: proj.objects.shellScriptBuildPhases)
        write(section: "PBXSourcesBuildPhase", proj: proj, object: proj.objects.sourcesBuildPhases)
        write(section: "PBXTargetDependency", proj: proj, object: proj.objects.targetDependencies)
        write(section: "PBXVariantGroup", proj: proj, object: proj.objects.variantGroups)
        write(section: "XCBuildConfiguration", proj: proj, object: proj.objects.buildConfigurations)
        write(section: "XCConfigurationList", proj: proj, object: proj.objects.configurationLists)
        write(section: "PBXCopyFilesBuildPhase", proj: proj, object: proj.objects.copyFilesBuildPhases)
        write(section: "PBXContainerItemProxy", proj: proj, object: proj.objects.containerItemProxies)
        decreaseIndent()
        writeIndent()
        write(string: "};")
        writeNewLine()
        write(dictionaryKey: "rootObject",
              dictionaryValue: .string(PBXProjPlistCommentedString(proj.rootObject,
                                                                   comment: "Project object")))
        writeDictionaryEnd()
        return output
    }
    
    // MARK: - Private
    
    private func writeUtf8() {
        output.append("// !$*UTF8*$!")
    }
    
    private func writeNewLine() {
        output.append("\n")
    }
    
    private func write(value: PBXProjPlistValue) {
        switch value {
        case .array(let array):
            write(array: array)
        case .dictionary(let dictionary):
            write(dictionary: dictionary)
        case .string(let commentedString):
            write(commentedString: commentedString)
        }
    }
    
    private func write(commentedString: PBXProjPlistCommentedString) {
        write(string: commentedString.string)
        if let comment = commentedString.comment {
            write(string: " ")
            write(comment: comment)
        }
    }
    
    private func write(string: String) {
        output.append(string)
    }
    
    private func write(comment: String) {
        output.append("/* \(comment) */")
    }
    
    private func write(section: String, proj: PBXProj, object: [PBXProjPlistSerializable]) {
        write(string: "/* Begin \(section) section */")
        writeNewLine()
        object.forEach { (serializable) in
            let element = serializable.pbxProjPlistElement(proj: proj)
            write(dictionaryKey: element.key, dictionaryValue: element.value)
        }
        write(string: "/* End \(section) section */")
        writeNewLine()
    }
    
    private func write(dictionary: [PBXProjPlistCommentedString: PBXProjPlistValue], newLines: Bool = true) {
        writeDictionaryStart()
        dictionary.forEach { write(dictionaryKey: $0.key, dictionaryValue: $0.value) }
        writeDictionaryEnd()
    }
    
    private func write(dictionaryKey: PBXProjPlistCommentedString, dictionaryValue: PBXProjPlistValue) {
        writeIndent()
        write(commentedString: dictionaryKey)
        output.append(" = ")
        write(value: dictionaryValue)
        output.append(";")
        writeNewLine()
    }
    
    private func writeDictionaryStart() {
        output.append("{")
        writeNewLine()
        increaseIndent()
    }
    
    private func writeDictionaryEnd() {
        decreaseIndent()
        writeIndent()
        output.append("}")
    }
    
    private func write(array: [PBXProjPlistValue], newlines: Bool = true) {
        writeArrayStart()
        array.forEach { write(arrayValue: $0) }
        writeArrayEnd()
    }
    
    private func write(arrayValue: PBXProjPlistValue) {
        writeIndent()
        write(value: arrayValue)
        output.append(",")
        writeNewLine()
    }
    
    private func writeArrayStart(newLines: Bool = true) {
        output.append("(")
        if newLines { writeNewLine() }
        increaseIndent()
    }
    
    private func writeArrayEnd() {
        decreaseIndent()
        writeIndent()
        output.append(")")
    }
    
    private func writeIndent() {
        output.append(String(repeating: "\t", count: Int(indent)))
    }
    
    private func increaseIndent() {
        indent += 1
    }
    
    private func decreaseIndent() {
        indent -= 1
    }
    
}
