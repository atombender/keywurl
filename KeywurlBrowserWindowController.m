#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWindowController

- (void) goToToolbarLocation: (id) sender {
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    
    // Only catch addresses containing spaces. We let the fallback URL mechanism catch the rest.
    NSString* input = [[_locationFieldEditor textStorage] string];
    if (input && [input rangeOfString: @" "].location != NSNotFound) {
        NSString* newUrl = [mapper mapKeywordInput: input];
        if (![input isEqualToString: newUrl]) {
            [_locationFieldEditor->field setObjectValue: newUrl];
        }
    }

    return [super goToToolbarLocation: sender];
}

@end
