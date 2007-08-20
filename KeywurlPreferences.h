#import <Cocoa/Cocoa.h>
#import "NSPreferenceModule.h"

@interface KeywurlPreferences : NSPreferencesModule {
	IBOutlet NSTableView* tableView;
}

- (IBAction) addKeyword: (id) sender;
- (IBAction) removeKeyword: (id) sender;

@end
