#import <Cocoa/Cocoa.h>
#import "Safari.h"

#ifdef __OBJC2__
@interface BrowserWebView (Keywurl_BrowserWebView)
+ (void) _Keywurl_load;
@end
#else
@interface KeywurlBrowserWebView : BrowserWebView
@end
#endif
