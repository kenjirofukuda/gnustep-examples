/* -*- mode: objc -*- */
/* All rights reserved */

#import <AppKit/AppKit.h>

@interface BigLetterView : NSView
{
  IBOutlet NSColor *bgColor;
  IBOutlet NSString *string;
  NSMutableDictionary *attributes;
  BOOL highlighted;
}

- (instancetype) initWithFrame: (NSRect)rect;

- (void) setBgColor: (NSColor *)c;
- (NSColor *) bgColor;
- (void) setString: (NSString *)s;
- (NSString *) string;

- (void) prepareAttributes;
- (void) drawStringCenteredIn: (NSRect)r;
- (void) writeStringToPasteboard: (NSPasteboard *)pb;
- (BOOL) readStringFromPasteboard: (NSPasteboard *)pb;

- (IBAction) savePDF: (id)sender;
- (IBAction) cut: (id)sender;
- (IBAction) copy: (id)sender;
- (IBAction) paste: (id)sender;
@end
