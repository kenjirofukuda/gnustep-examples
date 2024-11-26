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
const NSInteger MAX_WORLD_COL = 50;
const NSInteger MAX_WORLD_ROW = 50;
const NSInteger WORLD_WIDTH = TILE_SIZE * MAX_WORLD_COL;
const NSInteger WORLD_HEIGHT = TILE_SIZE * MAX_WORLD_ROW;
const NSInteger FPS = 60;

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
  NSString *_direction;

  NSInteger _spliteCounter;
  NSInteger _spliteNumber;
}

- (instancetype) init;
- (CGFloat) worldX;
- (CGFloat) worldY;
@end


@implementation Entity
- (instancetype) init
{
  self = [super init];
  if (self != nil)
    {
      _spliteCounter = 0;
      _spliteNumber = 1;
    }
  return self;
}

- (CGFloat) worldX
{
  return _worldLoc.x;
}

- (CGFloat) worldY
{
  return _worldLoc.y;
}

@end


@interface Player : Entity
{
  GameView *_view;
  KeyState *_keyState;
  NSPoint   _screenLoc;
}
- (instancetype) initWithView: (GameView *)view keyState: (KeyState *)keyState;
- (void) dealloc;
- (void) update;
- (void) draw;
- (CGFloat) screenX;
- (CGFloat) screenY;
- (NSRect) visibleBounds;
- (NSRect) visibleTileBounds;
@end

@implementation Player
- (instancetype) initWithView: (GameView *)view keyState: (KeyState *)keyState
{
  self = [super init];
  if (self != nil)
    {
      _view = view;
      _keyState = keyState;
      _screenLoc = NSMakePoint(SCREEN_WIDTH / 2 - TILE_SIZE / 2,
                               SCREEN_HEIGHT / 2 - TILE_SIZE / 2);

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
  _worldLoc = NSMakePoint(100 ,100);
  _speed = 4;
  _direction = @"down";
}

- (NSImage *) _imageOfResource: (NSString *)name
{
  return [_view imageOfResource: name inDirectory: @"Walking-sprites"];
}

- (void) _loadImages
{
  _up1 = [self _imageOfResource: @"boy_up_1"];
  _up2 = [self _imageOfResource: @"boy_up_2"];
  _down1 = [self _imageOfResource: @"boy_down_1"];
  _down2 = [self _imageOfResource: @"boy_down_2"];
  _left1 = [self _imageOfResource: @"boy_left_1"];
  _left2 = [self _imageOfResource: @"boy_left_2"];
  _right1 = [self _imageOfResource: @"boy_right_1"];
  _right2 = [self _imageOfResource: @"boy_right_2"];
}

- (CGFloat) screenX
{
  return _screenLoc.x;
}

- (CGFloat) screenY
{
  return _screenLoc.y;
}

- (NSRect) visibleBounds
{
  return NSMakeRect(-_screenLoc.x + _worldLoc.x,
                    -_screenLoc.y + _worldLoc.y,
                    SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (NSRect) visibleTileBounds
{
  NSRect bounds = [self visibleBounds];
  CGFloat minX = ceil((NSMinX(bounds) - TILE_SIZE) / TILE_SIZE);
  CGFloat minY = ceil((NSMinY(bounds) - TILE_SIZE) / TILE_SIZE);
  CGFloat maxX = ceil((NSMaxX(bounds) + TILE_SIZE) / TILE_SIZE);
  CGFloat maxY = ceil((NSMaxY(bounds) + TILE_SIZE) / TILE_SIZE);
  return NSMakeRect(minX, minY, maxX - minX, maxY - minY);
}

- (void) update
{
  if ([_view anyKeyPressed] == YES)
    {
      if (_keyState->up == YES)
        {
          _direction = @"up";
          _worldLoc.y += _speed;
        }
      if (_keyState->down == YES)
        {
          _direction = @"down";
          _worldLoc.y -= _speed;
        }
      if (_keyState->left == YES)
        {
          _direction = @"left";
          _worldLoc.x -= _speed;
        }
      if (_keyState->right == YES)
        {
          _direction = @"right";
          _worldLoc.x += _speed;
        }
      _spliteCounter++;
      if (_spliteCounter > 10)
        {
          _spliteNumber = (_spliteNumber == 1) ? 2 : 1;
          _spliteCounter = 0;
        }
    }
}

- (void) draw
{
  NSImage *image = nil;

  if ([_direction isEqualToString: @"up"])
    {
      if (_spliteNumber == 1)
        {
          image = _up1;
        }
      if (_spliteNumber == 2)
        {
          image = _up2;
        }
    }
  else if ([_direction isEqualToString: @"down"])
    {
      if (_spliteNumber == 1)
        {
          image = _down1;
        }
      if (_spliteNumber == 2)
        {
          image = _down2;
        }
    }
  else if ([_direction isEqualToString: @"left"])
    {
      if (_spliteNumber == 1)
        {
          image = _left1;
        }
      if (_spliteNumber == 2)
        {
          image = _left2;
        }
    }
  else if ([_direction isEqualToString: @"right"])
    {
      if (_spliteNumber == 1)
        {
          image = _right1;
        }
      if (_spliteNumber == 2)
        {
          image = _right2;
        }
    }
  if (image != nil)
    {
      [_view drawImage: image x: _screenLoc.x y: _screenLoc.y];
    }
  else
    {
      // error occurred fallback!!!
      NSRect bounds = NSMakeRect(_screenLoc.y, _screenLoc.y, TILE_SIZE, TILE_SIZE);
      [[NSColor whiteColor] set];
      NSRectFill(bounds);
    }
}
@end

@interface Tile : NSObject
{
  NSImage *_image;
  BOOL _collision;
}
- (instancetype) init;
- (void) dealloc;
- (void) setImage: (NSImage *)image;
- (NSImage *) image;

@end

@implementation Tile
- (instancetype) init
{
  self = [super init];
  if (self != nil)
    {
      _collision = false;
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_image);
  DEALLOC;
}

- (void) setImage: (NSImage *)image
{
  ASSIGN(_image, image);
}

- (NSImage *) image
{
  return _image;
}

@end

@interface TileManager : NSObject
{
  GameView *_view;
  NSMutableArray *_tiles;
  int *_mapTileNumbers;
}
- (instancetype) initWithView: (GameView *)view;
- (void) dellaoc;
- (void) draw;
@end

@implementation TileManager
- (instancetype) initWithView: (GameView *)view
{
  self = [super init];
  if (self != nil)
    {
      _view = view;
      _tiles = [[NSMutableArray alloc] init];
      size_t alloc_size = MAX_WORLD_COL * MAX_WORLD_ROW * sizeof(int);
      _mapTileNumbers = malloc(alloc_size);
      memset(_mapTileNumbers, 0, alloc_size);
      [self _loadTileImages];
      [self _loadMap: @"world01"];
    }
  return self;
}

- (void) dellaoc
{
  RELEASE(_tiles);
  free(_mapTileNumbers);
  DEALLOC;
}

- (void) _loadTileImages;
{
  for (NSString *name in
       @[@"grass", @"wall", @"water", @"earth", @"tree", @"sand"])
    {
      Tile *tile = [[Tile alloc] init];
      [tile setImage: [self _imageOfResource: name]];
      [_tiles addObject: tile];
    }
}

- (void) _loadMap: name;
{
  NSString *contents = [NSString stringWithContentsOfFile:
                                   [[NSBundle mainBundle]
                                     pathForResource: name
                                              ofType: @"txt"
                                         inDirectory: @"Maps"]];

  NSMutableArray *lines = [NSMutableArray array];
  [contents enumerateLinesUsingBlock: ^ (NSString *line, BOOL * stop)
            {
              NSString *trimed = [line stringByTrimmingCharactersInSet:
                                         [NSCharacterSet whitespaceCharacterSet]];
              if ([trimed length] != 0)
                {
                  [lines addObject: line];
                }
            }
   ];
  NSArray *reversedLines = [[lines reverseObjectEnumerator] allObjects];
  for (int row = 0; row < MAX_WORLD_ROW; row++)
    {
      NSString *line = [reversedLines objectAtIndex: row];
      NSArray *items = [line componentsSeparatedByString: @" "];
      int col = 0;
      for (NSString *item in items)
        {
          _mapTileNumbers[col + (row * MAX_WORLD_COL)] = [item intValue];
          col++;
        }
    }
}

- (NSImage *) _imageOfResource: (NSString *)name
{
  return [_view imageOfResource: name inDirectory: @"Tiles"];
}

- (void) draw
{
  NSRect tileBounds = [[_view player] visibleTileBounds];
  NSRect allBounds = NSMakeRect(0, 0, MAX_WORLD_COL, MAX_WORLD_ROW);
  tileBounds = NSIntersectionRect(tileBounds, allBounds);
  // NSDebugLog(@"tile: %@", NSStringFromRect(tileBounds));

  int worldCol = (int) NSMinX(tileBounds);
  int resetCol = worldCol;
  int worldRow = (int) NSMinY(tileBounds);
  int limitCol = (int) NSMaxX(tileBounds);
  int limitRow = (int) NSMaxY(tileBounds);
  // NSDebugLog(@"worldCol: %d", worldCol);
  // NSDebugLog(@"worldRow: %d", worldRow);
  // NSDebugLog(@"limitCol: %d", limitCol);
  // NSDebugLog(@"limitRow: %d", limitRow);
  // puts("");

  for (; worldRow < limitRow; worldRow++)
    {
      for (worldCol = resetCol; worldCol < limitCol; worldCol++)
        {
          int mapIndex = worldCol + (worldRow * MAX_WORLD_COL);
          /* NSDebugLog(@"mapIndex: %d row: %d col: %d", mapIndex, worldRow, worldCol); */
          int tileNumber = _mapTileNumbers[mapIndex];
          tileNumber = tileNumber > 5 ? 5 : tileNumber;
          tileNumber = tileNumber < 0 ? 0 : tileNumber;

          CGFloat worldX = worldCol * TILE_SIZE;
          CGFloat worldY = worldRow * TILE_SIZE;
          CGFloat screenX =
            worldX - [[_view player] worldX] + [[_view player] screenX];
          CGFloat screenY =
            worldY - [[_view player] worldY] + [[_view player] screenY];
          [_view drawImage:[[_tiles objectAtIndex:tileNumber] image]
                         x:screenX
                         y:screenY];
        }
    }
}
@end


@implementation GameView
- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  if (self != nil)
    {
      _player = [[Player alloc] initWithView: self keyState: &_keyState];
      _tileManager = [[TileManager alloc] initWithView: self];
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_timer);
  RELEASE(_tileManager);
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

// vim: filetype=objc ts=2 sw=2 expandtab
