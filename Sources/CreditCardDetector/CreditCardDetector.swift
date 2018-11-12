import Foundation

public struct CreditCardPosition {
    
    public var number: CreditCardNumber {
        return CreditCardNumber(String(substr))
    }
    
    init(_ substr: Substring, _ match: NSTextCheckingResult) {
        self.substr = substr
        self.match = match
    }
    
    fileprivate let substr: Substring
    fileprivate let match: NSTextCheckingResult
}

struct CreditCardDetector: Collection {
    typealias Element = CreditCardPosition
    typealias Index = Int
    
    init(with text: String) {
        self.text = text
        self.matches = CreditCardDetector.cardPattern.matches(in: text, options: [], range: text.nsrange)
    }
    
    var startIndex: Int { return matches.startIndex }
    
    var endIndex: Int { return matches.endIndex }
    
    func index(after i: Int) -> Int {
        return matches.index(after: i)
    }
    
    subscript(position: Int) -> CreditCardPosition {
        let match = matches[position]
        return CreditCardPosition(text[match.range], match)
    }
    
    // MARK: -
    static private let cardPattern = try! NSRegularExpression(pattern: "\\b(?:\\d[ -]*?){13,16}\\b")
    
    private let text: String
    private let matches: [NSTextCheckingResult]
}

extension CreditCardDetector {
    public func replaced(with str: String, on position: CreditCardPosition) -> String {
        var result = text
        guard let range = Range(position.match.range, in: result) else { return result }
        result.replaceSubrange(range, with: str)
        return result
    }
    
    public func replaced(with str: String, where check: (CreditCardPosition) -> Bool) -> String {
        var result = text
        for position in self.reversed() {
            guard let range = Range(position.match.range, in: result)  else { continue }
            if check(position) {
                result.replaceSubrange(range, with: str)
            }
        }
        return result
    }
    
    public func replaced(using generator: (CreditCardPosition) -> String?) -> String {
        var result = text
        for position in self.reversed() {
            guard let range = Range(position.match.range, in: result)  else { continue }
            if let s = generator(position) {
                result.replaceSubrange(range, with: s)
            }
        }
        return result
    }
}


