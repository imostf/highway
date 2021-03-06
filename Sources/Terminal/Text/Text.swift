import Foundation

public struct Text {
    // MARK: - Convenience
    public static let newline = Text(.newline)
    
    // MARK: - Init
    public init(_ strings: [SubText] = []) {
        self.strings = strings
    }
    
    public init(_ string: SubText) {
        append(string)
    }
    
    public init(_ text: String = "", color: Color = .none, bold: Bool = false) {
        self.init(SubText(text, color: color, bold: bold))
    }
    
    // MARK: - Properties
    private var strings = [SubText]()
    
    var terminalString: String {
        return strings.map { $0.terminalString }.joined()
    }
    var length: Int {
        return strings.map { $0.length }.reduce(0, +)
    }
    
    // MARK: - Working with the Strings
    public mutating func append(_ _strings: Text) {
        strings += _strings.strings
    }
    
    public func appending(_ _strings: Text) -> Text {
        var mutableSelf = self
        mutableSelf.append(_strings)
        
        return mutableSelf
    }
    
    mutating func setColor(_ color: Color) {
        strings.setColor(color)
    }
    
    public subscript(position: Int) -> SubText {
        get {
            return strings[position]
        }
        set {
            strings[position] = newValue
        }
    }
}

public extension Text {
    public init(whitespaceWidth width: Int = 0) {
        self.init(SubText.whitespace(width))
    }
    public static func whitespace(_ width: Int = 1) -> Text {
        return Text(whitespaceWidth: width)
    }
}
extension Text: BidirectionalCollection {
    public func index(before i: Int) -> Int {
        return strings.index(before: i)
    }
    public func index(after i: Int) -> Int {
        return strings.index(after: i)
    }
    public var endIndex: Int { return strings.endIndex }
    public var startIndex: Int { return strings.startIndex }
    
}
extension Text: RangeReplaceableCollection {
    public init() {}
    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, Text.Element == C.Element, Text.Index == R.Bound {
        strings.replaceSubrange(subrange, with: newElements)
    }
    
}

public extension Array where Iterator.Element == Text {
    var terminalString: String {
        return map { $0.terminalString }.joined()
    }
}

private extension Array where Iterator.Element == SubText {
    mutating func setColor(_ color: Color) {
        self = map {
            var text = $0
            text.color = color
            return text
        }
    }
    var terminalString: String {
        return map { $0.terminalString }.joined()
    }
}

