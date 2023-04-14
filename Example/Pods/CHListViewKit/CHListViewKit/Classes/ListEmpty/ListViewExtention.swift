//
//  ListViewExtention.swift
//  CHListViewKit
//
//  Created by RickWang on 2023/2/27.
//

import JiuFoundation

@objc
public extension UITableView {
    
    private struct AssociatedKeys {
        static var emptyViewKey: String = "emptyViewKey"
        
        static var emptyViewDataSourceKey: String = "emptySourceKey"
    }
    
    private class AssoCiatedSourceContainer: NSObject {
        
        public weak var weakObject: ListEmptyViewDelegate?
        
        override init() {
            super.init()
        }
        
        init(withWeakObject: ListEmptyViewDelegate?) {
            super.init()
            self.weakObject = withWeakObject
        }
    }
    
    var emptyDataSource: ListEmptyViewDelegate? {
        get {
            guard let container = objc_getAssociatedObject(self, &AssociatedKeys.emptyViewDataSourceKey) as? AssoCiatedSourceContainer else {
                return nil
            }
            
            return container.weakObject
            
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyViewDataSourceKey, AssoCiatedSourceContainer(withWeakObject: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var emptyListView: ListEmptyView {
        get {
            guard let view = objc_getAssociatedObject(self, &AssociatedKeys.emptyViewKey) as? ListEmptyView else {
                let emptyView = ListEmptyView(image: ListKitAsserts.icon_no_data ?? UIImage(), title: "暂无数据")
                objc_setAssociatedObject(self, &AssociatedKeys.emptyViewKey, emptyView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                print("emptyView is \(emptyView)")
                return emptyView
            }
            print("emptyView is \(view)")
            return view
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var chListItemsCount: Int {
        guard let dataSource = self.dataSource else{
            return 0
        }
        var sections = 1
        var items = 0
        let selectorSection = NSSelectorFromString("tableView:numberOfRowsInSection:")
        if dataSource.responds(to:selectorSection) {
            sections = dataSource.numberOfSections?(in: self) ?? 1
        }
        
        let selectorRow = NSSelectorFromString("tableView:numberOfRowsInSection:")
        if dataSource.responds(to:selectorRow) {
            for i in 0...sections {
                items += dataSource.tableView(self, numberOfRowsInSection: i)
            }
        }
        
        return items
    }
    
    @objc
    func reloadNoDataViews() {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            emptyView.isHidden = false
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            
            self.insertSubview(emptyView, at: 0)
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image: UIImage?, buttonTitle:String) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: buttonTitle, config: nil, imageStyle: .Middle, buttonStyle: .showButton)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image: UIImage?, buttonTitle:String, config: ListEmptyViewConfig?) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: buttonTitle, config: config, imageStyle: .Middle, buttonStyle: .showButton)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image: UIImage?, title: String) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: title, config: nil, imageStyle: .Middle, buttonStyle: .showLabel)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image: UIImage?, title: String, config: ListEmptyViewConfig?) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: title, config: config, imageStyle: .Middle, buttonStyle: .showLabel)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image:UIImage?,
                      title:String?,
                      titleImageGap: CGFloat = 16,
                      config: ListEmptyViewConfig?,
                      imageStyle:ListEmptyImageStyle = .Middle,
                      buttonStyle:ListEmptyButtonStyle = .showButton) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: title, config: config, imageStyle: imageStyle, buttonStyle: buttonStyle)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
}

@objc
public extension UICollectionView {
    
    private struct CollectionAssociatedKeys {
        
        static var emptyViewCollectionKey: String = "emptyViewCollectionKey"
        
        static var emptyViewCollectionDataSourceKey: String = "emptyCollectionSourceKey"
    }
    
    private class AssoCiatedSourceContainer: NSObject {
        
        public weak var weakObject: ListEmptyViewDelegate?
        
        override init() {
            super.init()
        }
        
        init(withWeakObject: ListEmptyViewDelegate?) {
            super.init()
            self.weakObject = withWeakObject
        }
    }
    
    var emptyDataSource: ListEmptyViewDelegate? {
        get {
            guard let container = objc_getAssociatedObject(self, &CollectionAssociatedKeys.emptyViewCollectionDataSourceKey) as? AssoCiatedSourceContainer else {
                return nil
            }
            
            return container.weakObject
            
        }
        set {
            objc_setAssociatedObject(self, &CollectionAssociatedKeys.emptyViewCollectionDataSourceKey, AssoCiatedSourceContainer(withWeakObject: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var emptyListView: ListEmptyView {
        get {
            guard let view = objc_getAssociatedObject(self, &CollectionAssociatedKeys.emptyViewCollectionKey) as? ListEmptyView else {
                let emptyView = ListEmptyView(image: ListKitAsserts.icon_no_data ?? UIImage(), title: "暂无数据")
                objc_setAssociatedObject(self, &CollectionAssociatedKeys.emptyViewCollectionKey, emptyView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                print("emptyView is \(emptyView)")
                return emptyView
            }
            print("emptyView is \(view)")
            return view
        }
        set {
            objc_setAssociatedObject(self, &CollectionAssociatedKeys.emptyViewCollectionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var chListItemsCount: Int {
        guard let dataSource = self.dataSource else{
            return 0
        }
        var sections = 1
        var items = 0
    
        let selectorSection = NSSelectorFromString("collectionView:numberOfItemsInSection:")
        if dataSource.responds(to:selectorSection) {
            sections = dataSource.numberOfSections?(in: self) ?? 1
        }
    
        let selectorRow = NSSelectorFromString("collectionView:numberOfItemsInSection:")
        if dataSource.responds(to:selectorRow) {
            for i in 0...sections {
                items += dataSource.collectionView(self, numberOfItemsInSection: i)
            }
        }
        
        return items
    }
    
    @objc
    func reloadNoDataViews() {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            emptyView.isHidden = false
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            
            self.insertSubview(emptyView, at: 0)
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image: UIImage?, buttonTitle:String) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: buttonTitle, config: nil, imageStyle: .Middle, buttonStyle: .showButton)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image: UIImage?, buttonTitle:String, config: ListEmptyViewConfig?) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: buttonTitle, config: config, imageStyle: .Middle, buttonStyle: .showButton)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image: UIImage?, title: String) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: title, config: nil, imageStyle: .Middle, buttonStyle: .showLabel)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image: UIImage?, title: String, config: ListEmptyViewConfig?) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: title, config: config, imageStyle: .Middle, buttonStyle: .showLabel)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
    
    @objc
    func reloadNoData(image:UIImage?,
                      title:String?,
                      titleImageGap: CGFloat = 16,
                      config: ListEmptyViewConfig?,
                      imageStyle:ListEmptyImageStyle = .Middle,
                      buttonStyle:ListEmptyButtonStyle = .showButton) {
        if chListItemsCount == 0 {
            let emptyView = self.emptyListView
            if self.emptyDataSource != nil {
                emptyView.delegate = self.emptyDataSource
            }
            self.insertSubview(emptyView, at: 0)
            self.emptyListView.updateListEmptyView(image: image, title: title, config: config, imageStyle: imageStyle, buttonStyle: buttonStyle)
            emptyView.isHidden = false
            
            if let superview = emptyView.superview {
                emptyView.frame = CGRect(x: 0, y: emptyView.config.topSeparatorHeight, width: superview.frame.width, height: superview.frame.height - emptyView.config.topSeparatorHeight)
            }
        } else {
            self.emptyListView.isHidden = true
        }
    }
}

public extension UIView {
    private struct AssociatedKeys {
        static var emptyViewKey: String = "UIViewEmptyViewKey"
        
        static var emptyViewDataSourceKey: String = "UIViewEmptySourceKey"
    }
    
    private class AssociatedSourceContainer: NSObject {
        
        public weak var weakObject: ListEmptyViewDelegate?
        
        override init() {
            super.init()
        }
        
        init(withWeakObject: ListEmptyViewDelegate?) {
            super.init()
            self.weakObject = withWeakObject
        }
    }
    
    var emptyData: ListEmptyViewDelegate? {
        get {
            guard let container = objc_getAssociatedObject(self, &AssociatedKeys.emptyViewDataSourceKey) as? AssociatedSourceContainer else {
                return nil
            }
            
            return container.weakObject
            
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.emptyViewDataSourceKey,
                                     AssociatedSourceContainer(withWeakObject: newValue),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var emptyPlaceholderView: ListEmptyView {
        get {
            guard let view = objc_getAssociatedObject(self, &AssociatedKeys.emptyViewKey) as? ListEmptyView else {
                let emptyView = ListEmptyView(image: ListKitAsserts.icon_no_data ?? UIImage(), title: "暂无数据")
                objc_setAssociatedObject(self, &AssociatedKeys.emptyViewKey, emptyView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                print("emptyView is \(emptyView)")
                return emptyView
            }
            print("emptyView is \(view)")
            return view
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc
    func reloadPlaceholderEmpty() {
        reloadEmptyPlaceholder()
    }
    
    @objc
    func reloadPlaceholderEmpty(image: UIImage?) {
        reloadEmptyPlaceholder(image: image)
    }
    
    @objc
    func reloadPlaceholderEmpty(image: UIImage?, title: String) {
        reloadEmptyPlaceholder(image: image, title: title)
    }
    
    @objc
    func reloadPlaceholderEmpty(image: UIImage?, title: String, config: ListEmptyViewConfig?) {
        reloadEmptyPlaceholder(image: image, title: title, config: config)
    }
    
    @objc
    func reloadPlaceholderEmpty(title: String) {
        reloadEmptyPlaceholder(title: title)
    }
    
    @objc
    func reloadPlaceholderEmpty(title: String, config: ListEmptyViewConfig?) {
        reloadEmptyPlaceholder(title: title, config: config)
    }
    
    @objc
    func reloadPlaceholderEmpty(title: String, buttonStyle: ListEmptyButtonStyle) {
        reloadEmptyPlaceholder(title: title, buttonStyle: buttonStyle)
    }
    
    @objc
    func reloadPlaceholderEmpty(image:UIImage? = nil,
                                title:String? = nil,
                                titleImageGap: CGFloat = 16,
                                config: ListEmptyViewConfig? = nil,
                                imageStyle: ListEmptyImageStyle = .Middle,
                                buttonStyle: ListEmptyButtonStyle = .showLabel) {
        reloadEmptyPlaceholder(image: image,
                               title: title,
                               titleImageGap: titleImageGap,
                               config: config,
                               imageStyle: imageStyle,
                               buttonStyle: buttonStyle)
    }
    
    @objc
    func hiddenPlaceholderEmptyView() {
        emptyPlaceholderView.removeFromSuperview()
    }
    
    private func reloadEmptyPlaceholder(image:UIImage? = nil,
                                        title:String? = nil,
                                        titleImageGap: CGFloat = 16,
                                        config: ListEmptyViewConfig? = nil,
                                        imageStyle: ListEmptyImageStyle = .Middle,
                                        buttonStyle: ListEmptyButtonStyle = .showLabel) {
        emptyPlaceholderView.updateListEmptyView(image: image,
                                                 title: title,
                                                 titleImageGap: titleImageGap,
                                                 config: config,
                                                 imageStyle: imageStyle,
                                                 buttonStyle: buttonStyle)
        emptyPlaceholderView.delegate = emptyData
        insertSubview(emptyPlaceholderView, at: 0) { maker in
            maker.edges(top: emptyPlaceholderView.config.topSeparatorHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc
    func reloadPlaceholderEmptyCenter() {
        emptyPlaceholderView.updateCenterView()
    }
}
