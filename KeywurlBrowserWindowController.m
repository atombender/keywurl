#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWindowController

- (void) goToToolbarLocation: (id) sender {
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    
    NSString* input = [[_locationFieldEditor textStorage] string];
    BOOL shouldMatch = true;
    #if KEYWURL_SAFARI_VERSION <= 3
      shouldMatch = (input && [input rangeOfString: @" "].location != NSNotFound);
    #endif
    if (shouldMatch) {
        NSString* newUrl = [mapper mapKeywordInput: input];
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
