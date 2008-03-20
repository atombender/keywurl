#import <Cocoa/Cocoa.h>
#import "KeywordMapping.h"

@interface KeywordMapper : NSObject {
    NSMutableArray* mappings;
    NSMutableDictionary* cache;
}

- (id) init;
- (KeywordMapping*) mappingForKeyword: (NSString*) keyword;
- (NSString*) mapKeywordInput: (NSString*) input;
- (void) reloadMappings;
- (void) loadMappingsFromFile: (NSString*) path;
- (void) saveMappings;
- (void) saveMappingsToFile: (NSString*) path;
- (void) addKeyword: (KeywordMapping*) mapping;
- (void) addKeyword: (NSString*) keyword expansion: (NSString*) expansion;
- (void) addKeyword: (NSString*) keyword expansion: (NSString*) expansion
    dontUseUnicode: (BOOL) theDontUseUnicode
    encodeSpaces: (BOOL) theEncodeSpaces;
- (void) removeKeyword: (NSString*) keyword;
- (void) removeKeywordAtIndex: (int) index;
- (NSArray*) mappings;
- (void) modified;

@end
