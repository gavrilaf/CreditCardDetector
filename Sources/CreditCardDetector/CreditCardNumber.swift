import Foundation

public struct CreditCardNumber {
    
    public let number: String
    
    public var isValid: Bool { return true }
    
    public var last4: String {
        return String(number.suffix(4))
    }
    
    init(_ number: String) {
        self.number = number
    }
}
