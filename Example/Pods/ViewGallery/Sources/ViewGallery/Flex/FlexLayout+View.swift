//
// Created by Nan Yang on 2022/7/19.
//

#if canImport(UIKit)
import UIKit

private var flexLayoutKey = "g5P6stwUkw" // 随机字符串

extension UIView {
    @usableFromInline
    var _flexLayout: FlexLayout? {
        get {
            self.associatedObject(key: &flexLayoutKey)
        }
        set {
            self.setAssociatedObject(key: &flexLayoutKey, object: newValue)
        }
    }

    public func markDirty() {
        _flexLayout?.markDirty()
    }

    public func removeFromFlexView() {
        if let parent = superview as? FlexViewContainer {
            parent.removeFlexSubview(self)
        } else {
            removeFromSuperview()
        }
    }
}

#endif
