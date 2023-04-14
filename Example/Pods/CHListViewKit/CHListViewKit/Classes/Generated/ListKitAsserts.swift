// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#endif

public final class ListKitAsserts : NSObject {
#if os(macOS)
    public typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
    public typealias Image = UIImage
#endif

    @objc public static var icon_arrow_down_x16: Image? { image(named: "icon_arrow_down_x16") }
    @objc public static var icon_arrow_up_x16: Image? { image(named: "icon_arrow_up_x16") }
    @objc public static var icon_clear_x16: Image? { image(named: "icon_clear_x16") }
    @objc public static var icon_no_data: Image? { image(named: "icon_no_data") }
    @objc public static var icon_search_x16: Image? { image(named: "icon_search_x16") }

    @objc
    public static func image(named name: String) -> Image? {
        let bundle = CHListViewKitAssets.bundle
#if os(iOS) || os(tvOS)
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
#elseif os(macOS)
        let image = bundle == Bundle.main ? NSImage(named: name) : bundle.image(forResource: name)
#elseif os(watchOS)
        let image: UIImage
        if #available(watchOS 6.0, *) {
            image = UIImage(named: name, in: bundle, with: nil)
        } else {
            image = UIImage(named: name)
        }
#endif
#if DEBUG
        assert(image != nil, "Unable to load image asset named \(name).")
#endif
        return image
    }
}
