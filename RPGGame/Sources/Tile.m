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

- (void) setCollision:(BOOL)state
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
      _tiles = [[NSMutableArray alloc] init];
      size_t alloc_size = MAX_WORLD_COL * MAX_WORLD_ROW * sizeof(int);
      _mapTileNumbers = malloc(alloc_size);
      memset(_mapTileNumbers, 0, alloc_size);
      _showsTileAddress = NO;
      [self _loadTileImages];
      [self _loadMap: @"world01"];
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

- (void)_setupTileAddressAttributes {
    NSFont *font = [NSFont systemFontOfSize: 8];
    NSArray *keyArray = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
    NSArray *valueArray = [NSArray arrayWithObjects: font, [NSColor blackColor], nil];

    NSDictionary *fontDict = [NSDictionary dictionaryWithObjects: valueArray forKeys: keyArray];
    ASSIGN(_tileAddressAttributes, fontDict);
}

- (void) _loadTileImages;
{
  NSDebugLog(@"%@", @"_loadTileImages");
  Tile *tile;
  NSImage *image;

  tile = [[Tile alloc] init];
  image = [self _imageOfResource: @"grass"];
  NSDebugLog(@"scaled size = %@", NSStringFromSize([image size]));
  [tile setImage: image];
  [_tiles addObject: tile];

  tile = [[Tile alloc] init];
  [tile setImage: [self _imageOfResource: @"wall"]];
  [tile setCollision: YES];
  [_tiles addObject: tile];

  tile = [[Tile alloc] init];
  [tile setImage: [self _imageOfResource: @"water"]];
  [_tiles addObject: tile];

  tile = [[Tile alloc] init];
  [tile setImage: [self _imageOfResource: @"earth"]];
  [_tiles addObject: tile];

  tile = [[Tile alloc] init];
  [tile setImage: [self _imageOfResource: @"tree"]];
  [_tiles addObject: tile];
  [tile setCollision: YES];

  tile = [[Tile alloc] init];
  [tile setImage: [self _imageOfResource: @"sand"]];
  [_tiles addObject: tile];
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
  NSImage *original = [_view imageOfResource: name inDirectory: @"Tiles"];
  NSImage *image = [_view scaledImage: original scale: SCALE];
  RELEASE(original);
  return image;
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
          tileNumber = tileNumber > 5 ? 5 : tileNumber;
          tileNumber = tileNumber < 0 ? 0 : tileNumber;

          CGFloat worldX = worldCol * TILE_SIZE;
          CGFloat worldY = worldRow * TILE_SIZE;
          CGFloat screenX =
            worldX - [[_view player] worldX] + [[_view player] screenX];
          CGFloat screenY =
            worldY - [[_view player] worldY] + [[_view player] screenY];
          [[[_tiles objectAtIndex: tileNumber] image] compositeToPoint: NSMakePoint(screenX, screenY)
                                                             operation: NSCompositeSourceOver];
          if (showsTileAddress == YES)
            {
              NSString *info = [NSString stringWithFormat: @"(%d, %d)", worldCol, worldRow];
              [info drawAtPoint: NSMakePoint(screenX, screenY) withAttributes: _tileAddressAttributes];
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
