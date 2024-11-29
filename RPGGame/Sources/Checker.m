// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Tile.h"
#import "Entity.h"
#import "Checker.h"

@implementation CollisionChecker
- (instancetype) initWithView: (GameView *)view
{
  if ((self = [super init]) != nil)
    {
      _view = view;
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_view);
  DEALLOC;
}

- (void) checkTile: (Entity *)entity
{
  Bounds entityBounds =
    BoundsFromNSRect(NSOffsetRect([entity solidArea], [entity worldX], [entity worldY]));
  Bounds entityTileAddress = BoundsDiv(entityBounds, TILE_SIZE);
  int tile1 = -1;
  int tile2 = -1;

  if ([[entity direction] isEqualToString: @"up"])
    {
      entityTileAddress.ymax = (entityBounds.ymax + [entity speed]) / TILE_SIZE;
      tile1 = [[_view tileManager] tileNumberOfRow: (int) entityTileAddress.ymax
                                               col: (int) entityTileAddress.xmin];
      tile2 = [[_view tileManager] tileNumberOfRow: (int) entityTileAddress.ymax
                                               col: (int) entityTileAddress.xmax];
    }
  else if ([[entity direction] isEqualToString: @"down"])
    {
      entityTileAddress.ymin = (entityBounds.ymin - [entity speed]) / TILE_SIZE;
      tile1 = [[_view tileManager] tileNumberOfRow: (int) entityTileAddress.ymin
                                               col: (int) entityTileAddress.xmin];
      tile2 = [[_view tileManager] tileNumberOfRow: (int) entityTileAddress.ymin
                                               col: (int) entityTileAddress.xmax];
    }
  else if ([[entity direction] isEqualToString: @"left"])
    {
      entityTileAddress.xmin = (entityBounds.xmin - [entity speed]) / TILE_SIZE;
      tile1 = [[_view tileManager] tileNumberOfRow: (int) entityTileAddress.ymax
                                               col: (int) entityTileAddress.xmin];
      tile2 = [[_view tileManager] tileNumberOfRow: (int) entityTileAddress.ymin
                                               col: (int) entityTileAddress.xmin];
    }
  else if ([[entity direction] isEqualToString: @"right"])
    {
      entityTileAddress.xmax = (entityBounds.xmax + [entity speed]) / TILE_SIZE;
      tile1 = [[_view tileManager] tileNumberOfRow: (int) entityTileAddress.ymax
                                               col: (int) entityTileAddress.xmax];
      tile2 = [[_view tileManager] tileNumberOfRow: (int) entityTileAddress.ymin
                                               col: (int) entityTileAddress.xmax];
    }
  else
    {
      NSDebugLog(@"%@", @"Bad direction");
    }
  if (tile1 >= 0 && tile2 >= 0)
    {
      NSArray *tiles = [[_view tileManager] tiles];

      // [entity setCollisionOn: (([[tiles objectAtIndex: tile1] collision] == YES
      //                        || [[tiles objectAtIndex: tile2] collision] == YES)) ? YES : NO];
      [entity setCollisionOn: [[tiles objectAtIndex: tile1] collision]
                           || [[tiles objectAtIndex: tile2] collision]];
    }
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
