#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface KeywordSaveController : NSObject {
    IBOutlet id nameTextField;
    IBOutlet id window;
    IBOutlet id buttonPopupLabel;
    IBOutlet id buttonPopupButton;
    DOMElement* inputElement;
    DOMElement* formElement;
    NSString* url;
}

- (id) initWithUrl: (NSString*) theUrl
    inputElement: (DOMElement*) theInputElement
    formElement: (DOMElement*) theFormElement;
- (void) saveKeyword: (id) sender;
- (void) cancel: (id) sender;
@end
