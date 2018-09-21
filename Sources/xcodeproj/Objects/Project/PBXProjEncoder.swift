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
    let referenceGenerator: ReferenceGenerating = ReferenceGenerator()
    var indent: UInt = 0
    var output: String = ""
    var multiline: Bool = true
    
    // swiftlint:disable function_body_length
    func encode(proj: PBXProj, outputSettings: PBXOutputSettings) throws -> String {
        
        try referenceGenerator.generateReferences(proj: proj)
        guard let rootObject = proj.rootObjectReference else { throw PBXProjEncoderError.emptyProjectReference }

        sort(buildPhases: proj.objects.copyFilesBuildPhases, outputSettings: outputSettings)
        sort(buildPhases: proj.objects.frameworksBuildPhases, outputSettings: outputSettings)
        sort(buildPhases: proj.objects.headersBuildPhases, outputSettings: outputSettings)
        sort(buildPhases: proj.objects.resourcesBuildPhases, outputSettings: outputSettings)
        sort(buildPhases: proj.objects.sourcesBuildPhases, outputSettings: outputSettings)
        sort(navigatorGroups: proj.objects.groups, outputSettings: outputSettings)

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
        try write(section: "PBXAggregateTarget", proj: proj, object: proj.objects.aggregateTargets, outputSettings: outputSettings)
        try write(section: "PBXBuildFile", proj: proj, object: proj.objects.buildFiles, outputSettings: outputSettings)
        try write(section: "PBXBuildRule", proj: proj, object: proj.objects.buildRules, outputSettings: outputSettings)
        try write(section: "PBXContainerItemProxy", proj: proj, object: proj.objects.containerItemProxies, outputSettings: outputSettings)
        try write(section: "PBXCopyFilesBuildPhase", proj: proj, object: proj.objects.copyFilesBuildPhases, outputSettings: outputSettings)
        try write(section: "PBXFileReference", proj: proj, object: proj.objects.fileReferences, outputSettings: outputSettings)
        try write(section: "PBXFrameworksBuildPhase", proj: proj, object: proj.objects.frameworksBuildPhases, outputSettings: outputSettings)
        try write(section: "PBXGroup", proj: proj, object: proj.objects.groups, outputSettings: outputSettings)
        try write(section: "PBXHeadersBuildPhase", proj: proj, object: proj.objects.headersBuildPhases, outputSettings: outputSettings)
        try write(section: "PBXLegacyTarget", proj: proj, object: proj.objects.legacyTargets, outputSettings: outputSettings)
        try write(section: "PBXNativeTarget", proj: proj, object: proj.objects.nativeTargets, outputSettings: outputSettings)
        try write(section: "PBXProject", proj: proj, object: proj.objects.projects, outputSettings: outputSettings)
        try write(section: "PBXReferenceProxy", proj: proj, object: proj.objects.referenceProxies, outputSettings: outputSettings)
        try write(section: "PBXResourcesBuildPhase", proj: proj, object: proj.objects.resourcesBuildPhases, outputSettings: outputSettings)
        try write(section: "PBXRezBuildPhase", proj: proj, object: proj.objects.carbonResourcesBuildPhases, outputSettings: outputSettings)
        try write(section: "PBXShellScriptBuildPhase", proj: proj, object: proj.objects.shellScriptBuildPhases, outputSettings: outputSettings)
        try write(section: "PBXSourcesBuildPhase", proj: proj, object: proj.objects.sourcesBuildPhases, outputSettings: outputSettings)
        try write(section: "PBXTargetDependency", proj: proj, object: proj.objects.targetDependencies, outputSettings: outputSettings)
        try write(section: "PBXVariantGroup", proj: proj, object: proj.objects.variantGroups, outputSettings: outputSettings)
        try write(section: "XCBuildConfiguration", proj: proj, object: proj.objects.buildConfigurations, outputSettings: outputSettings)
        try write(section: "XCConfigurationList", proj: proj, object: proj.objects.configurationLists, outputSettings: outputSettings)
        try write(section: "XCVersionGroup", proj: proj, object: proj.objects.versionGroups, outputSettings: outputSettings)
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
    
    private func write<T>(section: String, proj: PBXProj, object: [PBXObjectReference: T], outputSettings: PBXOutputSettings) throws where T: PlistSerializable & Equatable {
        try write(section: section, proj: proj, object: object, sort: outputSettings.projFileListOrder.sort)
    }
    
    private func write(section: String, proj: PBXProj, object: [PBXObjectReference: PBXBuildFile], outputSettings: PBXOutputSettings) throws {
        try write(section: section, proj: proj, object: object, sort: outputSettings.projFileListOrder.sort)
    }
    
    private func write(section: String, proj: PBXProj, object: [PBXObjectReference: PBXFileReference], outputSettings: PBXOutputSettings) throws {
        try write(section: section, proj: proj, object: object, sort: outputSettings.projFileListOrder.sort)
    }
    
    private func write<T>(section: String,
                          proj: PBXProj,
                          object: [PBXObjectReference: T],
                          sort: ((PBXObjectReference, T), (PBXObjectReference, T)) -> Bool) throws where T: PlistSerializable & Equatable {
        if object.count == 0 { return }
        writeNewLine()
        write(string: "/* Begin \(section) section */")
        writeNewLine()
        try object.sorted(by: sort)
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
    
    private func sort(buildPhases: [PBXObjectReference: PBXBuildPhase], outputSettings: PBXOutputSettings) {
        if let sort = outputSettings.projBuildPhaseFileOrder.sort {
            buildPhases.values.forEach { $0.files = $0.files.sorted(by: sort) }
        }
    }

    private func sort(navigatorGroups: [PBXObjectReference: PBXGroup], outputSettings: PBXOutputSettings) {
        if let sort = outputSettings.projNavigatorFileOrder.sort {
            navigatorGroups.values.forEach { $0.children = $0.children.sorted(by: sort) }
        }
    }
}
