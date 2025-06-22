// -*- mode: ObjC -*-
#ifndef _ENTIRY_H_
#define _ENTIRY_H_

#import <Foundation/Foundation.h>

#import "GameView.h"

@class GameView;

@interface Entity : NSObject
{
  GameView *_view;
  NSPoint   _worldLoc;
  NSPoint   _screenLoc;
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
  BOOL _showsSolidArea;
  NSMutableArray *_dialogs;
  NSUInteger _dialogIndex;
}

- (instancetype) initWithView: (GameView *)view;
- (void) dealloc;
- (Direction) direction;
- (CGFloat) speed;
- (CGFloat) worldX;
- (void) setWorldX: (CGFloat)value;
- (CGFloat) worldY;
- (void) setWorldY: (CGFloat)value;
- (NSRect) solidArea;
- (void) setSolidArea: (NSRect)area;
- (NSRect) worldSolidArea;
- (NSRect) peekStepedSolidArea;
- (void) setCollisionOn: (BOOL)state;
- (BOOL) showsSolidArea;
- (void) setShowsSolidArea: (BOOL) state;

- (void) speak;
- (void) action;
- (void) update;
- (void) draw;
- (NSImage *) _imageOfResource: (NSString *)name inDirectory: (NSString *)subDirectory;

@end // Entity


@interface Player : Entity
{
  BOOL* _keyState;
  BOOL _hasKey;
}
- (instancetype) initWithView: (GameView *)view keyState: (BOOL [])keyState;
- (void) update;
- (int) hasKey;
- (CGFloat) screenX;
- (CGFloat) screenY;
- (NSRect) visibleRect;
- (NSRect) visibleTileRect;
@end // Player


@interface NPCOldMan : Entity
{
  int _actionLockCounter;
}
- (instancetype) initWithView: (GameView *)view;
- (void) action;
- (void) update;
@end // NPCOldMan



#endif
// vim: filetype=objc ts=2 sw=2 expandtab
