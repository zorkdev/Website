#!/bin/sh

mint install yonaskolb/mint
mint run swiftlint
swift test
swift run
