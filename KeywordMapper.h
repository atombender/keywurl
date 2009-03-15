#import <Cocoa/Cocoa.h>
#import "KeywordMapping.h"

extern const NSString* KeywordMapperMappingsDidChangeNotification;

@interface KeywordMapper : NSObject {
    NSMutableArray* mappings;
    NSMutableDictionary* cache;
}

- (id) init;
- (KeywordMapping*) mappingForKeyword: (NSString*) keyword;
- (NSString*) mapKeywordInput: (NSString*) input;
- (NSString*) mapKeywordInput: (NSString*) input withDefault: (BOOL) withDefault;
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
- (NSArray*) mappings;
- (void) modified;

@end
