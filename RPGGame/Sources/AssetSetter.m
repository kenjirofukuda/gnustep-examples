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
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
