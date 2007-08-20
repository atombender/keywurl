#import <Cocoa/Cocoa.h>
#import "KeywordMapper.h"

@interface KeywurlPlugin : NSObject {
    KeywordMapper* fKeywordMapper;
    BOOL fLoaded;
}

- (id) init;
- (KeywordMapper*) keywordMapper;
- (BOOL) isLoaded;
+ (KeywurlPlugin*) sharedInstance;

@end
