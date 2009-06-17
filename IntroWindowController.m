#import "IntroWindowController.h"
#import "KeywurlPlugin.h"

@implementation IntroWindowController

+ (BOOL) shouldShow {
    return [[[KeywurlPlugin sharedInstance] preferences] objectForKey: @"introWindowShown"] == nil;
}

- (id) init {
    if (![NSBundle loadNibNamed: @"IntroWindow" owner: self]) {
        NSLog(@"Could not load intro window resource.");
        return nil;
    }
    return self;
}

- (void) show {    
    [window center];
    [[NSApplication sharedApplication] runModalForWindow: window];
}

- (void) close: (id) sender {
    [[[KeywurlPlugin sharedInstance] preferences] setObject: @"YES" forKey: @"introWindowShown"];
    [[KeywurlPlugin sharedInstance] savePreferences];    
    [window orderOut: sender];
    [NSApp stopModal];
}

@end
