import Foundation

// Defines the sorting applied to files within the file lists. Defaults to by UUID.
public enum FileListSortOrder {
    case byUUID
    case byFilename
    
    func sort<Object>(lhs: (PBXObjectReference, Object), rhs: (PBXObjectReference, Object)) -> Bool where Object: PlistSerializable & Equatable {
        return lhs.0 < rhs.0
    }
    
    func sort(lhs: (PBXObjectReference, PBXBuildFile), rhs: (PBXObjectReference, PBXBuildFile)) -> Bool {
        switch self {
        case .byFilename:
            return lhs.1.file?.path ?? lhs.1.uuid < rhs.1.file?.path ?? rhs.1.uuid
        default:
            return lhs.0 < rhs.0
        }
    }
    
    func sort(lhs: (PBXObjectReference, PBXFileReference), rhs: (PBXObjectReference, PBXFileReference)) -> Bool {
        switch self {
        case .byFilename:
            return lhs.1.path ?? lhs.1.uuid < rhs.1.path ?? rhs.1.uuid
        default:
            return lhs.0 < rhs.0
        }
    }
}

// Defines the sorting applied to groups with the project navigator and various build phases.
public enum ProjectNavigatorSortOrder {
    case unsorted
    case byFilename
    case byFilenameGroupsFirst
}

public enum BuildPhaseFileSortOrder {
    case unsorted
    case byFilename
}

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
    
    public var fileListSortOrder: FileListSortOrder = .byUUID
    public var navigatorGroupSortOrder: ProjectNavigatorSortOrder = .unsorted
    public var buildPhaseFileSortOrder: BuildPhaseFileSortOrder = .unsorted
    
    // swiftlint:disable function_body_length
    func encode(proj: PBXProj) throws -> String {
        
        try referenceGenerator.generateReferences(proj: proj)
        guard let rootObject = proj.rootObjectReference else { throw PBXProjEncoderError.emptyProjectReference }
        
        // Sort sub objects in advance.
        proj.forEach(self.sortFiles)
        
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
    
    private func write<T>(section: String, proj: PBXProj, object: [PBXObjectReference: T]) throws where T: PlistSerializable & Equatable {
        try write(section: section, proj: proj, object: object, sort: fileListSortOrder.sort)
    }
    
    private func write(section: String, proj: PBXProj, object: [PBXObjectReference: PBXBuildFile]) throws {
        try write(section: section, proj: proj, object: object, sort: fileListSortOrder.sort)
    }
    
    private func write(section: String, proj: PBXProj, object: [PBXObjectReference: PBXFileReference]) throws {
        try write(section: section, proj: proj, object: object, sort: fileListSortOrder.sort)
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
    
    private func sortFiles<T>(_ obj: T) where T: PBXObject {
        
        switch obj {
            
        case let buildPhase as PBXBuildPhase:
            if buildPhaseFileSortOrder == .byFilename {
                buildPhase.files = buildPhase.files.sorted { lhs, rhs in
                    lhs.file?.path ?? lhs.uuid < rhs.file?.path ?? rhs.uuid
                }
            }
            
        case let fileGroup as PBXGroup:
            
            if navigatorGroupSortOrder == .byFilename {
                fileGroup.children = fileGroup.children.sorted { lhs, rhs in
                    lhs.path ?? lhs.uuid < rhs.path ?? rhs.uuid
                }
            }
            
            if navigatorGroupSortOrder == .byFilenameGroupsFirst {
                fileGroup.children = fileGroup.children.sorted { lhs, rhs in
                    switch (lhs, rhs) {
                        
                    case (is PBXFileReference, is PBXGroup):
                        return false
                        
                    case (is PBXGroup, is PBXFileReference):
                        return true

                    default: // Where the types are the same or other types exist.
                        return lhs.path ?? lhs.uuid < rhs.path ?? rhs.uuid
                    }
                }
            }
            
        default:
            // Do nothing
            break
        }
    }
}
