#ifdef __OBJC2__
#include <objc/objc.h>
#include <objc/runtime.h>
#endif

#include "KeywurlBrowserWebView.h"
#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation KeywurlBrowserWebView

#ifdef __OBJC2__
+ (void) keywurl_load
{
    Method old, new;
    Class self_class = [self class];
    Class safari_class = [objc_getClass("BrowserWebView") class];
    
    class_addMethod(safari_class, @selector(keywurl_fallbackURLs),
                    class_getMethodImplementation(self_class, @selector(fallbackURLs)),
                    "@@:");

    old = class_getInstanceMethod(safari_class, @selector(fallbackURLs));
    new = class_getInstanceMethod(safari_class, @selector(keywurl_fallbackURLs));
    method_exchangeImplementations(old, new);

    class_addMethod(safari_class, @selector(webView:contextMenuItemsForElement:defaultMenuItems:),
                    class_getMethodImplementation(self_class,
                                                  @selector(keywurl_webView:contextMenuItemsForElement:defaultMenuItems:)),
                    "@@:@@@");

    old = class_getInstanceMethod(safari_class, @selector(webView:contextMenuItemsForElement:defaultMenuItems:));
    new = class_getInstanceMethod(safari_class, @selector(keywurl_webView:contextMenuItemsForElement:defaultMenuItems:));
    method_exchangeImplementations(old, new);
}
#endif

#if KEYWURL_SAFARI_VERSION >= 4

- (NSArray*) fallbackURLs {
    // If Safari has failed to resolve the address into a proper host name, the
    // list of fallback URLs is empty and we can intercept the URL and map it
#ifdef __OBJC2__
    NSArray* urls = [self keywurl_fallbackURLs];
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
        return [self keywurl_fallbackURLs];
#else
        return [super fallbackURLs];
#endif
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
#ifdef __OBJC2__
	return [self keywurl_webView: sender
#else
    return [super webView: sender
#endif
         contextMenuItemsForElement: elementDictionary
         defaultMenuItems: defaultMenuItems];
}

@end
