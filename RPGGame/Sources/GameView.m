// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Checker.h"
#import "Entity.h"
#import "Tile.h"

const NSInteger ORIGINAL_TILE_SIZE = 16;
const NSInteger SCALE = 3;
const NSInteger TILE_SIZE = ORIGINAL_TILE_SIZE * SCALE;
const NSInteger MAX_SCREEN_COL = 16;
const NSInteger MAX_SCREEN_ROW = 12;
const NSInteger SCREEN_WIDTH = TILE_SIZE * MAX_SCREEN_COL;
const NSInteger SCREEN_HEIGHT = TILE_SIZE * MAX_SCREEN_ROW;
const NSInteger MAX_WORLD_COL = 50;
const NSInteger MAX_WORLD_ROW = 50;
const NSInteger WORLD_WIDTH = TILE_SIZE * MAX_WORLD_COL;
const NSInteger WORLD_HEIGHT = TILE_SIZE * MAX_WORLD_ROW;
const NSInteger FPS = 60;

@implementation GameView
- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  if (self != nil)
    {
      _player = [[Player alloc] initWithView: self keyState: &_keyState];
      _tileManager = [[TileManager alloc] initWithView: self];
      _collisionChecker = [[CollisionChecker alloc] initWithView: self];
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_timer);
  RELEASE(_tileManager);
  RELEASE(_collisionChecker);
  RELEASE(_player);
  DEALLOC;
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
  [_tileManager draw];
  [[NSColor whiteColor] set];
  [_player draw];
}

- (void) keyEvent: (NSEvent *)event pressed: (BOOL)newState
{
  BOOL      handled = NO;
  NSString *characters;

  characters = [event charactersIgnoringModifiers];
  if (! handled && [characters isEqual: @"w"])
    {
      _keyState.up = newState;
      handled = YES;
    }
  if (! handled && [characters isEqual: @"s"])
    {
      _keyState.down = newState;
      handled = YES;
    }
  if (! handled && [characters isEqual: @"a"])
    {
      _keyState.left = newState;
      handled = YES;
    }
  if (! handled && [characters isEqual: @"d"])
    {
      _keyState.right = newState;
      handled = YES;
    }
}

- (void) keyDown: (NSEvent *)event
{
  [self keyEvent: event pressed: YES];
}

- (void) keyUp: (NSEvent *)event
{
  [self keyEvent: event pressed: NO];
}

- (Player *) player
{
  return _player;
}

- (TileManager *) tileManager
{
  return _tileManager;
}

- (CollisionChecker *) collisionChecker
{
  return _collisionChecker;
}

- (BOOL) anyKeyPressed;
{
  return _keyState.up == YES
    || _keyState.down == YES
    || _keyState.left == YES
    || _keyState.right == YES;
}

- (void) step: (NSTimer *)timer
{
  [_player update];
  [self setNeedsDisplay: YES];
}


- (NSImage *) imageOfResource: (NSString *)name inDirectory: (NSString *)subpath
{
  return  [[NSImage alloc]
            initWithContentsOfFile: [[NSBundle mainBundle]
                                      pathForResource: name
                                               ofType: @"png"
                                          inDirectory: subpath]];
}

- (void) drawImage: image x: (CGFloat)x y: (CGFloat)y width: (CGFloat)width height: (CGFloat)height
{
  NSRect imageRect;
  NSRect drawRect;

  imageRect.origin = NSMakePoint(0, 0);
  imageRect.size = [image size];
  drawRect.origin = NSMakePoint(x, y);
  drawRect.size = NSMakeSize(width, height);

  [image drawInRect: drawRect
           fromRect: imageRect
          operation: NSCompositeSourceOver
           fraction: 1.0];
}

- (void) drawImage: image x: (CGFloat)x y: (CGFloat)y
{
  [self drawImage: image x: x y: y width: TILE_SIZE height: TILE_SIZE];
}

- (IBAction) startStepping: (id)sender
{
  NSDebugLog(@"startStepping: %@", sender);
  [self setFrameSize: NSMakeSize(SCREEN_WIDTH, SCREEN_HEIGHT)];
  // https://stackoverflow.com/questions/10177882/resizing-nswindow-to-fit-child-nsview
  [[self window] setContentSize: self.frame.size];
  [[self window] setContentView: self];
  [self setNeedsDisplay: YES];

  _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / FPS
                                            target: self
                                          selector: @selector(step:)
                                          userInfo: nil
                                           repeats: YES];
  RETAIN(_timer);
}

@end

NSRect NSRectFromBounds(Bounds bounds)
{
  return NSMakeRect(bounds.xmin, bounds.ymin, bounds.xmax - bounds.xmin, bounds.ymax - bounds.ymin);
}

Bounds BoundsFromNSRect(NSRect rect)
{
  Bounds result;
  result.xmin = NSMinX(rect);
  result.ymin = NSMinY(rect);
  result.xmax = NSMaxX(rect);
  result.ymax = NSMaxY(rect);
  return result;
}

Bounds BoundsDiv(Bounds bounds, CGFloat value)
{
  Bounds result;
  result.xmin = trunc(bounds.xmin / value);
  result.ymin = trunc(bounds.ymin / value);
  result.xmax = trunc(bounds.xmax / value);
  result.ymax = trunc(bounds.ymax / value);
  return result;
}

// vim: filetype=objc ts=2 sw=2 expandtab
