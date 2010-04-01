#ifdef __OBJC2__
#include <objc/objc.h>
#include <objc/runtime.h>
#endif

#import "NSPreferences+Keywurl.h"
#import "KeywurlPreferences.h"

#ifdef __OBJC2__
@implementation NSPreferences (Keywurl_NSPreferences)
#else
@implementation NSPreferences_Keywurl
#endif

+ (void) load
{
#ifdef __OBJC2__
	Class c = [self class];
	
	Method old = class_getClassMethod(c, @selector(sharedPreferences));
	Method new = class_getClassMethod(c, @selector(_Keywurl_sharedPreferences));
	
	method_exchangeImplementations(old, new);
#else
	[NSPreferences_Keywurl poseAsClass: [NSPreferences class]];
#endif
}

#ifdef __OBJC2__
+ (id) _Keywurl_sharedPreferences
#else
+ (id) sharedPreferences
#endif
{
	static BOOL	added = NO;
#ifdef __OBJC2__
	id preferences = [self _Keywurl_sharedPreferences];
#else
	id preferences = [super sharedPreferences];
#endif
	if (preferences != nil && !added)
	{
		added = YES;
		[preferences addPreferenceNamed: @"Keywurl" owner: [KeywurlPreferences sharedInstance]];
	}	
	return preferences;
}

@end
