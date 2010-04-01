#import <Cocoa/Cocoa.h>
#import "Safari.h"

@interface KeywurlBrowserWindowController
#ifdef __OBJC2__
    : NSObject
#else
    : BrowserWindowController
#endif

#ifdef __OBJC2__
+ (void) keywurl_load;
#endif

- (id) keywurl_locationFieldEditor;

@end
