import Foundation
import XcodeProjectFormat

/// A build setting key split into its name and its bracketed conditions.
///
/// Xcode build setting keys can carry conditions, as in
/// `OTHER_LDFLAGS[sdk=iphoneos*][arch=arm64]`. The `project.xcproj` format keeps one flat
/// dictionary of build settings per project and per target, and expresses the per-configuration
/// values through a `config=` condition. `PBXProj` instead keeps one dictionary per
/// `XCBuildConfiguration`, so converting in either direction means moving that condition in or out
/// of the key.
struct BuildSettingKey: Equatable {
    /// The setting name, without any condition.
    var name: String

    /// The conditions, each without its surrounding brackets, in the order they appeared.
    var conditions: [String]

    /// The name of the build configuration this key is limited to, if any.
    var configurationName: String? {
        for condition in conditions {
            if let value = condition.droppingConditionPrefix("config") {
                return value
            }
        }
        return nil
    }

    init(name: String, conditions: [String] = []) {
        self.name = name
        self.conditions = conditions
    }

    /// Parses a raw build setting key.
    init(rawValue: String) {
        guard let bracket = rawValue.firstIndex(of: "[") else {
            self.init(name: rawValue)
            return
        }
        var conditions: [String] = []
        var remainder = rawValue[bracket...]
        while remainder.hasPrefix("["), let close = remainder.firstIndex(of: "]") {
            conditions.append(String(remainder[remainder.index(after: remainder.startIndex) ..< close]))
            remainder = remainder[remainder.index(after: close)...]
        }
        // A key such as `FOO[bar` is not a valid condition list. Keep it verbatim rather than
        // silently dropping the trailing text.
        guard remainder.isEmpty else {
            self.init(name: rawValue)
            return
        }
        self.init(name: String(rawValue[rawValue.startIndex ..< bracket]), conditions: conditions)
    }

    /// The raw key, as it appears in a project file.
    var rawValue: String {
        name + conditions.map { "[\($0)]" }.joined()
    }

    /// A copy of this key without its `config=` condition.
    func removingConfigurationCondition() -> BuildSettingKey {
        BuildSettingKey(
            name: name,
            conditions: conditions.filter { $0.droppingConditionPrefix("config") == nil }
        )
    }

    /// A copy of this key limited to the given build configuration.
    func addingConfigurationCondition(_ configurationName: String) -> BuildSettingKey {
        BuildSettingKey(name: name, conditions: ["config=\(configurationName)"] + conditions)
    }
}

private extension StringProtocol {
    /// Returns the value of a `name=value` condition, or `nil` when the condition has another name.
    func droppingConditionPrefix(_ name: String) -> String? {
        guard hasPrefix(name + "=") else { return nil }
        return String(dropFirst(name.count + 1))
    }
}

// MARK: - Schema to PBXProj

enum BuildSettingsMapping {
    /// Splits one flat `project.xcproj` build settings dictionary into one dictionary per build
    /// configuration.
    ///
    /// A key without a `config=` condition applies to every configuration. A key whose `config=`
    /// condition names one of `configurationNames` applies only to that configuration, and the
    /// condition is removed from the key. A `config=` condition that matches no configuration, for
    /// instance a wildcard such as `config=*`, is left on the key and applied to every
    /// configuration, because `PBXProj` has no better place to put it.
    static func split(
        _ settings: [String: XCSchema.BuildSetting],
        configurationNames: [String]
    ) -> [String: BuildSettings] {
        var result: [String: BuildSettings] = [:]
        for name in configurationNames {
            result[name] = [:]
        }
        let known = Set(configurationNames)

        for (rawKey, value) in settings {
            let key = BuildSettingKey(rawValue: rawKey)
            let setting = BuildSetting(value)
            if let configuration = key.configurationName, known.contains(configuration) {
                result[configuration]?[key.removingConfigurationCondition().rawValue] = setting
            } else {
                for name in configurationNames {
                    result[name]?[rawKey] = setting
                }
            }
        }
        return result
    }

    /// Merges one build settings dictionary per build configuration into the single flat dictionary
    /// that `project.xcproj` stores.
    ///
    /// A setting whose value is the same in every configuration is written without a condition. Any
    /// other setting is written once per configuration that defines it, with a `config=` condition.
    /// `configurationNames` fixes the order in which conditional keys are produced.
    static func merge(
        _ settingsByConfiguration: [String: BuildSettings],
        configurationNames: [String]
    ) -> [String: XCSchema.BuildSetting] {
        var result: [String: XCSchema.BuildSetting] = [:]
        var keys: [String] = []
        var seenKeys: Set<String> = []
        for name in configurationNames {
            for key in (settingsByConfiguration[name] ?? [:]).keys.sorted() where seenKeys.insert(key).inserted {
                keys.append(key)
            }
        }

        for rawKey in keys {
            let values = configurationNames.map { settingsByConfiguration[$0]?[rawKey] }
            let definedEverywhere = values.allSatisfy { $0 != nil }
            let allEqual = values.dropFirst().allSatisfy { $0 == values.first }

            if definedEverywhere, allEqual, let value = values.first ?? nil {
                result[rawKey] = XCSchema.BuildSetting(value)
                continue
            }
            let key = BuildSettingKey(rawValue: rawKey)
            for (name, value) in zip(configurationNames, values) {
                guard let value else { continue }
                result[key.addingConfigurationCondition(name).rawValue] = XCSchema.BuildSetting(value)
            }
        }
        return result
    }
}

// MARK: - Value conversion

extension BuildSetting {
    init(_ setting: XCSchema.BuildSetting) {
        switch setting {
        case let .string(value): self = .string(value)
        case let .array(value): self = .array(value)
        }
    }
}

extension XCSchema.BuildSetting {
    init(_ setting: BuildSetting) {
        switch setting {
        case let .string(value): self = .string(value)
        case let .array(value): self = .array(value)
        }
    }
}
