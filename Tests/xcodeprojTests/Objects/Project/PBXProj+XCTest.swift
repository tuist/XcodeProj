import Foundation
@testable import xcodeproj

extension PBXProj {
    func encode() throws -> String {
        let encoder = PBXProjEncoder()
        return try encoder.encode(proj: self)
    }
}
