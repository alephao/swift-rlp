# RLPSwift
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![pod v0.0.2](https://img.shields.io/badge/pod-v0.0.1-blue.svg)](https://cocoapods.org)

This is a basic Swift implementation of Recursive Length Prefix Encoding, a serialisation method for encoding arbitrarily structured binary data (byte arrays).

You can read more about it here:
* [Ethereum Wiki - RLP](https://github.com/ethereum/wiki/wiki/RLP)
* [Ethereum Yellowpaper](https://ethereum.github.io/yellowpaper/paper.pdf) (Appendix B)

# Getting Started

Encoding Strings and nested arrays of String

```swift
// Encoding strings
try! RLP.encode("dog") // \u{83}dog

// Encoding arrays is just as easy
try! RLP.encode(["cat", "dog"]) // \u{c8}\u{83}cat\u{83}dog
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

### Manually
Download and drop RLP.swift inside your project.

# License

RLPSwift is released under an [MIT](https://tldrlegal.com/license/mit-license) license. See [LICENSE](LICENSE) for more information.
