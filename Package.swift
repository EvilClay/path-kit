import PackageDescription

let package = Package(
    name: "PathKit",
    dependencies: [
        .Package(url: "https://github.com/Zewo/String.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/open-swift/C7.git", majorVersion: 0, minor: 4),
    ],
    exclude: [
        "Fixtures"
    ]
)
