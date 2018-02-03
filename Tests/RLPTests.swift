//  Created by Aleph Retamal on 31/1/18.
//  Copyright © 2018 Lalacode. All rights reserved.

import XCTest
@testable
import RLPSwift

class RLPTests: XCTestCase { }

// MARK: Helpers tests
extension RLPTests {
    func testBinaryLength() {
        XCTAssertEqual(RLP.binaryLength(of: 0xff), 1)
        XCTAssertEqual(RLP.binaryLength(of: 0xfff), 2)
        XCTAssertEqual(RLP.binaryLength(of: 0xffff), 3)
    }
    
    func testEncodeLengthSmallerThanOrEqualTo55() {
        XCTAssertEqual(RLP.encodeLength(0x00, offset: 0x80), Data(bytes: [0x80]))
        XCTAssertEqual(RLP.encodeLength(0x37, offset: 0x80), Data(bytes: [0xb7]))
    }
    
    func testEncodeLengthGreaterThan55() {
        XCTAssertEqual(RLP.encodeLength(0x38, offset: 0x80), Data(bytes: [0xb8, 0x0, 0x0, 0x0, 0x38]))
        XCTAssertEqual(RLP.encodeLength(0x0400, offset: 0x80), Data(bytes: [0xb9, 0x0, 0x0, 0x04, 0x0]))
        XCTAssertEqual(RLP.encodeLength(0x11170, offset: 0x80), Data(bytes: [0xba, 0x0, 0x01, 0x11, 0x70]))
    }
}


// MARK: Data encoding tests
extension RLPTests {
    func testEncodeEmptyData() {
        let subject = Data()
        XCTAssertEqual(RLP.encode(subject), Data(bytes: [0x80]))
    }
    
    func testEncodeDataWithSingleByte() {
        XCTAssertEqual(RLP.encode(Data(bytes: [0x30])), Data(bytes: [0x30]))
        XCTAssertEqual(RLP.encode(Data(bytes: [0x61])), Data(bytes: [0x61]))
        XCTAssertEqual(RLP.encode(Data(bytes: [0x7b])), Data(bytes: [0x7b]))
    }
    
    func testEncodeDataSmallerThan55Bytes() {
        XCTAssertEqual(RLP.encode(Data(bytes: [0x31, 0x30, 0x30])), Data(bytes: [0x83, 0x31, 0x30, 0x30]))
        XCTAssertEqual(RLP.encode(Data(bytes: [0x4c, 0x6f, 0x72, 0x65, 0x6d, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6d, 0x20, 0x64, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x73, 0x69, 0x74, 0x20, 0x61, 0x6d, 0x65, 0x74])), Data(bytes: [0x9a, 0x4c, 0x6f, 0x72, 0x65, 0x6d, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6d, 0x20, 0x64, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x73, 0x69, 0x74, 0x20, 0x61, 0x6d, 0x65, 0x74]))
    }
    
    func testEncodeDataEqualTo55Bytes() {
        let subject = Data(bytes: [UInt8](repeating: 0x61, count: 55))
        let expectedBytes = [0xb7] + subject
        XCTAssertEqual(RLP.encode(subject), Data(bytes: expectedBytes))
    }
    
    func testEncodeTheoreticalRepresentationOfTwo() {
        let subject: [Any] = [ [], [[]], [ [], [[]] ] ]
        
        XCTAssertEqual(try RLP.encode(nestedArrayOfData: subject), Data(bytes: [0xc7, 0xc0, 0xc1, 0xc0, 0xc3, 0xc0, 0xc1, 0xc0]))
    }
}

// MARK: String encoding tests
extension RLPTests {

    func testEncodeEmptyString() {
        XCTAssertEqual(try? RLP.encode(""), Data(bytes: [0x80]))
    }
    
    func testEncodeStringWithSingleByte() {
        XCTAssertEqual(try? RLP.encode("0"), Data(bytes: [0x30]))
        XCTAssertEqual(try? RLP.encode("a"), Data(bytes: [0x61]))
        XCTAssertEqual(try? RLP.encode("{"), Data(bytes: [0x7b]))
    }
    
    func testEncodeStringSmallerThan55Bytes() {
        XCTAssertEqual(try? RLP.encode("100"), Data(bytes: [0x83, 0x31, 0x30, 0x30]))
        XCTAssertEqual(try? RLP.encode("Lorem ipsum dolor sit amet"), Data(bytes: [0x9a, 0x4c, 0x6f, 0x72, 0x65, 0x6d, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6d, 0x20, 0x64, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x73, 0x69, 0x74, 0x20, 0x61, 0x6d, 0x65, 0x74]))
    }
    
    func testEncodeStringEqualTo55Bytes() {
        let subject = [String](repeating: "a", count: 55).reduce("", +)
        let expectedBytes: [UInt8] = [0xb7] + [UInt8](repeating: 0x61, count: 55)
        XCTAssertEqual(try? RLP.encode(subject), Data(bytes: expectedBytes))
    }

    func testEncodeStringGreaterThan55Bytes() {
        let stringWith400a = [String](repeating: "a", count: 400).reduce("", +)
        let expectedBytes: [UInt8] = [0xb9, 0x00, 0x00, 0x01, 0x90] + [UInt8](repeating: 0x61, count: 400)
        XCTAssertEqual(try? RLP.encode(stringWith400a), Data(bytes: expectedBytes))
    }
}
