//
//  ShapeCollectionViewCell.swift
//  
//
//  Created by Nan Yang on 2023/1/5.
//

#if canImport(UIKit)
import UIKit

public enum CellPosition {
    case top, center, bottom, single

    public func toRectCorner() -> UIRectCorner {
        switch self {
        case .top:
            return [.topLeft, .topRight]
        case .center:
            return []
        case .bottom:
            return [.bottomLeft, .bottomRight]
        case .single:
            return .allCorners
        }
    }
}

open class ShapeCollectionViewCell: UICollectionViewCell {
    public private(set) var position: CellPosition?
    public let containerView = ShapeView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(containerView)
    }
    
    open func updateShape(position: CellPosition, radius: CGFloat) {
        let shape = RoundedRectangle(radius: radius, byRounding: position.toRectCorner())
        containerView.updateShape(shape)
    }
    
    open func updateShape<S>(_ shape: S) where S: Shape {
        containerView.updateShape(shape)
    }
}

#endif // canImport(UIKit)
