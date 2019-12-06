#!/bin/sh

set -euxo pipefail

swift run swiftlint
swift test --generate-linuxmain
swift test
swift run
git diff --exit-code
