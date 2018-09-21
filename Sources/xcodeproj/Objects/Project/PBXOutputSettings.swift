//
//  FileSorting.swift
//  xcodeproj
//
//  Created by Derek Clarkson on 21/9/18.
//

import Foundation

/// Code for controlling sorting of files in an pbxproj file.

// Defines the sorting applied to files within the file lists. Defaults to by UUID.
public enum PBXFileOrder {
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

/// Defines the sorting applied to groups with the project navigator and various build phases.
public enum PBXNavigatorFileOrder {
    case unsorted
    case byFilename
    case byFilenameGroupsFirst

    var sort: ((PBXFileElement, PBXFileElement) -> Bool)? {

        switch self {

        case .byFilename:
            return { lhs, rhs in
                lhs.path ?? lhs.uuid < rhs.path ?? rhs.uuid
            }

        case .byFilenameGroupsFirst:
            return { lhs, rhs in
                switch (lhs, rhs) {

                case (is PBXFileReference, is PBXGroup):
                    return false

                case (is PBXGroup, is PBXFileReference):
                    return true

                default: // Where the types are the same or other types exist.
                    return lhs.path ?? lhs.uuid < rhs.path ?? rhs.uuid
                }
            }

        default:
            return nil // Don't sort.
        }
    }
}

/// Defines the sorting of file within a build phase.
public enum PBXBuildPhaseFileOrder {
    case unsorted
    case byFilename

    var sort: ((PBXBuildFile, PBXBuildFile) -> Bool)? {

        switch self {

        case .byFilename:
            return { lhs, rhs in
                lhs.file?.path ?? lhs.uuid < rhs.file?.path ?? rhs.uuid
            }

        default:
            return nil // Don't sort.
        }
    }
}

/// Struct of output settings passed to various methods.
public struct PBXOutputSettings {

    let projFileListOrder: PBXFileOrder
    let projNavigatorFileOrder: PBXNavigatorFileOrder
    let projBuildPhaseFileOrder: PBXBuildPhaseFileOrder

    /**
     Default initializer

     - Parameter projFileListOrder: Defines the sort order for internal file lists in the project file.
     - Parameter projNavigatorFileOrder: Defines the order of files in the project navigator groups.
     - Parameter projBuildPhaseFileOrder: Defines the sort order of files in build phases.
     */
    public init(projFileListOrder: PBXFileOrder = .byUUID,
                projNavigatorFileOrder: PBXNavigatorFileOrder = .unsorted,
                projBuildPhaseFileOrder: PBXBuildPhaseFileOrder = .unsorted) {
        self.projFileListOrder = projFileListOrder
        self.projNavigatorFileOrder = projNavigatorFileOrder
        self.projBuildPhaseFileOrder = projBuildPhaseFileOrder
    }


}
