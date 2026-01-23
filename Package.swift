// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZLProtoService",
    
    // 對應 podspec 中的 ios.deployment_target = '10.0'
    platforms: [
        .iOS(.v12),
        // 如果之後要支援 macOS、tvOS 等，可以再加上
        // .macOS(.v10_15),
    ],
    
    products: [
        // 通常會做成 library，名字建議跟 pod 名稱一致
        .library(
            name: "ZLPagerTabController",
            targets: ["ZLPagerTabController"]
        ),
         .library(
                    name: "ZLPagerTabControllerParallaxHeader",
                    targets: ["ZLPagerTabControllerParallaxHeader"]
                ),
          .library(
                    name: "ZLPagerTabControllerParallaxPagerViewController",
                    targets: ["ZLPagerTabControllerParallaxPagerViewController"]
                ),
    ],
    
    dependencies: [
     
    ],
    
    targets: [
        .target(
            name: "ZLPagerTabController",
            dependencies: [],
            path: "ZLPagerTabController/Classes/PagerViewController",
            resources: [
                .process("../../Resources/PrivacyInfo.xcprivacy")
                // 如果之後有圖片、xib、storyboard 等，也可以加在這邊
                // .process("Assets")
            ]
        ),
         .target(
                    name: "ZLPagerTabControllerParallaxHeader",
                    dependencies: [],
                    path: "ZLPagerTabController/Classes/ParallaxHeader",
                    resources: [
                        .process("../../Resources/PrivacyInfo.xcprivacy")
                    ]
                ),
         .target(
                    name: "ZLPagerTabControllerParallaxPagerViewController",
                    dependencies: [
                        "ZLPagerTabController" ,    // 明確依賴 Base
                        "ZLPagerTabControllerParallaxHeader"
                    ],
                    path: "ZLPagerTabController/Classes/ParallaxPagerViewController",
                    resources: [
                        .process("../../Resources/PrivacyInfo.xcprivacy")
                    ]
                ),
        
    ]
)
