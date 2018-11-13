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

public struct CreditCardDetector: Collection {
    public typealias Element = CreditCardPosition
    public typealias Index = Int
    
    public enum SearchOptions {
        case paranoid
        case wordBounds
    }
    
    public init(with text: String, options: SearchOptions = .paranoid) {
        self.text = text
        
        let pattern = options == .paranoid ? CreditCardDetector.patternParanoid : CreditCardDetector.patternWordBounds
        self.matches = pattern.matches(in: text, options: [], range: text.nsrange)
    }
    
    public var startIndex: Int { return matches.startIndex }
    
    public var endIndex: Int { return matches.endIndex }
    
    public func index(after i: Int) -> Int {
        return matches.index(after: i)
    }
    
    public subscript(position: Int) -> CreditCardPosition {
        let match = matches[position]
        return CreditCardPosition(text[match.range], match)
    }
    
    // MARK: -
    static private let patternParanoid = try! NSRegularExpression(pattern: "(?:\\d[ -]*?){13,16}")
    static private let patternWordBounds = try! NSRegularExpression(pattern: "\\b(?:\\d[ -]*?){13,16}\\b")
    
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


