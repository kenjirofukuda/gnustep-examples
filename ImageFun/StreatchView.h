/* All rights reserved */

#import <AppKit/AppKit.h>

@interface StreatchView : NSView
{
  NSBezierPath *_path;
}

- (id) initWithFrame: (NSRect)rect;
- (NSPoint) randomPoint;
- (void) drawRect: (NSRect)rect;
- (void) dealloc;

@end
