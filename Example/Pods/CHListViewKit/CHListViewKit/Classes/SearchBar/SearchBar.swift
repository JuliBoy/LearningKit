//
//  SearchBar.swift
//  OASwift
//
//  Created by RickWang on 2023/2/22.
//

import Foundation
import UIKit
import JiuFoundation

public typealias onSearchTextChangedAction = (String)->Void

public typealias onSearchButtonTapAction = (SearchValueModel)->Void

@objc
public protocol SearchBar: NSObjectProtocol {
    
    var textField:UITextField { get set }
    
    var hint: String { get set }
    
    var dropdownButton: UIButton { get set }
    
    var showSearchButton: Bool { get set }
    
    var searchButton: UIButton { get set }
    
    var leftSearchIconButton: UIButton { get set }
    
    var clearButton: UIButton { get set }
    
    var autoSearch: Bool { get set }
    
    var inputThrottleMS: Double { get set }
    
    var dropdownList:[SearchDropdownListItemModel]? { get set }
    
    var associatedList:[SearchValueModel]? { get set }
    
    var searchBarStyle: SearchBarStyle { get set }
    
}

@objc
public protocol SearchBarDelegate: NSObjectProtocol {
    
    func searchBarTextChanged(_ text: String)
    
    func searchBarSearchButtonTapped(_ text: String)
    
    @objc optional func searchBarDropdownItemTapped(_ dropdownItem: SearchDropdownListItemModel)
    
    @objc optional func searchBarAssociateItemTapped(_ associateItem: SearchValueModel)
    
    @objc optional func searchBarTextFieldShouldReturn(_ textField: UITextField) -> Bool
    
    @objc optional func searchBarTextFieldDidEndEditing(_ textField: UITextField)
}

@objcMembers
public class SearchBarView: UIView, SearchBar, UITextFieldDelegate, SearchBarDropdownDelegate, SearchBarAssociateViewDelegate {
    
    public weak var delegate: SearchBarDelegate?
   
    public var textField: UITextField = UITextField()
    
    public var text: String? {
        set {
            self.textField.text = newValue
            self.searchBarTextDidSet()
        }
        get {
            return self.textField.text
        }
    }
    
    public var hint: String = ""
    
    public var dropdownButton: UIButton = SearchBarDropdownButton()
    
    public var showSearchButton: Bool = true
    
    public var searchButton: UIButton = UIButton()
    
    public var leftSearchIconButton: UIButton = UIButton()
    
    public var clearButton: UIButton = UIButton()
    
    public var placeholderLabel: UILabel = UILabel()
    
    public var autoSearch: Bool = false
    
    public var inputThrottleMS: Double =  1.0
    
    public var dropdownList: [SearchDropdownListItemModel]? {
        didSet {
            dropdownListDidSet()
        }
    }
    
    public var associatedList: [SearchValueModel]? {
        didSet {
            associatedListDidSet()
        }
    }
    
    public var searchBarStyle: SearchBarStyle = OASearchBarStyle()
    
    public var dropdownView: SearchBarDropdownView?
    
    public var associateView: SearchBarAssociateView?
    
    public var containerView: UIView = UIView()
    
    public var textFieldConstraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
    
    public var clearButtonConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    public var leftSearchIconConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    public var dropdownButtonConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    public var hasDropdownList: Bool {
        guard let list = self.dropdownList else {
            return false
        }
        
        return list.isNotEmpty
    }
    
    public var dropdownViewIsHidden: Bool {
        if self.dropdownView == nil {
            return true
        }
        
        if let view = self.dropdownView {
            return view.isHidden
        } else {
            return true
        }
    }
    
    public var hasAssociatedList: Bool {
        guard let list = self.associatedList else {
            return false
        }
        
        return list.isNotEmpty
    }
    
    public var textFieldRightAnchorViewLayoutParams: (UIView, AutoEdge, CGFloat) {
        if self.clearButton.isHidden == false {
            return (self.clearButton, AutoEdge.left, -1)
        } else if self.showSearchButton {
            return (self.searchButton, AutoEdge.left, -1)
        } else {
            return (self.containerView, AutoEdge.right, -4)
        }
    }
    
    public weak var controller: UIViewController?
    
    public var anglePoint: CGPoint = CGPoint.zero
    
    public var timer: Timer?
    
    public var throttle: Bool = false
    
    public var defaultDropdownText: String? {
        didSet {
            defaultDropdownTextDidSet()
        }
    }
    
    public var selectedDropdownItem: SearchDropdownListItemModel?
    
    public var associatedText: String?

    
    // MARK: - Init
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(hint: String,
                showSearchButton: Bool,
                autoSearch: Bool,
                searchBarStyle: SearchBarStyle = OASearchBarStyle(),
                inController: UIViewController,
                dropdownList:[SearchDropdownListItemModel]?) {
        super.init(frame: CGRect.zero)
        self.hint = hint
        self.showSearchButton = showSearchButton
        self.autoSearch = autoSearch
        self.searchBarStyle = searchBarStyle
        self.controller = inController
        self.dropdownList = dropdownList
        self.initSubViews()
    }
    
    public init(hint: String,
                showSearchButton: Bool,
                autoSearch: Bool,
                searchBarStyle: SearchBarStyle = OASearchBarStyle(),
                inController: UIViewController,
                defaultDropdownText: String? = nil,
                dropdownList:[SearchDropdownListItemModel]?) {
        super.init(frame: CGRect.zero)
        self.hint = hint
        self.showSearchButton = showSearchButton
        self.autoSearch = autoSearch
        self.searchBarStyle = searchBarStyle
        self.controller = inController
        self.defaultDropdownText = defaultDropdownText
        self.dropdownList = dropdownList
        self.initSubViews()
    }
    
    fileprivate func initDropdownButton(_ dropdownListModel: [SearchDropdownListItemModel]) {
        let defaultSelectedItem = dropdownListModel.first(where: { $0.selected })
        self.dropdownButton.setTitle(defaultSelectedItem?.key, for: UIControl.State.normal)
        self.dropdownButton.setTitleColor(self.searchBarStyle.dropdownButtonTitleColor, for: UIControl.State.normal)
        self.dropdownButton.titleLabel?.font = self.searchBarStyle.dropdownButtonFont
        self.dropdownButton.setImage(self.searchBarStyle.dropdownButtonCollapseIcon, for: UIControl.State.normal)
        self.dropdownButton.setImage(self.searchBarStyle.dropdownButtonExpandIcon, for: UIControl.State.selected)
        self.dropdownButton.addTarget(self, action: #selector(dropdownButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        if let text = defaultDropdownText {
            self.dropdownButton.setTitle(text, for: UIControl.State.normal)
        }
    }
    
    public func initSubViews() {
        self.backgroundColor = searchBarStyle.barBackgroundColor
        self.containerView.backgroundColor = self.searchBarStyle.inputBackgroundColor
        
        self.leftSearchIconButton.setImage(self.searchBarStyle.leftSearchIcon, for: UIControl.State.normal)
        self.leftSearchIconButton.contentEdgeInsets = self.searchBarStyle.leftSearchIconEdgeInsets
        
        var initWithDropdownList = false
        if let dropdownListModel = self.dropdownList {
            initWithDropdownList = true
            self.searchBarStyle.inputMargingLeft = 4
            initDropdownButton(dropdownListModel)
        }
        
        self.textField.backgroundColor = self.searchBarStyle.inputBackgroundColor
        self.textField.textColor = self.searchBarStyle.inputTextColor
        self.textField.font = self.searchBarStyle.inputFont
        self.textField.delegate = self
        self.textField.returnKeyType = self.searchBarStyle.keyboardReturnKey
        //self.textField.attributedPlaceholder = AttributedBuilder(hint).font(self.searchBarStyle.inputHintFont).color(self.searchBarStyle.inputHintTextColor).build()
        
        self.placeholderLabel.text = self.hint
        self.placeholderLabel.textColor = self.searchBarStyle.inputHintTextColor
        self.placeholderLabel.font = self.searchBarStyle.inputHintFont
        self.placeholderLabel.textAlignment = NSTextAlignment.left
        
        self.clearButton.setImage(self.searchBarStyle.clearButtonIcon, for: UIControl.State.normal)
        self.clearButton.addTarget(self, action: #selector(clearButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        self.clearButton.contentEdgeInsets = self.searchBarStyle.clearButtonIconEdgeInsets
        self.clearButton.isHidden = true
        
        self.searchButton.setTitle(self.searchBarStyle.searchButtonTitle, for: UIControl.State.normal)
        self.searchButton.setTitleColor(self.searchBarStyle.searchButtonTitleColor, for: UIControl.State.normal)
        self.searchButton.titleLabel?.font = self.searchBarStyle.searchButtonFont
        self.searchButton.layer.backgroundColor = self.searchBarStyle.searchButtonBackgroundColor.cgColor
        self.searchButton.layer.cornerRadius = self.searchBarStyle.searchButtonCornerRadius
        self.searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        self.searchButton.contentEdgeInsets = self.searchBarStyle.searchButtonContentInsets
        
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.textField)
        self.textField.addSubview(self.placeholderLabel)
        self.containerView.addSubview(self.leftSearchIconButton)
        self.containerView.addSubview(self.clearButton)
        self.containerView.addSubview(self.searchButton)
        self.containerView.addSubview(self.dropdownButton)
        
        self.leftSearchIconButton.setContentCompressionResistancePriority(751, for: NSLayoutConstraint.Axis.horizontal)
        self.leftSearchIconButton.setContentHuggingPriority(251, for: NSLayoutConstraint.Axis.horizontal)
        
        self.dropdownButton.setContentCompressionResistancePriority(751, for: NSLayoutConstraint.Axis.horizontal)
        self.dropdownButton.setContentHuggingPriority(251, for: NSLayoutConstraint.Axis.horizontal)
        
        self.clearButton.setContentCompressionResistancePriority(751, for: NSLayoutConstraint.Axis.horizontal)
        self.clearButton.setContentHuggingPriority(251, for: NSLayoutConstraint.Axis.horizontal)
        
        self.searchButton.setContentCompressionResistancePriority(751, for: NSLayoutConstraint.Axis.horizontal)
        self.searchButton.setContentHuggingPriority(251, for: NSLayoutConstraint.Axis.horizontal)
        
        self.textField.setContentCompressionResistancePriority(749, for: NSLayoutConstraint.Axis.horizontal)
        
        self.containerView.autoMake { maker in
            maker.edges(top: searchBarStyle.inputEdgeInsets.top, left: searchBarStyle.inputEdgeInsets.left, bottom: searchBarStyle.inputEdgeInsets.bottom, right: searchBarStyle.inputEdgeInsets.right)
        }
        
        self.leftSearchIconConstraints = self.leftSearchIconButton.autoMake { maker in
            maker.left(inset: self.searchBarStyle.leftSearchIconMarginLeft)
            maker.centerY()
            maker.width(self.searchBarStyle.cleartButtonIconSize.width + self.searchBarStyle.leftSearchIconEdgeInsets.left + self.searchBarStyle.leftSearchIconEdgeInsets.right)
        }
        
        if initWithDropdownList {
            self.dropdownButtonConstraints = self.dropdownButton.autoMake { maker in
                maker.left(to: self.leftSearchIconButton, edge: AutoEdge.right, offset: self.searchBarStyle.dropdownButtonMarginLeft)
                maker.top()
                maker.bottom()
            }
        } else {
            self.dropdownButton.isHidden = true
        }
        
        if showSearchButton { // 展示搜索按钮
            self.searchButton.autoMake { maker in
                maker.right(inset: searchBarStyle.searchButtonMarginRight)
                maker.top(inset: 4)
                maker.bottom(inset: 4)
            }
        } else { // 不展示搜索按钮
            self.searchButton.isHidden = true
        }
        
        self.textFieldConstraints = self.textField.autoMake { maker in
            if (initWithDropdownList) {
                maker.left(to: self.dropdownButton, edge: AutoEdge.right, offset: self.searchBarStyle.inputMargingLeft)
            } else {
                maker.left(to:self.leftSearchIconButton, edge: AutoEdge.right, offset: self.searchBarStyle.inputMargingLeft)
            }
            maker.top()
            maker.bottom()
            if (showSearchButton) {
                maker.right(to: self.searchButton, edge: AutoEdge.left)
            } else {
                maker.right(inset: self.searchBarStyle.leftSearchIconMarginLeft)
            }
        }
        
        self.clearButtonConstraints = self.clearButton.autoMake { maker in
            if showSearchButton {
                maker.right(to: self.searchButton, edge: AutoEdge.left, offset: -1)
            } else {
                maker.right(inset: -10)
            }
            maker.width(self.searchBarStyle.clearButtonIconEdgeInsets.left + self.searchBarStyle.clearButtonIconEdgeInsets.right + self.searchBarStyle.cleartButtonIconSize.width)
            maker.centerY()
        }
        
        self.placeholderLabel.autoMake { maker in
            maker.centerY()
            maker.left(inset: 4)
        }
        
        self.layoutIfNeeded()
    }
    
    public func calculateAnglePoint() -> CGPoint{
        let anglePointOrigin = CGPoint(x: self.dropdownButton.frame.maxX - (self.dropdownButton.imageView!.bounds.width / 2) + self.searchBarStyle.inputEdgeInsets.left + 1, y: self.dropdownButton.frame.maxY + self.searchBarStyle.dropdownListMarginTop)
        var convertPoint = self.convert(anglePointOrigin, to: UIScreen.main.coordinateSpace)
        if let controller = self.controller {
            convertPoint = self.convert(anglePointOrigin, to: controller.view)
        }
        return convertPoint
    }
    
    public func initDropdownView() {
        guard hasDropdownList else {
            print("没有下拉列表的数据")
            return
        }
        
        if self.dropdownView == nil, let list = self.dropdownList {
            self.anglePoint = calculateAnglePoint()
            print("origin anglePoint is \(self.anglePoint)")
            self.dropdownView = SearchBarDropdownView(dropdownList: list, dropDownAngle: calculateAnglePoint())
            self.dropdownView?.delegate = self
        }
        
        guard let controller = self.controller else{
            print("没有视图控制器")
            return
        }
        
        guard let dropdownView = self.dropdownView else {
            print("下拉列表初始化失败")
            return
        }
        
        controller.view.addSubview(dropdownView)
        dropdownView.autoMake { maker in
            maker.left()
            maker.right()
            maker.bottom()
            maker.top(inset: self.anglePoint.y)
        }
    }
    
    public func initAssociateView() {
        guard hasAssociatedList else {
            print("没有联想列表的数据")
            return
        }
        
        if let list = associatedList, self.associateView == nil {
            self.associateView = SearchBarAssociateView(associatedList: list)
            self.associateView?.delegate = self
        }
        
        guard let controller = self.controller else{
            print("没有视图控制器")
            return
        }
        
        guard let associateView = self.associateView else {
            print("联想列表初始化失败")
            return
        }
        
        controller.view.addSubview(associateView)
        associateView.autoMake { maker in
            maker.left()
            maker.right()
            maker.bottom()
            maker.top(to: self, edge: AutoEdge.bottom)
        }
    }
    
    // MARK: - Life Circle
    
    public override func updateConstraints() {
        super.updateConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = self.containerView.bounds.height / 2
        self.textField.layer.cornerRadius = self.containerView.bounds.height / 2
        
    }
    
    // MARK: - Method
    public func updateCornerRadius() {
        self.containerView.layer.cornerRadius = self.containerView.bounds.height / 2
    }
    
    fileprivate func remakeLeftSearchIconButtonConstraints() {
        self.leftSearchIconConstraints = self.leftSearchIconButton.autoRemake(constraints: self.leftSearchIconConstraints, { maker in
            maker.left(inset: self.searchBarStyle.leftSearchIconMarginLeft)
            maker.width(self.searchBarStyle.cleartButtonIconSize.width + self.searchBarStyle.leftSearchIconEdgeInsets.left + self.searchBarStyle.leftSearchIconEdgeInsets.right)
            maker.centerY()
        })
    }
    
    fileprivate func remakeDropdownButtonConstraints() {
        self.dropdownButtonConstraints = self.dropdownButton.autoRemake(constraints: self.dropdownButtonConstraints, { maker in
            maker.left(to: self.leftSearchIconButton, edge: AutoEdge.right, offset: self.searchBarStyle.dropdownButtonMarginLeft)
            maker.top()
            maker.bottom()
        })
    }
    
    fileprivate func remakeTextFieldConstraints() {
        self.textFieldConstraints = self.textField.autoRemake(constraints: self.textFieldConstraints) { maker in
            if (hasDropdownList) {
                maker.left(to: self.dropdownButton, edge: AutoEdge.right, offset: self.searchBarStyle.inputMargingLeft)
            } else {
                maker.left(to:self.leftSearchIconButton, edge: AutoEdge.right, offset: self.searchBarStyle.inputMargingLeft)
            }
            maker.top()
            maker.bottom()
            maker.right(to: self.textFieldRightAnchorViewLayoutParams.0, edge:self.textFieldRightAnchorViewLayoutParams.1, offset: self.textFieldRightAnchorViewLayoutParams.2)
        }
    }
    
    fileprivate func remakeClearButtonConstraints() {
        self.clearButtonConstraints = self.clearButton.autoRemake(constraints: self.clearButtonConstraints, { maker in
            if showSearchButton {
                maker.right(to: self.searchButton, edge: AutoEdge.left, offset: -1)
            } else {
                maker.right(inset: -1)
            }
            maker.width(self.searchBarStyle.clearButtonIconEdgeInsets.left + self.searchBarStyle.clearButtonIconEdgeInsets.right + 16)
            maker.centerY()
        })
    }
    
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.textField.resignFirstResponder()
        return true
    }
    
    public func showClearButton() {
        self.clearButton.isHidden = false
        self.placeholderLabel.isHidden = true
        remakeClearButtonConstraints()
        remakeTextFieldConstraints()
    }
    
    public func hideClearButton() {
        self.clearButton.isHidden = true
        self.placeholderLabel.isHidden = false
        remakeClearButtonConstraints()
        remakeTextFieldConstraints()
    }
    
    public func showDropdownView() {
        if self.dropdownView == nil {
            self.initDropdownView()
        }
        self.dropdownView?.isHidden = false
    }
    
    public func hideDropdownView() {
        self.dropdownView?.isHidden = true
    }
    
    public func dropdownListDidSet() {
        guard hasDropdownList else {
            return
        }
        
        self.searchBarStyle.inputMargingLeft = 4
        initDropdownButton(self.dropdownList!)
        self.dropdownButton.isHidden = false
        remakeLeftSearchIconButtonConstraints()
        remakeDropdownButtonConstraints()
        remakeTextFieldConstraints()
    }
    
    public func defaultDropdownTextDidSet() {
        if let text = self.defaultDropdownText, selectedDropdownItem == nil {
            self.dropdownButton.setTitle(text, for: UIControl.State.normal)
        }
    }
    
    public func hideAssociatedView() {
        self.associateView?.isHidden = true
    }
    
    public func associatedListDidSet() {
        guard hasAssociatedList, let associateList = self.associatedList else {
            return
        }
        
        if self.associateView == nil {
            initAssociateView()
        } else {
            self.associateView?.associatedList = associateList
        }
        
        self.associateView?.isHidden = false
    }
    
    fileprivate func fireTimer() {
        
        self.timer?.invalidate()
        self.timer = nil
        
        if (self.timer == nil) {
            if #available(iOS 10.0, *) {
                self.timer = Timer(timeInterval: TimeInterval(inputThrottleMS), repeats: true, block: { [weak self] timer in
                    print("timer fired \(Date())")
                    if (self?.throttle) != nil && (self?.throttle) == true {
                        self?.throttle = false
                        self?.delegate?.searchBarTextChanged(self?.textField.text ?? "")
                    }
                    self?.timer?.invalidate()
                    self?.timer = nil
                })
                RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.default)
            }
        }
    }
    
    fileprivate func searchBarTextDidSet() {
        let str = self.textField.text ?? ""
        if str.count > 0 {
            showClearButton()
        } else {
            hideClearButton()
        }
        let selector = NSSelectorFromString("searchBarTextChanged:")
        delegate?.searchBarTextChanged(str)
    }
    
    // MARK: - Action
    
    @objc public func searchButtonTapped(_ sender: UIButton) {
        delegate?.searchBarSearchButtonTapped(self.textField.text ?? "")
        self.dropdownButton.isSelected = false
        let _ = resignFirstResponder()
        self.hideDropdownView()
        self.hideAssociatedView()
    }
    
    @objc public func dropdownButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            showDropdownView()
        } else {
            hideDropdownView()
        }
    }
    
    @objc public func clearButtonTapped(_ sender: UIButton) {
        self.textField.text = ""
        delegate?.searchBarTextChanged("")
        self.hideAssociatedView()
        self.hideDropdownView()
        self.dropdownButton.isSelected = false
        self.hideClearButton()
    }
    
    // MARK: - UITextFieldDelegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField == self.textField else {
            return true
        }
        
        if !dropdownViewIsHidden {
            self.dropdownView?.isHidden = true
            self.dropdownButton.isSelected = false
        }
        
        if let raw = textField.text {
            if raw.count == 1 && string == "" {
                // 隐藏清除按钮
                hideClearButton()
                hideAssociatedView()
            } else if string != "" {
                // 显示清除按钮
                showClearButton()
            }
        }
        
        if (autoSearch) {
            self.throttle = true
            self.fireTimer()
        }
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dropdownButton.isSelected = false
        let _ = resignFirstResponder()
        self.hideDropdownView()
        self.hideAssociatedView()
        return delegate?.searchBarTextFieldShouldReturn?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchBarTextFieldDidEndEditing?(textField)
    }
    
    
    // MARK: - SearchBarDropdownDelegate
    
    public func SearchBarDropdownItemDidSelect(_ item: SearchDropdownListItemModel, atIndexPath: IndexPath) {
        print("item is \(item) and indexPath is \(atIndexPath)")
        self.selectedDropdownItem = item
        self.dropdownButton.isSelected = !self.dropdownButton.isSelected
        self.dropdownButton.setTitle(item.key, for: UIControl.State.normal)
        self.dropdownButton.sizeToFit()
        self.dropdownView?.isHidden = true
        self.anglePoint = calculateAnglePoint()
        self.dropdownView?.anglePoint = self.anglePoint
        if item.inputHint.isNotEmpty {
            self.placeholderLabel.text = item.inputHint
        } else {
            self.placeholderLabel.text = self.hint
        }
        delegate?.searchBarDropdownItemTapped?(item)
    }
    
    public func SearchBarDropdownListDidHide() {
        self.dropdownButton.isSelected = !self.dropdownButton.isSelected
    }
    
    // MARK: - SearchBarAssociateViewDelegate
    public func SearchBarAssociateViewDidSelectItem(item: SearchValueModel, atIndexPath: IndexPath) {
        self.textField.text = item.key
        self.associateView?.isHidden = true
        delegate?.searchBarAssociateItemTapped?(item)
    }

}
