# Change project's name
chmod +x ./rename.swift
./rename.swift "iOSSample" "$1"
rm rename.swift
rm build.sh

# Build frameworks
carthage bootstrap --platform iOS --no-use-binaries