#ifdef __OBJC2__
#include <objc/objc.h>
#include <objc/runtime.h>
#endif

#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWindowController

#ifdef __OBJC2__
+ (void) keywurl_load {
    Class c = [objc_getClass("BrowserWindowController") class];
    
    class_addMethod(c, @selector(keywurl_goToToolbarLocation:),
                    class_getMethodImplementation(self, @selector(goToToolbarLocation:)),
                    "v@:@");
    
    class_addMethod(c, @selector(keywurl_locationFieldEditor),
                    class_getMethodImplementation(self, @selector(keywurl_locationFieldEditor)),
                    "@@:");
	
	Method old = class_getInstanceMethod(c, @selector(goToToolbarLocation:));
	Method new = class_getInstanceMethod(c, @selector(keywurl_goToToolbarLocation:));
	method_exchangeImplementations(old, new);
}
#endif

// We override this method to intercept addresses at an early stage without 
// invoking Safari's fallback system. This is quicker as it avoids unnecessary 
// DNS lookups
- (void) goToToolbarLocation: (id) sender {
    LocationFieldEditor *loc = [self keywurl_locationFieldEditor];
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    NSString* input = [[loc textStorage] string];
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
            #ifdef __OBJC2__
            id field = nil;
            object_getInstanceVariable(loc, "field", (void **)&field);
            [field setObjectValue: newUrl];
            #else
            [loc->field setObjectValue: newUrl];
            #endif
        }
    }
    #ifdef __OBJC2__
    [self keywurl_goToToolbarLocation: sender];
    #else
    return [super goToToolbarLocation: sender];
    #endif
}

- (id) keywurl_locationFieldEditor {
    #ifdef __OBJC2__
    id ret = nil;
    object_getInstanceVariable(self, "_locationFieldEditor", (void **)&ret);
    return ret;
    #else
    return _locationFieldEditor;
    #endif
}

@end
