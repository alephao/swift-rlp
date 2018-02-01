//  Created by Aleph Retamal on 31/1/18.
//  Copyright © 2018 Lalacode. All rights reserved.

public enum RLP {
    
    public enum Error: Swift.Error {
        case unicodeOutOfBoundaries
        case stringToData
        case dataToString
        case invalidType(Any)
    }

    static func binaryLength(of n: UInt32) -> UInt8 {
        return UInt8(ceil(log10(Double(n))/log10(Double(UInt8.max))))
    }
    
    static func encodeLength(_ length: UInt32, offset: UInt8) -> Data {
        if length < 56 {
            let lengthByte = offset + UInt8(length)
            return Data(bytes: [lengthByte])
        } else {
            let firstByte = offset + 55 + binaryLength(of: length)
            var bytes = [firstByte]
            bytes.append(contentsOf: length.byteArrayLittleEndian)
            return Data(bytes: bytes)
        }
    }
    
    public static func encode(_ bytes: Data) -> Data {
        if bytes.count == 1,
            0x00...0x7f ~= bytes[0] {
            return bytes
        } else {
            var result = encodeLength(UInt32(bytes.count), offset: 0x80)
            result.append(contentsOf: bytes)
            return result
        }
    }
    
    public static func encode(_ string: String) throws -> String {
        guard let data = string.data(using: .ascii) else {
            throw Error.stringToData
        }

        let bytes = encode(data)
        
        guard let result = String(data: bytes, encoding: .ascii) else {
            throw Error.dataToString
        }
        
        return result
    }
//
//    public static func encode(_ array: [Any]) throws -> String {
//        var output = ""
//
//        for item in array {
//            if let string = item as? String {
//                output += try encode(string)
//            } else if let array = item as? [Any] {
//                output += try encode(array)
//            } else {
//                throw Error.invalidType(item)
//            }
//        }
//
//        let encodedLength = try encodeLength(UInt32(output.count), offset: 0xc0)
//        return encodedLength + output
//    }
    
}
