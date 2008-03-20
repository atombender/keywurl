#import "KeywurlPlugin.h"
#import "KeywurlPreferences.h"

@interface KeywurlPreferences (Private)

- (void) saveEdit;
- (void) leaveEdit;
- (void) updateSelection;
- (void) reloadKeywords;

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
    [mapper release];
    [keywords release];
    if (mappingBeingEdited) [mappingBeingEdited release];
    [super dealloc];
}

- (void) awakeFromNib {
    mapper = [[[KeywurlPlugin sharedInstance] keywordMapper] retain];
    
    keywords = [NSMutableArray new];
    [self reloadKeywords];

/*  NSDictionary* infoDictionary = [[NSBundle bundleWithIdentifier: @"net.purefiction.keywurl"] 
        infoDictionary];
*/

    [tableView setDataSource: self];
    
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
    [self saveEdit];
    [self leaveEdit];
    [mapper addKeyword: @"" expansion: @""];
    [keywords addObject: @""];
    int rowIndex = [keywords count] - 1;
    [tableView reloadData];
    [tableView scrollRowToVisible: rowIndex];
    [tableView selectRowIndexes: [NSIndexSet indexSetWithIndex: rowIndex] byExtendingSelection: NO];
    [tableView editColumn: 0 row: rowIndex withEvent: nil select: YES];
    [self updateSelection];
}

- (IBAction) removeKeyword: (id) sender {
    int rowIndex = [tableView selectedRow];
    if (rowIndex >= 0) {
        [self leaveEdit];
        NSString* keyword = [keywords objectAtIndex: rowIndex];
        [keywords removeObject: keyword];
        [mapper removeKeyword: keyword];
        [tableView reloadData];
        [self updateSelection];
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
    atIndex: (unsigned) index {
    NSMutableArray* result = [NSMutableArray new];
    for (unsigned i = 0; i < [tokens count]; i++) {
        id item = [tokens objectAtIndex: i];
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
    [self leaveEdit];
    NSString* keyword = [tableView selectedRow] >= 0 ? [keywords objectAtIndex: [tableView selectedRow]] : nil;
    if (keyword) {
        KeywordMapping* mapping = [mapper mappingForKeyword: keyword];
        [expansionTokenField setObjectValue: [mapping expansionAsTokens]];
        [encodeSpacesCheckbox setState: [mapping encodeSpaces] ? NSOnState : NSOffState];
        [dontUseUnicodeCheckBox setState: [mapping dontUseUnicode] ? NSOnState : NSOffState];
        mappingBeingEdited = [mapping retain];
    } else {
        [expansionTokenField setStringValue: @""];
        [encodeSpacesCheckbox setState: NSOffState];
        [dontUseUnicodeCheckBox setState: NSOffState];
    }
    [expansionTokenField setEnabled: keyword != nil];
    [encodeSpacesCheckbox setEnabled: keyword != nil];
    [dontUseUnicodeCheckBox setEnabled: keyword != nil];
    [sourceTokenField setEnabled: keyword != nil];
}

- (void) saveEdit {
    KeywordMapping* mapping = mappingBeingEdited;
    if (mapping) {
        [mapping setEncodeSpaces: [encodeSpacesCheckbox state] == NSOnState];
        [mapping setDontUseUnicode: [dontUseUnicodeCheckBox state] == NSOnState];
        [mapping setExpansion: [[expansionTokenField objectValue] componentsJoinedByString: @""]];
        [mapper modified];
    }
}

- (void) leaveEdit {
    if (mappingBeingEdited) {
        [mappingBeingEdited release];
        mappingBeingEdited = nil;
    }
}

- (void) reloadKeywords {
    [keywords removeAllObjects];
    NSArray* mappings = [mapper mappings];
    for (int i = 0; i < [mappings count]; i++) {
        KeywordMapping* mapping = [mappings objectAtIndex: i];
        [keywords addObject: [mapping keyword]];
    }
    [keywords sortUsingSelector: @selector(caseInsensitiveCompare:)];
}

/* Table view data source methods */

- (int) numberOfRowsInTableView: (NSTableView*) aTableView {
    return [keywords count];
}

- (id) tableView: (NSTableView*) aTableView 
    objectValueForTableColumn: (NSTableColumn*) aTableColumn
    row: (int) rowIndex {
    if ([[aTableColumn identifier] isEqualToString: @"Keyword"]) {
        NSString* keyword = [keywords objectAtIndex: rowIndex];
        if (keyword) {        
            KeywordMapping* mapping = [mapper mappingForKeyword: keyword];
            return [mapping keyword];
        }
    }
    return nil;
}

- (void) tableView: (NSTableView*) aTableView 
    setObjectValue: (id) newValue
    forTableColumn: (NSTableColumn*) aTableColumn 
    row: (int) rowIndex {
    if ([[aTableColumn identifier] isEqualToString: @"Keyword"]) {
        NSString* keyword = [keywords objectAtIndex: rowIndex];
        if (keyword) {
            KeywordMapping* mapping = [mapper mappingForKeyword: keyword];
            if (mapping) {
                if ([newValue length] == 0) {
                    [keywords removeObject: keyword];
                    [mapper removeKeyword: keyword];
                    mapping = nil;
                } else {
                    [mapping setKeyword: newValue];
                    [mapper modified];
                }
                [self reloadKeywords];
                [tableView reloadData];
                if (mapping) {
                    int rowIndex = [keywords indexOfObject: [mapping keyword]];
                    [tableView scrollRowToVisible: rowIndex];
                    [tableView selectRowIndexes: [NSIndexSet indexSetWithIndex: rowIndex] byExtendingSelection: NO];
                }
            }
        }
    }
    [self updateSelection];
}

@end
