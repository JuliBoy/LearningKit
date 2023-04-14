//
// Created by Nan Yang on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

API_DEPRECATED("No longer supported",
    macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED))
@interface CHResultBox<ValueType> : NSObject

@property (nonatomic, strong, nullable, readonly) ValueType value;
@property (nonatomic, strong, nullable, readonly) NSError* error;

@property (nonatomic, assign, readonly) BOOL hasValue;
@property (nonatomic, assign, readonly) BOOL hasError;

- (instancetype)init;
- (instancetype)initWithValue:(nullable ValueType)value NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithError:(NSError*)error NS_DESIGNATED_INITIALIZER;

- (nullable ValueType)getValueWithError:(out NSError**)error;

- (instancetype)succeededBox:(nullable ValueType)value;
- (instancetype)failedBox:(NSError*)value;

@end

NS_ASSUME_NONNULL_END
