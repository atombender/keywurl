#import "KeywurlPlugin.h"
#import "KeywurlPreferences.h"

@interface KeywurlPreferences (Private)

- (void) saveEdit;

@end

@implementation KeywurlPreferences

+ (NSImage*) preloadImage: (NSString*) theName
{
	NSImage* image = nil;
	NSString* imagePath = [[NSBundle bundleWithIdentifier: @"net.purefiction.keywurl"] 
	    pathForImageResource: theName];
	if (!imagePath)
	{
		NSLog(@"imagePath for %@ is nil", theName);
		return nil;
	}
	image = [[NSImage alloc] initByReferencingFile: imagePath];
	if (!image)
	{
		NSLog(@"image for %@ is nil", theName);
		return nil;
	}
	[image setName: theName];
	return image;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

- (void) awakeFromNib {
	NSDictionary* infoDictionary = [[NSBundle bundleWithIdentifier: @"net.purefiction.keywurl"] 
	    infoDictionary];
    KeywordMapper* mapper = [[KeywurlPlugin sharedInstance] keywordMapper];
    [tableView setDataSource: mapper];
	/*
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"jfShouldReloadOnRelaunch"]) {
		[checkboxShouldReloadOnRelaunch setState: NSOnState];
	} else {
		[checkboxShouldReloadOnRelaunch setState: NSOffState];
	}
	*/
	[[NSNotificationCenter defaultCenter] addObserver: self
	    selector: @selector(tableViewSelectionDidChange:)
	    name: NSTableViewSelectionDidChangeNotification
        object: nil];
    [expansionTextField setEnabled: NO];
    [encodeSpacesCheckbox setEnabled: NO];
    [dontUseUnicodeCheckBox setEnabled: NO];
}

- (NSImage*) imageForPreferenceNamed: (NSString*) theName
{
	NSImage* image = [NSImage imageNamed: @"Keywurl.png"];
	if (image == nil) {
		image = [KeywurlPreferences preloadImage: @"Keywurl.png"];
	}
	return image;
}

- (NSString*) preferencesNibName
{
	return @"KeywurlPreferences";
}

- (void) didChange
{
	[super didChange];
}

- (NSView*) viewForPreferenceNamed: (NSString*) aName
{
	if ([[KeywurlPlugin sharedInstance] isLoaded] == NO) {
		return nil;
	}
	NSView* view = [super viewForPreferenceNamed: aName];
	return view;
}

- (void) willBeDisplayed
{
	if ([[KeywurlPlugin sharedInstance] isLoaded] == NO)
		return;
}

- (void) saveChanges
{
	if ([[KeywurlPlugin sharedInstance] isLoaded]) {
        [self saveEdit];
        KeywordMapper* mapper = [[KeywurlPlugin sharedInstance] keywordMapper];
        [mapper saveMappings];
	}
}

- (BOOL) hasChangesPending
{
	return [super hasChangesPending];
}

- (void) moduleWillBeRemoved
{
	[super moduleWillBeRemoved];
}

- (void) moduleWasInstalled
{
	[super moduleWasInstalled];
}

- (IBAction) addKeyword: (id) sender {
    KeywordMapper* mapper = [[KeywurlPlugin sharedInstance] keywordMapper];
    [mapper addKeyword: @"" expansion: @""];
    int rowIndex = [[mapper mappings] count] - 1;
    [tableView reloadData];
    [tableView scrollRowToVisible: rowIndex];
    [tableView selectRowIndexes: [NSIndexSet indexSetWithIndex: rowIndex] byExtendingSelection: NO];
    [tableView editColumn: 0 row: rowIndex withEvent: nil select: YES];
}

- (IBAction) removeKeyword: (id) sender {
    int rowIndex = [tableView selectedRow];
    if (rowIndex >= 0) {
        KeywordMapper* mapper = [[KeywurlPlugin sharedInstance] keywordMapper];
        [mapper removeKeywordAtIndex: rowIndex];
        [tableView reloadData];
    }
}

- (void) tableViewSelectionDidChange: (NSNotification*) notification {
    [self saveEdit];
    int rowIndex = [tableView selectedRow];
    if (rowIndex >= 0) {
        KeywordMapper* mapper = [[KeywurlPlugin sharedInstance] keywordMapper];
        KeywordMapping* mapping = [[mapper mappings] objectAtIndex: rowIndex];
        [expansionTextField setStringValue: [mapping expansion]];
        [encodeSpacesCheckbox setState: [mapping encodeSpaces] ? NSOnState : NSOffState];
        [dontUseUnicodeCheckBox setState: [mapping dontUseUnicode] ? NSOnState : NSOffState];
        [expansionTextField setEnabled: YES];
        [encodeSpacesCheckbox setEnabled: YES];
        [dontUseUnicodeCheckBox setEnabled: YES];
        mappingBeingEdited = mapping;
    } else {
        [expansionTextField setEnabled: NO];
        [encodeSpacesCheckbox setEnabled: NO];
        [dontUseUnicodeCheckBox setEnabled: NO];
        mappingBeingEdited = nil;
    }
}

- (void) saveEdit {
    if (mappingBeingEdited) {
        KeywordMapping* mapping = mappingBeingEdited;
        [mapping setEncodeSpaces: [encodeSpacesCheckbox state] == NSOnState];
        [mapping setDontUseUnicode: [dontUseUnicodeCheckBox state] == NSOnState];
        [mapping setExpansion: [expansionTextField stringValue]];
    }
}

@end
