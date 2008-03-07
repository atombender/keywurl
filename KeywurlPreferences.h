#import <Cocoa/Cocoa.h>
#import "NSPreferenceModule.h"
#import "KeywordMapping.h"

@interface KeywurlPreferences : NSPreferencesModule {
	IBOutlet NSTableView* tableView;
    IBOutlet NSTokenField* expansionTokenField;
    IBOutlet NSTokenField* sourceTokenField;
    IBOutlet id dontUseUnicodeCheckBox;
    IBOutlet id encodeSpacesCheckbox;
    IBOutlet NSMenu* tokenPopupMenu;
    KeywordMapping* mappingBeingEdited;
}

- (IBAction) addKeyword: (id) sender;
- (IBAction) removeKeyword: (id) sender;

@end
