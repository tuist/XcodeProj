import Foundation

/// Protocol that defines that the element can return a plist element that represents itself.
protocol PlistSerializable {
    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue)
    var multiline: Bool { get }
}

extension PlistSerializable {
    var multiline: Bool { return true }
}

/// Encodes your PBXProj files to String
final class PBXProjEncoder {
    var indent: UInt = 0
    var output: String = ""
    var multiline: Bool = true

    // swiftlint:disable function_body_length
    func encode(proj: PBXProj) throws -> String {
        guard let rootObject = proj.rootObjectReference else { throw PBXProjEncoderError.emptyProjectReference }
        writeUtf8()
        writeNewLine()
        writeDictionaryStart()
        write(dictionaryKey: "archiveVersion", dictionaryValue: .string(CommentedString("\(proj.archiveVersion)")))
        write(dictionaryKey: "classes", dictionaryValue: .dictionary([:]))
        write(dictionaryKey: "objectVersion", dictionaryValue: .string(CommentedString("\(proj.objectVersion)")))
        writeIndent()
        write(string: "objects = {")
        increaseIndent()
        writeNewLine()
        try write(section: "PBXAggregateTarget", proj: proj, object: proj.objects.aggregateTargets)
        try write(section: "PBXBuildFile", proj: proj, object: proj.objects.buildFiles)
        try write(section: "PBXBuildRule", proj: proj, object: proj.objects.buildRules)
        try write(section: "PBXContainerItemProxy", proj: proj, object: proj.objects.containerItemProxies)
        try write(section: "PBXCopyFilesBuildPhase", proj: proj, object: proj.objects.copyFilesBuildPhases)
        try write(section: "PBXFileReference", proj: proj, object: proj.objects.fileReferences)
        try write(section: "PBXFrameworksBuildPhase", proj: proj, object: proj.objects.frameworksBuildPhases)
        try write(section: "PBXGroup", proj: proj, object: proj.objects.groups)
        try write(section: "PBXHeadersBuildPhase", proj: proj, object: proj.objects.headersBuildPhases)
        try write(section: "PBXLegacyTarget", proj: proj, object: proj.objects.legacyTargets)
        try write(section: "PBXNativeTarget", proj: proj, object: proj.objects.nativeTargets)
        try write(section: "PBXProject", proj: proj, object: proj.objects.projects)
        try write(section: "PBXReferenceProxy", proj: proj, object: proj.objects.referenceProxies)
        try write(section: "PBXResourcesBuildPhase", proj: proj, object: proj.objects.resourcesBuildPhases)
        try write(section: "PBXRezBuildPhase", proj: proj, object: proj.objects.carbonResourcesBuildPhases)
        try write(section: "PBXShellScriptBuildPhase", proj: proj, object: proj.objects.shellScriptBuildPhases)
        try write(section: "PBXSourcesBuildPhase", proj: proj, object: proj.objects.sourcesBuildPhases)
        try write(section: "PBXTargetDependency", proj: proj, object: proj.objects.targetDependencies)
        try write(section: "PBXVariantGroup", proj: proj, object: proj.objects.variantGroups)
        try write(section: "XCBuildConfiguration", proj: proj, object: proj.objects.buildConfigurations)
        try write(section: "XCConfigurationList", proj: proj, object: proj.objects.configurationLists)
        try write(section: "XCVersionGroup", proj: proj, object: proj.objects.versionGroups)
        decreaseIndent()
        writeIndent()
        write(string: "};")
        writeNewLine()
        write(dictionaryKey: "rootObject",
              dictionaryValue: .string(CommentedString(rootObject.value,
                                                       comment: "Project object")))
        writeDictionaryEnd()
        writeNewLine()

        // clear reference cache
        return output
    }

    // MARK: - Private

    private func writeUtf8() {
        output.append("// !$*UTF8*$!")
    }

    private func writeNewLine() {
        if multiline {
            output.append("\n")
        } else {
            output.append(" ")
        }
    }

    private func write(value: PlistValue) {
        switch value {
        case let .array(array):
            write(array: array)
        case let .dictionary(dictionary):
            write(dictionary: dictionary)
        case let .string(commentedString):
            write(commentedString: commentedString)
        }
    }

    private func write(commentedString: CommentedString) {
        write(string: commentedString.validString)
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

    private func write<T: PlistSerializable & Equatable>(section: String, proj: PBXProj, object: [PBXObjectReference: T]) throws {
        if object.count == 0 { return }
        writeNewLine()
        write(string: "/* Begin \(section) section */")
        writeNewLine()
        try object.sorted(by: { $0.key < $1.key })
            .forEach { key, value in
                let element = try value.plistKeyAndValue(proj: proj, reference: key.value)
                write(dictionaryKey: element.key, dictionaryValue: element.value, multiline: value.multiline)
            }
        write(string: "/* End \(section) section */")
        writeNewLine()
    }

    private func write(dictionary: [CommentedString: PlistValue], newLines _: Bool = true) {
        writeDictionaryStart()
        dictionary.sorted(by: { (left, right) -> Bool in
            if left.key == "isa" {
                return true
            } else if right.key == "isa" {
                return false
            } else {
                return left.key.string < right.key.string
            }
        })
            .forEach({ write(dictionaryKey: $0.key, dictionaryValue: $0.value, multiline: self.multiline) })
        writeDictionaryEnd()
    }

    private func write(dictionaryKey: CommentedString, dictionaryValue: PlistValue, multiline: Bool = true) {
        writeIndent()
        let beforeMultiline = self.multiline
        self.multiline = multiline
        write(commentedString: dictionaryKey)
        output.append(" = ")
        write(value: dictionaryValue)
        output.append(";")
        self.multiline = beforeMultiline
        writeNewLine()
    }

    private func writeDictionaryStart() {
        output.append("{")
        if multiline { writeNewLine() }
        increaseIndent()
    }

    private func writeDictionaryEnd() {
        decreaseIndent()
        writeIndent()
        output.append("}")
    }

    private func write(array: [PlistValue]) {
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

    private func writeArrayStart() {
        output.append("(")
        if multiline { writeNewLine() }
        increaseIndent()
    }

    private func writeArrayEnd() {
        decreaseIndent()
        writeIndent()
        output.append(")")
    }

    private func writeIndent() {
        if multiline {
            output.append(String(repeating: "\t", count: Int(indent)))
        }
    }

    private func increaseIndent() {
        indent += 1
    }

    private func decreaseIndent() {
        indent -= 1
    }
}
