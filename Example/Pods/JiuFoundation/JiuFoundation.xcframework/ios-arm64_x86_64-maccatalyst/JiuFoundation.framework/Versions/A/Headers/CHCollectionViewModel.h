//
//  CHCollectionViewModel.h
//  
//
//  Created by Nan Yang on 2022/2/24.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_UNAVAILABLE("Please use CollectionViewModel")
@interface CHCollectionViewModel : NSObject
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign, readonly) NSString* identifier;
@end

NS_SWIFT_UNAVAILABLE("Please use CollectionReusableView")
@protocol CHCollectionReusableView <NSObject>

@required

- (void)reloadData:(__kindof CHCollectionViewModel *)data;

@end

NS_ASSUME_NONNULL_END

#endif // TARGET_OS_IOS
