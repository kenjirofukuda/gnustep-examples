/* All rights reserved */

#ifndef MyView_H_INCLUDE
#define MyView_H_INCLUDE

#import <AppKit/AppKit.h>

@interface MyView : NSView
{
  NSMutableArray *_points;
}
- (instancetype) initWithFrame: (NSRect) frameRect;
- (void) dealloc;

- (void) drawRect: (NSRect) area;
- (void) mouseDown: (NSEvent *) event;

@end

#endif // MyView_H_INCLUDE
