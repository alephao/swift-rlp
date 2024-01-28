.PHONY: fmt
fmt:
	swift-format \
	--in-place \
	--recursive \
	--configuration .swift-format \
	.