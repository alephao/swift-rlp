# RLPSwift

This is a basic Swift implementation of Recursive Length Prefix Encoding, a serialisation method for encoding arbitrarily structured binary data (byte arrays).

You can read more about it here:
* [Ethereum Wiki - RLP](https://github.com/ethereum/wiki/wiki/RLP)
* [Ethereum Yellowpaper](https://ethereum.github.io/yellowpaper/paper.pdf) (Appendix B)

# Getting Started

At the moment is possible to encode Strings and nested arrays of String

```swift
// Encoding strings
RLP.encode("dog") // \u{83}dog

// Encoding arrays is just as easy
RLP.encode(["cat", "dog"]) // \u{c8}\u{83}cat\u{83}dog
```

# Installation

### Manually
This library is small, so you can easily install it manually by dragging and dropping RLP.swift inside your project

# License

RLPSwift is released under an [MIT](https://tldrlegal.com/license/mit-license) license. See [LICENSE](LICENSE) for more information.
