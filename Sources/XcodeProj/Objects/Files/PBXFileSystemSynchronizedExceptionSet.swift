import Foundation

/// Common class for exception sets, such as `PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet` and `PBXFileSystemSynchronizedBuildFileExceptionSet`
public class PBXFileSystemSynchronizedExceptionSet: PBXObject {
    /// The synchronized root group this exception set belongs to.
    public internal(set) weak var synchronizedRootGroup: PBXFileSystemSynchronizedRootGroup?

    /// The comment string used when this object is referenced in a plist.
    var plistComment: String { type(of: self).isa }
}
