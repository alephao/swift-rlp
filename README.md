# RLPSwift
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![pod v0.0.3](https://img.shields.io/badge/pod-v0.0.3-blue.svg)](https://cocoapods.org)
[![Travis CI](https://travis-ci.org/bitfwdcommunity/RLPSwift.svg?branch=master)](https://travis-ci.org/bitfwdcommunity/RLPSwift)
[![codecov.io](https://codecov.io/gh/bitfwdcommunity/RLPSwift/branch/master/graph/badge.svg)](https://codecov.io/gh/bitfwdcommunity/RLPSwift/branch/master)

This is a basic Swift implementation of Recursive Length Prefix Encoding, a serialisation method for encoding arbitrarily structured binary data (byte arrays).

You can read more about it here:
* [Ethereum Wiki - RLP](https://github.com/ethereum/wiki/wiki/RLP)
* [Ethereum Yellowpaper](https://ethereum.github.io/yellowpaper/paper.pdf) (Appendix B)

# Interface

```swift
// Encoding Data
RLP.encode(_ data: Data) -> Data

// Encoding String
RLP.encode(_ string: String, with encoding: String.Encoding = .ascii) throws -> Data

// Encoding nested array of Data
RLP.encode(nestedArrayOfData array: [Any]) throws -> Data

// Encoding nested array of String
RLP.encode(nestedArrayOfString array: [Any], encodeStringsWith encoding: String.Encoding = .ascii) throws -> Data
```

# Installation

RLPSwift is available through [CocoaPods](http://cocoapods.org).

To install RLPSwift via cocoapods, add the following line to your Podfile:

```
pod 'RLPSwift'
```

Then run `pod install`.

In any file you'd like to use RLPSwift in, don't forget to
import the framework with `import RLPSwift`.

# License

RLPSwift is released under an [MIT](https://tldrlegal.com/license/mit-license) license. See [LICENSE](LICENSE) for more information.
