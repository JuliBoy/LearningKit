//
// Created by Nan Yang on 2022/8/19.
//

import QuartzCore

#if canImport(UIKit)
import UIKit
#endif

public protocol GradientLayerSetter {
    /// Style of gradient drawn by the layer.
    ///
    /// Defaults to `CAGradientLayerType.axial`.
    var gradientType: CAGradientLayerType { get set }

    func setBackgroundColor<Style>(_ style: Style) where Style: ColorStyle
}

@objc
public protocol GradientLayerView: NSObjectProtocol {
    var gradientLayer: CAGradientLayer? { get }

#if canImport(UIKit)
    func setBackgroundColor(startColor: UIColor, startPoint: CGPoint, endColor: UIColor, endPoint: CGPoint)

    func setHorizontalBackgroundColor(startColor: UIColor, endColor: UIColor)

    func setVerticalBackgroundColor(startColor: UIColor, endColor: UIColor)
#endif
}
