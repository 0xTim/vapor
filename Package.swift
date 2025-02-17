// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "vapor",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "Vapor", targets: ["Vapor"]),
        .library(name: "XCTVapor", targets: ["XCTVapor"]),
        .library(name: "_Vapor3", targets: ["_Vapor3"]),
    ],
    dependencies: [
        // HTTP client library built on SwiftNIO
        .package(url: "https://github.com/0xTim/async-http-client", from: "1.2.0"),
    
        // Sugary extensions for the SwiftNIO library
        .package(url: "https://github.com/0xTim/async-kit", from: "1.0.0"),

        // 💻 APIs for creating interactive CLI tools.
        .package(url: "https://github.com/0xTim/console-kit", from: "4.0.0"),

        // 🔑 Hashing (BCrypt, SHA2, HMAC), encryption (AES), public-key (RSA), and random data generation.
        .package(url: "https://github.com/apple/swift-crypto", from: "1.0.0"),

        // 🚍 High-performance trie-node router.
        .package(url: "https://github.com/vapor/routing-kit", from: "4.0.0"),

        // 💥 Backtraces for Swift on Linux
        .package(url: "https://github.com/swift-server/swift-backtrace", from: "1.1.1"),
        
        // Event-driven network application framework for high performance protocol servers & clients, non-blocking.
        .package(url: "https://github.com/apple/swift-nio", from: "2.18.0"),
        
        // Bindings to OpenSSL-compatible libraries for TLS support in SwiftNIO
        .package(url: "https://github.com/0xTim/swift-nio-ssl", from: "2.8.0"),
        
        // HTTP/2 support for SwiftNIO
        .package(url: "https://github.com/0xTim/swift-nio-http2", from: "1.13.0"),
        
        // Useful code around SwiftNIO.
        .package(url: "https://github.com/0xTim/swift-nio-extras", from: "1.0.0"),
        
        // Swift logging API
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),

        // Swift metrics API
        .package(url: "https://github.com/apple/swift-metrics", from: "2.0.0"),

        // WebSocket client library built on SwiftNIO
        .package(url: "https://github.com/0xTim/websocket-kit", from: "2.0.0"),
    ],
    targets: [
        // C helpers
        .target(name: "CBase32"),
        .target(name: "CBcrypt"),
        .target(name: "CMultipartParser"),
        .target(name: "COperatingSystem"),
        .target(name: "CURLParser"),

        // Vapor
        .target(name: "Vapor", dependencies: [
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "AsyncKit", package: "async-kit"),
            .product(name: "Backtrace", package: "swift-backtrace"),
            .target(name: "CBase32"),
            .target(name: "CBcrypt"),
            .target(name: "CMultipartParser"),
            .target(name: "COperatingSystem"),
            .target(name: "CURLParser"),
            .product(name: "ConsoleKit", package: "console-kit"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "Metrics", package: "swift-metrics"),
            .product(name: "NIO", package: "swift-nio"),
            .product(name: "NIOExtras", package: "swift-nio-extras"),
            .product(name: "NIOFoundationCompat", package: "swift-nio"),
            .product(name: "NIOHTTPCompression", package: "swift-nio-extras"),
            .product(name: "NIOHTTP1", package: "swift-nio"),
            .product(name: "NIOHTTP2", package: "swift-nio-http2"),
            .product(name: "NIOSSL", package: "swift-nio-ssl"),
            .product(name: "NIOWebSocket", package: "swift-nio"),
            .product(name: "Crypto", package: "swift-crypto"),
            .product(name: "RoutingKit", package: "routing-kit"),
            .product(name: "WebSocketKit", package: "websocket-kit"),
        ]),
        // Vapor 3 API shim
        .target(name: "_Vapor3", dependencies: [
            .target(name: "Vapor"),
            .product(name: "_NIO1APIShims", package: "swift-nio")
        ]),

        // Development
        .target(name: "Development", dependencies: [
            .target(name: "Vapor"),
            .target(name: "_Vapor3"),
        ], swiftSettings: [
            // Enable better optimizations when building in Release configuration. Despite the use of
            // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
            // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
            .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
        ]),

        // Testing
        .target(name: "XCTVapor", dependencies: [
            .target(name: "Vapor"),
        ]),
        .testTarget(name: "VaporTests", dependencies: [
            .product(name: "NIOTestUtils", package: "swift-nio"),
            .target(name: "XCTVapor"),
        ]),
    ]
)
