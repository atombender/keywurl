#import "KeywurlPlugin.h"
#import "KeywurlPreferences.h"

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

- (void) awakeFromNib
{
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

- (void)moduleWasInstalled
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

@end
