//
// Created by Nan Yang on 2021/2/26.
//

#ifndef JIU_FOUNDATION_ATOMIC_H
#define JIU_FOUNDATION_ATOMIC_H

#include <stdlib.h>
#include <stdbool.h>
#include <stdatomic.h>

#if __has_include(<JiuFoundation/Config.h>)
#include <JiuFoundation/Config.h>
#else
#include <Config.h>
#endif

CH_C_FILE_BEGIN

/**
 * @see https://en.cppreference.com/w/c/atomic/memory_order
 */
typedef CH_ENUM(int, CHMemoryOrder) {
    CHMemoryOrderRelaxed = memory_order_relaxed,
    CHMemoryOrderConsume = memory_order_consume,
    CHMemoryOrderAcquire = memory_order_acquire,
    CHMemoryOrderRelease = memory_order_release,
    CHMemoryOrderAcquireAndRelease = memory_order_acq_rel,
    CHMemoryOrderSequentiallyConsistent = memory_order_seq_cst,
} CH_SWIFT_NAME(MemoryOrder);

#define CH_ATOMIC_TYPE_CREATE(swift_type, swift_name, raw_type, atomic_type)                                    \
typedef struct ch_atomic_##swift_name* CHA##swift_type##Ref;                                                    \
static inline CHA##swift_type##Ref cha_##swift_name##_create(raw_type value) {                                  \
    atomic_##atomic_type* result = (atomic_##atomic_type*)malloc(sizeof(atomic_##atomic_type));                 \
    atomic_init(result, value);                                                                                 \
    return CH_POINTER_CAST(CHA##swift_type##Ref, result);                                                       \
}                                                                                                               \
static inline void cha_##swift_name##_init(CHA##swift_type##Ref swift_type, raw_type value) {                   \
    atomic_##atomic_type* result = CH_POINTER_CAST(atomic_##atomic_type*, swift_type);                          \
    atomic_init(result, value);                                                                                 \
}                                                                                                               \
static inline void cha_##swift_name##_free(CHA##swift_type##Ref swift_type) {                                   \
    free(CH_POINTER_CAST(atomic_##atomic_type*, swift_type));                                                   \
}                                                                                                               \
static inline size_t cha_##swift_name##_required_size() {                                                       \
    return sizeof(atomic_##atomic_type);                                                                        \
}                                                                                                               \

#define CH_ATOMIC_TYPE_STORE(swift_type, swift_name, raw_type, atomic_type)                                     \
static inline void cha_##swift_name##_store(CHA##swift_type##Ref swift_type, raw_type value) {                  \
    return atomic_store(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), value);                             \
}                                                                                                               \
static inline void cha_##swift_name##_store_explicit(CHA##swift_type##Ref swift_type, raw_type value,           \
                                                     CHMemoryOrder order) {                                     \
    return atomic_store_explicit(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), value, order);             \
}                                                                                                               \

#define CH_ATOMIC_TYPE_LOAD(swift_type, swift_name, raw_type, atomic_type)                                      \
static inline raw_type cha_##swift_name##_load(CHA##swift_type##Ref swift_type) {                               \
    return atomic_load(CH_POINTER_CAST(atomic_##atomic_type*, swift_type));                                     \
}                                                                                                               \
static inline raw_type cha_##swift_name##_load_explicit(CHA##swift_type##Ref swift_type,                        \
                                                     CHMemoryOrder order) {                                     \
    return atomic_load_explicit(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), order);                     \
}                                                                                                               \

#define CH_ATOMIC_TYPE_EXCHANGE(swift_type, swift_name, raw_type, atomic_type)                                  \
static inline raw_type cha_##swift_name##_exchange(CHA##swift_type##Ref swift_type, raw_type value) {           \
    return atomic_exchange(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), value);                          \
}                                                                                                               \
static inline raw_type cha_##swift_name##_exchange_explicit(CHA##swift_type##Ref swift_type, raw_type value,    \
                                                     CHMemoryOrder order) {                                     \
    return atomic_exchange_explicit(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), value, order);          \
}                                                                                                               \

#define CH_ATOMIC_TYPE_COMPARE_STRONG(swift_type, swift_name, raw_type, atomic_type)                            \
static inline bool cha_##swift_name##_compare_strong(CHA##swift_type##Ref swift_type, raw_type expected,        \
                                               raw_type desired) {                                              \
    raw_type value = expected;                                                                                  \
    return atomic_compare_exchange_strong(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), &value, desired); \
}                                                                                                               \
static inline bool cha_##swift_name##_compare_strong_explicit(CHA##swift_type##Ref swift_type,                  \
                   raw_type expected, raw_type desired, CHMemoryOrder success, CHMemoryOrder fail) {            \
    raw_type value = expected;                                                                                  \
    return atomic_compare_exchange_strong_explicit(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), &value,  \
                                                  desired, success, fail);                                      \
}                                                                                                               \

#define CH_ATOMIC_TYPE_COMPARE_WEAK(swift_type, swift_name, raw_type, atomic_type)                              \
static inline bool cha_##swift_name##_compare_weak(CHA##swift_type##Ref swift_type, raw_type expected,          \
                                               raw_type desired) {                                              \
    raw_type value = expected;                                                                                  \
    return atomic_compare_exchange_weak(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), &value, desired);   \
}                                                                                                               \
static inline bool cha_##swift_name##_compare_weak_explicit(CHA##swift_type##Ref swift_type,                    \
                   raw_type expected, raw_type desired, CHMemoryOrder success, CHMemoryOrder fail) {            \
    raw_type value = expected;                                                                                  \
    return atomic_compare_exchange_weak_explicit(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), &value,    \
                                                  desired, success, fail);                                      \
}                                                                                                               \

#define CH_ATOMIC_TYPE_FETCH(swift_type, swift_name, raw_type, atomic_type, action)                             \
static inline raw_type cha_##swift_name##_##action(CHA##swift_type##Ref swift_type, raw_type value) {           \
    return atomic_fetch_##action(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), value);                    \
}                                                                                                               \
static inline raw_type cha_##swift_name##_##action##_explicit(CHA##swift_type##Ref swift_type, raw_type value,  \
                                                     CHMemoryOrder order) {                                     \
    return atomic_fetch_##action##_explicit(CH_POINTER_CAST(atomic_##atomic_type*, swift_type), value, order);  \
}                                                                                                               \

#define CH_ATOMIC_TYPE_OPERATION(swift_type, swift_name, raw_type, atomic_type)                                 \
CH_ATOMIC_TYPE_STORE(swift_type, swift_name, raw_type, atomic_type)                                             \
CH_ATOMIC_TYPE_LOAD(swift_type, swift_name, raw_type, atomic_type)                                              \
CH_ATOMIC_TYPE_EXCHANGE(swift_type, swift_name, raw_type, atomic_type)                                          \
CH_ATOMIC_TYPE_COMPARE_STRONG(swift_type, swift_name, raw_type, atomic_type)                                    \
CH_ATOMIC_TYPE_COMPARE_WEAK(swift_type, swift_name, raw_type, atomic_type)                                      \
CH_ATOMIC_TYPE_FETCH(swift_type, swift_name, raw_type, atomic_type, add)                                        \
CH_ATOMIC_TYPE_FETCH(swift_type, swift_name, raw_type, atomic_type, sub)                                        \
CH_ATOMIC_TYPE_FETCH(swift_type, swift_name, raw_type, atomic_type, or)                                         \
CH_ATOMIC_TYPE_FETCH(swift_type, swift_name, raw_type, atomic_type, xor)                                        \
CH_ATOMIC_TYPE_FETCH(swift_type, swift_name, raw_type, atomic_type, and)                                        \

#define CH_MAKE_ATOMIC_TYPE(swift_type, swift_name, raw_type, atomic_type)                                      \
CH_ATOMIC_TYPE_CREATE(swift_type, swift_name, raw_type, atomic_type)                                            \
CH_ATOMIC_TYPE_OPERATION(swift_type, swift_name, raw_type, atomic_type)                                         \


// C11 => #define bool _Bool,
// after expanded from macro `atomic_bool` => `atomic__Bool`
CH_ATOMIC_TYPE_CREATE(Bool, bool, bool, bool)
CH_ATOMIC_TYPE_STORE(Bool, bool, bool, bool)
CH_ATOMIC_TYPE_LOAD(Bool, bool, bool, bool)
CH_ATOMIC_TYPE_EXCHANGE(Bool, bool, bool, bool)
CH_ATOMIC_TYPE_COMPARE_STRONG(Bool, bool, bool, bool)
CH_ATOMIC_TYPE_COMPARE_WEAK(Bool, bool, bool, bool)
CH_ATOMIC_TYPE_FETCH(Bool, bool, bool, bool, add)
CH_ATOMIC_TYPE_FETCH(Bool, bool, bool, bool, sub)
CH_ATOMIC_TYPE_FETCH(Bool, bool, bool, bool, or)
CH_ATOMIC_TYPE_FETCH(Bool, bool, bool, bool, xor)
CH_ATOMIC_TYPE_FETCH(Bool, bool, bool, bool, and)

CH_MAKE_ATOMIC_TYPE(Int8, int8, signed char, schar)
CH_MAKE_ATOMIC_TYPE(UInt8, uint8, unsigned char, uchar)
CH_MAKE_ATOMIC_TYPE(Int16, Int16, short, short)
CH_MAKE_ATOMIC_TYPE(UInt16, UInt16, unsigned short, ushort)
CH_MAKE_ATOMIC_TYPE(Int32, int32, int, int)
CH_MAKE_ATOMIC_TYPE(UInt32, uint32, unsigned int, uint)
// Curiously: No need __LP64__
CH_MAKE_ATOMIC_TYPE(Int, int, long, long)
CH_MAKE_ATOMIC_TYPE(UInt, uint, unsigned long, ulong)
CH_MAKE_ATOMIC_TYPE(Int64, int64, long long, llong)
CH_MAKE_ATOMIC_TYPE(UInt64, uint64, unsigned long long, ullong)

#undef CH_ATOMIC_TYPE_CREATE
#undef CH_ATOMIC_TYPE_STORE
#undef CH_ATOMIC_TYPE_LOAD
#undef CH_ATOMIC_TYPE_EXCHANGE
#undef CH_ATOMIC_TYPE_COMPARE_STRONG
#undef CH_ATOMIC_TYPE_COMPARE_WEAK
#undef CH_ATOMIC_TYPE_FETCH
#undef CH_ATOMIC_TYPE_FETCH
#undef CH_ATOMIC_TYPE_FETCH
#undef CH_ATOMIC_TYPE_FETCH
#undef CH_ATOMIC_TYPE_FETCH
#undef CH_MAKE_ATOMIC_TYPE

CH_C_FILE_END

#endif // JIU_FOUNDATION_ATOMIC_H
