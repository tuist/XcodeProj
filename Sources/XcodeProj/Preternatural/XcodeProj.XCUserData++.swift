//
// Copyright (c) Vatsal Manot
//

import PathKit

extension XCUserData {
    public convenience init(pathString: String) throws {
        try self.init(path: Path(pathString))
    }
    
    public static func initialize(from pathString: String) -> [XCUserData] {
        let path = Path(pathString)
        let userData = XCUserData.path(path)
            .glob("*.xcuserdatad")
            .compactMap { return try? XCUserData(path: $0) }
        return userData
    }
}
