/* All rights reserved */

#import "MyView.h"

@interface MyView(SimpleDrawing)
- (NSBezierPath *) circlePathWithCenter: (NSPoint)center radius: (CGFloat)radius;
@end

@implementation MyView(SimpleDrawing)

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


@implementation MyView
- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  _points = [[NSMutableArray alloc] init];
  return self;
}

- (void) dealloc
{
  RELEASE(_points);
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

- (void) mouseDown: (NSEvent *)event
{
  NSPoint loc = [self convertPoint: [event locationInWindow] fromView: nil];
  NSLog(@"loc: %@", NSStringFromPoint(loc));
  [_points addObject: [NSValue valueWithPoint: loc]];
  [self setNeedsDisplay: YES];
}


@end
