#import "KeywurlPlugin.h"
#import "KeywurlBrowserWindowController.h"
#import "Safari.h"

static KeywurlPlugin* plugin = nil;

@implementation KeywurlPlugin

+ (void) load {
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    NSClassFromString(@"BrowserWindowController");
    [[KeywurlBrowserWindowController class] poseAsClass: [BrowserWindowController class]];
	//[NSBundle loadNibNamed: @"KeywurlPreferences" owner: plugin];
    NSLog(@"Keywurl installed");
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

@end
