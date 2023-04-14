//
//  IMColors.swift
//  CHMessageSDK
//
//  Created by Nan Yang on 2022/5/25.
//

import Foundation

public final class CHListColors: NSObject {
    /// 浅色：0xF5F5F5，深色：0x242424
    @objc
    public static var background: UIColor {
        dynamicColor(light: 0xF5F5F5, dark: 0x242424)
    }
    
    /// 浅色：0x9C9C9C，深色：0xB5B5B5
    @objc
    public static var onBackground: UIColor {
        dynamicColor(light: 0x9C9C9C, dark: 0xB5B5B5)
    }
    
    /// 浅色：0xFFFFFF，深色：0x000000
    @objc
    public static var surface: UIColor {
        dynamicColor(light: 0xFFFFFF, dark: 0x000000)
    }
    
    /// 浅色：0x000000，深色：0xFFFFFF
    @objc
    public static var onSurface: UIColor {
        dynamicColor(light: 0x000000, dark: 0xFFFFFF)
    }
    
    /// 浅色：0x239DFC，深色：0x0384E7
    @objc
    public static var primary: UIColor {
        dynamicColor(light: 0x239DFC, dark: 0x0384E7)
    }
    
    @objc
    public static var onPrimary: UIColor {
        dynamicColor(light: 0xFFFFFF, dark: 0xFFFFFF)
    }
    
    /// 浅色：0x333333，深色：0xCCCCCC
    @objc
    public static var onSecondary: UIColor {
        dynamicColor(light: 0x333333, dark: 0xCCCCCC)
    }
    
    @objc
    public static var x828282: UIColor {
        dynamicColor(light: 0x828282, dark: 0x828282)
    }
    
    /// 浅色：0xDFDFDF，深色：0x404040
    @objc
    public static var separator: UIColor {
        dynamicColor(light: 0xDFDFDF, dark: 0x404040)
    }
    
    /// 浅色：0xEBEBEB，深色：0x141414
    @objc
    public static var line: UIColor { // 另一种分隔线……
        dynamicColor(light: 0xEBEBEB, dark: 0x141414)
    }
    
    /// 浅色：0xFAFAFA，深色：0x050505
    @objc
    public static var xFAFAFA: UIColor {
        dynamicColor(light: 0xFAFAFA, dark: 0x050505)
    }
    
    /// 浅色：0x4D9BF5，深色：0x4D9BF5
    @objc
    public static var x4D9BF5: UIColor {
        dynamicColor(light: 0x4D9BF5, dark: 0x4D9BF5)
    }
    
    /// 浅色：0x4D9BF5，深色：0x4D9BF5
    @objc
    public static var xF21C1C: UIColor {
        dynamicColor(light: 0xF21C1C, dark: 0xF21C1C)
    }
}

extension CHListColors {
    @objc
    public static var xDE392D: UIColor {
        dynamicColor(light: 0xDE392D, dark: 0xDE392D)
    }
    
    @objc
    public static var x555555: UIColor {
        dynamicColor(light: 0x555555, dark: 0x9C9C9C)
    }
    
    @objc
    public static var xFBF0E6: UIColor {
        dynamicColor(light: .init(argb: 0xFBF0E6), dark: .init(rgb: 0xFA6400, alpha: 0.08))
    }
    
    @objc
    public static var xFA6400: UIColor {
        dynamicColor(light: 0xFA6400, dark: 0xFA6400)
    }
}
