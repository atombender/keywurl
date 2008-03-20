#import <Cocoa/Cocoa.h>
#import "NSPreferenceModule.h"
#import "KeywordMapping.h"
#import "KeywordMapper.h"

@interface KeywurlPreferences : NSPreferencesModule {
	IBOutlet NSTableView* tableView;
    IBOutlet NSTokenField* expansionTokenField;
    IBOutlet NSTokenField* sourceTokenField;
    IBOutlet id dontUseUnicodeCheckBox;
    IBOutlet id encodeSpacesCheckbox;
    IBOutlet NSMenu* tokenPopupMenu;
    KeywordMapper* mapper;
    KeywordMapping* mappingBeingEdited;
    NSMutableArray* keywords;
}

- (IBAction) addKeyword: (id) sender;
- (IBAction) removeKeyword: (id) sender;

@end
