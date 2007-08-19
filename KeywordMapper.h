#import <Cocoa/Cocoa.h>

@interface KeywordMapper : NSObject {
    NSMutableDictionary* fMappings;
}

- (id) init;
- (NSString*) mapKeywordInput: (NSString*) input;
- (NSDictionary*) mappings;
- (void) loadMappings;
- (void) loadMappingsFromFile: (NSString*) path;

@end
