/* All rights reserved */

#ifndef MyView_H_INCLUDE
#define MyView_H_INCLUDE

#import <AppKit/AppKit.h>

@interface PointsView : NSView
{
  NSMutableArray *_points;
#ifndef GNUSTEP  
  NSTrackingArea *_trackingArea;
#endif
  NSTrackingRectTag _trackId;

}
- (instancetype) initWithFrame: (NSRect) frameRect;
- (void) dealloc;

- (void) drawRect: (NSRect) area;
- (void) mouseDown: (NSEvent *) event;
- (void) mouseEntered: (NSEvent *)event;
- (void) mouseExited: (NSEvent *)event;
- (void) viewDidMoveToWindow;

#ifndef GNUSTEP  
- (void) updateTrackingAreas;
#endif

@end

#endif // MyView_H_INCLUDE
