#import "KeywurlPlugin.h"
#import "KeywurlBrowserWebView.h"
#import "KeywurlBrowserWindowController.h"
#import "Safari.h"
#import "KeywordSaveController.h"
#import "Constants.h"

static KeywurlPlugin* plugin = nil;

@implementation KeywurlPlugin

+ (void) load {
    NSLog(@"Keywurl version %d.%d.%d loading", KEYWURL_MAJORVERSION, KEYWURL_MINORVERSION, KEYWURL_MAINTVERSION);
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    NSClassFromString(@"BrowserWindowController");
    [[KeywurlBrowserWindowController class] poseAsClass: [BrowserWindowController class]];
    NSClassFromString(@"BrowserWebView");
    [[KeywurlBrowserWebView class] poseAsClass: [BrowserWebView class]];
}

+ (KeywurlPlugin*) sharedInstance {
    if (plugin == nil) {
        plugin = [[KeywurlPlugin alloc] init];
    }
    return plugin;
}

- (id) init { 
    fKeywordMapper = [[KeywordMapper alloc] init];
    fLoaded = YES;
    return self;
}

- (KeywordMapper*) keywordMapper {
    return fKeywordMapper;
}

- (BOOL) isLoaded {
    return fLoaded;
}

- (void) createKeywordSearchFromForm: (id) sender {
    NSArray* parameters = (NSArray*) [sender representedObject];
    NSString* documentUrl = (NSString*) [parameters objectAtIndex: 0];
    DOMElement* inputElement = (DOMElement*) [parameters objectAtIndex: 1];
    DOMElement* formElement = nil;
    DOMNode* node = inputElement;
    while (node) {
        if ([node nodeType] == DOM_ELEMENT_NODE) {
            DOMElement* element = (DOMElement*) node;
            if ([[element tagName] isEqualToString: @"FORM"]) {
                formElement = element;
                break;
            }
        }
        node = [node parentNode];
    }
    if (inputElement && formElement) {
        KeywordSaveController* controller = [[KeywordSaveController alloc] initWithUrl: documentUrl
            inputElement: inputElement
            formElement: formElement];
    }
}

@end
