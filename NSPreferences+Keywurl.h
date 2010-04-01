#import <Cocoa/Cocoa.h>
#import "NSPreferenceModule.h"

#ifdef __OBJC2__
@interface NSPreferences (NSPreferences_Keywurl)
#else
@interface NSPreferences_Keywurl : NSPreferences {
}
#endif

+ (void) load;
+ (id) sharedPreferences;

@end
