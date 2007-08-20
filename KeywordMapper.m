#include "KeywordMapper.h"
#include "KeywordMapping.h"

@interface KeywordMapper (Internal)
- (void) buildCache;
- (NSString*) mappingFileName;
@end

@implementation KeywordMapper

- (id) init {
    mappings = [NSMutableArray new];
    cache = [NSMutableDictionary new];
    [self reloadMappings];
    return self;
}

- (int) numberOfRowsInTableView: (NSTableView*) aTableView {
    return [mappings count];
}

- (id) tableView: (NSTableView*) aTableView 
    objectValueForTableColumn: (NSTableColumn*) aTableColumn
    row: (int) rowIndex {
    KeywordMapping* mapping = [mappings objectAtIndex: rowIndex];
    if ([[aTableColumn identifier] isEqualToString: @"Keyword"]) {
        return [mapping keyword];
    } else if ([[aTableColumn identifier] isEqualToString: @"Expansion"]) {
        return [mapping expansion];
    } else {
        return nil;
    }
}

- (void) tableView: (NSTableView*) aTableView 
    setObjectValue: (id) anObject 
    forTableColumn: (NSTableColumn*) aTableColumn 
    row: (int) rowIndex {
    KeywordMapping* mapping = [mappings objectAtIndex: rowIndex];
    if ([[aTableColumn identifier] isEqualToString: @"Keyword"]) {
        [mapping setKeyword: anObject];
        [self buildCache];
    } else if ([[aTableColumn identifier] isEqualToString: @"Expansion"]) {
        [mapping setExpansion: anObject];
        [self buildCache];
    }
}

- (NSString*) mapKeywordInput: (NSString*) input {
    input = [input stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSRange spaceRange = [input rangeOfString: @" "];
    if (spaceRange.location == NSNotFound) {
        spaceRange.location = [input length];
    }         
    NSString* keyword = [input substringToIndex: spaceRange.location];
    id output = [cache objectForKey: keyword];
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

- (NSString*) mappingFileName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString* path = [[paths objectAtIndex: 0] stringByAppendingPathComponent: @"Keywurl/Keywords.plist"];
    return path;
}

- (void) reloadMappings {
    [self loadMappingsFromFile: [self mappingFileName]];
}

- (void) loadMappingsFromFile: (NSString*) path {
    NSLog(@"Loading keywords from %@", path);
    [mappings removeAllObjects];
    if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
        NSData* data = [NSData dataWithContentsOfFile: path];
        NSPropertyListFormat format;
        NSString* error;
        id plist = [NSPropertyListSerialization propertyListFromData: data
            mutabilityOption: NSPropertyListImmutable
            format: &format
            errorDescription: &error];
        if (plist) {
            NSEnumerator* keyEumerator = [plist keyEnumerator];
            NSString* keyword;
            while (keyword = [keyEumerator nextObject]) {
                NSString* expansion = [plist objectForKey: keyword];
                [self addKeyword: keyword expansion: expansion];
            }
        } else {
            NSLog(@"Could not load keywords: %@", error);
            [error release];
        }
    } else {
        // Set up some sensible defaults
        [self addKeyword: @"amazon" 
            expansion: @"http://www.amazon.com/exec/obidos/search-handle-url/index%3Dblended%26field-keywords%3D@@@"];
        [self addKeyword: @"allmusic"
            expansion: @"http://allmusic.com/cg/amg.dll?P=amg&sql=@@@&opt1=1"];
        [self addKeyword: @"discogs"
            expansion: @"http://www.discogs.com/search?type=all&q=@@@"];
        [self addKeyword: @"flickr"
            expansion: @"http://flickr.com/photos/tags/@@@"];
        [self addKeyword: @"imdb"
            expansion: @"http://imdb.com/find?s=all&q=@@@"];
        [self addKeyword: @"gmaps"
            expansion: @"http://maps.google.com/maps?oi=map&q=@@@"];
        [self addKeyword: @"gimages"
            expansion: @"http://images.google.com/images?q=@@@&ie=UTF-8&oe=UTF-8"];
        [self addKeyword: @"wiki"
            expansion: @"http://en.wikipedia.org/wiki/Special:Search?search=@@@&go=Go"];
        [self addKeyword: @"youtube"
            expansion: @"http://youtube.com/results?search_query=@@@"];
    }
    [self buildCache];
}

- (void) saveMappings {
    [self saveMappingsToFile: [self mappingFileName]];
}

- (void) saveMappingsToFile: (NSString*) path {
    NSLog(@"Saving keywords to %@", path);
    NSString* error;
    NSData* data = [NSPropertyListSerialization dataFromPropertyList: cache
        format: NSPropertyListXMLFormat_v1_0
        errorDescription: &error];
    if (data) {
        NSString* directory = [path stringByDeletingLastPathComponent];
        if (![[NSFileManager defaultManager] fileExistsAtPath: directory]) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath: directory attributes: nil]) {
                NSLog(@"Could not create directory");
            }
        }
        if (![data writeToFile: path atomically: YES]) {
            NSLog(@"Could not write mappings to file");
        }
    } else {
        NSLog(@"Could not serialize keywords: %@", error);
        [error release];
    }
}

- (void) addKeyword: (NSString*) keyword expansion: (NSString*) expansion {
    KeywordMapping* mapping = [[KeywordMapping alloc] initWithKeyword: keyword 
        expansion: expansion];
    [mappings addObject: mapping];
    [self buildCache];
}

- (void) removeKeyword: (NSString*) keyword {
    for (int i = [mappings count] - 1; i >= 0; i--) {
        KeywordMapping* mapping = [mappings objectAtIndex: i];
        if ([[mapping keyword] isEqualToString: keyword]) {
            [mappings removeObjectAtIndex: i];
        }
    }
    [self buildCache];
}

- (void) removeKeywordAtIndex: (int) index {
    [mappings removeObjectAtIndex: index];
    [self buildCache];
}

- (NSArray*) mappings {
    return mappings;
}

- (void) buildCache {
    [cache removeAllObjects];
    for (int i = [mappings count] - 1; i >= 0; i--) {
        KeywordMapping* mapping = [mappings objectAtIndex: i];
        [cache setValue: [mapping expansion] forKey: [mapping keyword]];
    }
}

@end
