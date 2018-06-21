import Foundation

/// Generates the deterministic references of the project objects that have a temporary reference.
/// When objects are added to the project, those are added with a temporary reference that other
/// objects can refer to. Before saving the project, we make those references permanent giving them
/// a deterministic value that depends on the object itself and its ancestor.
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

        // Projects, targets, groups and file references.
        // Note: The references of those type of objects should be generated first.
        ///      We use them to generate the references of the objects that depend on them.
        ///      For instance, the reference of a build file, is generated from the reference of
        ///      the file it refers to.
        let identifiers = [String(describing: project), project.name]
        generateProjectAndTargets(project: project, identifiers: identifiers)
        if let mainGroup: PBXGroup = try? project.mainGroupReference.object() {
            try generateGroupReferences(mainGroup, identifiers: identifiers)
        }

        // Targets
        let targets: [PBXTarget] = project.targetsReferences.compactMap({ try? $0.object() as PBXNativeTarget })
        try targets.forEach({ try generateTargetReferences($0, identifiers: identifiers) })

        // Project references
        try project.projectReferences.flatMap({ $0.values }).forEach { objectReference in
            guard let fileReference: PBXFileReference = try? objectReference.object() else { return }
            try generateFileReference(fileReference, identifiers: identifiers)
        }

        /// Configuration list
        if let configurationList: XCConfigurationList = try? project.buildConfigurationListReference.object() {
            try generateConfigurationListReferences(configurationList, identifiers: identifiers)
        }
    }

    /// Generates the reference for the project and its target.
    ///
    /// - Parameters:
    ///   - project: project whose reference will be generated.
    ///   - identifiers: list of identifiers.
    func generateProjectAndTargets(project: PBXProject,
                                   identifiers: [String]) {
        // Project
        if project.reference.temporary {
            project.reference.fix(generate(identifiers: identifiers))
        }

        // Targets
        let targets: [PBXTarget] = project.targetsReferences.compactMap({ try? $0.object() as PBXTarget })
        targets.forEach { target in

            var identifiers = identifiers
            identifiers.append(String(describing: target))
            identifiers.append(target.name)

            if target.reference.temporary {
                target.reference.fix(generate(identifiers: identifiers))
            }
        }
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
            guard let childFileElement: PBXFileElement = try? child.object() else { return }
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
        let buildPhases = target.buildPhasesReferences.compactMap({ try? $0.object() as PBXBuildPhase })
        try buildPhases.forEach({ try generateBuildPhaseReferences($0,
                                                                   identifiers: identifiers) })

        // Build rules
        let buildRules = target.buildRulesReferences.compactMap({ try? $0.object() as PBXBuildRule })
        try buildRules.forEach({ try generateBuildRules($0, identifiers: identifiers) })

        // Dependencies
        let dependencies = target.dependenciesReferences.compactMap({ try? $0.object() as PBXTargetDependency })
        try dependencies.forEach({ try generateTargetDependencyReferences($0, identifiers: identifiers) })
    }

    /// Generates the reference for a target dependency object.
    ///
    /// - Parameters:
    ///   - targetDependency: target dependency instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateTargetDependencyReferences(_ targetDependency: PBXTargetDependency,
                                                        identifiers: [String]) throws {
        var identifiers = identifiers
        identifiers.append(String(describing: targetDependency))

        // Target proxy
        if let targetProxyReference = targetDependency.targetProxyReference,
            targetProxyReference.temporary,
            let targetProxy = try targetDependency.targetProxy(),
            let remoteGlobalIDReference = targetProxy.remoteGlobalIDReference {
            var identifiers = identifiers
            identifiers.append(String(describing: targetProxy))
            identifiers.append(remoteGlobalIDReference.value)
            targetProxyReference.fix(generate(identifiers: identifiers))
        }

        // Target dependency
        if targetDependency.reference.temporary {
            if let targetReference = targetDependency.targetReference?.value {
                identifiers.append(targetReference)
            }
            if let targetProxyReference = targetDependency.targetProxyReference?.value {
                identifiers.append(targetProxyReference)
            }
            targetDependency.reference.fix(generate(identifiers: identifiers))
        }
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

        // Build phase
        if buildPhase.reference.temporary {
            buildPhase.reference.fix(generate(identifiers: identifiers))
        }

        // Build files
        buildPhase.fileReferences.forEach { buildFileReference in
            if !buildFileReference.temporary { return }

            guard let buildFile: PBXBuildFile = try? buildFileReference.object() else { return }

            var identifiers = identifiers
            identifiers.append(String(describing: buildFile))

            if let fileReference = buildFile.fileReference,
                let fileReferenceObject: PBXObject = try? fileReference.object() {
                identifiers.append(fileReferenceObject.reference.value)
            }

            buildFileReference.fix(generate(identifiers: identifiers))
        }
    }

    /// Generates the reference for a build rule object.
    ///
    /// - Parameters:
    ///   - buildRule: build phase instance.
    ///   - identifiers: list of identifiers.
    fileprivate func generateBuildRules(_ buildRule: PBXBuildRule,
                                        identifiers: [String]) throws {
        var identifiers = identifiers
        identifiers.append(String(describing: buildRule))
        if let name = buildRule.name {
            identifiers.append(name)
        }

        // Build rule
        if buildRule.reference.temporary {
            buildRule.reference.fix(generate(identifiers: identifiers))
        }
    }

    /// Given a list of identifiers, it returns a deterministic reference.
    /// If the reference already exists in the project (very unlikely), it'll
    /// make sure the generated reference doesn't collide with the existing one.
    ///
    /// - Parameter identifiers: list of identifiers used to generate the reference of the object.
    /// - Returns: object reference.
    fileprivate func generate(identifiers: [String]) -> String {
        return identifiers.joined(separator: "-").md5.uppercased()
    }
}
