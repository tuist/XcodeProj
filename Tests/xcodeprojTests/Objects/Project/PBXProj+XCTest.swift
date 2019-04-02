import Foundation
@testable import XcodeProj

extension PBXProj {
    func encode() throws -> String {
        let outputSettings = PBXOutputSettings()
        let encoder = PBXProjEncoder(outputSettings: outputSettings)
        return try encoder.encode(proj: self)
    }
}
