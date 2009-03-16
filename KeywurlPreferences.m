#import "KeywurlPlugin.h"
#import "KeywurlPreferences.h"

@interface KeywurlPreferences (Private)

- (void) saveEdit;
- (void) leaveEdit;
- (void) reloadKeywords;
- (void) selectKeyword: (NSString*) keyword;
- (void) selectKeyword: (NSString*) keyword edit: (BOOL) edit;
- (void) updateForm;

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
        [[InputToken alloc] init],
        [[QueryToken alloc] init],
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
        selector: @selector(mappingsDidChange:)
        name: KeywordMapperMappingsDidChangeNotification
        object: mapper];
	[[NSNotificationCenter defaultCenter] addObserver: self
	    selector: @selector(tableViewSelectionDidChange:)
	    name: NSTableViewSelectionDidChangeNotification
        object: tableView];
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
    [mapper addKeyword: @"" expansion: @""];
    [self selectKeyword: @"" edit: YES];
}

- (IBAction) removeKeyword: (id) sender {
    int rowIndex = [tableView selectedRow];
    if (rowIndex >= 0) {
        [self leaveEdit];
        NSString* keyword = [keywords objectAtIndex: rowIndex];
        [mapper removeKeyword: keyword];
    }
}

- (void) tableViewSelectionDidChange: (NSNotification*) notification {
    [self saveEdit];
    NSString* keyword = [tableView selectedRow] >= 0 ? [keywords objectAtIndex: [tableView selectedRow]] : nil;
    if (keyword) {
        KeywordMapping* mapping = [mapper mappingForKeyword: keyword];
        mappingBeingEdited = [mapping retain];
    } else {
        if (mappingBeingEdited) {
            [mappingBeingEdited release];
            mappingBeingEdited = nil;
        }
    }
    [self updateForm];
}

- (void) updateForm {
    if (mappingBeingEdited) {
        [expansionTokenField setObjectValue: [mappingBeingEdited expansionAsTokens]];
        [encodeSpacesCheckbox setState: [mappingBeingEdited encodeSpaces] ? NSOnState : NSOffState];
        [dontUseUnicodeCheckBox setState: [mappingBeingEdited dontUseUnicode] ? NSOnState : NSOffState];        
    } else {
        [expansionTokenField setStringValue: @""];
        [encodeSpacesCheckbox setState: NSOffState];
        [dontUseUnicodeCheckBox setState: NSOffState];        
    }
    [expansionTokenField setEnabled: mappingBeingEdited != nil];
    [encodeSpacesCheckbox setEnabled: mappingBeingEdited != nil];
    [dontUseUnicodeCheckBox setEnabled: mappingBeingEdited != nil];
    [sourceTokenField setEnabled: mappingBeingEdited != nil];    
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
        if ([item isEqualToString: @"complete query"]) {
            [result addObject: [[QueryToken alloc] init]];
        } else if ([item isEqualToString: @"complete location field"]) {
            [result addObject: [[InputToken alloc] init]];
        } else if ([item hasPrefix: @"query word "] && [[item substringFromIndex: 11] intValue] >= 1) {
            int n = [[item substringFromIndex: 11] intValue];
            [result addObject: [[QueryPartToken alloc] initWithPartNumber: n]];
        } else {
            [result addObject: item];
        }
    }
    return result;
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
        [self updateForm];
    }
}

- (void) reloadKeywords {
    if (!reloading) {
        reloading = YES;
        @try {
            [self saveEdit];
    
            // Get currently selected keywod
            int rowIndex = [tableView selectedRow];
            NSString* keyword = rowIndex >= 0 && rowIndex < [keywords count] ? 
                [keywords objectAtIndex: [tableView selectedRow]] : nil;
            if (keyword) [keyword retain];

            // Build new, sorted keyword list
            [keywords removeAllObjects];
            NSArray* mappings = [mapper mappings];
            for (int i = 0; i < [mappings count]; i++) {
                KeywordMapping* mapping = [mappings objectAtIndex: i];
                [keywords addObject: [mapping keyword]];
            }
            [keywords sortUsingSelector: @selector(caseInsensitiveCompare:)];
            int emptyIndex = [keywords indexOfObject: @""];
            if (emptyIndex != NSNotFound) {
                [keywords removeObjectAtIndex: emptyIndex];
                [keywords addObject: @""];
            }
            [tableView reloadData];

            // Reselect previously selected
            [self selectKeyword: keyword];
            if (keyword) [keyword release];
        } @finally {
            reloading = NO;
        }
    }
}

- (void) selectKeyword: (NSString*) keyword edit: (BOOL) edit {
    if (keyword) {
        int rowIndex = [keywords indexOfObject: keyword];
        if (rowIndex != NSNotFound) {
            [tableView scrollRowToVisible: rowIndex];
            [tableView selectRowIndexes: [NSIndexSet indexSetWithIndex: rowIndex] byExtendingSelection: NO];
            if (edit) {
                [tableView editColumn: 0 row: rowIndex withEvent: nil select: YES];
            }
        }
    }
}

- (void) selectKeyword: (NSString*) keyword {
    [self selectKeyword: keyword edit: NO];
}

/* Mapper notifications */

- (void) mappingsDidChange: (NSNotification*) notification {
    [self reloadKeywords];
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
                    [self selectKeyword: [mapping keyword]];
                }
            }
        }
    }
}

@end
