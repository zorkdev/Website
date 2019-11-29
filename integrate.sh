#!/bin/sh

git clone https://github.com/yonaskolb/Mint.git
cd Mint
swift run mint install yonaskolb/mint
cd ..
mint run swiftlint
swift test --generate-linuxmain
swift test
swift run
