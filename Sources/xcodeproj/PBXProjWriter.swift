import Foundation

/// Protocol that defines that the element can return a plist element that represents itself.
protocol PlistSerializable {
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue)
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
        write(section: "PBXAggregateTarget", proj: proj, object: proj.objects.aggregateTargets)
        write(section: "PBXBuildFile", proj: proj, object: proj.objects.buildFiles)
        write(section: "PBXFileReference", proj: proj, object: proj.objects.fileReferences)
        write(section: "PBXProject", proj: proj, object: proj.objects.projects)
        write(section: "PBXFileElement", proj: proj, object: proj.objects.fileElements)
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
    
    private func write(value: PlistValue) {
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
    
    private func write(section: String, proj: PBXProj, object: [PlistSerializable]) {
        if object.count == 0 { return }
        write(string: "/* Begin \(section) section */")
        writeNewLine()
        object.forEach { (serializable) in
            let element = serializable.plistKeyAndValue(proj: proj)
            write(dictionaryKey: element.key, dictionaryValue: element.value)
        }
        write(string: "/* End \(section) section */")
        writeNewLine()
    }
    
    private func write(dictionary: [CommentedString: PlistValue], newLines: Bool = true) {
        writeDictionaryStart()
        dictionary.forEach { write(dictionaryKey: $0.key, dictionaryValue: $0.value) }
        writeDictionaryEnd()
    }
    
    private func write(dictionaryKey: CommentedString, dictionaryValue: PlistValue) {
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
    
    private func write(array: [PlistValue], newlines: Bool = true) {
        writeArrayStart()
        array.forEach { write(arrayValue: $0) }
        writeArrayEnd()
    }
    
    private func write(arrayValue: PlistValue) {
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
