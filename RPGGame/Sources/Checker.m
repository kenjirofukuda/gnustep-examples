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

  if ([entity direction] == Up)
    {
      entityTileAddress.ymax = (entityBounds.ymax + [entity speed]) / TILE_SIZE;
      tile1 = [[_view tileManager] tileNumberOfCol: (int) entityTileAddress.xmin
                                               row: (int) entityTileAddress.ymax];
      tile2 = [[_view tileManager] tileNumberOfCol: (int) entityTileAddress.xmax
                                               row: (int) entityTileAddress.ymax];
    }
  else if ([entity direction] == Down)
    {
      entityTileAddress.ymin = (entityBounds.ymin - [entity speed]) / TILE_SIZE;
      tile1 = [[_view tileManager] tileNumberOfCol: (int) entityTileAddress.xmin
                                               row: (int) entityTileAddress.ymin];
      tile2 = [[_view tileManager] tileNumberOfCol: (int) entityTileAddress.xmax
                                               row: (int) entityTileAddress.ymin];
    }
  else if ([entity direction] == Left)
    {
      entityTileAddress.xmin = (entityBounds.xmin - [entity speed]) / TILE_SIZE;
      tile1 = [[_view tileManager] tileNumberOfCol: (int) entityTileAddress.xmin
                                               row: (int) entityTileAddress.ymax];
      tile2 = [[_view tileManager] tileNumberOfCol: (int) entityTileAddress.xmin
                                               row: (int) entityTileAddress.ymin];
    }
  else if ([entity direction] == Right)
    {
      entityTileAddress.xmax = (entityBounds.xmax + [entity speed]) / TILE_SIZE;
      tile1 = [[_view tileManager] tileNumberOfCol: (int) entityTileAddress.xmax
                                               row: (int) entityTileAddress.ymax];
      tile2 = [[_view tileManager] tileNumberOfCol: (int) entityTileAddress.xmax
                                               row: (int) entityTileAddress.ymin];
    }
  else
    {
      NSDebugLog(@"%@", @"Bad direction");
    }
  if (tile1 >= 0 && tile2 >= 0)
    {
      NSArray *tiles = [[_view tileManager] tiles];

      [entity setCollisionOn: [[tiles objectAtIndex: tile1] collision]
                           || [[tiles objectAtIndex: tile2] collision]];
    }
}

- (SuperObject *) checkObject: (Entity *)entity isPlayer: (BOOL)isPlayer
{
  SuperObject *result = nil;
  NSRect entityArea = [entity peekStepedSolidArea];

  for (SuperObject *obj in [_view objects])
    {
      NSRect objArea = [obj worldSolidArea];
      if (NSIntersectsRect(entityArea, objArea))
        {
          if ([obj collision] == YES)
            {
              [entity setCollisionOn: YES];
            }
          if (isPlayer == YES)
            {
              result = obj;
              break;
            }
        }
    }
  return result;
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
