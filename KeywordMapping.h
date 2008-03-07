#import <Cocoa/Cocoa.h>

@interface QueryToken : NSObject {
}

- (NSString*) label;

@end

@interface QueryPartToken : NSObject {
    int partNumber;
}

- (id) initWithPartNumber: (int) partNumber;
- (int) partNumber;
- (NSString*) label;

@end

@interface InputToken : NSObject {
}

- (NSString*) label;

@end

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
- (NSArray*) expansionAsTokens;
- (void) setExpansion: (NSString*) newExpansion;
- (void) setDontUseUnicode: (BOOL) flag;
- (BOOL) dontUseUnicode;
- (void) setEncodeSpaces: (BOOL) flag;
- (BOOL) encodeSpaces;

- (NSDictionary*) toDictionary;

- (NSString*) encodeQuery: (NSString*) query;
- (NSArray*) tokenizeParts: (NSString*) query;

@end
