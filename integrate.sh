#!/usr/bin/env sh

set -euo pipefail

swift run swiftlint --strict
swift run
git diff --exit-code
