extension UInt32 {
    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8((self & 0xFF00_0000) >> 24),
            UInt8((self & 0x00FF_0000) >> 16),
            UInt8((self & 0x0000_FF00) >> 8),
            UInt8(self & 0x0000_00FF),
        ]
    }
}
