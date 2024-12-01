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
      _image = nil;
      _solidArea = NSMakeRect(0, 0, TILE_SIZE, TILE_SIZE);
    }
  return self;
}

- (void) dealloc
{
  TEST_RELEASE(_image);
  DEALLOC;
}

- (BOOL) collision
{
  return _collision;
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

- (NSRect) worldSolidArea
{
  return NSOffsetRect(_solidArea, _worldLoc.x, _worldLoc.y);
}

- (NSImage *) _imageOfResource:(NSString *)name
{
  NSImage *original = [_view imageOfResource: name inDirectory:@"Objects"];
  NSImage *image = [_view scaledImage: original scale:SCALE];
  RELEASE(original);
  return image;
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
      _image = [self _imageOfResource: @"key"];
    }
  return self;
}

- (void) dealloc
{
  DEALLOC;
}
@end

@implementation ObjDoor
- (instancetype) initWithView: (GameView *)view;
{
  self = [super initWithView: view];
  if (self != nil)
    {
      _name = @"Door";
      _image = [self _imageOfResource: @"door"];
    }
  return self;
}

- (void) dealloc
{
  DEALLOC;
}
@end

@implementation ObjChest
- (instancetype) initWithView: (GameView *)view;
{
  self = [super initWithView: view];
  if (self != nil)
    {
      _name = @"Chest";
      _image = [self _imageOfResource: @"chest (OLD)"];
    }
  return self;
}

- (void) dealloc
{
  DEALLOC;
}
@end

// vim: filetype=objc ts=2 sw=2 expandtab
