//
//  SearchBarAssociate.swift
//  OASwift
//
//  Created by RickWang on 2023/2/23.
//

import Foundation
import JiuFoundation

@objc
public protocol SearchBarAssociateViewDelegate: NSObjectProtocol {
    
    func SearchBarAssociateViewDidSelectItem(item: SearchValueModel, atIndexPath: IndexPath)
    
}

@objcMembers
public class SearchBarAssociateView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    // MARK: - Property
    
    public var style: SearchBarStyle = OASearchBarStyle()
    
    public var tableView: UITableView = UITableView()
    
    public var associatedList: [SearchValueModel] = [SearchValueModel]() {
        didSet {
            associatedListDidSet()
        }
    }
    
    public var contentTargetFrame: CGRect = CGRect.zero
    
    public var backgroundLayer:CAShapeLayer = CAShapeLayer()
    
    lazy var tapGusture: UITapGestureRecognizer! = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    public var associatedString: String?
    
    public weak var delegate: SearchBarAssociateViewDelegate?
    
    // MARK: - Init
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSubViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubViews()
    }
    
    public init(associatedList: [SearchValueModel]) {
        super.init(frame: CGRect.zero)
        self.associatedList = associatedList
        self.initSubViews()
    }
    
    public func initSubViews() {
        self.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.4)
        self.addGestureRecognizer(self.tapGusture)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.keyboardDismissMode = .onDrag
        tableView.register(SearchBarAssociateCell.self, forCellReuseIdentifier: NSStringFromClass(SearchBarAssociateCell.self))
        
        backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = CHListColors.surface.cgColor
        self.layer.addSublayer(backgroundLayer)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        self.addSubview(tableView)
        
        let tableHeight = style.associateListCellHeight * CGFloat(associatedList.count)
        self.tableView.autoMake { maker in
            maker.top()
            maker.left()
            maker.right()
            maker.height(tableHeight)
        }
        
        if associatedList.count > 0 {
            tableView.reloadData()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = tableView.bounds
        backgroundLayer.path = UIBezierPath(roundedRect: tableView.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 8, height: 8)).cgPath
    }
    
    // MARK: - Method
    fileprivate func associatedListDidSet() {
        self.tableView.reloadData()
        self.isHidden = false
    }
    
    // MARK: - Action
    
    @objc
    fileprivate func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.isHidden = true
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.associatedList.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return style.associateListCellHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SearchBarAssociateCell.self), for: indexPath) as! SearchBarAssociateCell
        cell.style = self.style
        cell.reloadCell(associatedList[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = associatedList[indexPath.row]
        delegate?.SearchBarAssociateViewDidSelectItem(item: item, atIndexPath: indexPath)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: self)
        if (point.x >= self.tableView.frame.minX && point.x <= self.tableView.frame.maxX) &&
            (point.y >= self.tableView.frame.minY && point.y <= self.tableView.frame.maxY){
            return false
        }
        
        return true
    }
    
}
