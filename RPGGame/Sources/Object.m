// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Entity.h"
#import "Object.h"

@implementation SuperObject
- (instancetype) initWithView: (GameView *)view;
{
  if ((self = [super init]) != nil)
    {
      _view = view;
      _collision = NO;
    }
  return self;
}

- (void) dealloc
{
  DEALLOC;
}

- (CGFloat) worldX
{
  return _worldLoc.x;
}

- (void) setWorldX: (CGFloat)value
{
  _worldLoc.x = value;
}

- (CGFloat) worldY
{
  return _worldLoc.y;
}

- (void) setWorldY: (CGFloat)value
{
  _worldLoc.y = value;
}

- (void) draw
{
  CGFloat screenX =
    _worldLoc.x - [[_view player] worldX] + [[_view player] screenX];
  CGFloat screenY =
    _worldLoc.y - [[_view player] worldY] + [[_view player] screenY];
  [_image compositeToPoint: NSMakePoint(screenX, screenY)
                 operation: NSCompositeSourceOver];
}

@end

@implementation ObjKey
- (instancetype) initWithView: (GameView *)view;
{
  self = [super initWithView: view];
  if (self != nil)
    {
      _name = @"Key";

      NSImage *image = [view imageOfResource: @"key" inDirectory: @"Objects"];
      _image = [view scaledImage: image scale: SCALE];
      RELEASE(image);
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_image);
  DEALLOC;
}


@end

// vim: filetype=objc ts=2 sw=2 expandtab
