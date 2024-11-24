/* All rights reserved */

#import "PointsView.h"

@interface PointsView (Tracking)
- (void) _frameChanged: (NSNotification *) aNot;
- (void) _removeTrack;
@end

@interface PointsView (SimpleDrawing)
- (NSBezierPath *) circlePathWithCenter: (NSPoint)center radius: (CGFloat)radius;
@end

@implementation PointsView (SimpleDrawing)

- (NSBezierPath *) circlePathWithCenter: (NSPoint)center radius: (CGFloat)radius
{
  CGFloat size = radius + radius;
  NSRect bounds = NSMakeRect(
                    center.x - radius,
                    center.y - radius,
                    size,
                    size);

  NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect: bounds];
  return path;
}


@end


@implementation PointsView
- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  if (self != nil)
    {
      _points = [[NSMutableArray alloc] init];
#ifndef GNUSTEP
      _trackingArea = nil;
#endif
      [[NSNotificationCenter defaultCenter] 
        addObserver: self
           selector: @selector(_frameChanged:)
               name: NSViewFrameDidChangeNotification
             object: self];
      _trackId = 0;      
    }
  return self;
}

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver: self];
  RELEASE(_points);
#ifndef GNUSTEP
  RELEASE(_trackingArea);
#endif
  DEALLOC;
}

- (void) drawRect: (NSRect)area
{
  [[NSColor whiteColor] set];
  NSRectFill(area);
  [[NSColor blackColor] set];
  NSFrameRect(area);

  for (NSValue * pv in _points)
    {
      NSBezierPath *path = [self circlePathWithCenter: [pv pointValue]
                                               radius: 3.0f];
      [path fill];
    }
}

- (void) viewDidMoveToWindow
{
  [super viewDidMoveToWindow];
  [[NSNotificationCenter defaultCenter] postNotificationName: NSViewFrameDidChangeNotification
                                                      object: self];

}

- (void) mouseDown: (NSEvent *)event
{
  NSPoint loc = [self convertPoint: [event locationInWindow] fromView: nil];
  NSLog(@"loc: %@", NSStringFromPoint(loc));
  [_points addObject: [NSValue valueWithPoint: loc]];
  [self setNeedsDisplay: YES];
}

- (void) mouseEntered: (NSEvent *)event
{
  NSLog(@"mouseEntered: %@", event);
  [super mouseEntered: event];
  [[NSCursor crosshairCursor] set];
}

- (void) mouseExited: (NSEvent *)event
{
  NSLog(@"mouseExited: %@", event);
  [super mouseExited: event];
  [[NSCursor arrowCursor] set];
}

#ifndef GNUSTEP  
- (void) updateTrackingAreas
{
  [super updateTrackingAreas];
  if (_trackingArea != nil)
    {
      [self removeTrackingArea: _trackingArea];
      RELEASE(_trackingAreaa);
    }

  int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  _trackingArea = [[NSTrackingArea alloc] initWithRect: [self bounds]
                                               options: opts
                                                 owner: self
                                              userInfo: nil];
  [self addTrackingArea: _trackingArea];
}
#endif
@end

@implementation PointsView (Tracking)
- (void) _frameChanged: (NSNotification *) aNot
{
  [self _removeTrack];
  _trackId = [self addTrackingRect: [self bounds]
                             owner: self
                          userData: NULL
                      assumeInside: NO];
}

- (void) _removeTrack
{
  if (_trackId)
    [self removeTrackingRect: _trackId];
  _trackId = 0;
}

@end
