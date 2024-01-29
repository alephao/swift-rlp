import XCTest

@testable import RLPSwift

class DecodingTests: XCTestCase {}

extension DecodingTests {

    func assertDecoding(_ value: RLPValue) throws {
        let encoder = RLPEncoder()
        let decoder = RLPDecoder()

        let encoded = try encoder.encode(value)
        let decoded = try decoder.decode(from: encoded)

        XCTAssertEqual(decoded, value)
    }

    func testDecodeEmptyData() throws {
        try assertDecoding(.string(""))
    }

    func testDecodeDataWithSingleByte() throws {
        for str in ["0", "a", "{"] {
            try assertDecoding(.string(str))
        }
    }

    func testDecodeDataEqOrShorterThan55Bytes() throws {
        let byte = "a".data(using: .utf8)!.first!

        for l in 2...55 {
            let data = Data([UInt8](repeating: byte, count: l))
            let str = String(data: data, encoding: .utf8)!
            try assertDecoding(.string(str))
        }
    }

    func testEncodeStringLongerThan55Bytes() throws {
        let byte = "a".data(using: .utf8)!.first!

        for length in [
            56,
            100,
            300,
            400,
        ] {
            let data = Data([UInt8](repeating: byte, count: length))
            let str = String(data: data, encoding: .utf8)!
            try assertDecoding(.string(str))
        }
    }
}
