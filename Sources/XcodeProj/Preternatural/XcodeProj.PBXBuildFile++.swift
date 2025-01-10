//
// Copyright (c) Vatsal Manot
//

extension PBXBuildFile {
    /// Sets whether code signing on copy is enabled for this build file
    public func setCodeSigningOnCopy(_ enabled: Bool) {
        if enabled {
            appendToSettingsArray(value: "CodeSignOnCopy", forKey: "ATTRIBUTES")
        } else {
            removeFromSettingsArray(value: "CodeSignOnCopy", forKey: "ATTRIBUTES")
        }
    }
    
    private func appendToSettingsArray(value: String, forKey key: String) {
        var currentSettings = settings ?? [:]
        var array = (currentSettings[key] as? [String]) ?? []
        
        if !array.contains(value) {
            array.append(value)
        }
        
        currentSettings[key] = array
        settings = currentSettings
    }
    
    private func removeFromSettingsArray(value: String, forKey key: String) {
        var currentSettings = settings ?? [:]
        guard var array = currentSettings[key] as? [String] else {
            return
        }
        
        array.removeAll { $0 == value }
        
        if array.isEmpty {
            currentSettings.removeValue(forKey: key)
        } else {
            currentSettings[key] = array
        }
        
        settings = currentSettings
    }
}

