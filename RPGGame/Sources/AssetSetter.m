// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "AssetSetter.h"
#import "GameView.h"
#import "Object.h"

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
  [obj setWorldX: FLIPED_COL(23) * TILE_SIZE];
  [obj setWorldY: FLIPED_ROW( 7) * TILE_SIZE];
  [_view addSuperObject: obj];
  RELEASE(obj);

  obj = [[ObjKey alloc] initWithView: _view];
  [obj setWorldX: FLIPED_COL(23) * TILE_SIZE];
  [obj setWorldY: FLIPED_ROW(40) * TILE_SIZE];
  [_view addSuperObject: obj];
  RELEASE(obj);

  obj = [[ObjKey alloc] initWithView: _view];
  [obj setWorldX: FLIPED_COL(38) * TILE_SIZE];
  [obj setWorldY: FLIPED_ROW( 8) * TILE_SIZE];
  [_view addSuperObject: obj];
  RELEASE(obj);

  obj = [[ObjDoor alloc] initWithView: _view];
  [obj setWorldX: FLIPED_COL(10) * TILE_SIZE];
  [obj setWorldY: FLIPED_ROW(11) * TILE_SIZE];
  [_view addSuperObject: obj];
  RELEASE(obj);

  obj = [[ObjDoor alloc] initWithView: _view];
  [obj setWorldX: FLIPED_COL( 8) * TILE_SIZE];
  [obj setWorldY: FLIPED_ROW(28) * TILE_SIZE];
  [_view addSuperObject: obj];
  RELEASE(obj);

  obj = [[ObjDoor alloc] initWithView: _view];
  [obj setWorldX: FLIPED_COL(12) * TILE_SIZE];
  [obj setWorldY: FLIPED_ROW(22) * TILE_SIZE];
  [_view addSuperObject: obj];
  RELEASE(obj);

  obj = [[ObjChest alloc] initWithView: _view];
  [obj setWorldX: FLIPED_COL(10) * TILE_SIZE];
  [obj setWorldY: FLIPED_ROW( 7) * TILE_SIZE];
  [_view addSuperObject: obj];
  RELEASE(obj);

  obj = [[ObjBoots alloc] initWithView: _view];
  [obj setWorldX: FLIPED_COL(37) * TILE_SIZE];
  [obj setWorldY: FLIPED_ROW(42) * TILE_SIZE];
  [_view addSuperObject: obj];
  RELEASE(obj);
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
