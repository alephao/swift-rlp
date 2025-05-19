import Foundation

public struct RLPEncoder: Sendable {
    public enum Error: Swift.Error {
        case stringToData(String)

        public var localizedDescription: String {
            switch self {
            case let .stringToData(str): return "Failed to convert String to Data: \"\(str)\""
            }
        }
    }

    public let encoding: String.Encoding = .utf8

    public init() {}

    public func encode(_ input: RLPValue) throws -> Data {
        switch input {
        case let .string(str):
            return try encode(string: str)

        case let .array(arr):
            let output = try arr.reduce(into: Data()) { acc, val in
                acc += try encode(val)
            }
            return encodeLength(UInt(output.count), offset: 0xc0) + output
        }
    }

    public func encode(string input: String) throws -> Data {
        guard let strData = input.data(using: encoding) else {
            throw Error.stringToData(input)
        }

        if strData.count == 1, strData.first! < 0x80 {
            return strData
        }

        return encodeLength(UInt(input.count), offset: 0x80) + strData
    }
}

func binaryLength(of n: UInt32) -> UInt8 {
    return UInt8(ceil(log10(Double(n)) / log10(Double(UInt8.max))))
}

func toBinary(_ x: UInt) -> Data {
    if x == 0 {
        return Data()
    }

    let (q, r) = x.quotientAndRemainder(dividingBy: 256)

    return toBinary(q) + Data([UInt8(r)])
}

func encodeLength(_ length: UInt, offset: UInt8) -> Data {
    if length < 56 {
        let lengthByte = offset + UInt8(length)
        return Data([lengthByte])
    }

    let binaryLength = toBinary(length)
    return Data([UInt8(UInt(binaryLength.count) + UInt(offset) + 55)]) + binaryLength
}
