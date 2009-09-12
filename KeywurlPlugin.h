#import <Cocoa/Cocoa.h>
#import "KeywordMapper.h"

#ifndef NSINTEGER_DEFINED
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif

@interface KeywurlPlugin : NSObject {
    IBOutlet NSWindow* introWindow;
    KeywordMapper* fKeywordMapper;
    NSMutableDictionary* preferences;
    BOOL fLoaded;
}

- (id) init;
- (KeywordMapper*) keywordMapper;
- (BOOL) isLoaded;
- (NSString*) preferenceFileName;
- (NSMutableDictionary*) preferences;
- (void) savePreferences;

+ (KeywurlPlugin*) sharedInstance;

- (IBAction) createKeywordSearchFromForm: (id) sender;

@end
