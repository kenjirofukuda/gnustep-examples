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
  Bounds entityBounds = BoundsFromNSRect([entity peekSteppedSolidArea]);
  Bounds entityTileAddress = BoundsDiv(entityBounds, TILE_SIZE);
  int tile1 = -1;
  int tile2 = -1;

  if ([entity direction] == Up)
    {
      tile1 = [[_view tileManager] tileNumberOfCol: (int) BoundsLeft(entityTileAddress)
                                               row: (int) BoundsTop(entityTileAddress)];
      tile2 = [[_view tileManager] tileNumberOfCol: (int) BoundsRight(entityTileAddress)
                                               row: (int) BoundsTop(entityTileAddress)];
    }
  else if ([entity direction] == Down)
    {
      tile1 = [[_view tileManager] tileNumberOfCol: (int) BoundsLeft(entityTileAddress)
                                               row: (int) BoundsBottom(entityTileAddress)];
      tile2 = [[_view tileManager] tileNumberOfCol: (int) BoundsRight(entityTileAddress)
                                               row: (int) BoundsBottom(entityTileAddress)];
    }
  else if ([entity direction] == Left)
    {
      tile1 = [[_view tileManager] tileNumberOfCol: (int) BoundsLeft(entityTileAddress)
                                               row: (int) BoundsTop(entityTileAddress)];
      tile2 = [[_view tileManager] tileNumberOfCol: (int) BoundsLeft(entityTileAddress)
                                               row: (int) BoundsBottom(entityTileAddress)];
    }
  else if ([entity direction] == Right)
    {
      tile1 = [[_view tileManager] tileNumberOfCol: (int) BoundsRight(entityTileAddress)
                                               row: (int) BoundsTop(entityTileAddress)];
      tile2 = [[_view tileManager] tileNumberOfCol: (int) BoundsRight(entityTileAddress)
                                               row: (int) BoundsBottom(entityTileAddress)];
    }
  else
    {
      NSDebugLog(@"%@", @"Bad direction");
    }
  if (tile1 >= 0 && tile2 >= 0)
    {
      NSArray *tiles = [[_view tileManager] tiles];
      /* INDENT-OFF */
      [entity setCollisionOn: [[tiles objectAtIndex: tile1] collision]
                           || [[tiles objectAtIndex: tile2] collision]];
      /* INDENT-OFF */
    }
}

- (SuperObject *) checkObject: (Entity *)entity isPlayer: (BOOL)isPlayer
{
  SuperObject *result = nil;
  NSRect entityArea = [entity peekSteppedSolidArea];

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
              NSDebugLog(@"objects = %@", [_view objects]);
              NSDebugLog(@"obj = %@", obj);
              break;
            }
        }
    }
  return result;
}


- (Entity *) checkEntity: (Entity *)entity entities: (NSArray *)targets
{
  Entity *result = nil;
  NSRect entityArea = [entity peekSteppedSolidArea];

  for (Entity *obj in targets)
    {
      NSRect objArea = [obj worldSolidArea];
      if (NSIntersectsRect(entityArea, objArea))
        {
          [entity setCollisionOn: YES];
          result = obj;
          break;
        }
    }
  return result;
}

- (void) checkPlayer: (Entity *)entity
{
  NSRect playerArea = [[_view player] worldSolidArea];
  NSRect entityArea = [entity peekSteppedSolidArea];
  if (NSIntersectsRect(entityArea, playerArea))
    {
      [entity setCollisionOn: YES];
    }
}


@end

// vim: filetype=objc ts=2 sw=2 expandtab
