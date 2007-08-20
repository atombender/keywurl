#import "NSPreferences+Keywurl.h"
#import "KeywurlPreferences.h"

@implementation NSPreferences_Keywurl

+ (void) load
{
	[NSPreferences_Keywurl poseAsClass: [NSPreferences class]];
}

+ (id) sharedPreferences
{
    NSLog(@"sharedPreferences");
	static BOOL	added = NO;
	id preferences = [super sharedPreferences];
	if (preferences != nil && !added)
	{
		added = YES;
		[preferences addPreferenceNamed: @"Keywurl" owner: [KeywurlPreferences sharedInstance]];
	}	
	return preferences;
}

@end
