#!/bin/sh

set -euxo pipefail

swift run swiftlint --strict
swift run
git diff --exit-code
