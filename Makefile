.PHONY: build
build:
	swift build \
	--target SwiftRLP

.PHONY: test
test:
	swift test

.PHONY: build-cli
build-cli:
	swift build \
	--product cli

.PHONY: fmt
fmt:
	swift-format \
	--in-place \
	--recursive \
	--configuration .swift-format \
	.