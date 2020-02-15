install:
	swift run swiftlint --strict
	swift build -c release
	install .build/release/Website /usr/local/bin/website
