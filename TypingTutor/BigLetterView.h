/* -*- mode: objc -*- */
/* All rights reserved */

#import <AppKit/AppKit.h>

@interface BigLetterView : NSView
{
  IBOutlet NSColor *bgColor;
  IBOutlet NSString *string;
  NSMutableDictionary *attributes;
}

- (instancetype) initWithFrame: (NSRect)rect;

- (void) setBgColor: (NSColor *)c;
- (NSColor *) bgColor;
- (void) setString: (NSString *)s;
- (NSString *) string;

- (void) prepareAttributes;
- (void) drawStringCenteredIn: (NSRect)r;

- (IBAction) savePDF: (id)sender;
@end
