#import <Cocoa/Cocoa.h>
#import "Safari.h"

#ifdef __OBJC2__
@interface BrowserWindowController (Keywurl_BrowserWindowController)
#else
@interface KeywurlBrowserWindowController : BrowserWindowController
#endif

#ifdef __OBJC2__
+ (void) _Keywurl_load;
#endif

- (id) keywurl_locationFieldEditor;

@end
