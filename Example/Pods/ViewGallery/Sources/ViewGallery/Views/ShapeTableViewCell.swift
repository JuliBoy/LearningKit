//
//  ShapeTableViewCell.swift
//  
//
//  Created by Nan Yang on 2023/1/12.
//

#if canImport(UIKit)
import UIKit

open class ShapeTableViewCell: UITableViewCell {
    public private(set) var position: CellPosition?
    public let containerView = ShapeView(frame: .zero)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
