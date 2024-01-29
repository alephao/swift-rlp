import Foundation

public enum RLPError: Swift.Error {
    case stringToData(String)
    case dataToString
    case invalidObject(ofType: Any.Type, expected: Any.Type)

    public var localizedDescription: String {
        switch self {
        case let .stringToData(str): return "Failed to convert String to Data: \"\(str)\""
        case .dataToString: return "Failed to convert Data to String"
        case let .invalidObject(got, expected):
            return "Invalid object, expected \(expected), but got \(got)"
        }
    }
}
