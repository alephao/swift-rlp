//  Created by Aleph Retamal on 31/1/18.
//  Copyright © 2018 Lalacode. All rights reserved.

import XCTest
@testable
import RLPSwift

class RLPTests: XCTestCase {
    
    func testEncodeLengthSmallerThanOrEqualTo55() {
        XCTAssertEqual(RLP.encodeLength(0x00, offset: 0x80), Data(bytes: [0x80]))
        XCTAssertEqual(RLP.encodeLength(0x37, offset: 0x80), Data(bytes: [0xb7]))
    }
    
    func testEncodeLengthGreaterThan55() {
        XCTAssertEqual(RLP.encodeLength(0x38, offset: 0x80), Data(bytes: [0xb8, 0x0, 0x0, 0x0, 0x38]))
        XCTAssertEqual(RLP.encodeLength(0x0400, offset: 0x80), Data(bytes: [0xb9, 0x0, 0x0, 0x04, 0x0]))
        XCTAssertEqual(RLP.encodeLength(0x11170, offset: 0x80), Data(bytes: [0xba, 0x0, 0x01, 0x11, 0x70]))
    }
    
    func testEncodeEmptyData() {
        let subject = Data()
        XCTAssertEqual(RLP.encode(subject), Data(bytes: [0x80]))
    }

    func testEncodeDataWithSingleByte() {
        XCTAssertEqual(try? RLP.encode("0"), "0")
        XCTAssertEqual(try? RLP.encode("a"), "a")
        XCTAssertEqual(try? RLP.encode("{"), "{")
    }
    
    func testEncodeEmptyString() {
        XCTAssertEqual(try? RLP.encode(""), "\u{80}")
    }

    func testEncodeStringSmallerThanOrEqualTo55Bytes() {
        XCTAssertEqual(try? RLP.encode("100"), "\u{83}100")
        XCTAssertEqual(try? RLP.encode("Lorem ipsum dolor sit amet"), "\u{9a}Lorem ipsum dolor sit amet")

        let string55 = [String](repeating: "a", count: 55).reduce("", +)
        XCTAssertEqual(try? RLP.encode(string55), "\u{b7}\(string55)")
    }

    func testEncodeStringGreaterThan55Bytes() {
        XCTAssertEqual(try? RLP.encode("Lorem ipsum dolor sit amet, consectetur adipisicing elit"), "\u{b8}\u{38}Lorem ipsum dolor sit amet, consectetur adipisicing elit")

        let stringWith400a = [String](repeating: "a", count: 400).reduce("", +)
        XCTAssertEqual(try? RLP.encode(stringWith400a), "\u{b9}\u{190}\(stringWith400a)")
    }


}
