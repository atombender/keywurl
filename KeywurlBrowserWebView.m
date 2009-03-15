#include "KeywurlBrowserWebView.h"
#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWebView

#if KEYWURL_SAFARI_VERSION >= 4

- (NSArray*) fallbackURLs {
    // If Safari has failed to resolve the address into a proper host name, the
    // list of fallback URLs is empty and we can intercept the URL and map it
    NSArray* urls = [super fallbackURLs];
    if (urls == nil || [urls count] == 0) {
    	KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
        KeywordMapper* mapper = [plugin keywordMapper];
        LocationFieldEditor* fieldEditor = (LocationFieldEditor*) [
          (KeywurlBrowserWindowController*) [self windowController] keywurl_locationFieldEditor];
    	NSString* address = [[fieldEditor textStorage] string];
        NSString* mapped = [mapper mapKeywordInput: address];
    	if (mapped && ![mapped isEqualToString: address]) {
            NSURL* mappedUrl = [NSURL URLWithString: mapped];
            urls = [NSArray arrayWithObject: mappedUrl];
        }
    }
    return urls;
}

#else

- (NSArray*) fallbackURLs {
	KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    LocationFieldEditor* fieldEditor = (LocationFieldEditor*) [
      (KeywurlBrowserWindowController*) [self windowController] keywurl_locationFieldEditor];
	NSString* address = [[fieldEditor textStorage] string];
    NSString* mapped = [mapper mapKeywordInput: address];
	if (mapped && ![mapped isEqualToString: address]) {
        NSURL* mappedUrl = [NSURL URLWithString: mapped];
        return [NSArray arrayWithObject: mappedUrl];
    } else {
        return [super fallbackURLs];
    }
}

#endif

- (id) webView: (id) sender 
    contextMenuItemsForElement: (id) elementDictionary
    defaultMenuItems: (NSMutableArray*) defaultMenuItems {
    NSString* documentUrl = [self mainFrameURL];
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    id node = [elementDictionary objectForKey: @"WebElementDOMNode"];
    if (node) {
        [defaultMenuItems addObject: [NSMenuItem separatorItem]];
        NSMenuItem* item = [[NSMenuItem alloc] initWithTitle: @"Create Keyword Search"
            action: @selector(createKeywordSearchFromForm:)
            keyEquivalent: @""];
        [item setRepresentedObject: [NSArray arrayWithObjects: documentUrl, node, nil]];
        [item setTarget: plugin];
        [defaultMenuItems addObject: item];
    }
    return [super webView: sender
         contextMenuItemsForElement: elementDictionary
         defaultMenuItems: defaultMenuItems];
}

@end
