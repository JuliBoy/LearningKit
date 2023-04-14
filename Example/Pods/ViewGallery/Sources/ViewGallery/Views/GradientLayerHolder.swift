//
// Created by Nan Yang on 2022/8/19.
//

import QuartzCore

/// 为简化在 UIView 中使用 CAGradientLayer 而生的属性包装器。
///
/// 使用方法：
/// ```swift
/// class SomeView: UIView {
///     @GradientLayerHolder
///     private var gradientLayer: CAGradientLayer
///
///     func setup() {
///         _gradientLayer.setBackgroundColor(.solid(UIColor.blue))
///         _gradientLayer.setBackgroundColor(.horizontalGradient()
///             .start(UIColor.blue)
///             .end(UIColor.green))
///     }
/// }
/// ```
@frozen
@propertyWrapper
public struct GradientLayerHolder: GradientLayerSetter {
    public let layer: CAGradientLayer

    public var wrappedValue: CAGradientLayer {
        layer
    }

    public init(wrappedValue: CAGradientLayer) {
        layer = wrappedValue
    }

    public init(_ layer: CAGradientLayer) {
        self.layer = layer
    }

    public init() {
        layer = CAGradientLayer()
    }

    public var gradientType: CAGradientLayerType {
        get {
            layer.type
        }
        set {
            layer.type = newValue
        }
    }

    public func setBackgroundColor<Style>(_ style: Style) where Style: ColorStyle {
        style.accept(self)
    }
}

extension GradientLayerHolder: ColorStyleVisitor {
    public func visit(solidStyle: SolidColorStyle) {
        layer.colors = nil
        layer.backgroundColor = solidStyle.color?.cgColor
    }

    public func visit(gradientStyle: GradientColorStyle) {
        guard let startColor = gradientStyle.startColor,
              let endColor = gradientStyle.endColor else {
            return
        }
        layer.colors = [startColor.cgColor, endColor.cgColor]
        layer.startPoint = gradientStyle.startPoint
        layer.endPoint = gradientStyle.endPoint
    }
}
