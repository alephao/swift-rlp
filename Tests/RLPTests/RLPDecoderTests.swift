import Foundation
import Testing

@testable import RLP

struct RLPDecoderTests {
  func assertRoundtrip(of value: RLPValue) throws {
    let encoder = RLPEncoder()
    let decoder = RLPDecoder()

    let encoded = try encoder.encode(value)
    let decoded = try decoder.decode(from: encoded)

    #expect(decoded == value)
  }

  @Test func decodeEmptyString() throws {
    try assertRoundtrip(of: .string(""))
  }

  @Test func decodeDataWithSingleByte() throws {
    for str in ["0", "a", "{"] {
      try assertRoundtrip(of: .string(str))
    }
  }

  @Test func decodeDataEqOrShorterThan55Bytes() throws {
    let byte = "a".data(using: .utf8)!.first!

    for l in 2...55 {
      let data = Data([UInt8](repeating: byte, count: l))
      let str = String(data: data, encoding: .utf8)!
      try assertRoundtrip(of: .string(str))
    }
  }

  @Test func encodeStringLongerThan55Bytes() throws {
    let byte = "a".data(using: .utf8)!.first!

    for length in [
      56,
      100,
      300,
      400,
    ] {
      let data = Data([UInt8](repeating: byte, count: length))
      let str = String(data: data, encoding: .utf8)!
      try assertRoundtrip(of: .string(str))
    }
  }
}
