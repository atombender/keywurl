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

/*!
  Encodes a query using the settings (Unicode, etc.) of this mapping.
*/
- (NSString*) encodeQuery: (NSString*) query;

/*!
  Tokenizes a query into parts. Each word is a part, as is each phrase (multiple words enclosed in 
  double quotes).
*/
- (NSArray*) tokenizeParts: (NSString*) query;

/*!
  Expands a query using this mapping, returning the expanded version.
*/
- (NSString*) expand: (NSString*) input forKeyword: (NSString*) keyword;

@end
