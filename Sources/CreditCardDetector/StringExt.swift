import Foundation

extension String {
    
    enum Constant {
        static let numbers = {
            Set("0123456789".map { $0 })
        }()
    }
    
    // MARK:-
    func removeNonDigits() -> String {
        return self.filter { return String.Constant.numbers.contains($0) }
    }
    
    subscript(_ nsrange: NSRange) -> Substring {
        guard let range = Range(nsrange, in: self) else { return self[self.startIndex...] }
        return self[range]
    }
    
    var nsrange: NSRange {
        return NSRange(location: 0, length: self.utf16.count)
    }
}
