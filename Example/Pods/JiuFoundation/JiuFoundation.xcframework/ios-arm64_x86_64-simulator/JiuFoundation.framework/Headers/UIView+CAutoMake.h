//
// Created by Nan Yang on 2021/8/24.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS

#import <UIKit/UIKit.h>

@class AutoMaker;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CAutoMake)

- (NSMutableArray<NSLayoutConstraint *> *)autoMutableMake:(void (^ NS_NOESCAPE)(AutoMaker *maker))make
    NS_SWIFT_UNAVAILABLE("Just unavailable");

- (void)autoUpdateInto:(NSMutableArray<NSLayoutConstraint*> *)constraints
                  make:(void(^ NS_NOESCAPE)(AutoMaker* maker))make NS_SWIFT_UNAVAILABLE("Just unavailable");

- (void)autoUpdate:(NSArray<NSLayoutConstraint*> *__strong _Nullable *_Nullable)constraints
              make:(void(^ NS_NOESCAPE)(AutoMaker* maker))make NS_SWIFT_UNAVAILABLE("Just unavailable");

NS_ASSUME_NONNULL_END

@end

#endif // TARGET_OS_IOS
