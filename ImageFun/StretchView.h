/* All rights reserved */

#import <AppKit/AppKit.h>

@interface StretchView : NSView
{
  NSBezierPath *_path;
  NSImage *_image;
  float _opacity;
}

- (id) initWithFrame: (NSRect)rect;
- (NSPoint) randomPoint;
- (void) drawRect: (NSRect)rect;
- (void) dealloc;

- (void) setImage: (NSImage *)x;
- (void) setOpacity: (float)x;
@end
