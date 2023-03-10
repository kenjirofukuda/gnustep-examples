/* All rights reserved */

#import <AppKit/AppKit.h>
#import "StretchView.h"

@implementation StretchView

- (id) initWithFrame: (NSRect)rect
{
  int i;
  NSPoint p;

  if (self = [super initWithFrame: rect])
    {
      srandom(time(NULL));
      ASSIGN(_path, [[NSBezierPath alloc] init]);
      [_path setLineWidth: 2.3];
      p = [self randomPoint];
      [_path moveToPoint: p];
      for (i = 0; i < 15; i++)
        {
          p = [self randomPoint];
          [_path lineToPoint: p];
        }
      [_path closePath];
    }
  return self;
}


- (NSPoint) randomPoint
{
  NSPoint result;
  NSRect r;
  int width, height;

  r = [self bounds];
  width = round(r.size.width);
  height = round(r.size.height);
  result.x = (random() % width) + r.origin.x;
  result.y = (random() % height) + r.origin.y;
  return result;
}


- (void) drawRect: (NSRect)rect
{
  NSRect bounds = [self bounds];
  [[NSColor greenColor] set];
  [NSBezierPath fillRect: bounds];

  [[NSColor whiteColor] set];
  [_path stroke];
  if (_image)
    {
      NSRect imageRect;
      NSRect drawingRect;
      imageRect.origin.x = 0;
      imageRect.origin.y = 0;
      imageRect.size = [_image size];
      drawingRect = [self currentRect];
      [_image drawInRect: drawingRect
                fromRect: imageRect
               operation: NSCompositeSourceOver
                fraction: _opacity];
    }
}


- (void) dealloc
{
  RELEASE(_image);
  RELEASE(_path);
  DEALLOC;
}


- (void) setOpacity: (float)x
{
  _opacity = x;
  [self setNeedsDisplay: YES];
}

- (void) setImage: (NSImage *)x
{
  ASSIGN(_image, x);
  [self setNeedsDisplay: YES];
}


- (void) mouseDown: (NSEvent *)event
{
  NSPoint windowPoint = [event locationInWindow];
  _downPoint = [self convertPoint: windowPoint fromView: nil];
  _currentPoint = _downPoint;
  [self setNeedsDisplay: YES];
}


- (void) mouseDragged: (NSEvent *)event
{
  NSPoint windowPoint = [event locationInWindow];
  _currentPoint = [self convertPoint: windowPoint fromView: nil];
  [self setNeedsDisplay: YES];
}


- (void) mouseUp: (NSEvent *)event
{
  NSPoint windowPoint = [event locationInWindow];
  _currentPoint = [self convertPoint: windowPoint fromView: nil];
  [self setNeedsDisplay: YES];
}

- (NSRect) currentRect
{
  CGFloat minX = MIN(_downPoint.x, _currentPoint.x);
  CGFloat minY = MIN(_downPoint.y, _currentPoint.y);
  CGFloat maxX = MAX(_downPoint.x, _currentPoint.x);
  CGFloat maxY = MAX(_downPoint.y, _currentPoint.y);
  return NSMakeRect(minX, minY, maxX - minX, maxY - minY);
}



@end
