/* All rights reserved */

#import <AppKit/AppKit.h>
#import "StreatchView.h"

@implementation StreatchView

- (void) drawRect: (NSRect)rect
{
  NSRect bounds = [self bounds];
  [[NSColor greenColor] set];
  [NSBezierPath fillRect: bounds];
}

@end
