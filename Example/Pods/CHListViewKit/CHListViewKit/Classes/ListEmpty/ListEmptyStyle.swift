//
//  ListEmptyStyle.swift
//  OASwift
//
//  Created by RickWang on 2023/2/20.
//
import Foundation
import JiuFoundation

@objc
public enum ListEmptyImageStyle: Int {
    case Middle = 0
    case TopDistance = 1
}

@objc
public enum ListEmptyButtonStyle: Int {
    case showButton = 0
    case showLabel = 1
}

@objcMembers
public class ListEmptyViewConfig: NSObject {
    
    public var backgroundColor: UIColor = CHListColors.surface
    
    public var topSeparatorHeight: CGFloat = 0
    
    public var imageConfig: ListEmptyImageConfig = ListEmptyImageConfig()
    
    public var labelConfig: ListEmptyLabelConfig = ListEmptyLabelConfig()
    
    public var buttonConfig: ListEmptyButtonConfig = ListEmptyButtonConfig()
}

@objcMembers
public class ListEmptyImageConfig: NSObject {
    
    public var width: CGFloat = 159
    
    public var height: CGFloat = 120
    
    public var topDistance: CGFloat = 0
    
    public var showStyle: ListEmptyImageStyle = .Middle
}

@objcMembers
public class ListEmptyLabelConfig: NSObject {
    
    public var fontSize: CGFloat = 14
    
    public var font: UIFont {
        UIFont.systemFont(ofSize: self.fontSize)
    }
    
    public var textColor: UIColor = CHListColors.x828282
    
    public var titleImageGap: CGFloat = 16
    
    public var show: Bool = false
}

@objcMembers
public class ListEmptyButtonConfig: NSObject {
    
    public var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    public var textColor: UIColor = UIColor.white
    
    public var titleImageGap: CGFloat = 16
    
    public var backgroundColor: UIColor = CHListColors.primary
    
    public var minSize:CGSize = CGSize(width: 106, height: 30)
    
    public var cornerRadius: CGFloat = 15
    
    public var edgInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    public var show: Bool = true
    
}

