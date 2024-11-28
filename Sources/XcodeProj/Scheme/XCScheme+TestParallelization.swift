import Foundation

public extension XCScheme {
  /// With the introduction of Swift Testing and Xcode 16, you can now choose to run your tests in parallel across either the full suite of tests in a target with `.all`, just those created under Swift Testing with `.swiftTestingOnly`, or run them serially with the `.none` option.
  enum TestParallelization: String {
    case all
    case swiftTestingOnly
    case none
  }
}
