// -*- mode: ObjC -*-
#ifndef _GAMEVIEW_H_
#define _GAMEVIEW_H_

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


extern const NSInteger ORIGINAL_TILE_SIZE;
extern const NSInteger SCALE;
extern const NSInteger TILE_SIZE;
extern const NSInteger MAX_SCREEN_COL;
extern const NSInteger MAX_SCREEN_ROW;
extern const NSInteger SCREEN_WIDTH;
extern const NSInteger SCREEN_HEIGHT;
extern const NSInteger MAX_WORLD_COL;
extern const NSInteger MAX_WORLD_ROW;
extern const NSInteger WORLD_WIDTH;
extern const NSInteger WORLD_HEIGHT;
extern const NSInteger FPS;

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
