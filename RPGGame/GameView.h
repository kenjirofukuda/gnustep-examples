// -*- mode: ObjC -*-
#ifndef _GAMEVIEW_H_
#define _GAMEVIEW_H_

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

typedef struct KeyState
{
  BOOL up;
  BOOL down;
  BOOL left;
  BOOL right;
} KeyState;

@class Player;
@class TileManager;

@interface GameView : NSView
{
  NSTimer *_timer;
  Player *_player;
  KeyState _keyState;
  NSUInteger _drawCount;
  TileManager *_tileManager;
}
- (instancetype) initWithFrame: (NSRect)frameRect;
- (void) dealloc;
- (BOOL) acceptsFirstResponder;
- (BOOL) acceptsFirstMouse: (NSEvent *)event;
- (void) drawRect: (NSRect)rect;
- (void) step: (NSTimer *)timer;
- (void) keyDown: (NSEvent *)theEvent;
- (void) keyUp: (NSEvent *)theEvent;

- (Player *) player;
- (BOOL) anyKeyPressed;
- (NSImage *) imageOfResource: (NSString *)name inDirectory: (NSString *)subpath;
- (void) drawImage: image x: (CGFloat)x y: (CGFloat)y width: (CGFloat)width height: (CGFloat)height;
- (void) drawImage: image x: (CGFloat)x y: (CGFloat)y;

- (IBAction) startStepping: (id)sender;

@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
