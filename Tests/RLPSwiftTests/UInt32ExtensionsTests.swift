//  Created by Aleph Retamal on 31/1/18.
//  Copyright © 2018 Lalacode. All rights reserved.

import XCTest
@testable
import RLPSwift

class UInt32ExtensionsTests: XCTestCase {
    func testByteArrayLittleEndian() {
        let subject: UInt32 = 0x12345
        let expected: [UInt8] = [0x00, 0x01, 0x23, 0x45]
            
        XCTAssertEqual(subject.byteArrayLittleEndian, expected)
    }
}
