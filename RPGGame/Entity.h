// -*- mode: ObjC -*-
#ifndef _ENTIRY_H_
#define _ENTIRY_H_

#import <Foundation/Foundation.h>

#import "GameView.h"

@interface Entity : NSObject
{
  NSPoint   _worldLoc;
  NSInteger _speed;

  NSImage *_up1;
  NSImage *_up2;
  NSImage *_down1;
  NSImage *_down2;
  NSImage *_left1;
  NSImage *_left2;
  NSImage *_right1;
  NSImage *_right2;
  NSString *_direction;

  NSInteger _spliteCounter;
  NSInteger _spliteNumber;
}

- (instancetype) init;
- (CGFloat) worldX;
- (CGFloat) worldY;
@end

@class GameView;

@interface Player : Entity
{
  GameView *_view;
  KeyState *_keyState;
  NSPoint   _screenLoc;
}
- (instancetype) initWithView: (GameView *)view keyState: (KeyState *)keyState;
- (void) dealloc;
- (void) update;
- (void) draw;
- (CGFloat) screenX;
- (CGFloat) screenY;
- (NSRect) visibleBounds;
- (NSRect) visibleTileBounds;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
