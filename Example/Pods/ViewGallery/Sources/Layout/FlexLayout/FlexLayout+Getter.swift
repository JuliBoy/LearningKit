//
//  Created by Nan Yang on 2022/1/13.
//

import CoreGraphics

extension FlexLayout {
    public func cgFrame(left: Double, top: Double) -> CGRect {
        CGRect(x: left + box.left, y: top + box.top, width: box.width, height: box.height)
    }
}
