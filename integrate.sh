#!/bin/sh

set -eo pipefail

if hash mint 2>/dev/null; then
    mint install yonaskolb/mint
else
    cd ..
    git clone https://github.com/yonaskolb/Mint.git
    cd Mint
    swift run mint install yonaskolb/mint
    cd ../Website
fi

mint run swiftlint
swift test --generate-linuxmain
swift test
swift run
git diff --exit-code
