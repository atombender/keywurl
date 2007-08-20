#import "KeywordMapping.h"

@implementation KeywordMapping

- (id) initWithKeyword: (NSString*) theKeyword expansion: (NSString*) theExpansion {
    keyword = [theKeyword copy];
    expansion = [theExpansion copy];
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

@end
