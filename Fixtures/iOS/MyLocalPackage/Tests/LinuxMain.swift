import XCTest

import MyLocalPackageTests

var tests = [XCTestCaseEntry]()
tests += MyLocalPackageTests.allTests()
XCTMain(tests)
