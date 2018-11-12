import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CreditCardDetectorTests.allTests),
        testCase(CreditCardNumberTests.allTests),
    ]
}
#endif
