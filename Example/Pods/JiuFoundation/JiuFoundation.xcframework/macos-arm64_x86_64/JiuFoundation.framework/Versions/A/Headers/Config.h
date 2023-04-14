//
// Created by Nan Yang on 2021/2/26.
//

#ifndef JIU_FOUNDATION_CONFIG_H
#define JIU_FOUNDATION_CONFIG_H

// ------------- FILE ------------------

#if (__cplusplus)
    #define CH_EXTERN_C_BEGIN   extern "C" {
    #define CH_EXTERN_C_END     }
    #ifdef CH_CPP_USE_NAMECHACE
        #define CH_CPP_FILE_BEGIN   namespace CH_CPP_NAMECHACE { \
                                    _Pragma("clang assume_nonnull begin")
        #define CH_CPP_FILE_END     _Pragma("clang assume_nonnull end") \
                                    }
    #else
        #define CH_CPP_FILE_BEGIN  _Pragma("clang assume_nonnull begin")
        #define CH_CPP_FILE_END    _Pragma("clang assume_nonnull end")
    #endif // #ifdef CH_CPP_USE_NAMECHACE
#else
    #define CH_EXTERN_C_BEGIN
    #define CH_EXTERN_C_END
    #define CH_CPP_FILE_BEGIN   _Pragma("clang assume_nonnull begin")
    #define CH_CPP_FILE_END     _Pragma("clang assume_nonnull end")
#endif // (__cplusplus)

#define CH_C_FILE_BEGIN CH_EXTERN_C_BEGIN \
                        _Pragma("clang assume_nonnull begin")
#define CH_C_FILE_END   _Pragma("clang assume_nonnull end") \
                        CH_EXTERN_C_END

// ------------- FILE ------------------

#if defined(__clang__) || defined(__GNUC__)
    #define CH_LIKELY(x)    __builtin_expect(!!(x), 1)
    #define CH_UNLIKELY(x)  __builtin_expect(!!(x), 0)
#else
    #define CH_LIKELY(x)    (x)
    #define CH_UNLIKELY(x)  (x)
#endif // defined(__clang__) || defined(__GNUC__)

// ------------- NULLABLE ------------------
// http://clang.llvm.org/docs/AttributeReference.html#nullability-attributes
// A nullable pointer to non-null pointers to const characters.
// const char *join_strings(const char * _Nonnull * _Nullable strings, unsigned n);
#if defined(__clang__)
    // int fetch(int * CH_NONNULL ptr);
    #define CH_NONNULL _Nonnull
    #define CH_NULL_UNCHECIFIED _Null_unspecified
    // int fetch_or_zero(int * CH_NULLABLE ptr);
    #define CH_NULLABLE _Nullable
#else
    #define CH_NONNULL
    #define CH_NULL_UNCHECIFIED
    #define CH_NULLABLE
#endif // defined(__clang__)
// ------------- NULLABLE ------------------

// ------------- NSInteger ------------------
// .../usr/include/objc/NSObjCRuntime.h
#if !__has_include(<NSObjCRuntime.h>)

    #if __LP64__ || 0 || NS_BUILD_32_LIKE_64
        typedef long NSInteger;
        typedef unsigned long NSUInteger;
    #else
        typedef int NSInteger;
        typedef unsigned int NSUInteger;
    #endif

#endif // !__has_include(<NSObjCRuntime.h>)
// ------------- NSInteger ------------------

// ------------- NSEnum ------------------
#if defined(CF_ENUM)
    #define CH_ENUM CF_ENUM
    #define CH_OPTIONS CF_OPTIONS
#else
    // .../CoreFoundation.framework/Headers/CFAvailability.h
    // Enums and Options
    #if __has_attribute(enum_extensibility)
        #define __CH_ENUM_ATTRIBUTES __attribute__((enum_extensibility(open)))
        #define __CH_CLOSED_ENUM_ATTRIBUTES __attribute__((enum_extensibility(closed)))
        #define __CH_OPTIONS_ATTRIBUTES __attribute__((flag_enum,enum_extensibility(open)))
    #else
        #define __CH_ENUM_ATTRIBUTES
        #define __CH_CLOSED_ENUM_ATTRIBUTES
        #define __CH_OPTIONS_ATTRIBUTES
#endif

#define __CH_ENUM_GET_MACRO(_1, _2, NAME, ...) NAME
#if (__cplusplus && __cplusplus >= 201103L && (__has_extension(cxx_strong_enums) || \
    __has_feature(objc_fixed_enum))) || (!__cplusplus && __has_feature(objc_fixed_enum))
    #define __CH_NAMED_ENUM(_type, _name)     enum __CH_ENUM_ATTRIBUTES _name : _type _name; enum _name : _type
    #define __CH_ANON_ENUM(_type)             enum __CH_ENUM_ATTRIBUTES : _type
    #define CH_CLOSED_ENUM(_type, _name)      enum __CH_CLOSED_ENUM_ATTRIBUTES _name : _type _name; enum _name : _type
    #if (__cplusplus)
        #define CH_OPTIONS(_type, _name) _type _name; enum __CH_OPTIONS_ATTRIBUTES : _type
    #else
        #define CH_OPTIONS(_type, _name) enum __CH_OPTIONS_ATTRIBUTES _name : _type _name; enum _name : _type
    #endif
#else
    #define __CH_NAMED_ENUM(_type, _name) _type _name; enum
    #define __CH_ANON_ENUM(_type) enum
    #define CH_CLOSED_ENUM(_type, _name) _type _name; enum
    #define CH_OPTIONS(_type, _name) _type _name; enum
#endif

/* CH_ENUM supports the use of one or two arguments.
 * The first argument is always the integer type used for the values of the enum.
 * The second argument is an optional type name for the macro.
 * When specifying a type name, you must precede the macro with 'typedef' like so:
typedef CH_ENUM(CFIndex, CFComparisonResult) {
    ...
};
If you do not specify a type name, do not use 'typdef', like so:
CH_ENUM(CFIndex) {
    ...
};
*/

#define CH_ENUM(...) __CH_ENUM_GET_MACRO(__VA_ARGS__, __CH_NAMED_ENUM, __CH_ANON_ENUM, )(__VA_ARGS__)
#endif
// ------------- NSEnum ------------------

// ------------- NS_SWIFT_NAME ------------------
#if defined(CF_SWIFT_NAME)
    #define CH_SWIFT_NAME CF_SWIFT_NAME
#else
    // CoreFoundation.framework/Headers/CFBase.h
    #if __has_attribute(swift_name)
        #define CH_SWIFT_NAME(_name) __attribute__((swift_name(#_name)))
    #else
        #define CH_SWIFT_NAME(_name)
    #endif
#endif
// ------------- NS_SWIFT_NAME ------------------

// ------------- NS_NOESCAPE ------------------
#ifdef NS_NOESCAPE
    #define CH_NOESCAPE NS_NOESCAPE
#else
    #if __has_attribute(noescape)
        #define CH_NOESCAPE __attribute__((noescape))
    #else
        #define CH_NOESCAPE
    #endif
#endif
// ------------- NS_NOESCAPE ------------------

// ------------- CAST ------------------
#ifndef CH_OPAQUE_POINTER
    #define CH_OPAQUE_POINTER(x) typedef struct x##_t* x##_p
#endif // CH_OPAQUE_POINTER

#if (__cplusplus)

#define CH_SIMPLE_CONVERSION(CxxType, CRef)                     \
inline CxxType *unwrap(CRef value) {                            \
    return reinterpret_cast<CxxType*>(value);                   \
}                                                               \
                                                                \
inline CRef wrap(const CxxType* value) {                        \
    return reinterpret_cast<CRef>(const_cast<CxxType*>(value)); \
}                                                               \

#define CH_STATIC_CONVERSION(TARGET, SOURCE)                    \
inline TARGET unwrap(const SOURCE& value) {                     \
    return static_cast<TARGET>(value);                          \
}                                                               \
                                                                \
inline SOURCE wrap(const TARGET& value) {                       \
    return static_cast<SOURCE>(value);                          \
}                                                               \

#define CH_CLASS_CONVERSION(TARGET, SOURCE)                                                     \
inline const TARGET& unwrap(const SOURCE& value) {                                              \
    return *const_cast<const TARGET*>(reinterpret_cast<TARGET*>(const_cast<SOURCE*>(&value)));  \
}                                                                                               \
                                                                                                \
inline TARGET& unwrap(SOURCE& value) {                                                          \
    return *reinterpret_cast<TARGET*>(&value);                                                  \
}                                                                                               \
                                                                                                \
inline const SOURCE& wrap(const TARGET& value) {                                                \
    return *const_cast<const SOURCE*>(reinterpret_cast<SOURCE*>(const_cast<TARGET*>(&value)));  \
}                                                                                               \
                                                                                                \
inline SOURCE& wrap(TARGET& value) {                                                            \
    return *reinterpret_cast<SOURCE*>(&value);                                                  \
}                                                                                               \

#define CH_POINTER_CAST(type, source) (reinterpret_cast<type>(source))

#else // (__cplusplus)

#define CH_SIMPLE_CONVERSION(CxxType, CRef)                     \
inline CxxType *unwrap(CRef value) {                            \
    return (CxxType*)(value);                                   \
}                                                               \
                                                                \
inline CRef wrap(const CxxType* value) {                        \
    return (CRef)(const_cast<CxxType*>(value));                 \
}                                                               \

#define CH_STATIC_CONVERSION(TARGET, SOURCE)                    \
inline TARGET unwrap(const SOURCE& value) {                     \
    return (TARGET)(value);                                     \
}                                                               \
                                                                \
inline SOURCE wrap(const TARGET& value) {                       \
    return (SOURCE)(value);                                     \
}                                                               \

#define CH_POINTER_CAST(type, source) ((type)(source))

#endif // (__cplusplus)

// ------------- CAST ------------------

#endif // JIU_FOUNDATION_CONFIG_H
