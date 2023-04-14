//
// Created by Nan Yang on 2021/5/23.
//

#import <Foundation/Foundation.h>

NSString *_Nonnull CHStringOrEmpty(NSString* _Nullable value)
    NS_SWIFT_UNAVAILABLE("Just unavailable");

NS_SWIFT_UNAVAILABLE("Just unavailable")
@interface NSString (JiuFoundation)

@property (nonatomic, assign, readonly) BOOL isEmpty;
@property (nonatomic, assign, readonly) BOOL isNotEmpty;

@end
