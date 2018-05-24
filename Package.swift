// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Work",
    products: [
        .library(
            name: "Work",
            targets: ["Work"]),
    ],
    targets: [
        .target(
            name: "Work"),
        .target(
            name: "work-sync",
            dependencies: ["Work"]),
        .target(
            name: "work-async",
            dependencies: ["Work"]),
    ]
)
