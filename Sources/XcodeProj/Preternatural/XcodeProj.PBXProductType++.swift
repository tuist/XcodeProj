//
// Copyright (c) Vatsal Manot
//

extension PBXProductType {
  /// Whether the product is executable or not.
  public var isExecutable: Bool {
    return self == .application
  }

  /// Whether the product is a library or not.
  public var isLibrary: Bool {
    return self == .staticLibrary || self == .dynamicLibrary
  }
}
