import Foundation

/// This is the element for a build target that aggregates several others.
public final class PBXAggregateTarget: PBXTarget {
    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXAggregateTarget else { return false }
        return isEqual(to: rhs)
    }
}

// MARK: - PBXAggregateTarget Extension (PlistSerializable)

extension PBXAggregateTarget: PlistSerializable {
    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        return try plistValues(proj: proj, isa: PBXAggregateTarget.isa, reference: reference)
    }
}

// MARK: - Helpers

public extension PBXAggregateTarget {
    /// Adds a local target dependency to the target.
    ///
    /// - Parameter target: dependency target.
    /// - Returns: target dependency reference.
    /// - Throws: an error if the dependency cannot be created.
    func addDependency(target: PBXTarget) throws -> PBXTargetDependency? {
        let objects = try target.objects()
        guard let project = objects.projects.first?.value else {
            return nil
        }
        let proxy = PBXContainerItemProxy(containerPortal: .project(project),
                                          remoteGlobalID: .object(target),
                                          proxyType: .nativeTarget,
                                          remoteInfo: target.name)
        objects.add(object: proxy)
        let targetDependency = PBXTargetDependency(name: target.name,
                                                   target: target,
                                                   targetProxy: proxy)
        objects.add(object: targetDependency)
        dependencies.append(targetDependency)
        return targetDependency
    }
}
