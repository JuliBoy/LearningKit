//
//  ListEmpty.swift
//  OASwift
//
//  Created by RickWang on 2023/2/20.
//

import Foundation
import UIKit
import JiuFoundation

@objc
public protocol ListEmpty: NSObjectProtocol {
    
    var imageView: UIImageView { get set }
    
    var titleLabel: UILabel { get set }
    
    var button: UIButton { get set }
    
    var image: UIImage? { get set }
    
    var title: String { get set }
    
    var imageStyle: ListEmptyImageStyle { get set }
    
    var buttonStyle: ListEmptyButtonStyle { get set }
    
    var titleImageGap: CGFloat { get set }
    
    var config: ListEmptyViewConfig { get set }
}

@objc
public protocol ListEmptyViewDelegate: NSObjectProtocol {
    @objc optional func buttonDidTapped()
}

@objcMembers
public class ListEmptyView: UIView, ListEmpty {
    
    // MARK: - Property
    public var imageView: UIImageView = UIImageView()
    
    public var titleLabel: UILabel = UILabel()
    
    public var imageStyle: ListEmptyImageStyle = .Middle
    
    public var button: UIButton = UIButton()
    
    public var image: UIImage? = ListKitAsserts.icon_no_data
    
    public var title: String = ""
    
    public var buttonStyle: ListEmptyButtonStyle = .showButton
    
    public var titleImageGap: CGFloat = 16
    
    public var config: ListEmptyViewConfig = ListEmptyViewConfig()
    
    public weak var delegate: ListEmptyViewDelegate?
    
    public var imageConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    public var titleConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    public var buttonConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()

    
    // MARK: - Init
    @objc
    public init(image: UIImage, title: String) {
        super.init(frame: CGRect.zero)
        self.image = image
        self.title = title
        self.buttonStyle = .showLabel
        self.initSubViews()
    }
    
    @objc
    public init(image: UIImage, buttonTitle: String) {
        super.init(frame: CGRect.zero)
        self.image = image
        self.title = buttonTitle
        self.buttonStyle = .showButton
        self.initSubViews()
    }
    
    @objc
    public init(image: UIImage, buttonTitle: String, config: ListEmptyViewConfig) {
        super.init(frame: CGRect.zero)
        self.image = image
        self.title = buttonTitle
        self.buttonStyle = .showButton
        self.initSubViews()
    }
    
    @objc
    public init(image: UIImage, title: String, config: ListEmptyViewConfig) {
        super.init(frame: CGRect.zero)
        self.image = image
        self.title = title
        self.buttonStyle = .showLabel
        self.initSubViews()
    }
    
    @objc
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        initSubViews()
    }
    
    public func initSubViews() {
        self.backgroundColor = self.config.backgroundColor
        self.imageView.image = self.image
        self.addSubview(self.imageView)
        
        // 初始化图片，标签和按钮
        var textHeight:CGFloat = 0
        if buttonStyle == .showButton { // 展示按钮
            textHeight = titleImageGap + config.buttonConfig.minSize.height
            self.button.setTitle(self.title, for: UIControl.State.normal)
            self.button.setTitleColor(config.buttonConfig.textColor, for: UIControl.State.normal)
            self.button.titleLabel?.font = config.buttonConfig.font
            self.button.titleLabel?.textAlignment = .center
            self.button.layer.backgroundColor = config.buttonConfig.backgroundColor.cgColor
            self.button.layer.cornerRadius = config.buttonConfig.cornerRadius
            self.button.contentEdgeInsets = config.buttonConfig.edgInsets
            self.button.addTarget(self, action: #selector(buttonDidTapAction(_:)), for: UIControl.Event.touchUpInside)
            self.button.sizeToFit()
            self.addSubview(self.button)
            
        } else { // 展示标签
            textHeight = titleImageGap + 14
            self.titleLabel.text = self.title
            self.titleLabel.textAlignment = .center
            self.titleLabel.font = config.labelConfig.font
            self.titleLabel.textColor = config.labelConfig.textColor
            self.addSubview(self.titleLabel)
        }
        
        self.imageConstraints = self.imageView.autoMake({ maker in
            if (imageStyle == .Middle) {
                maker.center(x: 0, y: (self.config.imageConfig.height + titleImageGap + textHeight) * -0.5)
            } else {
                maker.centerX()
                maker.top(inset: config.imageConfig.topDistance)
            }
            maker.size(width: config.imageConfig.width, height: config.imageConfig.height)
        })
        
        if (buttonStyle == .showButton) {
            self.buttonConstraints = self.button.autoMake { maker in
                maker.centerX()
                maker.top(to: self.imageView, edge: .bottom, offset: titleImageGap)
                maker.width(self.config.buttonConfig.minSize.width, by: NSLayoutConstraint.Relation.greaterThanOrEqual)
            }
        } else {
            self.titleConstraints = self.titleLabel.autoMake({ maker in
                maker.centerX()
                maker.top(to: self.imageView, edge: .bottom, offset: titleImageGap)
            })
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    // MARK: - Method
    public func updateListEmptyView(image:UIImage?,
                                    title:String?,
                                    titleImageGap: CGFloat = 16,
                                    config: ListEmptyViewConfig?,
                                    imageStyle:ListEmptyImageStyle = .Middle,
                                    buttonStyle:ListEmptyButtonStyle = .showButton) {
        
        if let imageNew = image {
            self.image = imageNew
            self.imageView.image = imageNew
        }
        
        if let titleNew = title {
            self.title = titleNew
        }
        
        self.titleImageGap = titleImageGap
        if let configNew = config {
            self.config = configNew
        }
        
        self.backgroundColor = self.config.backgroundColor
        self.imageStyle = imageStyle
        self.buttonStyle = buttonStyle
        
        var textHeight:CGFloat = 0
        if buttonStyle == .showButton { // 展示按钮
            if self.button.superview == nil {
                self.addSubview(self.button)
            }
            if (!self.titleLabel.isHidden) {
                self.titleLabel.isHidden = true
            }
            textHeight = titleImageGap + self.config.buttonConfig.minSize.height
            self.button.setTitle(self.title, for: UIControl.State.normal)
            self.button.setTitleColor(self.config.buttonConfig.textColor, for: UIControl.State.normal)
            self.button.titleLabel?.font = self.config.buttonConfig.font
            self.button.titleLabel?.textAlignment = .center
            self.button.layer.backgroundColor = self.config.buttonConfig.backgroundColor.cgColor
            self.button.layer.cornerRadius = self.config.buttonConfig.cornerRadius
            self.button.contentEdgeInsets = self.config.buttonConfig.edgInsets
            self.button.sizeToFit()
        } else {
            if (self.titleLabel.superview == nil) {
                self.addSubview(self.titleLabel)
            }
            if (!self.button.isHidden) {
                self.button.isHidden = true
            }
            textHeight = titleImageGap + 14
            self.titleLabel.text = self.title
            self.titleLabel.textColor = self.config.labelConfig.textColor
            self.titleLabel.textAlignment = .center
            self.titleLabel.font = self.config.labelConfig.font
        }
        
        self.imageConstraints = self.imageView.autoRemake(constraints: self.imageConstraints, { maker in
            if (imageStyle == .Middle) {
                maker.center(x: 0, y: (self.config.imageConfig.height + titleImageGap + textHeight) * -0.5)
            } else {
                maker.centerX()
                maker.top(inset: self.config.imageConfig.topDistance)
            }
            maker.size(width: self.config.imageConfig.width, height: self.config.imageConfig.height)
        })
        
        if (buttonStyle == .showButton) {
            self.buttonConstraints = self.button.autoRemake(constraints: self.buttonConstraints, { maker in
                maker.centerX()
                maker.top(to: self.imageView, edge: .bottom, offset: titleImageGap)
                maker.width(self.config.buttonConfig.minSize.width, by: NSLayoutConstraint.Relation.greaterThanOrEqual)
            })
        } else {
            self.titleConstraints = self.titleLabel.autoRemake(constraints: self.titleConstraints, { maker in
                maker.centerX()
                maker.top(to: self.imageView, edge: .bottom, offset: titleImageGap)
            })
        }
    }
    
    // 满足横屏时刷新（临时）
    func updateCenterView() {
        let inset = max(0.0, (frame.height - config.imageConfig.height - titleImageGap - titleImageGap - 16.0) / 2.0)
        imageConstraints = imageView.autoRemake(constraints: imageConstraints, { maker in
            maker.top(inset: inset)
            maker.centerX()
            maker.size(width: config.imageConfig.width, height: config.imageConfig.height)
        })
    }
    
    // MARK: - Action
    @objc fileprivate func buttonDidTapAction(_ sender: UIButton) {
        let selector = NSSelectorFromString("buttonDidTapped")
        if let delegate = self.delegate, delegate.responds(to: selector) {
            delegate.buttonDidTapped?()
        }
    }
    
}
