//
//  WIndowScene.swift
//  CHIMChatBoxSDK
//
//  Created by May on 2022/9/28.
//

#if canImport(UIKit)
import UIKit

public struct WindowScene {
    public init() {
        
    }
    
    /// 当前的keyWindow
    public func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow } ??
            UIApplication
                .shared
                .keyWindow
        } else {
            // Fallback on earlier versions
            return UIApplication
                .shared
                .keyWindow
        }
    }
}

public class WindowSceneCoordinator: NSObject {
    /// 当前的keyWindow
    @objc public static func keyWindow() -> UIWindow? {
        WindowScene().keyWindow()
    }
}
#endif
