// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "AssetSetter.h"
#import "GameView.h"
#import "Object.h"
#import "Entity.h"

@implementation AssetSetter
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
  DEALLOC;
}

- (void) setObject
{
  SuperObject *obj;
  obj = [[ObjKey alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL(23) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW( 7) * TILE_SIZE];
  [_view addSuperObject: obj];

  obj = [[ObjKey alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL(23) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW(40) * TILE_SIZE];
  [_view addSuperObject: obj];

  obj = [[ObjKey alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL(38) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW( 8) * TILE_SIZE];
  [_view addSuperObject: obj];

  obj = [[ObjDoor alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL(10) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW(12) * TILE_SIZE];
  [_view addSuperObject: obj];

  obj = [[ObjDoor alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL( 8) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW(29) * TILE_SIZE];
  [_view addSuperObject: obj];

  obj = [[ObjDoor alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL(12) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW(23) * TILE_SIZE];
  [_view addSuperObject: obj];

  obj = [[ObjChest alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL(10) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW( 8) * TILE_SIZE];
  [_view addSuperObject: obj];

  obj = [[ObjBoots alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL(37) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW(42) * TILE_SIZE];
  [_view addSuperObject: obj];
}

- (void) setNPC
{
  Entity *obj;
  obj = [[NPCOldMan alloc] initWithView: _view];
  [obj setWorldX: FLIPPED_COL(21) * TILE_SIZE];
  [obj setWorldY: FLIPPED_ROW(21) * TILE_SIZE];
  [_view addNPCObject: obj];
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
