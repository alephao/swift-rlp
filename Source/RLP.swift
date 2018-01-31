//  Created by Aleph Retamal on 31/1/18.
//  Copyright © 2018 Lalacode. All rights reserved.

public enum RLP {
    
    public enum Error: Swift.Error {
        case unicodeOutOfBoundaries
        case stringToData
        case invalidType(Any)
    }

    static func binaryLength(of n: UInt32) -> UInt8 {
        return UInt8(ceil(log10(Double(n))/log10(Double(UInt8.max))))
    }
    
    static func encodeLength(_ length: UInt32, offset: UInt8) throws -> String {
        if length < 56 {
            let lengthByte = offset + UInt8(length)
            return String(Unicode.Scalar(lengthByte))
        } else {
            let firstByte = offset + 55 + binaryLength(of: length)
            guard let lengthUnicode = Unicode.Scalar(length) else {
                throw Error.unicodeOutOfBoundaries
            }
            return "\(Unicode.Scalar(firstByte))\(lengthUnicode)"
        }
    }
    
    public static func encode(_ string: String) throws -> String {
        guard let data = string.data(using: .utf8) else {
            throw Error.stringToData
        }
        
        if data.count == 1,
            0x00...0x7f ~= data[0] {
            return string
        } else {
            let encodedLength = try encodeLength(UInt32(data.count), offset: 0x80)
            return encodedLength + string
        }
    }
    
    public static func encode(_ array: [Any]) throws -> String {
        var output = ""
        
        for item in array {
            if let string = item as? String {
                output += try encode(string)
            } else if let array = item as? [Any] {
                output += try encode(array)
            } else {
                throw Error.invalidType(item)
            }
        }
        
        let encodedLength = try encodeLength(UInt32(output.count), offset: 0xc0)
        return encodedLength + output
    }
    
}
