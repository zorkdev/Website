import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [testCase(WebsiteTests.allTests)]
}
#endif
