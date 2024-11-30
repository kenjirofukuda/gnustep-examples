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
  Direction _direction;
  NSInteger _spliteCounter;
  NSInteger _spliteNumber;
  NSRect _solidArea;
  BOOL _collisionOn;
}

- (instancetype) init;
- (Direction) direction;
- (CGFloat) speed;
- (CGFloat) worldX;
- (CGFloat) worldY;
- (NSRect) solidArea;
- (void) setSolidArea: (NSRect)area;
- (void) setCollisionOn: (BOOL)state;
@end

@class GameView;

@interface Player : Entity
{
  GameView *_view;
  BOOL* _keyState;
  NSPoint   _screenLoc;
}
- (instancetype) initWithView: (GameView *)view keyState: (BOOL *)keyState;
- (void) dealloc;
- (void) update;
- (void) draw;
- (CGFloat) screenX;
- (CGFloat) screenY;
- (NSRect) visibleRect;
- (NSRect) visibleTileRect;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
