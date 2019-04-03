import Foundation
@testable import XcodeProj

extension PBXProj {
    func encode() -> String {
        let outputSettings = PBXOutputSettings()
        let encoder = PBXProjEncoder(outputSettings: outputSettings)
        return encoder.encode(proj: self)
    }
}
