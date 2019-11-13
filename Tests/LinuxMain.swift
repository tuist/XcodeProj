import XCTest
@testable import XcodeProjTests

var tests = [XCTestCaseEntry]()
tests += XcodeProjTests.allTests()
XCTMain(tests)
