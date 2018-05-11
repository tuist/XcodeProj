import Basic
import Foundation

public extension PBXObjects {
    /// Returns all the targets with the given name.
    ///
    /// - Parameters:
    ///   - name: target name.
    /// - Returns: targets with the given name.
    public func targets(named name: String) -> [PBXTarget] {
        var targets: [PBXTarget] = []
        targets.append(contentsOf: nativeTargets.values.map({ $0 as PBXTarget }))
        targets.append(contentsOf: legacyTargets.values.map({ $0 as PBXTarget }))
        targets.append(contentsOf: aggregateTargets.values.map({ $0 as PBXTarget }))
        return targets.filter { $0.name == name }
    }
}
