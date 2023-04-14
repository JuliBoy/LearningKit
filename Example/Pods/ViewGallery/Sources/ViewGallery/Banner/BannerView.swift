//
//  BannerView.swift
//
//
//  Created by Nan Yang on 2021/9/22.
//

#if canImport(UIKit)
import UIKit

public protocol BannerViewDelegate: AnyObject {
    func bannerView(_ bannerView: BannerView, didSelectViewAt index: Int)
}

public protocol BannerViewDataSource: AnyObject {
    func numberOfBanner(in bannerView: BannerView) -> Int
    func bannerView(_ bannerView: BannerView, previousView: UIView?, at index: Int) -> UIView
}

open class BannerView: UIView, UIScrollViewDelegate {
    public let scrollView = UIScrollView(frame: .zero)
    private var itemViews: [UIView] = []
    // 标记，当 itemViews 需要重新设置 frame 是设置为 true
    private var dirty = false
    // 自动滚动用的定时器
    private var timer: Timer?
    // 是否需要开始自动滚动
    private var requestAutoScroll = false
    // 当前是否是用户在滑动
    private var manualScroll = false
    // 是否是无限循环视图
    private var infinite = false
    // 有多少个 Item View
    private var count = 0
    // 当前滚动到的 index
    private var index = 0

    /// 自动滚动的时间间隔，默认为3秒。单位：秒。
    public var autoScrollTimeInterval: TimeInterval = 3.0
    public var autoScroll = true {
        didSet {
            autoScroll ? startScroll() : stopScroll()
        }
    }

    private weak var _delegate: BannerViewDelegate?
    private var _anonymousDelegate: BannerViewDelegate? {
        didSet {
            _delegate = nil
        }
    }

    private weak var _dataSource: BannerViewDataSource?
    private var _anonymousDataSource: BannerViewDataSource? {
        didSet {
            _dataSource = nil
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }

    private func initialization() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self

        addSubview(scrollView) { maker in
            maker.edges(horizontal: 0, vertical: 0)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        layoutItemViews()
    }

    open override func setNeedsLayout() {
        super.setNeedsLayout()
        dirty = true
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        //        print("willMoveToWindow \(self) has window = \(newWindow != nil)")
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            stopScroll()
        }
    }

    open override func didMoveToWindow() {
        //        print("didMoveToWindow \(self)")
        super.didMoveToWindow()
        if requestAutoScroll {
            startScroll()
        }
    }

    public final func setDataSource<Element, View>(_ data: [Element], view _: View.Type,
                                                   setup: @escaping (View, Element) -> Void) where View: UIView {
        _anonymousDataSource = BannerViewArrayDataSource(data: data, configuration: setup)
    }

    open func startScroll(force: Bool = false) {
        guard window != nil else {
            return
        }
        if !force && timer?.isValid == true {
            return
        }
        stopScroll()
        assert(timer == nil || !(timer!.isValid))
        let timer = Timer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(timerAction(_:)),
                          userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
        requestAutoScroll = false
    }

    open func stopScroll() {
        timer?.invalidate()
        timer = nil
    }

    open func reloadData() {
        stopScroll()
        reloadItemViews()
        startScroll()
    }

    public final func reloadData<Element, View>(_ data: [Element], view: View.Type,
                                                setup: @escaping (View, Element) -> Void) where View: UIView {
        setDataSource(data, view: view, setup: setup)
        reloadData()
    }

    private func reloadItemViews() {
        guard let dataSource = effectiveDataSource else {
            return
        }
        var count = dataSource.numberOfBanner(in: self)
        if count < 1 {
            removeAllItemViews()
            return
        }
        // dirty = true 当前的 BannerView 大小还没有确定，延迟布局
        dirty = !(frame.width > 0 && frame.height > 0)
        forEach(count) { source, index in // 源数据下标，itemViews下标
            print(source, index)
            let previous = itemViews.at(index)
            let next = dataSource.bannerView(self, previousView: previous, at: source)
            setupItemView(previous: previous, next: next, at: index, frame: dirty ? nil : frame)
        }
        var index = count + 1
        count = itemViews.count
        while index < count {
            itemViews.removeLast().removeFromSuperview()
            index += 1
        }
    }

    private func layoutItemViews() {
        guard dirty else {
            return
        }
        var index: CGFloat = -1.0
        for view in itemViews {
            view.frame = CGRect(x: index * frame.width, y: 0, width: frame.width, height: frame.height)
            index += 1.0
        }
        scrollView.contentSize = CGSize(width: frame.width * index, height: frame.height)
    }

    // 源数据下标，itemViews下标
    private func forEach(_ count: Int, _ method: (Int, Int) -> Void) {
        guard count > 0 else {
            return
        }
        var source = count - 1
        var index = 0
        method(source, index)
        source = 0
        index += 1
        while index < count + 1 {
            method(source, index)
            source += 1
            index += 1
        }
        method(0, index)
    }

    private func removeAllItemViews() {
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews.removeAll()
    }

    private func setupItemView(previous: UIView?, next: UIView, at index: Int, frame: CGRect?) {
        if let previous = previous {
            if previous == next {
                assert(next.superview == scrollView, "next.superview != self.scrollView")
                if next.superview != scrollView {
                    next.removeFromSuperview()
                    scrollView.addSubview(next)
                }
            } else {
                previous.removeFromSuperview()
                scrollView.addSubview(next)
            }
        } else {
            scrollView.addSubview(next)
        }
        assert(itemViews.count >= index, "Out of index.")
        itemViews.insert(next, at: index)
        if let size = frame?.size {
            next.frame = CGRect(x: CGFloat(index - 1) * size.width, y: 0, width: size.width, height: size.height)
        }
    }

    @objc
    private func timerAction(_ timer: Timer) {
        index += 1
        let x = scrollView.bounds.width * CGFloat(index)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    // MARK: - UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !manualScroll, infinite else {
            return
        }
        let width = scrollView.bounds.width
        guard width > 0 else {
            return
        }
        let x = scrollView.contentOffset.x
        if x >= (width * CGFloat(count) + width) {
            scrollView.contentOffset = CGPoint(x: width, y: 0)
        } else if x <= 0 {
            scrollView.contentOffset = CGPoint(x: width * CGFloat(count), y: 0)
        }
        let next = Int(scrollView.contentOffset.x / width + 0.5)
        index = next
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        manualScroll = false
        startScroll(force: false)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopScroll()
        manualScroll = true
    }
}

extension BannerView {
    public var delegate: BannerViewDelegate? {
        get {
            _delegate
        }
        set {
            _anonymousDelegate = nil
            _delegate = newValue
        }
    }

    @inline(__always)
    fileprivate var effectiveDelegate: BannerViewDelegate? {
        _anonymousDelegate ?? _delegate
    }

    public var dataSource: BannerViewDataSource? {
        get {
            _dataSource
        }
        set {
            _anonymousDelegate = nil
            _dataSource = newValue
        }
    }

    @inline(__always)
    fileprivate var effectiveDataSource: BannerViewDataSource? {
        _anonymousDataSource ?? _dataSource
    }

    @inline(__always)
    fileprivate var couldScroll: Bool {
        itemViews.count > 1 && superview != nil && window != nil
    }
}
#endif // canImport(UIKit)
