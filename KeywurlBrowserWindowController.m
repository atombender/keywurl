#ifdef __OBJC2__
#include <objc/objc.h>
#include <objc/runtime.h>
#endif

#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

#ifdef __OBJC2__
@implementation BrowserWindowController (Keywurl_BrowserWindowController)
#else
@implementation KeywurlBrowserWindowController
#endif

#ifdef __OBJC2__
+ (void) _Keywurl_load {
	Class c = [self class];
	
	Method old = class_getInstanceMethod(c, @selector(goToToolbarLocation:));
	Method new = class_getInstanceMethod(c, @selector(_Keywurl_goToToolbarLocation:));
	method_exchangeImplementations(old, new);
}
#endif

// We override this method to intercept addresses at an early stage without 
// invoking Safari's fallback system. This is quicker as it avoids unnecessary 
// DNS lookups
#ifdef __OBJC2__
- (void) _Keywurl_goToToolbarLocation: (id) sender {
#else
- (void) goToToolbarLocation: (id) sender {
#endif
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    NSString* input = [[_locationFieldEditor textStorage] string];
    if (input) {
        BOOL useDefault = NO;
        if ([input rangeOfString: @" "].location != NSNotFound ||
          [input rangeOfString: @"."].location == NSNotFound) {
            // URL contains spaces and is not a single word that contains dots, 
            // so it's pretty much guaranteed to not be a URL
            useDefault = YES;
        }
        NSString* newUrl = [mapper mapKeywordInput: input withDefault: useDefault];
        if (![input isEqualToString: newUrl]) {
            [_locationFieldEditor->field setObjectValue: newUrl];
        }
    }
#ifdef __OBJC2__
    return [self _Keywurl_goToToolbarLocation: sender];
#else
    return [super goToToolbarLocation: sender];
#endif
}

- (id) keywurl_locationFieldEditor {
    return _locationFieldEditor;
}

@end
