// Thanks: Swift PM
public enum Result<Value, ErrorType: Swift.Error> {
    case success(Value)
    case failure(ErrorType)
    
    public init(_ value: Value) {
        self = .success(value)
    }
    
    public init(_ error: ErrorType) {
        self = .failure(error)
    }
    
    public init(_ body: () throws -> Value) throws {
        do {
            self = .success(try body())
        } catch let error as ErrorType {
            self = .failure(error)
        }
    }
    
    public func dematerialize() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure(_):
            return nil
        }
    }
}

extension Result: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success(let value):
            return "Result(\(value))"
        case .failure(let error):
            return "Result(\(error))"
        }
    }
}

public struct AnyError: Swift.Error, CustomStringConvertible {
    public let underlyingError: Swift.Error
    
    public init(_ error: Swift.Error) {
        if case let error as AnyError = error {
            self = error
        } else {
            self.underlyingError = error
        }
    }
    
    public var description: String {
        return String(describing: underlyingError)
    }
}
