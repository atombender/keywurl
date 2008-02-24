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
        query = [query stringByReplacingOccurrencesOfString: @"#" withString: @"%23"];
    }
    query = [query stringByReplacingOccurrencesOfString: @":" withString: @"%3a"];
    if (encodeSpaces) {
        query = [query stringByReplacingOccurrencesOfString: @"%20" withString: @"+"];
        NSLog(@"Spaced out: %@", query);
    }
    return query;
}

@end
