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
        XCTAssertEqual(try? RLP.encode(""), "\u{80}")
    }
    
    func testEncodeStringWithSingleByte() {
        XCTAssertEqual(try? RLP.encode("0"), "0")
        XCTAssertEqual(try? RLP.encode("a"), "a")
        XCTAssertEqual(try? RLP.encode("{"), "{")
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
    
    func testEncodeStringArray() {
        XCTAssertEqual(try? RLP.encode(["cat", "dog"]), "\u{c8}\u{83}cat\u{83}dog")
    }
    
    func testEncodeTheoreticalRepresentationOfTwo() {
        let subject: [Any] = [ [], [[]], [ [], [[]] ] ]
        XCTAssertEqual(try? RLP.encode(subject), "\u{c7}\u{c0}\u{c1}\u{c0}\u{c3}\u{c0}\u{c1}\u{c0}")
    }
    
    func testEncodeTransactionObjectAsStringArray() {
        let subject = [
            ["from", "0xb60e8dd61c5d32be8058bb8eb970870f07233155"],
            ["to", "0xd46e8dd67c5d32be8058bb8eb970870f07244567"],
            ["gas", "0x76c0"],
            ["gasPrice", "0x9184e72a000"],
            ["value", "0x9184e72a"],
            ["data", "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"]
        ]
        
        let expected = "\u{f8}\u{f3}\u{f0}\u{84}from\u{aa}0xb60e8dd61c5d32be8058bb8eb970870f07233155\u{ee}\u{82}to\u{aa}0xd46e8dd67c5d32be8058bb8eb970870f07244567\u{cb}\u{83}gas\u{86}0x76c0\u{d7}\u{88}gasPrice\u{8d}0x9184e72a000\u{d1}value\u{8a}0x9184e72a\u{f8}\u{5b}\u{84}data\u{b8}\u{54}0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"
        
        XCTAssertEqual(try? RLP.encode(subject), expected)
    }

}
