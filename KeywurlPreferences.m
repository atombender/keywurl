#import "KeywurlPlugin.h"
#import "KeywurlPreferences.h"

@interface KeywurlPreferences (Private)

- (void) saveEdit;
- (void) updateSelection;

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
    [sourceTokenField setObjectValue: [NSArray arrayWithObjects: 
        [[QueryToken alloc] init],
        [[InputToken alloc] init],
        [[QueryPartToken alloc] initWithPartNumber: 1],
        [[QueryPartToken alloc] initWithPartNumber: 2],
        [[QueryPartToken alloc] initWithPartNumber: 3],
        [[QueryPartToken alloc] initWithPartNumber: 4],
        [[QueryPartToken alloc] initWithPartNumber: 5],
        [[QueryPartToken alloc] initWithPartNumber: 6],
        [[QueryPartToken alloc] initWithPartNumber: 7],
        [[QueryPartToken alloc] initWithPartNumber: 8],
        [[QueryPartToken alloc] initWithPartNumber: 9],
        nil
    ]];
	[[NSNotificationCenter defaultCenter] addObserver: self
	    selector: @selector(tableViewSelectionDidChange:)
	    name: NSTableViewSelectionDidChangeNotification
        object: nil];
    [self updateSelection];
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
        mappingBeingEdited = nil;
        KeywordMapper* mapper = [[KeywurlPlugin sharedInstance] keywordMapper];
        [mapper removeKeywordAtIndex: rowIndex];
        [tableView reloadData];
    }
}

- (void) tableViewSelectionDidChange: (NSNotification*) notification {
    [self updateSelection];
}

- (NSTokenStyle) tokenField: (NSTokenField*) tokenField 
    styleForRepresentedObject: (id) representedObject {
    if ([representedObject isKindOfClass: [NSString class]]) {
        return NSPlainTextTokenStyle;
    } else {
        return NSRoundedTokenStyle;
    }
}

- (id) tokenField: (NSTokenField*) tokenField 
    representedObjectForEditingString: (NSString*) editingString {
    NSLog(@"representedObjectForEditingString: %@", editingString);
    if ([editingString isEqualToString: @"{query}"]) {
        return [[QueryToken alloc] init];
    } else if ([editingString isEqualToString: @"{input}"]) {
        return [[InputToken alloc] init];
    } else if ([editingString hasPrefix: @"{"] && [editingString hasSuffix: @"}"] &&
        [[editingString substringWithRange: NSMakeRange(1, [editingString length] - 2)] intValue] >= 1) {
        int n = [[editingString substringWithRange: NSMakeRange(1, [editingString length] - 2)] intValue];
        return [[QueryPartToken alloc] initWithPartNumber: n];
    } else {
        return [editingString description];
    }
}

- (NSString*) tokenField: (NSTokenField*) tokenField 
    displayStringForRepresentedObject: (id) representedObject {
    if ([representedObject isKindOfClass: [NSString class]]) {
        return representedObject;
    } else {
        return [representedObject label];
    }
}

- (NSString*) tokenField: (NSTokenField*) tokenField 
    editingStringForRepresentedObject: (id) representedObject {
    if ([representedObject isKindOfClass: [NSString class]]) {
        return representedObject;
    } else {
        return [representedObject description];
    }
}

- (NSArray*) tokenField: (NSTokenField*) tokenField 
    shouldAddObjects: (NSArray*) tokens 
    atIndex: (NSUInteger) index {
    NSMutableArray* result = [NSMutableArray new];
    for (id item in tokens) {
        if ([item isEqualToString: @"Query"]) {
            [result addObject: [[QueryToken alloc] init]];
        } else if ([item isEqualToString: @"Input"]) {
            [result addObject: [[InputToken alloc] init]];
        } else if ([item hasPrefix: @"Query "] && [[item substringFromIndex: 6] intValue] >= 1) {
            int n = [[item substringFromIndex: 6] intValue];
            [result addObject: [[QueryPartToken alloc] initWithPartNumber: n]];
        } else {
            [result addObject: item];
        }
    }
    return result;
}

- (void) updateSelection {
    [self saveEdit];
    int rowIndex = [tableView selectedRow];
    if (rowIndex >= 0) {
        KeywordMapper* mapper = [[KeywurlPlugin sharedInstance] keywordMapper];
        KeywordMapping* mapping = [[mapper mappings] objectAtIndex: rowIndex];
        [expansionTokenField setObjectValue: [mapping expansionAsTokens]];
        [expansionTokenField setEnabled: YES];
        [encodeSpacesCheckbox setState: [mapping encodeSpaces] ? NSOnState : NSOffState];
        [encodeSpacesCheckbox setEnabled: YES];
        [dontUseUnicodeCheckBox setState: [mapping dontUseUnicode] ? NSOnState : NSOffState];
        [dontUseUnicodeCheckBox setEnabled: YES];
        mappingBeingEdited = mapping;
    } else {
        [expansionTokenField setEnabled: NO];
        [expansionTokenField setStringValue: @""];
        [encodeSpacesCheckbox setEnabled: NO];
        [encodeSpacesCheckbox setState: NSOffState];
        [dontUseUnicodeCheckBox setEnabled: NO];
        [dontUseUnicodeCheckBox setState: NSOffState];
        mappingBeingEdited = nil;
    }
}

- (void) saveEdit {
    KeywordMapping* mapping = mappingBeingEdited;
    if (mapping) {
        [mapping setEncodeSpaces: [encodeSpacesCheckbox state] == NSOnState];
        [mapping setDontUseUnicode: [dontUseUnicodeCheckBox state] == NSOnState];
        [mapping setExpansion: [[expansionTokenField objectValue] componentsJoinedByString: @""]];
    }
}

@end
