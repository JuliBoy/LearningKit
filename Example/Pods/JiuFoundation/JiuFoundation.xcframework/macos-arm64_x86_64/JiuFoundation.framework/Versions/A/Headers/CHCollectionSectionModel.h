//
//  CHCollectionSectionModel.h
//  
//
//  Created by Nan Yang on 2022/2/24.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CHCollectionCellModel;
@class CHCollectionViewModel;

NS_SWIFT_UNAVAILABLE("Please use CollectionSectionModel")
@interface CHCollectionSectionModel : NSObject

@property (nonatomic, copy, readonly) NSArray<CHCollectionCellModel*>* items;
@property (nonatomic, strong, readonly, nullable) CHCollectionViewModel* header;
@property (nonatomic, strong, readonly, nullable) CHCollectionViewModel* footer;

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign, readonly) BOOL isEmpty;
@property (nonatomic, assign, readonly) NSUInteger count;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithItems:(NSArray<CHCollectionCellModel*>*)items NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithItems:(NSArray<CHCollectionCellModel*>*)items
                       header:(CHCollectionViewModel*)header
                       footer:(CHCollectionViewModel*)footer NS_DESIGNATED_INITIALIZER;

- (__kindof CHCollectionCellModel* _Nullable)itemAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END

#endif // TARGET_OS_IOS
