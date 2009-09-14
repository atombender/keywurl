#import "KeywurlPlugin.h"
#import "KeywurlBrowserWebView.h"
#import "KeywurlBrowserWindowController.h"
#import "IntroWindowController.h"
#import "Safari.h"
#import "KeywordSaveController.h"
#import "Constants.h"

static KeywurlPlugin* plugin = nil;

@implementation KeywurlPlugin

+ (void) load {
    #ifdef KEYWURL_BETA_BUILD
        NSLog(@"Keywurl version %d.%d.%d beta %d loading", 
            KEYWURL_MAJORVERSION, KEYWURL_MINORVERSION, KEYWURL_MAINTVERSION, KEYWURL_BETA_BUILD);
    #else
        NSLog(@"Keywurl version %d.%d.%d loading", 
            KEYWURL_MAJORVERSION, KEYWURL_MINORVERSION, KEYWURL_MAINTVERSION);
    #endif
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    #ifdef __OBJC2__
    [KeywurlBrowserWindowController keywurl_load];
    [KeywurlBrowserWebView keywurl_load];
    #else
    NSClassFromString(@"BrowserWindowController");
    [[KeywurlBrowserWindowController class] poseAsClass: [BrowserWindowController class]];
    NSClassFromString(@"BrowserWebView");
    [[KeywurlBrowserWebView class] poseAsClass: [BrowserWebView class]];
    #endif
    
    NSUserDefaults* preferences = [[NSUserDefaults standardUserDefaults] retain];
    [preferences setObject: @"world" forKey: @"hello"];
    [preferences release];
    
    if ([IntroWindowController shouldShow]) {
        IntroWindowController* introController = [[IntroWindowController alloc] init];
        [introController show];
    }
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
    introWindow = nil;
    return self;
}

- (void) dealloc {
    if (preferences) {
        [preferences release];
    }
    [super dealloc];
}

- (NSString*) preferenceFileName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(
      NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex: 0] stringByAppendingPathComponent: @"Keywurl/Settings.plist"];
}

- (NSMutableDictionary*) preferences {
    if (!preferences) {
        NSDictionary* immutablePreferences = [NSDictionary dictionaryWithContentsOfFile: [self preferenceFileName]];
        if (immutablePreferences) {
            preferences = [immutablePreferences mutableCopy];
        } else {
            preferences = [NSMutableDictionary dictionary];
        }
    }
    return preferences;
}

- (void) savePreferences {
    if (preferences) {
        [preferences writeToFile: [self preferenceFileName] atomically: YES];
    }
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
    if ([inputElement respondsToSelector: @selector(form)]) {
        formElement = [inputElement form];
    }
    if (!formElement) {
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
    }
    if (inputElement && formElement) {
        [[KeywordSaveController alloc] initWithUrl: documentUrl
            inputElement: inputElement
            formElement: formElement];
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle: @"OK"];
        [alert setMessageText: @"Could not create keyword"];
        [alert setInformativeText: [NSString stringWithFormat:
            @"The field you clicked on seem to be constructed in a way that Keywurl \
does not understand. \
\
For example, the field may be JavaScript/AJAX-based, or the HTML may be malformed. \
Keywurl can only deal with good old-fashioned HTML forms. \
\
Sorry."]];
        [alert setAlertStyle: NSInformationalAlertStyle];
        [alert beginSheetModalForWindow: [NSApp keyWindow]
            modalDelegate: nil
            didEndSelector: nil
            contextInfo: nil];
    }
}

@end
