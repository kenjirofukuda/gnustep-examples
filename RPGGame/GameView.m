// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"

const NSInteger ORIGINAL_TILE_SIZE = 16;
const NSInteger SCALE = 3;
const NSInteger TILE_SIZE = ORIGINAL_TILE_SIZE * SCALE;
const NSInteger MAX_SCREEN_COL = 16;
const NSInteger MAX_SCREEN_ROW = 12;
const NSInteger SCREEN_WIDTH = TILE_SIZE * MAX_SCREEN_COL;
const NSInteger SCREEN_HEIGHT = TILE_SIZE * MAX_SCREEN_ROW;
const NSInteger FPS = 60;

@interface Entity : NSObject
{
  NSInteger _x;
  NSInteger _y;
  NSInteger _speed;
}
@end


@implementation Entity
@end


@interface Player : Entity
{
  GameView *_view;
  KeyState *_keyState;
}
- (instancetype) initWithView: (GameView *)view keyState: (KeyState *)keyState;
- (void) setDefaultValues;
- (void) update;
- (void) draw;
@end

@implementation Player
- (instancetype) initWithView: (GameView *)view keyState: (KeyState *)keyState
{
  self = [super init];
  if (self != nil)
    {
      _view = view;
      _keyState = keyState;
      [self setDefaultValues];
    }
  return self;
}

- (void) setDefaultValues
{
  _x = 100;
  _y = 100;
  _speed = 4;
}

- (void) update
{
  if (_keyState->up == YES)
    _y += _speed;
  if (_keyState->down == YES)
    _y -= _speed;
  if (_keyState->left == YES)
    _x -= _speed;
  if (_keyState->right == YES)
    _x += _speed;
}

- (void) draw
{
  NSRect bounds = NSMakeRect(_x, _y, TILE_SIZE, TILE_SIZE);
  [[NSColor whiteColor] set];
  NSRectFill(bounds);
}

@end

@implementation GameView
- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  if (self != nil)
    {
      NSDebugLog(@"- (instancetype) initWithFrame: (NSRect)frameRect");
      _player = [[Player alloc] initWithView: self keyState: &_keyState];
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_timer);
  RELEASE(_player);
  RELEASE(_name);
  [super dealloc];
}

- (NSString *) name
{
  return _name;
}

- (void) setName: (NSString *)name
{
  ASSIGNCOPY(_name, name);
}

- (BOOL) acceptsFirstResponder
{
  return YES;
}

- (BOOL) acceptsFirstMouse: (NSEvent *)event
{
  return YES;
}

- (void) drawRect: (NSRect)rect
{
  [super drawRect: rect];
  NSRect frameRect = [self bounds];

  [[NSColor blackColor] set];
  NSRectFill(frameRect);
  [[NSColor whiteColor] set];
  [_player draw];
}

- (void) keyEvent: (NSEvent *)event on: (BOOL)newState
{
  BOOL      handled = NO;
  NSString *characters;
  unichar   keyChar = 0;

  characters = [event charactersIgnoringModifiers];
  if ([characters length] == 1)
    {
      keyChar = [characters characterAtIndex: 0];
      if (keyChar == NSHomeFunctionKey)
        {
        }
    }
  if (!handled && [characters isEqual: @"w"])
    {
      _keyState.up = newState;
      handled = YES;
    }
  if (!handled && [characters isEqual: @"s"])
    {
      _keyState.down = newState;
      handled = YES;
    }
  if (!handled && [characters isEqual: @"a"])
    {
      _keyState.left = newState;
      handled = YES;
    }
  if (!handled && [characters isEqual: @"d"])
    {
      _keyState.right = newState;
      handled = YES;
    }
}

- (void) keyDown: (NSEvent *)event
{
  [self keyEvent: event on: YES];
}

- (void) keyUp: (NSEvent *)event
{
  [self keyEvent: event on: NO];
}

- (void) step: (NSTimer *)timer
{
  [_player update];
  [self setNeedsDisplay: YES];
}

- (IBAction) startStepping: (id)sender
{
  NSDebugLog(@"startStepping: %@", sender);
  [self setFrameSize: NSMakeSize(SCREEN_WIDTH, SCREEN_HEIGHT)];
  _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / FPS
                                            target: self
                                          selector: @selector(step:)
                                          userInfo: nil
                                           repeats: YES];
  RETAIN(_timer);
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
