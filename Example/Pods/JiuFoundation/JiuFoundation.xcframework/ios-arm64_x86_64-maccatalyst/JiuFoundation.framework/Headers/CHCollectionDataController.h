//
//  CHCollectionDataController.h
//  
//
//  Created by Nan Yang on 2022/2/24.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CHCollectionMapModel;

NS_SWIFT_UNAVAILABLE("Please use CollectionDataController")
@interface CHCollectionDataController : NSObject

@property (nonatomic, assign, readonly) BOOL isEmpty;
@property (nonatomic, assign, readonly) NSUInteger count;
@property (nonatomic, assign, readonly) NSUInteger totalCount;

- (void)updateToMap:(CHCollectionMapModel *)model;

@end

NS_ASSUME_NONNULL_END

#endif // TARGET_OS_IOS
