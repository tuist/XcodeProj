// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - PBXAggregateTarget AutoEquatable
extension PBXAggregateTarget : Equatable  {
  public static func == (lhs: PBXAggregateTarget, rhs: PBXAggregateTarget) -> Bool {
    guard (lhs as PBXTarget) == (rhs as PBXTarget) else { return false }
    return true
  }
}
// MARK: - PBXLegacyTarget AutoEquatable
extension PBXLegacyTarget : Equatable  {
  public static func == (lhs: PBXLegacyTarget, rhs: PBXLegacyTarget) -> Bool {
    guard compareOptionals(lhs: lhs.buildToolPath, rhs: rhs.buildToolPath, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.buildArgumentsString, rhs: rhs.buildArgumentsString, compare: ==) else { return false }
    guard lhs.passBuildSettingsInEnvironment == rhs.passBuildSettingsInEnvironment else { return false }
    guard compareOptionals(lhs: lhs.buildWorkingDirectory, rhs: rhs.buildWorkingDirectory, compare: ==) else { return false }
    guard (lhs as PBXTarget) == (rhs as PBXTarget) else { return false }
    return true
  }
}
// MARK: - PBXNativeTarget AutoEquatable
extension PBXNativeTarget : Equatable  {
  public static func == (lhs: PBXNativeTarget, rhs: PBXNativeTarget) -> Bool {
    guard (lhs as PBXTarget) == (rhs as PBXTarget) else { return false }
    return true
  }
}
// MARK: - PBXTarget AutoEquatable
extension PBXTarget  {
  public static func == (lhs: PBXTarget, rhs: PBXTarget) -> Bool {
    guard compareOptionals(lhs: lhs.buildConfigurationList, rhs: rhs.buildConfigurationList, compare: ==) else { return false }
    guard lhs.buildPhases == rhs.buildPhases else { return false }
    guard lhs.buildRules == rhs.buildRules else { return false }
    guard lhs.dependencies == rhs.dependencies else { return false }
    guard lhs.name == rhs.name else { return false }
    guard compareOptionals(lhs: lhs.productName, rhs: rhs.productName, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.productReference, rhs: rhs.productReference, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.productType, rhs: rhs.productType, compare: ==) else { return false }
    return true
  }
}

// MARK: - AutoEquatable for Enums
