import XCTest
@testable import CreditCardDetector

final class CreditCardDetectorTests: XCTestCase {
    
    func testSingleCard() {
        let textSingleCard = ["This is Visa: 4485679678967628",
                              "This is Visa with -: 4485-6796-7896-7628",
                              "This is Mastercard: 5567008565655260"]

        textSingleCard.forEach {
            let detector = CreditCardDetector(with: $0)
            XCTAssertFalse(detector.isEmpty, "Should find card pattern in \($0)")
        }
    }
    
    func testNoCard() {
        let textNoCardCard = ["", "Simple text", "Text with 11234 numbers"]
        
        textNoCardCard.forEach {
            let detector = CreditCardDetector(with: $0)
            XCTAssertTrue(detector.isEmpty, "Should not find card pattern in \($0)")
        }
    }
    
    func testReplaced() {
        let text = "This is Visa: 4485679678967628"
        let expected = "This is Visa: ****"
        
        let detector = CreditCardDetector(with: text)
        let processed = detector.replaced(with: "****", on: detector.first!)
        
        XCTAssertEqual(expected, processed)
    }
    
    func testReplaceAll() {
        let cases = [("This is Visa: 4485679678967628", "This is Visa: ****"),
                     ("", ""),
                     ("No card here", "No card here"),
                     ("Card 4485679678967628, and 4485-6796-7896-7628, or card 5567 0085 6565 5260", "Card ****, and ****, or card ****"),]
        
        cases.forEach {
            let detector = CreditCardDetector(with: $0.0)
            let processed = detector.replaced(with: "****") { _ in return true }
            XCTAssertEqual($0.1, processed)
        }
    }

    func testReplaceUsingGenerator() {
        let cases = [("This is Visa: 4485679678967628", "This is Visa: ****7628"),
                     ("", ""),
                     ("No card here", "No card here"),
                     ("Card 4485679678967628, and 4485-6796-7896-7628, or card 5567 0085 6565 5260", "Card ****7628, and ****7628, or card ****5260"),]
        
        cases.forEach {
            let detector = CreditCardDetector(with: $0.0)
            let processed = detector.replaced {
                return "****"+$0.number.last4
            }
            XCTAssertEqual($0.1, processed)
        }
    }

    static var allTests = [
        ("testSingleCard", testSingleCard),
        ("testNoCard", testNoCard),
        ("testReplaced", testReplaced),
        ("testReplaceUsingGenerator", testReplaceUsingGenerator),
    ]
}
