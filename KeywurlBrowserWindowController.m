#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWindowController

// We override this method to intercept addresses at an early stage without 
// invoking Safari's fallback system. This is quicker as it avoids unnecessary 
// DNS lookups
- (void) goToToolbarLocation: (id) sender {
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    NSString* input = [[_locationFieldEditor textStorage] string];
    if (input) {
        BOOL useDefault = NO;
        if (input && [input rangeOfString: @" "].location != NSNotFound) {
            // URL contains spaces, so it's pretty much guaranteed to not be a URL
            useDefault = YES;
        }
        NSString* newUrl = [mapper mapKeywordInput: input withDefault: useDefault];
        if (![input isEqualToString: newUrl]) {
            [_locationFieldEditor->field setObjectValue: newUrl];
        }
    }
    return [super goToToolbarLocation: sender];
}

- (id) keywurl_locationFieldEditor {
    return _locationFieldEditor;
}

@end
