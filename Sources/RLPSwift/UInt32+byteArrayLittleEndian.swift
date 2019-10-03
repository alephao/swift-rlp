//  Created by Aleph Retamal on 2/2/18.
//  Copyright © 2018 Lalacode. All rights reserved.

extension UInt32 {
    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8((self & 0xFF000000) >> 24),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8(self & 0x000000FF)
        ]
    }
}
