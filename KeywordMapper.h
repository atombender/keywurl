#import <Cocoa/Cocoa.h>

@interface KeywordMapper : NSObject {
    NSMutableArray* mappings;
    NSMutableDictionary* cache;
}

- (id) init;
- (NSString*) mapKeywordInput: (NSString*) input;
- (void) reloadMappings;
- (void) loadMappingsFromFile: (NSString*) path;
- (void) saveMappings;
- (void) saveMappingsToFile: (NSString*) path;
- (void) addKeyword: (NSString*) keyword expansion: (NSString*) expansion;
- (void) removeKeyword: (NSString*) keyword;
- (void) removeKeywordAtIndex: (int) index;
- (NSArray*) mappings;

@end
