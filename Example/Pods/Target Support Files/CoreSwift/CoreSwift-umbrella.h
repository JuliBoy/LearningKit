#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Compiler.h"
#import "Features.h"
#import "FeaturesCxx.h"
#import "Language.h"
#import "LanguageCxx.h"
#import "LanguageObjC.h"
#import "LanguageSwift.h"
#import "Typing.h"

FOUNDATION_EXPORT double CoreSwiftVersionNumber;
FOUNDATION_EXPORT const unsigned char CoreSwiftVersionString[];

