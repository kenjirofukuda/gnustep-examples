// -*- mode: objc; -*-
/* All rights reserved */

#import <AppKit/AppKit.h>

@interface StretchView : NSView
{
  NSBezierPath* _path;
  NSImage* _image;
  float _opacity;
  NSPoint _downPoint;
  NSPoint _currentPoint;
}

- (instancetype) initWithFrame: (NSRect)rect;
- (void) drawRect: (NSRect)rect;
- (void) mouseDown: (NSEvent*)event;
- (void) mouseDragged: (NSEvent*)event;
- (void) mouseUp: (NSEvent*)event;
- (void) dealloc;

- (NSPoint) randomPoint;
- (void) setImage: (NSImage*)x;
- (void) setOpacity: (float)x;
- (NSRect) currentRect;
@end
