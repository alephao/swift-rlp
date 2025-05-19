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
	swift format -i -r -p Sources Tests Package.swift
