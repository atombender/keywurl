#import "KeywordMapping.h"

@implementation KeywordMapping

- (id) initWithKeyword: (NSString*) theKeyword fromDictionary: (NSDictionary*) dictionary {
    NSString* theExpansion = [dictionary objectForKey: @"expansion"];
    BOOL theDontUseUnicode = [[dictionary objectForKey: @"dontUseUnicode"] 
        isEqualToNumber: [NSNumber numberWithInt: 1]];
    BOOL theEncodeSpaces = [[dictionary objectForKey: @"encodeSpaces"] 
        isEqualToNumber: [NSNumber numberWithInt: 1]];
    return [self initWithKeyword: theKeyword 
        expansion: theExpansion 
        dontUseUnicode: theDontUseUnicode 
        encodeSpaces: theEncodeSpaces];
}

- (id) initWithKeyword: (NSString*) theKeyword 
    expansion: (NSString*) theExpansion {
    return [self initWithKeyword: theKeyword expansion: theExpansion dontUseUnicode: NO encodeSpaces: NO];
}

- (id) initWithKeyword: (NSString*) theKeyword 
    expansion: (NSString*) theExpansion
    dontUseUnicode: (BOOL) theDontUseUnicode
    encodeSpaces: (BOOL) theEncodeSpaces {
    keyword = [theKeyword copy];
    expansion = [theExpansion copy];
    dontUseUnicode = theDontUseUnicode;
    encodeSpaces = theEncodeSpaces;
    return self;
}

- (void) dealloc {
    [keyword release];
    [expansion release];
    [super dealloc];
}

- (NSString*) keyword {
    return keyword;
}

- (void) setKeyword: (NSString*) newKeyword {
    [keyword release];
    keyword = [newKeyword copy];
}

- (NSString*) expansion {
    return expansion;
}

- (void) setExpansion: (NSString*) newExpansion {
    [expansion release];
    expansion = [newExpansion copy];
}

- (void) setDontUseUnicode: (BOOL) flag {
    dontUseUnicode = flag;
}

- (BOOL) dontUseUnicode {
    return dontUseUnicode;
}

- (void) setEncodeSpaces: (BOOL) flag {
    encodeSpaces = flag;
}

- (BOOL) encodeSpaces {
    return encodeSpaces;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary new];    
    [dictionary setObject: expansion forKey: @"expansion"];
    [dictionary setObject: [NSNumber numberWithInt: dontUseUnicode ? 1 : 0] forKey: @"dontUseUnicode"];
    [dictionary setObject: [NSNumber numberWithInt: encodeSpaces ? 1 : 0] forKey: @"encodeSpaces"];
    return dictionary;
}

- (NSString*) encodeQuery: (NSString*) query {
    if (dontUseUnicode) {
        NSMutableString* output = [NSMutableString new];
        for (unsigned i = 0; i < [query length]; i++) {
            unichar* c = [query characterAtIndex: i];
            if (c >= 0 && c < 127) {
                [output appendString: [NSString stringWithCharacters: &c length: 1]];
            } else {
                [output appendString: [NSString stringWithFormat: @"%%%2x", (unsigned int) c]];
            }
        }      
        return output;
    } else {
        return query;
    }
}

+ (NSString*) encodeSpaces: (NSString*) string {
    NSMutableString* newString = [string mutableCopy];
    [newString replaceOccurrencesOfString: @" " 
        withString: @"+" 
        options: 0 
        range: NSMakeRange(0, [newString length])];
    return newString;
}

@end
