# CreditCardDetector
Swift library for searching &amp; validating credit card numbers

## Usage

### Validating card number

```swift
let card = CreditCardNumber("4485-6796-7896-7628")
if card.isValid {
 ....
}

switch card.type {
case .visa:
....
case .masterCard
}
```

### Search and masking card numbers in the text

```swift
let detector = CreditCardDetector(with: text)
let maskedText = detector.replaced { (card) -> String? in
  if card.number.isValid {
    return "****\(card.last4)"
  }
  return nil
}
```

Text before: *This is Visa: 4485679678967628*

Text after: *This is Visa: \*\*\*\*7628*

