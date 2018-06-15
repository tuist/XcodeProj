import Foundation

/// Generates the references of the project objects that have a temporary reference.
protocol ReferenceGenerating: AnyObject {
    /// Generates the references of the objects of the given project.
    ///
    /// - Parameter proj: project whose objects references will be generated.
    func generateReferences(proj: PBXProj) throws
}

/// Reference generator.
final class ReferenceGenerator: ReferenceGenerating {
    /// Project pbxproj instance.
    var proj: PBXProj?

    /// Generates the references of the objects of the given project.
    ///
    /// - Parameter proj: project whose objects references will be generated.
    func generateReferences(proj: PBXProj) throws {
        guard let project: PBXProject = try proj.rootObjectReference?.object() else {
            return
        }

        self.proj = proj
        defer {
            self.proj = nil
        }

        let identifiers = [String(describing: project), project.name]

        if project.reference.temporary {
            project.reference.fix(generate(identifiers: identifiers))
        }

        // Groups
        let mainGroup: PBXGroup = try project.mainGroupReference.object()
        try generateGroupReferences(mainGroup, identifiers: identifiers)
        // Note: Groups and files should be generated first because their references
        // are used to generate other references.

        // Targets
        let targets: [PBXTarget] = try project.targetsReferences.map({ try $0.object() as PBXTarget })
        try targets.forEach({ try generateTargetReferences($0, identifiers: identifiers) })

        // Project references
        try project.projectReferences.flatMap({ $0.values }).forEach { objectReference in
            let fileReference: PBXFileReference = try objectReference.object()
            try generateFileReference(fileReference, identifiers: identifiers)
        }

        /// Configuration list
        let configurationList: XCConfigurationList = try project.buildConfigurationListReference.object()
        try generateConfigurationListReferences(configurationList, identifiers: identifiers)
    }

    /// Generates the reference for a group object.
    ///
    /// - Parameters:
    ///   - group: group instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateGroupReferences(_ group: PBXGroup,
                                             identifiers: [String]) throws {
        var identifiers = identifiers
        identifiers.append(String(describing: group))
        if let groupName = group.fileName() {
            identifiers.append(groupName)
        }

        // Group
        if group.reference.temporary {
            group.reference.fix(generate(identifiers: identifiers))
        }

        // Children
        try group.childrenReferences.forEach { child in
            let childFileElement: PBXFileElement = try child.object()
            if let childGroup = childFileElement as? PBXGroup {
                try generateGroupReferences(childGroup, identifiers: identifiers)
            } else if let childFileReference = childFileElement as? PBXFileReference {
                try generateFileReference(childFileReference, identifiers: identifiers)
            }
        }
    }

    /// Generates the reference for a file reference object.
    ///
    /// - Parameters:
    ///   - fileReference: file reference instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateFileReference(_ fileReference: PBXFileReference, identifiers: [String]) throws {
        var identifiers = identifiers
        identifiers.append(String(describing: fileReference))
        if let groupName = fileReference.fileName() {
            identifiers.append(groupName)
        }

        if fileReference.reference.temporary {
            fileReference.reference.fix(generate(identifiers: identifiers))
        }
    }

    /// Generates the reference for a configuration list object.
    ///
    /// - Parameters:
    ///   - configurationList: configuration list instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateConfigurationListReferences(_ configurationList: XCConfigurationList,
                                                         identifiers: [String]) throws {
        var identifiers = identifiers
        identifiers.append(String(describing: configurationList))

        if configurationList.reference.temporary {
            configurationList.reference.fix(generate(identifiers: identifiers))
        }

        let buildConfigurations: [XCBuildConfiguration] = try configurationList.buildConfigurations()

        buildConfigurations.forEach { configuration in
            if !configuration.reference.temporary { return }

            var identifiers = identifiers
            identifiers.append(String(describing: configuration))
            identifiers.append(configuration.name)

            configuration.reference.fix(generate(identifiers: identifiers))
        }
    }

    /// Generates the reference for a target object.
    ///
    /// - Parameters:
    ///   - target: target instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateTargetReferences(_ target: PBXTarget,
                                              identifiers: [String]) throws {
        var identifiers = identifiers
        identifiers.append(String(describing: target))
        identifiers.append(target.name)

        // Configuration list
        if let configurationList = try target.buildConfigurationList() {
            try generateConfigurationListReferences(configurationList,
                                                    identifiers: identifiers)
        }
        // Build phases
        let buildPhashes = try target.buildPhasesReferences.map({ try $0.object() as PBXBuildPhase })
        try buildPhashes.forEach({ try generateBuildPhaseReferences($0,
                                                                    identifiers: identifiers) })

        // Build rules
        let buildRules = try target.buildRulesReferences.map({ try $0.object() as PBXBuildRule })
        try buildRules.forEach({ try generateBuildRules($0, identifiers: identifiers) })

        // Dependencies
        let dependencies = try target.buildRulesReferences.map({ try $0.object() as PBXTargetDependency })
        try dependencies.forEach({ try generateTargetDependencyReferences($0, identifiers: identifiers) })
    }

    /// Generates the reference for a target dependency object.
    ///
    /// - Parameters:
    ///   - targetDependency: target dependency instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateTargetDependencyReferences(_: PBXTargetDependency,
                                                        identifiers _: [String]) throws {
    }

    /// Generates the reference for a build phase object.
    ///
    /// - Parameters:
    ///   - buildPhase: build phase instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateBuildPhaseReferences(_ buildPhase: PBXBuildPhase,
                                                  identifiers: [String]) throws {
        var identifiers = identifiers
        identifiers.append(String(describing: buildPhase))
        if let name = buildPhase.name() {
            identifiers.append(name)
        }

        if buildPhase.reference.temporary {
            buildPhase.reference.fix(generate(identifiers: identifiers))
        }

        try buildPhase.filesReferences.forEach { buildFileReference in
            if buildFileReference.temporary { return }

            let buildFile: PBXBuildFile = try buildFileReference.object()

            var identifiers = identifiers
            identifiers.append(String(describing: buildFile))

            // Note: At this point the file reference reference shouldn't be temporary so we can
            // use its value to generate the reference of the build file.
            if let fileReference: PBXFileElement = try buildFile.fileReference?.object(), !fileReference.reference.temporary {
                identifiers.append(fileReference.reference.value)
            }

            buildFileReference.fix(generate(identifiers: identifiers))
        }
    }

    /// Generates the reference for a build rule object.
    ///
    /// - Parameters:
    ///   - buildRule: build phase instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateBuildRules(_: PBXBuildRule,
                                        identifiers _: [String]) throws {
    }

    /// Given a list of identifiers, it returns a deterministic reference.
    /// If the reference already exists in the project (very unlikely), it'll
    /// make sure the generated reference doesn't collide with the existing one.
    ///
    /// - Parameter identifiers: list of identifiers used to generate the reference of the object.
    /// - Returns: object reference.
    fileprivate func generate(identifiers _: [String]) -> String {
        // Check if the identifier already exists
        return ""
    }
}
