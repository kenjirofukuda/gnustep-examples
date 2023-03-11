/* All rights reserved */

#import <AppKit/AppKit.h>

@interface BigLetterView : NSView
{
  IBOutlet NSColor *bgColor;
  IBOutlet NSString *string;
}

- (instancetype) initWithFrame: (NSRect)rect;
- (void) setBgColor: (NSColor *)c;
- (NSColor *) bgColor;
- (void) setString: (NSString *)s;
- (NSString *) string;
@end
