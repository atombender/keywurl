#import <Cocoa/Cocoa.h>
#import "KeywordMapper.h"

@interface KeywurlPlugin : NSObject {
    KeywordMapper* fKeywordMapper;
}

- (id) init;
- (KeywordMapper*) keywordMapper;
+ (KeywurlPlugin*) sharedInstance;

@end
