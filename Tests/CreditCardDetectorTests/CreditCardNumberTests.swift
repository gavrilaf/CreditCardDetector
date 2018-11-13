import XCTest
import CreditCardDetector

class CreditCardNumberTests: XCTestCase {
    
    func testBasicProperties() {
        let cases = [("4485679678967628", "4485679678967628", "7628"),
                     ("4485-6796-7896-7628", "4485679678967628", "7628"),
                     ("5567 0085 6565 5260", "5567008565655260", "5260")]
        
        cases.forEach {
            let crediCard = CreditCardNumber($0.0)
            XCTAssertEqual($0.1, crediCard.number)
            XCTAssertEqual($0.2, crediCard.last4)
        }
    }
    
    func testCardType() {
        let cases: [(String, CreditCardNumber.CardType, Bool)] = [("4716291504973456", .visa, true),    // Visa 16 digits
                                                                  ("4916857277472", .visa, true),       // Visa 13 digits
                                                                  ("5146035769592270", .masterCard, true),
                                                                  ("376600200115411", .americanExpress, true),
                                                                  ("6011806982530242", .discover, true),
                                                                  ("36413153004752", .dinersClub, true),
                                                                  ("3592637955454456", .jcb, true),
                                                                  ("1234567812344567", .none, false),
                                                                  ("1111-1111-1111-1111", .none, false),
                                                                  ("", .none, false),]
        
        cases.forEach {
            let crediCard = CreditCardNumber($0.0)
            XCTAssertEqual($0.1, crediCard.type)
            XCTAssertEqual($0.2, crediCard.isValid)
        }
    }

    static var allTests = [
        ("testBasicProperties", testBasicProperties),
        ("testCardType", testCardType),
    ]
}
