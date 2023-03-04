/* All rights reserved */

#import <AppKit/AppKit.h>
#import "StreatchView.h"

@implementation StreatchView

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
}


- (void) dealloc
{
  RELEASE(_path);
  DEALLOC
}

@end
