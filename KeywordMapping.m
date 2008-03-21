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
        query = [query stringByAddingPercentEscapesUsingEncoding: NSISOLatin1StringEncoding];
    } else {
        // Hashes are interpreted as URL fragments by Safari
        query = [query stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    }
    NSMutableString* result = [query mutableCopy];
    [result replaceOccurrencesOfString: @"#" withString: @"%23" options: 0 range: NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString: @":" withString: @"%3a" options: 0 range: NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString: @"&" withString: @"%26" options: 0 range: NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString: @"=" withString: @"%3d" options: 0 range: NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString: @"+" withString: @"%2b" options: 0 range: NSMakeRange(0, [result length])];
    if (encodeSpaces) {
        [result replaceOccurrencesOfString: @"%20" withString: @"+" options: 0 range: NSMakeRange(0, [result length])];
    }
    return result;
}

@end
