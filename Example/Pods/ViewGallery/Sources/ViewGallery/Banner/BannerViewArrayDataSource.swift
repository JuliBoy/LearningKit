//
//  BannerViewArrayDataSource.swift
//
//
//  Created by Nan Yang on 2021/9/22.
//

#if canImport(UIKit)
import UIKit
import JiuFoundation

public final class BannerViewArrayDataSource<Element, View>: BannerViewDataSource where View: UIView {
    private var data: [Element]
    private let handler: Handler

    public init(data: [Element] = [], configuration: @escaping (View, Element) -> Void) {
        self.data = data
        handler = SetupHandler(configuration)
    }

    public func numberOfBanner(in bannerView: BannerView) -> Int {
        data.count
    }

    public func bannerView(_ bannerView: BannerView, previousView: UIView?, at index: Int) -> UIView {
        guard let item = data.at(index) else {
            return UIView(frame: .zero)
        }
        let previous = previousView as? View
        return handler.createView(previousView: previous, element: item, at: index)
    }

    private class Handler {
        func createView(previousView: View?, element: Element, at index: Int) -> UIView {
            assert(false, "Subclass hook")
            return UIView(frame: .zero)
        }
    }

    private final class SetupHandler: Handler {
        private let setup: (View, Element) -> Void

        init(_ setup: @escaping (View, Element) -> Void) {
            self.setup = setup
        }

        override func createView(previousView: View?, element: Element, at index: Int) -> UIView {
            let next = previousView ?? View(frame: .zero)
            setup(next, element)
            return next
        }
    }
}
#endif // canImport(UIKit)
