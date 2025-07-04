// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Entity.h"
#import "Tile.h"

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

- (void) setCollision: (BOOL)state
{
  _collision = state;
}

- (BOOL) collision
{
  return _collision;
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

@implementation TileManager
- (instancetype) initWithView: (GameView *)view
{
  self = [super init];
  if (self != nil)
    {
      _view = view;
      _tiles = [[NSMutableArray alloc] initWithCapacity: 6];
      size_t alloc_size = MAX_WORLD_COL * MAX_WORLD_ROW * sizeof(int);
      _mapTileNumbers = malloc(alloc_size);
      memset(_mapTileNumbers, 0, alloc_size);
      _showsTileAddress = NO;
      [self _loadTileImages];
      [self _loadMap: @"worldV2"];
      [self _setupTileAddressAttributes];
    }
  return self;
}

- (void) dellaoc
{
  RELEASE(_tiles);
  RELEASE(_tileAddressAttributes);
  free(_mapTileNumbers);
  DEALLOC;
}

- (NSArray *) tiles
{
  return _tiles;
}

- (BOOL) showsTileAddress
{
  return _showsTileAddress;
}

- (void) setShowsTileAddress: (BOOL)state
{
  _showsTileAddress = state;
}

- (void) _setupTileAddressAttributes {
    NSDictionary *fontDict = @{ NSFontAttributeName: [NSFont systemFontOfSize: 8],
                                NSForegroundColorAttributeName: [NSColor blackColor] };
   ASSIGN(_tileAddressAttributes, fontDict);
}

- (void) _loadTileImages;
{
  NSDebugLog(@"%@", @"_loadTileImages");
  // skip one digit number
  for (int i = 0; i <= 9; i++)
    [self _setupAtIndex: i name: @"grass00"  collision: NO];
  [self _setupAtIndex: 10 name: @"grass00" collision: NO];
  [self _setupAtIndex: 11 name: @"grass01" collision: NO];
  for (int i = 0; i <= 13; i++)
    {
      NSString *name = [NSString stringWithFormat: @"water%02d", i];
      [self _setupAtIndex: 12 + i name: name collision: YES];
    }
  for (int i = 0; i <= 12; i++)
    {
      NSString *name = [NSString stringWithFormat: @"road%02d", i];
      [self _setupAtIndex: 26 + i name: name collision: NO];
    }
  [self _setupAtIndex: 39 name: @"earth" collision: NO];
  [self _setupAtIndex: 40 name: @"wall"  collision: YES];
  [self _setupAtIndex: 41 name: @"tree"  collision: YES];
}

- (void) _setupAtIndex: (NSInteger)index
                name: (NSString *)name
           collision: (BOOL)state
{
  NSDebugLog(@"_startAtIndex: %ld name: %@ collision: %@", index, name, (state ? @"YES" : @"NO"));
  Tile *tile;

  tile = [[Tile alloc] init];
  [tile setImage: [self _imageOfResource: name]];
  [tile setCollision: state];
  _tiles[index] = tile;
  RELEASE(tile);
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
  NSArray *finalLines;
  if ([_view isFlipped] == YES)
    {
      finalLines = lines;
    }
  else
    {
      finalLines = [[lines reverseObjectEnumerator] allObjects];
    }
  for (int row = 0; row < MAX_WORLD_ROW; row++)
    {
      NSString *line = [finalLines objectAtIndex: row];
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
  NSImage *original = [_view imageOfResource: name inDirectory: @"Tiles"];
  NSImage *image = [_view scaledImage: original scale: SCALE];
  RELEASE(original);
  return AUTORELEASE(image);
}

- (void) draw
{
  NSRect tileRect = [[_view player] visibleTileRect];
  NSRect allRect = NSMakeRect(0, 0, MAX_WORLD_COL, MAX_WORLD_ROW);
  tileRect = NSIntersectionRect(tileRect, allRect);
  Bounds visibleBounds = BoundsFromNSRect(tileRect);
  BOOL showsTileAddress = [self showsTileAddress];

  for (int worldRow = (int) visibleBounds.ymin; worldRow < (int) visibleBounds.ymax; worldRow++)
    {
      for (int worldCol = (int) visibleBounds.xmin; worldCol < (int) visibleBounds.xmax; worldCol++)
        {
          int tileNumber = [self tileNumberOfCol: worldCol row: worldRow];
          tileNumber = tileNumber > 41 ? 41 : tileNumber;
          tileNumber = tileNumber < 0 ? 0 : tileNumber;

          CGFloat worldX = worldCol * TILE_SIZE;
          CGFloat worldY = worldRow * TILE_SIZE;
          CGFloat screenX =
            worldX - [[_view player] worldX] + [[_view player] screenX];
          CGFloat screenY =
            worldY - [[_view player] worldY] + [[_view player] screenY];
          NSImage *tileImage = [[_tiles objectAtIndex:tileNumber] image];
          [tileImage compositeToPoint: [_view calcCompositePoint: tileImage position: NSMakePoint(screenX, screenY)]
                            operation: NSCompositeSourceOver];
          if (showsTileAddress == YES)
            {
              if ([_view isFlipped] == YES)
                {
                  NSString *info = [NSString stringWithFormat: @"(%d, %d)", worldCol, worldRow];
                  [info drawAtPoint: NSMakePoint(screenX, screenY)
                     withAttributes: _tileAddressAttributes];
                }
              else
                {
                  NSString *info1 = [NSString stringWithFormat: @"(%d, %d)", worldCol, worldRow];
                  [info1 drawAtPoint: NSMakePoint(screenX, screenY)
                     withAttributes: _tileAddressAttributes];
                  NSString *info2 = [NSString stringWithFormat: @"(%d, %d)", worldCol, (int) FLIPPED_ROW(worldRow)];
                  [info2 drawAtPoint: NSMakePoint(screenX, screenY + 10)
                     withAttributes: _tileAddressAttributes];
                }
            }
        }
    }
}

- (int) tileNumberOfCol: (int)col row: (int)row
{
  return _mapTileNumbers[(row * MAX_WORLD_COL) + col];
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
