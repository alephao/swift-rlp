@preconcurrency import ArgumentParser
import Foundation
import SwiftRLP

@main
struct RLPCli: ParsableCommand {
    struct Encode: ParsableCommand {
        @Argument(help: "string to encode")
        var str: String

        mutating func run() throws {
            let encoder = RLPEncoder()
            let encodedData = try encoder.encode(string: str)
            print(bytesToHexString(encodedData))
        }
    }

    struct Decode: ParsableCommand {
        @Argument(help: "hex string to decode")
        var hex: String

        mutating func run() throws {
            let decoder = RLPDecoder()

            let data = try hexStringToBytes(hex)
            let result = try decoder.decode(from: data)
            print(result)
        }
    }

    static let configuration = CommandConfiguration(
        abstract: "A utility for performing rlp encoding/decoding.",
        subcommands: [Encode.self, Decode.self]
    )
}

enum InputError: Error {
    case invalidHexString(String)
}

func bytesToHexString(_ data: Data) -> String {
    return data.reduce(into: "0x") { str, byte in
        str += String(byte, radix: 16, uppercase: true)
            .padding(toLength: 2, withPad: "0", startingAt: 0)
    }
}

func hexStringToBytes(_ str: String) throws -> Data {
    if str.count % 2 != 0 {
        throw InputError.invalidHexString(str)
    }

    if !str.hasPrefix("0x") {
        throw InputError.invalidHexString(str)
    }

    var result = Data()
    for i in 1..<(str.count / 2) {
        let l = i * 2
        let r = l + 1
        let range = str.index(str.startIndex, offsetBy: l)...str.index(str.startIndex, offsetBy: r)
        result.append(contentsOf: [UInt8(str[range], radix: 16)!])
    }

    return result
}
