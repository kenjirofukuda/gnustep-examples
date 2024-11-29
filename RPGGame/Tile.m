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

// vim: filetype=objc ts=2 sw=2 expandtab
