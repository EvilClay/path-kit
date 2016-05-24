import PackageDescription

let package = Package(
    name: "PathKit",
    dependencies: [
        .Package(url: "https://github.com/EvilClay/CatchingFire.git", majorVersion: 0, minor: 2),
    ]
)

