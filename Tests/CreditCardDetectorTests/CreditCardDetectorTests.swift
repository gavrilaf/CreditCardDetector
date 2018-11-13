import XCTest
import CreditCardDetector

final class CreditCardDetectorTests: XCTestCase {
    
    func testSingleCardSearch() {
        let textSingleCard = ["This is Visa: 4485679678967628",
                              "This is Visa with -: 4485-6796-7896-7628",
                              "This is Mastercard: 5567008565655260",
                              "amexnobounds376600200115411"]

        textSingleCard.forEach {
            let detector = CreditCardDetector(with: $0)
            XCTAssertFalse(detector.isEmpty, "Should found card pattern in \($0)")
        }
    }
    
    func testNoCard() {
        let textNoCardCard = ["", "Simple text", "Text with 11234 numbers"]
        
        textNoCardCard.forEach {
            let detector = CreditCardDetector(with: $0)
            XCTAssertTrue(detector.isEmpty, "Should not found card pattern in \($0)")
        }
    }
    
    func testSingleCardSearchWithWordBounds() {
        let textShouldFound = ["This is Visa: 4485679678967628",
                               "This is Visa with -: 4485-6796-7896-7628",
                               "This is Mastercard: 5567008565655260"]
        
        let textShouldNotFound = ["amexnobounds376600200115411", "This is Visa4485679678967628"]
        
        textShouldFound.forEach {
            let detector = CreditCardDetector(with: $0, options: .wordBounds)
            XCTAssertFalse(detector.isEmpty, "Should found pattern in \($0)")
        }
        
        textShouldNotFound.forEach {
            let detector = CreditCardDetector(with: $0, options: .wordBounds)
            XCTAssertTrue(detector.isEmpty, "Should not found card pattern in \($0)")
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
    
    func testReplaceForAllCardTypes() {
        let rawText = """
            This is Visa: 4485679678967628,
            MasterCard5111675855423582 and MasterCardAgain - 51216-087021   -59677,
            Visa 13 digits 4539875198593,
            AE 3766-002-0011-5411
            and just numbers 1111111111111111
            Dinenrs club: 30263 682 060 726
            JBC 3527531644188130
            and numbers again 16-04-1978 24-01-1989
        """
        
        let expectedText = """
            This is Visa: ****,
            MasterCard**** and MasterCardAgain - ****,
            Visa 13 digits ****,
            AE ****
            and just numbers 1111111111111111
            Dinenrs club: ****
            JBC ****
            and numbers again 16-04-1978 24-01-1989
        """

        let detector = CreditCardDetector(with: rawText)
        let processed = detector.replaced { (card) -> String? in
            if card.number.isValid {
                return "****"
            }
            return nil
        }
        
        XCTAssertEqual(expectedText, processed)
    }

    static var allTests = [
        ("testSingleCardSearch", testSingleCardSearch),
        ("testSingleCardSearchWithWordBounds", testSingleCardSearchWithWordBounds),
        ("testNoCard", testNoCard),
        ("testReplaced", testReplaced),
        ("testReplaceUsingGenerator", testReplaceUsingGenerator),
        ("testReplaceForAllCardTypes", testReplaceForAllCardTypes)
    ]
}
