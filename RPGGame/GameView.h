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

@interface GameView : NSView
{
  NSString *_name;
  NSTimer *_timer;
  Player *_player;
  KeyState _keyState;
  NSUInteger _drawCount;

}
- (instancetype) initWithFrame: (NSRect)frameRect;
- (void) dealloc;
- (BOOL) acceptsFirstResponder;
- (BOOL) acceptsFirstMouse: (NSEvent *)event;
- (void) drawRect: (NSRect)rect;
- (void) step: (NSTimer *)timer;
- (void) keyDown: (NSEvent *)theEvent;
- (void) keyUp: (NSEvent *)theEvent;

- (BOOL) anyKeyPressed;

- (IBAction) startStepping: (id)sender;

@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
