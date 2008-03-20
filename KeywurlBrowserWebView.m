#include "KeywurlBrowserWebView.h"
#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWebView

- (NSArray*) fallbackURLs {
	KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    LocationFieldEditor* fieldEditor = (LocationFieldEditor*) [(KeywurlBrowserWindowController*) [self windowController] keywurl_locationFieldEditor];
	NSString* address = [[fieldEditor textStorage] string];
    NSString* mapped = [mapper mapKeywordInput: address];
	if (mapped && ![mapped isEqualToString: address]) {
        NSURL* mappedUrl = [NSURL URLWithString: mapped];
        return [NSArray arrayWithObject: mappedUrl];
    } else {
        return [super fallbackURLs];
    }
}

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
