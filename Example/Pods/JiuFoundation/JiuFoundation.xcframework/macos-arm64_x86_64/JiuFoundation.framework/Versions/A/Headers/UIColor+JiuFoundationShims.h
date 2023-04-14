//
// Created by Nan Yang on 2021/6/30.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JiuFoundationShims)

/**
 * 使用数字生成 UIColor。颜色排序为 A，R，G，B。
 * 当 value 的值为 0x00_0000 到 0xFF_FFFFF 时，Alpha 解析为 1。
 *
 * @param value 色值，范围为 0x0000_0000 到 0xFFFF_FFFFF。
 * @return 初始化好的 UIColor 对象。
 */
+ (instancetype)argb:(uint32_t)value NS_SWIFT_UNAVAILABLE("Just unavailable");

/**
 * 使用数字生成 UIColor。颜色排序为 R，G，B，A。
 *
 * @param value 色值，范围为 0x00_0000 到 0xFF_FFFFF。
 * @param alpha 透明度，取值范围为 0 - 1。
 * @return 初始化好的 UIColor 对象。
 */
+ (instancetype)rgb:(uint32_t)value alpha:(CGFloat)alpha NS_SWIFT_UNAVAILABLE("Just unavailable");

/**
 * 使用 String 生成 UIColor。
 * 可以接受的格式有：
 * FFFFFF
 * FFFFFFFF
 * #FFFFFF
 * #FFFFFFFF
 * 0xFFFFFF
 * 0xFFFFFFFF
 * 0XFFFFFF
 * 0XFFFFFFFF
 *
 * @param value 符合上述格式的字符串。
 * @return 初始化好的 UIColor 对象。
 */
+ (instancetype)from:(NSString *)value NS_SWIFT_UNAVAILABLE("Just unavailable");

@end

NS_ASSUME_NONNULL_END

#endif // TARGET_OS_IOS
