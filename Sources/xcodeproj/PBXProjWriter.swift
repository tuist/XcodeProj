import Foundation

/// It represents a PBXProj Plist valid value.
///
/// - string: commented string.
/// - array: array of plist values.
/// - dictionary: dictionary where the keys are a commented strings and the values are a plist values.
enum PBXProjPlistValue: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral, ExpressibleByStringLiteral {
    case string(CommentedString)
    case array([PBXProjPlistValue])
    case dictionary([CommentedString: PBXProjPlistValue])
    var string: (CommentedString)? {
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
    var dictionary: [CommentedString: PBXProjPlistValue]? {
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
    
    public init(dictionaryLiteral elements: (CommentedString, PBXProjPlistValue)...) {
        var dictionary: [CommentedString: PBXProjPlistValue] = [:]
        elements.forEach { dictionary[$0.0] = $0.1 }
        self = .dictionary(dictionary)
    }
    
    // MARK: - ExpressibleByStringLiteral
    
    public init(stringLiteral value: String) {
        self = .string(CommentedString(value))
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .string(CommentedString(value))
    }
    public init(unicodeScalarLiteral value: String) {
        self = .string(CommentedString(value))
    }
}

// MARK: PBXProjPlistValue Extension (Equatable)

extension PBXProjPlistValue: Equatable {
    
    static func == (lhs: PBXProjPlistValue, rhs: PBXProjPlistValue) -> Bool {
        switch (lhs, rhs) {
        case (.string(let lhsString), .string(let rhsString)):
            return lhsString == rhsString
        case (.array(let lhsArray), .array(let rhsArray)):
            return lhsArray == rhsArray
        case (.dictionary(let lhsDictionary), .dictionary(let rhsDictionary)):
            return lhsDictionary == rhsDictionary
        default:
            return false
        }
    }
    
}

/// Protocol that defines that the element can return a plist element that represents itself.
protocol PBXProjPlistSerializable {
    func pbxProjPlistElement(proj: PBXProj) -> (key: CommentedString, value: PBXProjPlistValue)
}

// MARK: - Dictionary Extension (PBXProjPlistValue)

extension Dictionary where Key == String {
    
    func pbxProjPlistValue() -> PBXProjPlistValue {
        var dictionary: [CommentedString: PBXProjPlistValue] = [:]
        self.forEach { (key, value) in
            if let array = value as? [Any] {
                dictionary[CommentedString(key)] = array.pbxProjPlistValue()
            } else if let subDictionary = value as? [String: Any] {
                dictionary[CommentedString(key)] = subDictionary.pbxProjPlistValue()
            } else if let string = value as? CustomStringConvertible {
                dictionary[CommentedString(key)] = .string(CommentedString(string.description))
            }
        }
        return .dictionary(dictionary)
    }

}

// MARK: - Array Extension (PBXProjPlistValue)

extension Array {
    
    func pbxProjPlistValue() -> PBXProjPlistValue {
        return .array(self.flatMap({ (element) -> PBXProjPlistValue? in
            if let array = element as? [Any] {
                return array.pbxProjPlistValue()
            } else if let dictionary = element as? [String: Any] {
                return dictionary.pbxProjPlistValue()
            } else if let string = element as? CustomStringConvertible {
                return PBXProjPlistValue.string(CommentedString(string.description))
            }
            return nil
        }))
    }
    
}

/// Writes your PBXProj files
class PBXProjWriter {
    
    var indent: UInt = 0
    var output: String = ""
    
    func write(proj: PBXProj) -> String {
        writeUtf8()
        writeNewLine()
        writeDictionaryStart()
        write(dictionaryKey: "archiveVersion", dictionaryValue: .string(CommentedString("\(proj.archiveVersion)")))
        write(dictionaryKey: "classes", dictionaryValue: .array([]))
        write(dictionaryKey: "objectVersion", dictionaryValue: .string(CommentedString("\(proj.objectVersion)")))
        writeIndent()
        write(string: "objects = {")
        increaseIndent()
        writeNewLine()
        write(section: "PBXNativeTarget", proj: proj, object: proj.objects.nativeTargets)
        // PBXAggregateTarget
        write(section: "PBXBuildFile", proj: proj, object: proj.objects.buildFiles)
        // PBXFileReference
        write(section: "PBXProject", proj: proj, object: proj.objects.projects)
        // PBXFileElement
        write(section: "PBXGroup", proj: proj, object: proj.objects.groups)
        write(section: "PBXHeadersBuildPhase", proj: proj, object: proj.objects.headersBuildPhases)
        write(section: "PBXFrameworksBuildPhase", proj: proj, object: proj.objects.frameworksBuildPhases)
        write(section: "PBXResourcesBuildPhase", proj: proj, object: proj.objects.resourcesBuildPhases)
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
              dictionaryValue: .string(CommentedString(proj.rootObject,
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
    
    private func write(commentedString: CommentedString) {
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
    
    private func write(dictionary: [CommentedString: PBXProjPlistValue], newLines: Bool = true) {
        writeDictionaryStart()
        dictionary.forEach { write(dictionaryKey: $0.key, dictionaryValue: $0.value) }
        writeDictionaryEnd()
    }
    
    private func write(dictionaryKey: CommentedString, dictionaryValue: PBXProjPlistValue) {
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
