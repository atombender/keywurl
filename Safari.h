#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

#if KEYWURL_SAFARI_VERSION == 2
    #import "Safari2_0.h"
#elif KEYWURL_SAFARI_VERSION == 3
    #import "Safari3_0.h"
#elif KEYWURL_SAFARI_VERSION == 4
    #import "Safari4_0.h"
#else
    #error "You need to define KEYWURL_SAFARI_VERSION correctly"
#endif
