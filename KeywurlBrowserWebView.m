#include "KeywurlBrowserWebView.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWebView

- (NSArray*) fallbackURLs {
	KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    LocationFieldEditor* fieldEditor = (LocationFieldEditor*) [[[self windowController] window] firstResponder];
	NSString* address = [[fieldEditor textStorage] string];
    NSString* mapped = [mapper mapKeywordInput: address];
    NSArray* fallbackUrls = nil;
	if (mapped && ![mapped isEqualToString: address]) {
        NSURL* mappedUrl = [NSURL URLWithString: mapped];
        NSLog(@"Fallback URL %@", mappedUrl);
        fallbackUrls = [NSArray arrayWithObject: mappedUrl];
    }
	return fallbackUrls;
}

@end
