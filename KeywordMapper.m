#include "KeywordMapper.h"

@implementation KeywordMapper

- (id) init {
    fMappings = [NSMutableDictionary new];
    [self loadMappings];
    return self;
}

- (NSString*) mapKeywordInput: (NSString*) input {
    input = [input stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSRange spaceRange = [input rangeOfString: @" "];
    if (spaceRange.location == NSNotFound) {
        spaceRange.location = [input length];
    }         
    NSString* keyword = [input substringToIndex: spaceRange.location];
    id output = [fMappings objectForKey: keyword];
    if (output) {
        output = [output mutableCopy];
        NSString* value = [input substringFromIndex: spaceRange.location + 1];
        value = [value stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        while (true) {
            NSRange expansionRange = [output rangeOfString: @"@@@"]; 
            if (expansionRange.location == NSNotFound) {
                break;
            }
            [output deleteCharactersInRange: expansionRange];
            [output insertString: value atIndex: expansionRange.location];
        }
        [output autorelease];
    } else {
        output = input;
    }
    return output;
}

- (NSDictionary*) mappings {
    return [[fMappings copy] autorelease];
}

- (void) loadMappings {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString* path = [[paths objectAtIndex: 0] stringByAppendingPathComponent: @"Keywurl/Keywords.plist"];
    [self loadMappingsFromFile: path];
}

- (void) loadMappingsFromFile: (NSString*) path {
    NSLog(@"Loading keywords from %@", path);
    [fMappings removeAllObjects];
    NSData* plistData = [NSData dataWithContentsOfFile: path];
    NSPropertyListFormat format;
    NSString *error;
    id plist = [NSPropertyListSerialization propertyListFromData: plistData
        mutabilityOption: NSPropertyListImmutable
        format: &format
        errorDescription: &error];
    if (plist) {
        NSEnumerator* keyEumerator = [plist keyEnumerator];
        NSString* keyword;
        while (keyword = [keyEumerator nextObject]) {
            NSString* expansion = [plist objectForKey: keyword];
            [fMappings setValue: expansion forKey: keyword];
        }
    } else {
        NSLog(@"Could not load keywords: %@", error);
        [error release];
    }
}

@end
