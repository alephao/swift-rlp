import Foundation
import Testing

@testable import SwiftRLP

struct RLPEncoderTests {
  @Test func binaryLength() {
    #expect(SwiftRLP.binaryLength(of: 0xFF) == 1)
    #expect(SwiftRLP.binaryLength(of: 0xFFF) == 2)
    #expect(SwiftRLP.binaryLength(of: 0xFFFF) == 3)
  }

  @Test func encodeLengthSmallerThanOrEqualTo55() {
    #expect(encodeLength(0x00, offset: 0x80) == Data([0x80]))
    #expect(encodeLength(0x37, offset: 0x80) == Data([0xB7]))
  }

  @Test func encodeLengthGreaterThan55() {
    #expect(encodeLength(0x38, offset: 0x80) == Data([0xB8, 0x38]))
    #expect(encodeLength(0x0400, offset: 0x80) == Data([0xB9, 0x04, 0x0]))
    #expect(encodeLength(0x11170, offset: 0x80) == Data([0xBA, 0x01, 0x11, 0x70]))
  }

  @Test func encodeEmptyData() throws {
    let sut = RLPEncoder()
    #expect(try sut.encode(.string("")) == Data([0x80]))
  }

  @Test func encodeDataWithSingleByte() throws {
    let sut = RLPEncoder()
    #expect(try sut.encode(.string("0")) == Data([0x30]))
    #expect(try sut.encode(.string("a")) == Data([0x61]))
    #expect(try sut.encode(.string("{")) == Data([0x7B]))
  }

  @Test func encodeDataEqOrShorterThan55Bytes() throws {
    let sut = RLPEncoder()
    let byte = "a".data(using: .utf8)!.first!

    for l in 2...55 {
      let data = Data([UInt8](repeating: byte, count: l))
      let str = String(data: data, encoding: .utf8)!
      #expect(try sut.encode(.string(str)) == Data([0x80 + UInt8(l)] + data))
    }
  }

  @Test func encodeStringLongerThan55Bytes() throws {
    let sut = RLPEncoder()
    let byte = "a".data(using: .utf8)!.first!

    for val in [
      (length: 56, prefix: Data([0xb8, 0x38])),
      (length: 100, prefix: Data([0xb8, 0x64])),
      (length: 300, prefix: Data([0xb9, 0x01, 0x2c])),
      (length: 400, prefix: Data([0xb9, 0x01, 0x90])),
    ] {
      let data = Data([UInt8](repeating: byte, count: val.length))
      let str = String(data: data, encoding: .utf8)!
      #expect(try sut.encode(.string(str)) == val.prefix + data)
    }
  }

  @Test func encodeStrings() throws {
    let sut = RLPEncoder()
    #expect(try sut.encode(.string("dog")) == Data([0x83, 0x64, 0x6F, 0x67]))
    #expect(
      try sut.encode(.string("Lorem ipsum dolor sit amet, consectetur adipisicing eli"))
        == Data([
          0xb7, 0x4c, 0x6f, 0x72, 0x65, 0x6d, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6d, 0x20, 0x64, 0x6f,
          0x6c, 0x6f, 0x72, 0x20, 0x73, 0x69,
          0x74,
          0x20, 0x61, 0x6d, 0x65, 0x74, 0x2c, 0x20, 0x63, 0x6f, 0x6e, 0x73, 0x65, 0x63, 0x74, 0x65,
          0x74, 0x75, 0x72, 0x20, 0x61, 0x64,
          0x69,
          0x70, 0x69, 0x73, 0x69, 0x63, 0x69, 0x6e, 0x67, 0x20, 0x65, 0x6c, 0x69,
        ])
    )
  }

  @Test func encodeTheoreticalRepresentationOfTwo() throws {
    let sut = RLPEncoder()
    let value: RLPValue = .array([
      .array([]),
      .array([
        .array([])
      ]),
      .array([
        .array([]),
        .array([
          .array([])
        ]),
      ]),
    ])
    #expect(try sut.encode(value) == Data([0xC7, 0xC0, 0xC1, 0xC0, 0xC3, 0xC0, 0xC1, 0xC0]))
  }

  @Test func encodeEmptyString() throws {
    let sut = RLPEncoder()
    #expect(try sut.encode(.string("")) == Data([0x80]))
  }
}
