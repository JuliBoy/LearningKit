//
// Created by Nan Yang on 2020/11/17.
//

#ifndef JIU_FOUNDATION_VIEW_AUTO_H
#define JIU_FOUNDATION_VIEW_AUTO_H

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Auto)

/**
 * A convenient method to create a view.
 * @return A newly created view.
 */
+ (instancetype)create API_DEPRECATED("No longer supported",
    macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED));

@end

@interface UIButton (Auto)

/**
 * A convenient method to create a button.
 * @param type The button type. See `UIButtonType` for the possible values.
 * @return A newly created button.
 */
+ (instancetype)createWithType:(UIButtonType)type NS_SWIFT_NAME(create(type:))
API_DEPRECATED("No longer supported",
    macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED));

@end

@interface UITableView (Auto)

/**
 * A convenient method to create a table view.
 * @param style A constant that specifies the style of the table view.
 * For a list of valid styles, see `UITableViewStyle`.
 * @return A newly created table view.
 */
+ (instancetype)createWithStyle:(UITableViewStyle)style NS_SWIFT_NAME(create(style:))
API_DEPRECATED("No longer supported",
    macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED));

@end

@interface UICollectionView (Auto)

+ (instancetype)create NS_UNAVAILABLE;

/**
 * A convenient method to create a collection view.
 * @param layout The layout object to use for organizing items.
 * The collection view stores a strong reference to the specified object.
 * @return A newly created collection view.
 */
+ (instancetype)createWithCollectionViewLayout:(UICollectionViewLayout*)layout
    NS_SWIFT_NAME(create(collectionViewLayout:))
    API_DEPRECATED("No longer supported", macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED));

@end

NS_ASSUME_NONNULL_END

#endif // TARGET_OS_IOS

#endif // JIU_FOUNDATION_VIEW_AUTO_H
