import PackageDescription

let package = Package(
    name: "BotKit",
    dependencies: [
        .Package(url: "https://github.com/utahiosmac/jobs", majorVersion: 1),
        .Package(url: "https://github.com/daltoniam/Starscream", majorVersion: 2)
    ]
)
