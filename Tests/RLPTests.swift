//  Created by Aleph Retamal on 31/1/18.
//  Copyright © 2018 Lalacode. All rights reserved.

import XCTest
@testable
import RLPSwift

class RLPTests: XCTestCase {
    
    func testEncodeLength() {
        XCTAssertEqual(try? RLP.encodeLength(0x00, offset: 0x80), "\u{80}")
        XCTAssertEqual(try? RLP.encodeLength(0x0400, offset: 0x80), "\u{b9}\u{400}")
        XCTAssertEqual(try? RLP.encodeLength(0x11170, offset: 0x80), "\u{ba}\u{11170}")
    }
    
    func testEncodeEmptyString() {
        XCTAssertEqual(RLP.encode(""), "\u{80}")
    }
    
    func testEncodeStringWithSingleByte() {
        XCTAssertEqual(RLP.encode("0"), "0")
        XCTAssertEqual(RLP.encode("a"), "a")
        XCTAssertEqual(RLP.encode("{"), "{")
    }
    
    func testEncodeStringSmallerThanOrEqualTo55Bytes() {
        XCTAssertEqual(RLP.encode("100"), "\u{83}100")
        XCTAssertEqual(RLP.encode("Lorem ipsum dolor sit amet"), "\u{9a}Lorem ipsum dolor sit amet")
        
        let string55 = [String](repeating: "a", count: 55).reduce("", +)
        XCTAssertEqual(RLP.encode(string55), "\u{b7}\(string55)")
    }
    
    func testEncodeStringGreaterThan55Bytes() {
        XCTAssertEqual(RLP.encode("Lorem ipsum dolor sit amet, consectetur adipisicing elit"), "\u{b8}\u{38}Lorem ipsum dolor sit amet, consectetur adipisicing elit")
        
        let stringWith400a = [String](repeating: "a", count: 400).reduce("", +)
        XCTAssertEqual(RLP.encode(stringWith400a), "\u{b9}\u{190}\(stringWith400a)")
    }

}
