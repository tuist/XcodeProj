import Foundation

// This is the element for referencing localized resources.
public final class PBXVariantGroup: PBXGroup {
    public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXVariantGroup else { return false }
        return super.isEqual(to: rhs)
    }
}
