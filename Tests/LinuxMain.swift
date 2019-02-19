import XCTest

import xcodeprojTests
import xcodeprojIntegrationTests

var tests = [XCTestCaseEntry]()
tests += xcodeprojTests.__allTests()
tests += xcodeprojIntegrationTests.__allTests()

XCTMain(tests)
