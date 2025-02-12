//
// Copyright (c) Vatsal Manot
//

extension PBXProductType {
    public var isExecutable: Bool {
        isApp || isExtension || isSystemExtension || isTest || self == .commandLineTool
    }
    
    public var isLibrary: Bool {
        self == .staticLibrary || self == .dynamicLibrary
    }
    
    public var isExtension: Bool {
        fileExtension == "appex"
    }
    
    public var isSystemExtension: Bool {
        fileExtension == "dext" || fileExtension == "systemextension"
    }
    
    public var isApp: Bool {
        fileExtension == "app"
    }
    
    public var isTest: Bool {
        fileExtension == "xctest"
    }
}
