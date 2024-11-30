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
  [obj setWorldX: 23 * TILE_SIZE];
  [obj setWorldY: (MAX_WORLD_ROW - 7 - 1) * TILE_SIZE];
  [_view addSuperObject: obj];

  obj = [[ObjKey alloc] initWithView: _view];
  [obj setWorldX: 23 * TILE_SIZE];
  [obj setWorldY: (MAX_WORLD_ROW - 40 - 1) * TILE_SIZE];
  [_view addSuperObject: obj];
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
