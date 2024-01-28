import XCTest

@testable import RLPSwift

class RLPTests: XCTestCase {}

// MARK: Helpers tests

extension RLPTests {
    func testBinaryLength() {
        XCTAssertEqual(RLP.binaryLength(of: 0xFF), 1)
        XCTAssertEqual(RLP.binaryLength(of: 0xFFF), 2)
        XCTAssertEqual(RLP.binaryLength(of: 0xFFFF), 3)
    }

    func testEncodeLengthSmallerThanOrEqualTo55() {
        XCTAssertEqual(RLP.encodeLength(0x00, offset: 0x80), Data([0x80]))
        XCTAssertEqual(RLP.encodeLength(0x37, offset: 0x80), Data([0xB7]))
    }

    func testEncodeLengthGreaterThan55() {
        XCTAssertEqual(RLP.encodeLength(0x38, offset: 0x80), Data([0xB8, 0x0, 0x0, 0x0, 0x38]))
        XCTAssertEqual(RLP.encodeLength(0x0400, offset: 0x80), Data([0xB9, 0x0, 0x0, 0x04, 0x0]))
        XCTAssertEqual(RLP.encodeLength(0x11170, offset: 0x80), Data([0xBA, 0x0, 0x01, 0x11, 0x70]))
    }
}

// MARK: Data encoding tests

extension RLPTests {
    func testEncodeEmptyData() {
        let subject = Data()
        XCTAssertEqual(RLP.encode(subject), Data([0x80]))
    }

    func testEncodeDataWithSingleByte() {
        XCTAssertEqual(RLP.encode(Data([0x30])), Data([0x30]))
        XCTAssertEqual(RLP.encode(Data([0x61])), Data([0x61]))
        XCTAssertEqual(RLP.encode(Data([0x7B])), Data([0x7B]))
    }

    func testEncodeDataSmallerThan55Bytes() {
        XCTAssertEqual(RLP.encode(Data([0x31, 0x30, 0x30])), Data([0x83, 0x31, 0x30, 0x30]))
        XCTAssertEqual(
            RLP.encode(
                Data([
                    0x4C, 0x6F, 0x72, 0x65, 0x6D, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6D, 0x20, 0x64, 0x6F, 0x6C, 0x6F, 0x72, 0x20, 0x73, 0x69, 0x74,
                    0x20, 0x61, 0x6D, 0x65, 0x74,
                ])),
            Data([
                0x9A, 0x4C, 0x6F, 0x72, 0x65, 0x6D, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6D, 0x20, 0x64, 0x6F, 0x6C, 0x6F, 0x72, 0x20, 0x73, 0x69, 0x74,
                0x20, 0x61, 0x6D, 0x65, 0x74,
            ]))
    }

    func testEncodeDataEqualTo55Bytes() {
        let subject = Data([UInt8](repeating: 0x61, count: 55))
        let expectedBytes = [0xB7] + subject
        XCTAssertEqual(RLP.encode(subject), Data(expectedBytes))
    }

    func testEncodeTheoreticalRepresentationOfTwo() {
        let subject: [Any] = [[], [[]], [[], [[]]]]

        XCTAssertEqual(try RLP.encode(nestedArrayOfData: subject), Data([0xC7, 0xC0, 0xC1, 0xC0, 0xC3, 0xC0, 0xC1, 0xC0]))
    }
}

// MARK: String encoding tests

extension RLPTests {
    func testEncodeEmptyString() {
        XCTAssertEqual(try? RLP.encode(""), Data([0x80]))
    }

    func testEncodeStringWithSingleByte() {
        XCTAssertEqual(try? RLP.encode("0"), Data([0x30]))
        XCTAssertEqual(try? RLP.encode("a"), Data([0x61]))
        XCTAssertEqual(try? RLP.encode("{"), Data([0x7B]))
    }

    func testEncodeStringSmallerThan55Bytes() {
        XCTAssertEqual(try? RLP.encode("100"), Data([0x83, 0x31, 0x30, 0x30]))
        XCTAssertEqual(
            try? RLP.encode("Lorem ipsum dolor sit amet"),
            Data([
                0x9A, 0x4C, 0x6F, 0x72, 0x65, 0x6D, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6D, 0x20, 0x64, 0x6F, 0x6C, 0x6F, 0x72, 0x20, 0x73, 0x69, 0x74,
                0x20, 0x61, 0x6D, 0x65, 0x74,
            ]))
    }

    func testEncodeStringEqualTo55Bytes() {
        let subject = [String](repeating: "a", count: 55).reduce("", +)
        let expectedBytes: [UInt8] = [0xB7] + [UInt8](repeating: 0x61, count: 55)
        XCTAssertEqual(try? RLP.encode(subject), Data(expectedBytes))
    }

    func testEncodeStringGreaterThan55Bytes() {
        let stringWith400a = [String](repeating: "a", count: 400).reduce("", +)
        let expectedBytes: [UInt8] = [0xB9, 0x00, 0x00, 0x01, 0x90] + [UInt8](repeating: 0x61, count: 400)
        XCTAssertEqual(try? RLP.encode(stringWith400a), Data(expectedBytes))
    }
}
