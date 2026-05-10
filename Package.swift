// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CustomizableSlider",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "CustomizableSlider", targets: ["CustomizableSlider"]),
    ],
    targets: [
        .target(
            name: "CustomizableSlider",
            path: "Sources/CustomizableSlider"
        ),
        .testTarget(
            name: "CustomizableSliderTests",
            dependencies: ["CustomizableSlider"],
            path: "CustomizableSliderTests"
        ),
    ]
)
