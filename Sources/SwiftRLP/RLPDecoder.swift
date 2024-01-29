import Foundation

public class RLPDecoder {
    public enum Error: Swift.Error {
        case dataToString(Data)
        case emptyInput
        case invalidInput

        public var localizedDescription: String {
            switch self {
            case let .dataToString(data): return "Failed to convert Data to String: \"\(data)\""
            case .emptyInput: return "Got an empty input when decoding"
            case .invalidInput: return "Failed to decode, input does not conform to RLP"
            }
        }
    }

    public var encoding: String.Encoding = .utf8

    public init() {}

    public func decode(from input: Data) throws -> RLPValue {
        if input.count == 0 {
            return .string("")
        }

        let (offset, size, type) = try decodeLength(input)

        if size == 0 {
            return .string("")
        }

        switch type {
        case .string:
            guard let str = String(data: input.slice(offset, size), encoding: encoding) else {
                throw Error.dataToString(input)
            }
            return .string(str)

        case .array:
            return .array([try decode(from: input.slice(offset, size))])
        }
    }
}

enum DecodingLengthType {
    case string
    case array
}

extension Data {
    func slice(_ offset: Int, _ length: Int) -> Data {
        return self[offset..<offset + length]
    }
}

func decodeLength(_ input: Data) throws -> (offset: Int, size: Int, DecodingLengthType) {
    let length = input.count
    if length == 0 {
        throw RLPDecoder.Error.emptyInput
    }
    let prefix = Int(input.first!)
    if prefix <= 0x7f {
        return (0, 1, .string)
    }

    if prefix <= 0xb7, length > prefix - 0x80 {
        let strLen = prefix - 0x80
        return (1, strLen, .string)
    }

    if prefix <= 0xbf {
        let lenOfStrLen = prefix - 0xb7
        let strLen = try toInteger(input.slice(1, lenOfStrLen))

        if length > lenOfStrLen, length > lenOfStrLen + strLen {
            return (1 + lenOfStrLen, strLen, .string)
        }
    }

    if prefix <= 0xf7 {
        let listLen = prefix - 0xc0
        if length > listLen {
            return (1, listLen, .array)
        }
    }

    if prefix <= 0xff {
        let lenOfListLen = prefix - 0xf7
        let listLen = try toInteger(input.slice(1, lenOfListLen))

        if length > lenOfListLen, length > lenOfListLen + listLen {
            return (1 + lenOfListLen, listLen, .array)
        }
    }

    throw RLPDecoder.Error.invalidInput
}

func toInteger(_ data: Data) throws -> Int {
    switch data.count {
    case 0:
        throw RLPDecoder.Error.emptyInput

    case 1:
        return Int(data.first!)

    default:
        return Int(data.last!) + (try toInteger(data.prefix(data.count - 1))) * 256
    }
}
