#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWindowController

- (void) goToToolbarLocation: (id) sender {
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    NSString* url = [[_locationFieldEditor textStorage] string];
    NSString* newUrl = [mapper mapKeywordInput: url];
    if (![url isEqualToString: newUrl]) {
        [_locationFieldEditor->field setObjectValue: newUrl];
    }
    return [super goToToolbarLocation: sender];
}

@end
