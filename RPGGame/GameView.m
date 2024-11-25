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

@implementation GameView
- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  if (self != nil)
    {
      NSDebugLog(@"- (instancetype) initWithFrame: (NSRect)frameRect");
      _player.bounds = NSMakeRect(100, 100, TILE_SIZE, TILE_SIZE);
      _player.speed = 4;
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_timer);
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
  // NSAffineTransform *xform = [NSAffineTransform transform];
  // [xform translateXBy: 0.0 yBy: frameRect.size.height];
  // [xform scaleXBy: 1.0 yBy: -1.0];
  // [xform concat];

  [[NSColor blackColor] set];
  NSRectFill(frameRect);
  [[NSColor whiteColor] set];
  // [NSBezierPath strokeLineFromPoint: NSMakePoint(0, 0)
  //                           toPoint: NSMakePoint(frameRect.size.width,
  //                                                frameRect.size.height)];
  NSRectFill(_player.bounds);

}


- (void) keyEvent: (NSEvent *)event on: (BOOL)newState
{
  BOOL      handled = NO;
  NSString *characters;
  unichar   keyChar = 0;

  // NSDebugLog(@"event: %@", event);

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
  NSDate *currentDate = [NSDate date];
  if (_keyState.up == YES)
    _player.bounds.origin.y += _player.speed;
  if (_keyState.down == YES)
    _player.bounds.origin.y -= _player.speed;
  if (_keyState.left == YES)
    _player.bounds.origin.x -= _player.speed;
  if (_keyState.right == YES)
    _player.bounds.origin.x += _player.speed;
  // NSDebugLog(@"step: %@", currentDate);
  [self setNeedsDisplay: YES];
}

- (IBAction) startStepping: (id)sender
{
  NSDebugLog(@"startStepping: %@", sender);
  [self setFrameSize: NSMakeSize(SCREEN_WIDTH, SCREEN_HEIGHT)];
  _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / 60.0
                                            target: self
                                          selector: @selector(step:)
                                          userInfo: nil
                                           repeats: YES];
  RETAIN(_timer);

  // [[NSRunLoop mainRunLoop] addTimer: _timer forMode: NSRunLoopCommonModes];
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
