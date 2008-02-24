#import <Cocoa/Cocoa.h>

@interface KeywordMapping : NSObject {
    NSString* keyword;
    NSString* expansion;
    BOOL dontUseUnicode;
    BOOL encodeSpaces;
}

- (id) initWithKeyword: (NSString*) theKeyword fromDictionary: (NSDictionary*) dictionary;
- (id) initWithKeyword: (NSString*) theKeyword 
    expansion: (NSString*) theExpansion;
- (id) initWithKeyword: (NSString*) theKeyword 
    expansion: (NSString*) theExpansion
    dontUseUnicode: (BOOL) theDontUseUnicode
    encodeSpaces: (BOOL) theEncodeSpaces;

- (NSString*) keyword;
- (void) setKeyword: (NSString*) newKeyword;
- (NSString*) expansion;
- (void) setExpansion: (NSString*) newExpansion;
- (void) setDontUseUnicode: (BOOL) flag;
- (BOOL) dontUseUnicode;
- (void) setEncodeSpaces: (BOOL) flag;
- (BOOL) encodeSpaces;

- (NSDictionary*) toDictionary;

- (NSString*) encodeQuery: (NSString*) query;

@end
