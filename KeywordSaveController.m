#import "KeywordSaveController.h"
#import "KeywordMapper.h"
#import "KeywordMapping.h"
#import "KeywurlPlugin.h"

@interface KeywordSaveController (Internal)

- (void) collectFields: (NSMutableArray*) fields 
    fromElement: (DOMElement*) element;
- (void) collectButtons: (NSMutableDictionary*) buttons
    fromElement: (DOMElement*) element;

@end

@interface FormField : NSObject {
    NSString* name;
    NSString* value;
}

- initWithName: (NSString*) theName value: (NSString*) theValue;
- (NSString*) name;
- (NSString*) value;

@end

@implementation FormField 

- initWithName: (NSString*) theName value: (NSString*) theValue {
    name = [theName copy];
    value = [theValue copy];
    return self;
}

- (NSString*) name {
    return name;
}

- (NSString*) value {
    return value;
}

@end

@implementation KeywordSaveController

- (id) initWithUrl: (NSString*) theUrl
    inputElement: (DOMElement*) theInputElement
    formElement: (DOMElement*) theFormElement {
    url = [theUrl copy];
    inputElement = theInputElement;
    formElement = theFormElement; 
    if (![NSBundle loadNibNamed: @"SaveKeywordWindow" owner: self]) {
        NSLog(@"Could not load resource.");
        return nil;
    }
    {
        [buttonPopupButton removeAllItems];
        NSMutableDictionary* buttons = [NSMutableDictionary new];
        [self collectButtons: buttons fromElement: formElement];
        if ([buttons count] <= 1) {
            [buttonPopupButton setHidden: YES];
            [buttonPopupLabel setHidden: YES];
        } else {
            NSEnumerator* keyEumerator = [buttons keyEnumerator];
            NSString* name;
            int index = 0;
            while (name = [keyEumerator nextObject]) {
                NSString* value = (NSString*) [buttons objectForKey: name];
                if ([value length] == 0) {
                    value = @"Default button";
                }
                [buttonPopupButton insertItemWithTitle: value atIndex: index];
                NSMenuItem* item = [buttonPopupButton itemAtIndex: index];
                [item setRepresentedObject: name];
                index++;
            }
            [buttonPopupButton selectItemAtIndex: 0];
            [buttonPopupButton synchronizeTitleAndSelectedItem];
        }
    }
    [NSApp beginSheet: window
        modalForWindow: [NSApp keyWindow]
        modalDelegate: self
        didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
        contextInfo: nil];        
    return self;
}

- (void) saveKeyword: (id) sender {
    NSMutableArray* fields = [NSMutableArray new];
    [self collectFields: fields fromElement: formElement];
    NSURL* absoluteUrl = [NSURL URLWithString: url];
    NSString* action = [formElement action];
    NSURL* actionUrl = [NSURL URLWithString: action relativeToURL: absoluteUrl];
    NSMutableString* expansion = [NSMutableString new];
    [expansion appendString: [actionUrl absoluteString]];
    [expansion appendString: @"?"];
    for (int i = 0; i < [fields count]; i++) {
        FormField* field = (FormField*) [fields objectAtIndex: i];
        [expansion appendString: [[field name] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        [expansion appendString: @"="];
        [expansion appendString: [[field value] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        [expansion appendString: @"&"];
    }
    NSMenuItem* buttonItem = [buttonPopupButton selectedItem];
    if (buttonItem) {
        [expansion appendString: [[buttonItem representedObject] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        [expansion appendString: @"="];
        [expansion appendString: [[buttonItem title] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        [expansion appendString: @"&"];
    }
    [expansion appendString: [inputElement name]];
    [expansion appendString: @"={query}"];
    NSString* keyword = [nameTextField stringValue];
    KeywordMapping* mapping = [[KeywordMapping alloc] initWithKeyword: keyword
        expansion: expansion];
    KeywordMapper* mapper = [[KeywurlPlugin sharedInstance] keywordMapper];
    [mapper addKeyword: mapping];
    [NSApp endSheet: window];

    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle: @"OK"];
    [alert setMessageText: @"Keyword added"];
    [alert setInformativeText: [NSString stringWithFormat:
        @"You can now type '%@ something' in Safari's address field to do a search for 'something'", keyword]];
    [alert setAlertStyle: NSInformationalAlertStyle];
    [alert beginSheetModalForWindow: [NSApp keyWindow]
        modalDelegate: nil
        didEndSelector: nil
        contextInfo: nil];
}

- (void) cancel: (id) sender {
    [NSApp endSheet: window];    
}

- (void) didEndSheet: (NSWindow*) sheet returnCode: (int) returnCode 
    contextInfo: (void*) contextInfo 
{ 
    [window orderOut: self];
}

- (void) collectFields: (NSMutableArray*) fields 
    fromElement: (DOMElement*) element {
    DOMNodeList* children = [element childNodes];
    for (int i = 0; i < [children length]; i++) {
        DOMNode* node = [children item: i];
        if ([node isKindOfClass: [DOMElement class]]) {
            [self collectFields: fields fromElement: (DOMElement*) node];
        }
    }
    if (element != inputElement && [element respondsToSelector: @selector(disabled)] &&
        ![element disabled]) {
        NSString* tag = [[element tagName] lowercaseString];
        if ([tag isEqualToString: @"textarea"] || (
            [tag isEqualToString: @"input"] &&
            ([[element getAttribute: @"type"] isEqualToString: @"hidden"] ||
            ([[element getAttribute: @"type"] isEqualToString: @"radio"] && [element checked]) ||
            ([[element getAttribute: @"type"] isEqualToString: @"checkbox"] && [element checked])))) {
            [fields addObject: [[FormField alloc] initWithName: [element name] value: [element value]]];
        } else if ([tag isEqualToString: @"select"] &&
            ![element multiple] && [element selectedIndex] != -1) {
            [fields addObject: [[FormField alloc] initWithName: [element name] value: [element value]]];
        } else if ([tag isEqualToString: @"select"] && [element multiple]) {
            DOMHTMLOptionsCollection* options = [element options];
            for (int i = 0; i < [options length]; i++) {
                DOMHTMLOptionElement* option = [options item: i];
                if ([option selected]) {
                    [fields addObject: [[FormField alloc] initWithName: [element name] 
                        value: [option value]]];
                }
            }
        }
    }
}

- (void) collectButtons: (NSMutableDictionary*) buttons
    fromElement: (DOMElement*) element {
    DOMNodeList* children = [element childNodes];
    for (int i = 0; i < [children length]; i++) {
        DOMNode* node = [children item: i];
        if ([node isKindOfClass: [DOMElement class]]) {
            [self collectButtons: buttons fromElement: (DOMElement*) node];
        }
    }
    NSString* tag = [[element tagName] lowercaseString];
    if ([tag isEqualToString: @"input"] &&
        ([[element getAttribute: @"type"] isEqualToString: @"submit"] ||
        [[element getAttribute: @"type"] isEqualToString: @"image"])) {
        [buttons setObject: [element value] forKey: [element name]];
    }
}

@end
