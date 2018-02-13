import Foundation
@testable import xcproj

extension PBXProj {
    func encode() -> String {
        let encoder = PBXProjEncoder()
        return encoder.encode(proj: self)
    }
}
