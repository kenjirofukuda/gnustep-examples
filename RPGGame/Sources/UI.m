// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Entity.h"
#import "Object.h"
#import "UI.h"

@implementation UI
- (instancetype) initWithView: (GameView *)view
{
  self = [super init];
  if (self != nil)
    {
      _view = view;
      // NOTE: Arial not in Linux default.
      ASSIGN(_monospace40, [NSFont systemFontOfSize: 40]);
      ObjKey *key = AUTORELEASE([[ObjKey alloc] initWithView: view]);
      ASSIGN(_keyImage, [key image]);
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_monospace40);
  DEALLOC;
}

- (void) draw
{
  NSArray *keyArray = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
  NSArray *valueArray = [NSArray arrayWithObjects: _monospace40,  [NSColor whiteColor], nil];
  NSDictionary *fontDict = [NSDictionary dictionaryWithObjects: valueArray forKeys: keyArray];

  [_view drawImage: _keyImage
                 x: TILE_SIZE / 2
                 y: SCREEN_HEIGHT - TILE_SIZE - TILE_SIZE / 2
             width: TILE_SIZE
            height: TILE_SIZE];

  NSString *info = [NSString stringWithFormat: @"x %d", [[_view player] hasKey]];
  [info drawAtPoint: NSMakePoint(74, SCREEN_HEIGHT - 75) withAttributes: fontDict];
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
