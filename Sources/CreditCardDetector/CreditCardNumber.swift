import Foundation

public struct CreditCardNumber {
    
    public enum CardType {
        case none
        case visa
        case masterCard
        case americanExpress
        case dinersClub
        case discover
        case jcb
    }
    
    public let number: String
    
    public var last4: String {
        return String(number.suffix(4))
    }
    
    public let type: CardType
    
    public var isValid: Bool { return type != .none }
    
    public init(_ number: String) {
        let cleanNumber = number.removeNonDigits()
        self.number = cleanNumber
        if let found = CreditCardNumber.patterns.first(where: { (_, pattern) -> Bool in return pattern.firstMatch(in: cleanNumber, options: [], range: cleanNumber.nsrange) != nil }) {
            self.type = found.key
        } else {
            self.type = .none
        }
    }
    
    // MARK:-
    
    private static let patterns: [CardType: NSRegularExpression] = {
        var p = Dictionary<CardType, NSRegularExpression>()
        p[.visa] = try! NSRegularExpression(pattern: "^4[0-9]{12}(?:[0-9]{3})?$")
        p[.masterCard] = try! NSRegularExpression(pattern: "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$")
        p[.americanExpress] = try! NSRegularExpression(pattern: "^3[47][0-9]{13}$")
        p[.dinersClub] = try! NSRegularExpression(pattern: "^3(?:0[0-5]|[68][0-9])[0-9]{11}$")
        p[.discover] = try! NSRegularExpression(pattern: "^6(?:011|5[0-9]{2})[0-9]{12}$")
        p[.jcb] = try! NSRegularExpression(pattern: "^(?:2131|1800|35\\d{3})\\d{11}$")
        
        return p
    }()
}
