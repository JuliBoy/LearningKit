//
//  Color.swift
//  AppBase
//
//  Created by Nan Yang on 2022/5/12.
//

import UIKit

@inline(__always)
func isLightStyle() -> Bool {
    if #available(iOS 13.0, *) {
        let style = UITraitCollection.current.userInterfaceStyle
        return style != .dark
    } else {
        return true
    }
}

@inline(__always)
func isLightStyle(traitCollection: UITraitCollection) -> Bool {
    if #available(iOS 12.0, *) {
        let style = traitCollection.userInterfaceStyle
        return style != .dark
    } else {
        return true
    }
}

func dynamicColor(light: UInt32, dark: UInt32) -> UIColor {
    if #available(iOS 13.0, *) {
        return UIColor { traitCollection in
            UIColor(argb: isLightStyle(traitCollection: traitCollection) ? light : dark)
        }
    } else {
        return UIColor(argb: light)
    }
}

func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
    if #available(iOS 13.0, *) {
        return UIColor { traitCollection in
            isLightStyle(traitCollection: traitCollection) ? light : dark
        }
    } else {
        return light
    }
}
