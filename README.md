# RLP
[![Swift 6.1](https://img.shields.io/badge/Swift-6.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Version](https://img.shields.io/badge/SPM-1.0.0-orange.svg?stlyle=flat)](https://github.com/alephao/swift-rlp/releases/tag/v1.0.0)

This is a simple, pure Swift implementation of Recursive Length Prefix Encoding, a serialisation method for encoding arbitrarily structured binary data (byte arrays).

RLP Encoding is used in Ethereum. You can read more about it here:
* [Ethereum Wiki - RLP](https://github.com/ethereum/wiki/wiki/RLP)
* [Ethereum Yellowpaper](https://ethereum.github.io/yellowpaper/paper.pdf) (Appendix B)

## Library Usage

RLP is available through [Swift Package Manager](https://swift.org/package-manager/).

Adding RLP as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
  .package(url: "https://github.com/alephao/swift-rlp.git", from: "1.0.0")
],
targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "RLP", package: "swift-rlp")
      ]
    ),
]
```

### Encoding

```swift
import RLP

let encoder = RLPEncoder()

// String Encoding
try encoder.encode(.string("dog"))
try encoder.encode(string: "dog")

// Array Encoding
try encoder.encode(.array(["d", "o", "g"]))
```

### Decoding

```swift
import RLP

let encodedData = try RLPEncoder().encode(string: "dog")

let decoder = RLPDecoder()
try decoder.decode(from: encodedData) // RLPValue.string("dog")
```

## CLI

Currently, the CLI is only available via source code. To use it, clone this repo and run:

### Encoding

```bash
$ swift run cli encode dog
> 0x83646F67
```

### Decoding

```bash
$ swift run cli decode 0x83646F67
> string("dog")
```

## License

RLP is released under an [MIT](https://tldrlegal.com/license/mit-license) license. See [LICENSE](LICENSE) for more information.
