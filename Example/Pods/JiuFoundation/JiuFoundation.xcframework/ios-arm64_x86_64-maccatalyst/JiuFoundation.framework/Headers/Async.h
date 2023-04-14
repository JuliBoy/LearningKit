//
// Created by Nan Yang on 2021/5/23.
//

#ifndef JIU_FOUNDATION_ASYNC_H
#define JIU_FOUNDATION_ASYNC_H

#import <Foundation/Foundation.h>

#define _JIU_ASYNC_UNAVAILABLE NS_SWIFT_UNAVAILABLE("Please use DispatchQueue")

typedef NS_ENUM(NSUInteger, CHGlobalQueueType) {
    CHGlobalQueueTypeUserInteractive = QOS_CLASS_USER_INTERACTIVE,
    CHGlobalQueueTypeUserInitiated = QOS_CLASS_USER_INITIATED,
    CHGlobalQueueTypeUserDefault = QOS_CLASS_DEFAULT,
    CHGlobalQueueTypeUserUtility = QOS_CLASS_UTILITY,
    CHGlobalQueueTypeUserBackground = QOS_CLASS_BACKGROUND,
    CHGlobalQueueTypeUserUnspecified = QOS_CLASS_UNSPECIFIED,
} _JIU_ASYNC_UNAVAILABLE;

typedef CHGlobalQueueType NSGlobalQueueType
    API_DEPRECATED_WITH_REPLACEMENT("CHGlobalQueueType",
        macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED));

/// 将一个 `Block` 提交到主线程执行。
/// @param work 要执行的工作，不可以为 `NULL`。
///
/// 如果当前已经是主线程，则立刻执行。
static inline void CHRunOnMain(dispatch_block_t _Nonnull work) _JIU_ASYNC_UNAVAILABLE {
    assert(work != nil);
    if ([NSThread isMainThread]) {
        work();
    } else {
        dispatch_async(dispatch_get_main_queue(), work);
    }
}

/// 将一个异步执行的 `Block` 提交到主线程异步执行。
/// @param work 要执行的工作，不可以为 `NULL`。
static inline void CHRunOnMainAsync(dispatch_block_t _Nonnull work) _JIU_ASYNC_UNAVAILABLE {
    assert(work != nil);
    dispatch_async(dispatch_get_main_queue(), work);
}

/**
 * 根据类型参数将一个异步执行的 `Block` 提交到对应的线程异步执行。
 * @param type 线程的 `qos` 类型。
 * @param work 要执行的工作，不可以为 `NULL`。
 */
static inline void CHRunOnGlobalAsync(CHGlobalQueueType type,
    dispatch_block_t _Nonnull work) _JIU_ASYNC_UNAVAILABLE {
    assert(work != nil);
    dispatch_async(dispatch_get_global_queue(type, 0), work);
}

/// 将一个 `Block` 提交到主线程执行。
/// @param work 要执行的工作，不可以为 `NULL`。
///
/// 如果当前已经是主线程，则立刻执行。
static inline void NSRunOnMain(dispatch_block_t _Nonnull work) _JIU_ASYNC_UNAVAILABLE
API_DEPRECATED_WITH_REPLACEMENT("CHRunOnMain",
    macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED)) {
    CHRunOnMain(work);
}

/// 将一个异步执行的 `Block` 提交到主线程异步执行。
/// @param work 要执行的工作，不可以为 `NULL`。
static inline void NSRunOnMainAsync(dispatch_block_t _Nonnull work) _JIU_ASYNC_UNAVAILABLE
API_DEPRECATED_WITH_REPLACEMENT("CHRunOnMainAsync",
    macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED)) {
    CHRunOnMainAsync(work);
}

/**
 * 根据类型参数将一个异步执行的 `Block` 提交到对应的线程异步执行。
 * @param type 线程的 `qos` 类型。
 * @param work 要执行的工作，不可以为 `NULL`。
 */
static inline void NSRunOnGlobalAsync(CHGlobalQueueType type,
    dispatch_block_t _Nonnull work) _JIU_ASYNC_UNAVAILABLE
API_DEPRECATED_WITH_REPLACEMENT("CHRunOnGlobalAsync",
    macos(10.0, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED)) {
    CHRunOnGlobalAsync(type, work);
}

#undef _JIU_ASYNC_UNAVAILABLE

#endif // JIU_FOUNDATION_ASYNC_H
