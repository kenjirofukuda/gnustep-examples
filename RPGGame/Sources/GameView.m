// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Checker.h"
#import "Entity.h"
#import "Tile.h"
#import "Object.h"
#import "AssetSetter.h"
#import "Sound.h"
#import "UI.h"

const NSInteger ORIGINAL_TILE_SIZE = 16;
const NSInteger SCALE = 3;
const NSInteger TILE_SIZE = ORIGINAL_TILE_SIZE * SCALE;
const NSInteger MAX_SCREEN_COL = 16;
const NSInteger MAX_SCREEN_ROW = 12;
const NSInteger SCREEN_WIDTH = TILE_SIZE * MAX_SCREEN_COL;
const NSInteger SCREEN_HEIGHT = TILE_SIZE * MAX_SCREEN_ROW;
const NSInteger MAX_WORLD_COL = 50;
const NSInteger MAX_WORLD_ROW = 50;
const NSInteger FPS = 60;

// *INDENT-OFF*
DirectionEntry directions[4] =
{
  {Up,    @"up",    { 0.0,   1.0}},
  {Down,  @"down",  { 0.0,  -1.0}},
  {Left,  @"left",  {-1.0,   0.0}},
  {Right, @"right", { 1.0,   0.0}}
};
// *INDENT-ON*

@implementation GameView
- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  if (self != nil)
    {
      _keyState[Up] = NO;
      _keyState[Down] = NO;
      _keyState[Left] = NO;
      _keyState[Right] = NO;
      _player = [[Player alloc] initWithView: self keyState: _keyState];
      _tileManager = [[TileManager alloc] initWithView: self];
      _collisionChecker = [[CollisionChecker alloc] initWithView: self];
      _ui = [[UI alloc] initWithView: self];
      _objects = [[NSMutableArray alloc] init];
      _npcs = [[NSMutableArray alloc] init];
      _assetSetter = [[AssetSetter alloc] initWithView: self];
      _sound = [[Sound alloc] init];
      _music = [[Sound alloc] init];
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_ui);
  RELEASE(_music);
  RELEASE(_sound);
  RELEASE(_assetSetter);
  RELEASE(_npcs);
  RELEASE(_objects);
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
  [self _drawSuperObjects];
  [self _drawNPCObjects];
  [_player draw];
  [_ui draw];
}

- (void) _drawSuperObjects
{
  NSRect viewRect = [_player visibleRect];
  for (SuperObject *obj in _objects)
    {
      if (NSIntersectsRect(viewRect, NSMakeRect([obj worldX], [obj worldY], TILE_SIZE, TILE_SIZE)) == YES)
        [obj draw];
    }
}

- (void) _drawNPCObjects
{
  NSRect viewRect = [_player visibleRect];
  for (Entity *ent in _npcs)
    {
      if (NSIntersectsRect(viewRect, NSMakeRect([ent worldX], [ent worldY], TILE_SIZE, TILE_SIZE)) == YES)
        [ent draw];
    }
}

- (void) keyEvent: (NSEvent *)event pressed: (BOOL)newState
{
  NSString *characters = [event charactersIgnoringModifiers];
  if ([characters isEqualToString: @"w"])
    _keyState[Up] = newState;
  else if ([characters isEqualToString: @"s"])
    _keyState[Down] = newState;
  else if ([characters isEqualToString: @"a"])
    _keyState[Left] = newState;
  else if ([characters isEqualToString: @"d"])
    _keyState[Right] = newState;
}

- (void) keyDown: (NSEvent *)event
{
  [self keyEvent: event pressed: YES];
  NSString *characters = [event charactersIgnoringModifiers];
  if ([characters isEqualToString: @"i"])
    [_tileManager setShowsTileAddress: ! [_tileManager showsTileAddress]];
  if ([characters isEqualToString: @"o"])
    [_player setShowsSolidArea: ! [_player showsSolidArea]];
  if ([characters isEqualToString: @"p"])
    _gameState = _gameState == playState ? pauseState : playState;
}

- (void) keyUp: (NSEvent *)event
{
  [self keyEvent: event pressed: NO];
}

- (void) setupGame
{
  [_assetSetter setObject];
  [_assetSetter setNPC];
  [self playMusic];
  _gameState = playState;
}

- (NSMutableArray *) objects
{
  return _objects;
}

- (NSMutableArray *) npcs
{
  return _npcs;
}

- (void) addSuperObject: (SuperObject *)object
{
 [ _objects addObject: object];
}

- (void) addNPCObject: (Entity *)object
{
 [ _npcs addObject: object];
}

- (Sound *) sound
{
  return _sound;
}

- (Sound *) music
{
  return _music;
}

- (void) playMusic
{
  [_music setFileIndex: 0];
  [_music loop];
  [_music play];
}

- (void) stopMusic
{
  [_music stop];
}

- (void) playSoundIndex: (NSInteger) index
{
  [_sound setFileIndex: index];
  [_sound play];
}

- (void) stopSound
{
  [_sound stop];
}

- (GameState) gameState
{
  return _gameState;
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

- (UI *) ui
{
  return _ui;
}

- (BOOL) anyKeyPressed;
{
  return _keyState[Up] == YES
    || _keyState[Down] == YES
    || _keyState[Left] == YES
    || _keyState[Right] == YES;
}

- (void) step: (NSTimer *)timer
{
  if (_gameState == playState)
    {
      [_player update];
      for (Entity *ent in _npcs)
        {
          [ent update];
        }
    }
  if (_gameState == pauseState)
    ; // nothing

  [self setNeedsDisplay: YES];
  if ([_ui gameFinished] == YES)
    {
      [timer invalidate];
    }
}


- (NSImage *) imageOfResource: (NSString *)name inDirectory: (NSString *)subpath
{
  return  [[NSImage alloc]
            initWithContentsOfFile: [[NSBundle mainBundle]
                                      pathForResource: name
                                               ofType: @"png"
                                          inDirectory: subpath]];
}

- (NSImage *) scaledImage: (NSImage *)image scale: (CGFloat)scale
{
  // https://stackoverflow.com/questions/11876963/get-the-correct-image-width-and-height-of-an-nsimage
  NSImageRep *rep = [[image representations] objectAtIndex: 0];
  NSSize originalSize = NSMakeSize(rep.pixelsWide, rep.pixelsHigh);
  NSSize scaledSize = originalSize;

  scaledSize.width *= scale;
  scaledSize.height *= scale;
  NSImage *result = [[NSImage alloc] initWithSize: scaledSize];

  [result lockFocus];

  NSRect imageRect;
  NSRect drawRect;
  imageRect.origin = NSMakePoint(0, 0);
  imageRect.size = originalSize;
  drawRect.origin = NSMakePoint(0, 0);
  drawRect.size = scaledSize;

  [image drawInRect: drawRect
           fromRect: imageRect
          operation: NSCompositeSourceOver
           fraction: 1.0];

  [result unlockFocus];
  return result;
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

- (void) drawString: (NSString *)string
                   x: (CGFloat)x
                   y: (CGFloat)y
              height: (CGFloat)height
               color: (NSColor *)color
{
    NSFont *font = [NSFont systemFontOfSize: height];
    NSDictionary *fontDict = @{ NSFontAttributeName: font,
                                NSForegroundColorAttributeName: color };

    NSPoint drawLocation = NSMakePoint(x, y);
    [string drawAtPoint: drawLocation withAttributes: fontDict];
}

- (IBAction) startStepping: (id)sender
{
  [self setFrameSize: NSMakeSize(SCREEN_WIDTH, SCREEN_HEIGHT)];
  // https://stackoverflow.com/questions/10177882/resizing-nswindow-to-fit-child-nsview
  [[self window] setContentSize: self.frame.size];
  [[self window] setContentView: self];
  [self setupGame];
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
