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

  NSImage *_up1;
  NSImage *_up2;
  NSImage *_down1;
  NSImage *_down2;
  NSImage *_left1;
  NSImage *_left2;
  NSImage *_right1;
  NSImage *_right2;
  NSString *_direction;

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
- (void) dealloc;
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
      [self _setDefaultValues];
      [self _loadImages];
    }
  return self;
}
- (void) dealloc
{
  RELEASE(_up1);
  RELEASE(_up2);
  RELEASE(_down1);
  RELEASE(_down2);
  RELEASE(_left1);
  RELEASE(_left2);
  RELEASE(_right1);
  RELEASE(_right2);
  DEALLOC;
}

- (void) _setDefaultValues
{
  _x = 100;
  _y = 100;
  _speed = 4;
  _direction = @"down";
}

- (void) _loadImages
{
  NSBundle *bundle = [NSBundle mainBundle];
  _up1 = [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: @"boy_up_1"]];
  _up2 = [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: @"boy_up_2"]];
  _down1 = [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: @"boy_down_1"]];
  _down2 = [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: @"boy_down_2"]];
  _left1 = [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: @"boy_left_1"]];
  _left2 = [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: @"boy_left_2"]];
  _right1 = [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: @"boy_right_1"]];
  _right2 = [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: @"boy_right_2"]];
}


- (void) update
{
  if (_keyState->up == YES)
    {
      _direction = @"up";
      _y += _speed;
    }

  if (_keyState->down == YES)
    {
      _direction = @"down";
      _y -= _speed;
    }

  if (_keyState->left == YES)
    {
      _direction = @"left";
      _x -= _speed;
    }

  if (_keyState->right == YES)
    {
      _direction = @"right";
      _x += _speed;
    }
}

- (void) draw
{
  NSImage *image = nil;

  if ([_direction isEqualToString: @"up"])
    {
      image = _up1;
    }
  else if ([_direction isEqualToString: @"down"])
    {
      image = _down1;
    }
  else if ([_direction isEqualToString: @"left"])
    {
      image = _left1;
    }
  else if ([_direction isEqualToString: @"right"])
    {
      image = _right1;
    }
  if (image != nil)
    {
      NSRect imageRect;
      NSRect drawRect;

      imageRect.origin = NSMakePoint(0, 0);
      imageRect.size = [image size];
      drawRect.origin = NSMakePoint(_x, _y);
      drawRect.size = NSMakeSize(TILE_SIZE, TILE_SIZE);

      [image drawInRect: drawRect
               fromRect: imageRect
              operation: NSCompositeSourceOver
               fraction: 1.0];
    }
  else
    {
      // error occured fallbuck!!!
      NSRect bounds = NSMakeRect(_x, _y, TILE_SIZE, TILE_SIZE);
      [[NSColor whiteColor] set];
      NSRectFill(bounds);
    }
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
