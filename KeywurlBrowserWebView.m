#ifdef __OBJC2__
#include <objc/objc.h>
#include <objc/runtime.h>
#endif

#include "KeywurlBrowserWebView.h"
#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

#ifdef __OBJC2__
@implementation BrowserWebView (BrowserWebView_KeywurlPlugin)
#else
@implementation KeywurlBrowserWebView
#endif

#ifdef __OBJC2__
+ (void) _Keywurl_load
{
	Method old, new;
	Class c = [self class];
	
	old = class_getInstanceMethod(c, @selector(fallbackURLs));
	new = class_getInstanceMethod(c, @selector(_Keywurl_fallbackURLs));
	method_exchangeImplementations(old, new);
	
	old = class_getInstanceMethod(c, @selector(webView));
	new = class_getInstanceMethod(c, @selector(_Keywurl_webView));
	method_exchangeImplementations(old, new);
}
#endif

#if KEYWURL_SAFARI_VERSION >= 4

#ifdef __OBJC2__
- (NSArray*) _Keywurl_fallbackURLs {
#else
- (NSArray*) fallbackURLs {
#endif
    // If Safari has failed to resolve the address into a proper host name, the
    // list of fallback URLs is empty and we can intercept the URL and map it
#ifdef __OBJC2__
    NSArray* urls = [self _Keywurl_fallbackURLs];
#else
    NSArray* urls = [super fallbackURLs];
#endif
    if (urls == nil || [urls count] == 0) {
    	KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
        KeywordMapper* mapper = [plugin keywordMapper];
        LocationFieldEditor* fieldEditor = (LocationFieldEditor*) [
          [self windowController] keywurl_locationFieldEditor];
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
#ifdef __OBJC2__
        return [self _Keywurl_fallbackURLs];
#else
        return [super fallbackURLs];
#endif
    }
}

#endif

#ifdef __OBJC2__
- (id) _Keywurl_webView: (id) sender 
#else
- (id) webView: (id) sender 
#endif
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
#ifdef __OBJC2__
	return [self _Keywurl_webView: sender
#else
    return [super webView: sender
#endif
         contextMenuItemsForElement: elementDictionary
         defaultMenuItems: defaultMenuItems];
}

@end
