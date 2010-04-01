#import <Cocoa/Cocoa.h>
#import "Safari.h"

#ifdef __OBJC2__
@interface KeywurlBrowserWebView : NSObject
+ (void) keywurl_load;
@end
#else
@interface KeywurlBrowserWebView : BrowserWebView
@end
#endif
