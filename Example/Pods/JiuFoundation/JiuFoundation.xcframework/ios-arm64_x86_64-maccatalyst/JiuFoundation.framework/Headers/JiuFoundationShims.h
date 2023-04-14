//
//  JiuFoundationShims.h
//
//
//  Created by Nan Yang on 2021/6/22.
//

#import <Foundation/Foundation.h>

// find Sources/JiuAPIShims/include -name "*.h" ! -name "JiuFoundationShims.h" |\
//  sort -f | xargs basename | xargs printf "#import \"%s\"\n"

#if COCOAPODS
#import <JiuFoundation/CHCollectionCellModel.h>
#import <JiuFoundation/CHCollectionDataController.h>
#import <JiuFoundation/CHCollectionMapModel.h>
#import <JiuFoundation/CHCollectionSectionModel.h>
#import <JiuFoundation/CHCollectionViewModel.h>
#import <JiuFoundation/UIColor+JiuFoundationShims.h>
#import <JiuFoundation/UIView+CAutoMake.h>
#else
#import "CHCollectionCellModel.h"
#import "CHCollectionDataController.h"
#import "CHCollectionMapModel.h"
#import "CHCollectionSectionModel.h"
#import "CHCollectionViewModel.h"
#import "UIColor+JiuFoundationShims.h"
#import "UIView+CAutoMake.h"
#endif // COCOAPODS

#if TARGET_OS_IOS

#if COCOAPODS
@class AttributedBuilder;
#else
@import JiuFoundation;
#endif

NS_ASSUME_NONNULL_BEGIN

typedef AttributedBuilder AttributedString
    API_DEPRECATED_WITH_REPLACEMENT("AttributedBuilder",
        macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED));

NS_ASSUME_NONNULL_END

#endif // TARGET_OS_IOS
