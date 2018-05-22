import Foundation

extension PBXNativeTarget {
    /// Adds a dependency to the target.
    ///
    /// - Parameter target: dependency target.
    /// - Returns: target dependency reference.
    /// - Throws: an error if the dependency cannot be created.
    public func addDependency(target: PBXNativeTarget) throws -> PBXObjectReference? {
        let objects = try target.objects()
        guard let project = objects.projects.first?.value else {
            return nil
        }
        let proxy = PBXContainerItemProxy(containerPortal: project.reference,
                                          remoteGlobalID: target.reference,
                                          proxyType: .nativeTarget,
                                          remoteInfo: target.name)
        let proxyReference = objects.addObject(proxy)
        let targetDependency = PBXTargetDependency(name: target.name,
                                                   target: target.reference,
                                                   targetProxy: proxyReference)
        let targetDependencyReference = objects.addObject(targetDependency)
        dependencies.append(targetDependencyReference)
        return targetDependencyReference
    }
}
