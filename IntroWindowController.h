#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface IntroWindowController : NSObject {
    IBOutlet id window;
}

+ (BOOL) shouldShow;

- (id) init;
- (void) show;
- (void) close: (id) sender;
@end
