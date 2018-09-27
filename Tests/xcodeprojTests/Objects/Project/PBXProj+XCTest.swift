import Foundation
@testable import xcodeproj

extension PBXProj {
    func encode() throws -> String {
        let encoder = PBXProjEncoder()
        let outputSettings = PBXOutputSettings()
        return try encoder.encode(proj: self, outputSettings: outputSettings)
    }
}
