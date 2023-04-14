//
//  CHCollectionMapModel.h
//  
//
//  Created by Nan Yang on 2022/2/24.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CHCollectionSectionModel;
@class CHCollectionCellModel;
@class CHCollectionViewModel;

NS_SWIFT_UNAVAILABLE("Please use CollectionMapModel")
@interface CHCollectionMapModel : NSObject

@property (nonatomic, copy, readonly) NSArray<CHCollectionSectionModel*>* sections;
@property (nonatomic, assign, readonly) BOOL isEmpty;
@property (nonatomic, assign, readonly) NSUInteger count;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSections:(NSArray<CHCollectionSectionModel*>*)sections NS_DESIGNATED_INITIALIZER;

- (__kindof CHCollectionSectionModel* _Nullable)sectionAtIndex:(NSUInteger)index;
- (__kindof CHCollectionCellModel* _Nullable)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)itemCountInSection:(NSUInteger)section;

- (__kindof CHCollectionViewModel* _Nullable)headerInSection:(NSUInteger)section;
- (__kindof CHCollectionViewModel* _Nullable)footerInSection:(NSUInteger)section;

- (__kindof CHCollectionViewModel* _Nullable)headerAtIndexPath:(NSIndexPath *)indexPath;
- (__kindof CHCollectionViewModel* _Nullable)footerAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

#endif // TARGET_OS_IOS
