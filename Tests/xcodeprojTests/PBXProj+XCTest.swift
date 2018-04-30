import Foundation
@testable import xcodeproj

extension PBXProj {
    func encode() -> String {
        let encoder = PBXProjEncoder()
        return encoder.encode(proj: self)
    }
}
