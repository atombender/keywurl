#import <Cocoa/Cocoa.h>

@interface KeywordMapping : NSObject {
    NSString* keyword;
    NSString* expansion;
}

- (id) initWithKeyword: (NSString*) theKeyword expansion: (NSString*) theExpansion;
- (NSString*) keyword;
- (void) setKeyword: (NSString*) newKeyword;
- (NSString*) expansion;
- (void) setExpansion: (NSString*) newExpansion;

@end
