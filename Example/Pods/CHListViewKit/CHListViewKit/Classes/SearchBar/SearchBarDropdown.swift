//
//  SearchBarDropdown.swift
//  OASwift
//
//  Created by RickWang on 2023/2/23.
//

import Foundation
import UIKit
import JiuFoundation

@objcMembers
public class SearchBarDropdownButton: UIButton {
    
    // MARK: -
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let label = self.titleLabel, let imageView = self.imageView else {
            return
        }
        
        label.sizeToFit()
        imageView.sizeToFit()
        
        label.frame = CGRect(x: 0, y: (self.bounds.height - label.bounds.height)/2, width: label.bounds.width, height: label.bounds.height)
        imageView.frame = CGRect(x: label.frame.maxX + 2, y: (self.bounds.height - imageView.bounds.height)/2, width: imageView.bounds.width, height: imageView.bounds.height)
    }
}


@objc
public protocol SearchBarDropdownDelegate {
    
    func SearchBarDropdownItemDidSelect(_ item: SearchDropdownListItemModel, atIndexPath: IndexPath)
    
    func SearchBarDropdownListDidHide()
    
}


@objcMembers
public class SearchBarDropdownView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Property
    
    public var dropdownList: [SearchDropdownListItemModel] = [SearchDropdownListItemModel]()
    
    public var style: SearchBarStyle = OASearchBarStyle()
    
    public var anglePoint: CGPoint = CGPoint.zero {
        didSet {
            self.contentOrigin = CGPoint(x: anglePoint.x - (dropdownContentWidth / 2), y: 0)
            print("contentOrigin x is \(contentOrigin)")
            self.dropdownContentView.autoUpdate(in: &self.contentConstraint, { maker in
                maker.left(inset: contentOrigin.x)
                print("didUpdate dropdownContentView constraint left is \(contentOrigin.x)")
            })
        }
    }
    
    lazy var tapGusture: UITapGestureRecognizer! = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    public var dropdownContentView: SearchBarDropdownContentView = SearchBarDropdownContentView()
    
    public var dropdownContentWidth: CGFloat = 0
    
    public var dropContentHeight: CGFloat = 0
    
    public var contentOrigin: CGPoint = CGPoint.zero
    
    public var contentConstraint: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    public weak var delegate: SearchBarDropdownDelegate?
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(dropdownList: [SearchDropdownListItemModel], dropDownAngle: CGPoint, style: SearchBarStyle = OASearchBarStyle()){
        super.init(frame: CGRect.zero)
        self.dropdownList = dropdownList
        self.anglePoint = dropDownAngle
        self.style = style
        self.initSubViews()
    }
    
    public func initSubViews() {
        self.addGestureRecognizer(tapGusture)
        dropdownContentWidth = style.dropdownListMinWidth
        if let maxTitle = self.dropdownList.map({$0.key}).max(by: { $1.count > $0.count }) {
            dropdownContentWidth = self.calculateDropdownContentWidth(maxTitle: maxTitle)
        }
        
        dropContentHeight = CGFloat(self.dropdownList.count) * style.dropdownListCellHeight + 3
        
        contentOrigin = CGPoint(x: anglePoint.x - (dropdownContentWidth / 2), y: 0)
        print("origin ContentOrigin is \(contentOrigin)")
        self.dropdownContentView = SearchBarDropdownContentView(dropdownList: self.dropdownList)
        self.dropdownContentView.itemTappedBlock = { [weak self] (item, indexPath) in
            self?.delegate?.SearchBarDropdownItemDidSelect(item, atIndexPath: indexPath)
        }
        self.addSubview(self.dropdownContentView)
        self.contentConstraint = self.dropdownContentView.autoMake { maker in
            maker.left(inset: contentOrigin.x)
            maker.top()
            maker.width(dropdownContentWidth)
            maker.height(dropContentHeight)
        }
    }
    
    // MARK: - Layout
    
    public override func updateConstraints() {
        
        super.updateConstraints()
    }
    
    fileprivate func calculateDropdownContentWidth(maxTitle: String) -> CGFloat {
        var title = maxTitle
        if title.count > 10 {
            let subTitle = String(title[..<title.index(title.startIndex, offsetBy: 10)])
            title = subTitle + "..."
        }
        
        let AttributeTitle = AttributedBuilder(title).font(style.dropdownListCellSelectedFont).build()
        var width = AttributeTitle.boundingRect(size: CGSize(width: CGFloat.infinity, height: CGFloat.infinity)).size.width
        
        if width < style.dropdownListMinWidth {
            width = style.dropdownListMinWidth
        }
        
        return width
    }
    
    // MARK: - Method
    
    // MAKR: - Action
    @objc
    fileprivate func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.isHidden = true
        delegate?.SearchBarDropdownListDidHide()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = gestureRecognizer.location(in: self)
        if (point.x >= self.dropdownContentView.frame.minX && point.x <= self.dropdownContentView.frame.maxX) &&
            (point.y >= self.dropdownContentView.frame.minY && point.y <= self.dropdownContentView.frame.maxY){
            return false
        }
        
        return true
    }
    
}


@objcMembers
public class SearchBarDropdownContentView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Property
    public var dropdownList: [SearchDropdownListItemModel] = [SearchDropdownListItemModel]()
    
    public var tableView: UITableView = UITableView()
    
    public var style: SearchBarStyle = OASearchBarStyle()
    
    public var itemTappedBlock: ((SearchDropdownListItemModel, IndexPath)->Void)?
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    public init(dropdownList:[SearchDropdownListItemModel]) {
        super.init(frame: CGRect.zero)
        self.dropdownList = dropdownList
        initSubViews()
    }
    
    public func initSubViews() {
        self.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchBarDropdownCell.self, forCellReuseIdentifier: NSStringFromClass(SearchBarDropdownCell.self))
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        self.addSubview(tableView)
        
        self.tableView.autoMake { maker in
            maker.top(inset: 3)
            maker.left()
            maker.right()
            maker.bottom()
        }
        
        if dropdownList.count > 0 {
            tableView.reloadData()
        }
    }
    
    // MARK: - Method
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return style.dropdownListCellHeight
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SearchBarDropdownCell.self), for: indexPath) as! SearchBarDropdownCell
        cell.style = style
        let model = dropdownList[indexPath.row]
        cell.reloadCell(model)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropdownList.forEachIndexed({$0.selected = (indexPath.row == $1)})
        tableView.reloadData()
        itemTappedBlock?(dropdownList.at(indexPath.row, or: SearchDropdownListItemModel()), indexPath)
    }
    
    // MARK: - DrawRect
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 3, width: rect.width, height: rect.height - 3), cornerRadius: 10)
        let color = style.dropdownListBackgroundColor
        color.setFill()
        bezierPath.fill()
        
        let bezierPathAngle = UIBezierPath()
        bezierPathAngle.move(to: CGPoint(x: rect.width / 2 - 4, y: 3))
        bezierPathAngle.addLine(to: CGPoint(x: rect.width / 2, y: 0))
        bezierPathAngle.addLine(to: CGPoint(x: rect.width / 2 + 4, y: 3))
        bezierPathAngle.addLine(to: CGPoint(x: rect.width / 2 - 4, y: 3))
        bezierPathAngle.fill()
    }
}
