#import <Cocoa/Cocoa.h>
#import "NSPreferenceModule.h"

@interface NSPreferences_Keywurl : NSPreferences {
}

+ (void) load;
+ (id) sharedPreferences;

@end
