#import <Cocoa/Cocoa.h>
#import "NSPreferenceModule.h"
#import "KeywordMapping.h"

@interface KeywurlPreferences : NSPreferencesModule {
	IBOutlet NSTableView* tableView;
    IBOutlet id expansionTextField;
    IBOutlet id dontUseUnicodeCheckBox;
    IBOutlet id encodeSpacesCheckbox;
    KeywordMapping* mappingBeingEdited;
}

- (IBAction) addKeyword: (id) sender;
- (IBAction) removeKeyword: (id) sender;

@end
