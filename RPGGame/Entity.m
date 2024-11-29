// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "Entity.h"

@implementation Entity
- (instancetype) init
{
  if ((self = [super init]) != nil)
    {
      // implement hear
    }
  return self;
}

- (void) dealloc
{
  [super dealloc];
}

- (CGFloat) worldX
{
  return _worldLoc.x;
}

- (CGFloat) worldY
{
  return _worldLoc.y;
}
@end

@implementation Player
- (instancetype) initWithView: (GameView *)view keyState: (KeyState *)keyState
{
  self = [super init];
  if (self != nil)
    {
      _view = view;
      _keyState = keyState;
      _screenLoc = NSMakePoint(SCREEN_WIDTH / 2 - TILE_SIZE / 2,
                               SCREEN_HEIGHT / 2 - TILE_SIZE / 2);

      [self _setDefaultValues];
      [self _loadImages];
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_up1);
  RELEASE(_up2);
  RELEASE(_down1);
  RELEASE(_down2);
  RELEASE(_left1);
  RELEASE(_left2);
  RELEASE(_right1);
  RELEASE(_right2);
  DEALLOC;
}

- (void) _setDefaultValues
{
  _worldLoc = NSMakePoint(WORLD_WIDTH / 2 - TILE_SIZE / 2,
                          WORLD_HEIGHT / 2 - TILE_SIZE / 2);
  _speed = 4;
  _direction = @"down";
}

- (NSImage *) _imageOfResource: (NSString *)name
{
  return [_view imageOfResource: name inDirectory: @"Walking-sprites"];
}

- (void) _loadImages
{
  _up1 = [self _imageOfResource: @"boy_up_1"];
  _up2 = [self _imageOfResource: @"boy_up_2"];
  _down1 = [self _imageOfResource: @"boy_down_1"];
  _down2 = [self _imageOfResource: @"boy_down_2"];
  _left1 = [self _imageOfResource: @"boy_left_1"];
  _left2 = [self _imageOfResource: @"boy_left_2"];
  _right1 = [self _imageOfResource: @"boy_right_1"];
  _right2 = [self _imageOfResource: @"boy_right_2"];
}

- (CGFloat) screenX
{
  return _screenLoc.x;
}

- (CGFloat) screenY
{
  return _screenLoc.y;
}

- (NSRect) visibleBounds
{
  return NSMakeRect(-_screenLoc.x + _worldLoc.x,
                    -_screenLoc.y + _worldLoc.y,
                    SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (NSRect) visibleTileBounds
{
  NSRect bounds = [self visibleBounds];
  CGFloat minX = ceil((NSMinX(bounds) - TILE_SIZE) / TILE_SIZE);
  CGFloat minY = ceil((NSMinY(bounds) - TILE_SIZE) / TILE_SIZE);
  CGFloat maxX = ceil((NSMaxX(bounds) + TILE_SIZE) / TILE_SIZE);
  CGFloat maxY = ceil((NSMaxY(bounds) + TILE_SIZE) / TILE_SIZE);
  return NSMakeRect(minX, minY, maxX - minX, maxY - minY);
}

- (void) update
{
  if ([_view anyKeyPressed] == YES)
    {
      if (_keyState->up == YES)
        {
          _direction = @"up";
          _worldLoc.y += _speed;
        }
      if (_keyState->down == YES)
        {
          _direction = @"down";
          _worldLoc.y -= _speed;
        }
      if (_keyState->left == YES)
        {
          _direction = @"left";
          _worldLoc.x -= _speed;
        }
      if (_keyState->right == YES)
        {
          _direction = @"right";
          _worldLoc.x += _speed;
        }
      _spliteCounter++;
      if (_spliteCounter > 10)
        {
          _spliteNumber = (_spliteNumber == 1) ? 2 : 1;
          _spliteCounter = 0;
        }
    }
}

- (void) draw
{
  NSImage *image = nil;

  if ([_direction isEqualToString: @"up"])
    {
      if (_spliteNumber == 1)
        {
          image = _up1;
        }
      if (_spliteNumber == 2)
        {
          image = _up2;
        }
    }
  else if ([_direction isEqualToString: @"down"])
    {
      if (_spliteNumber == 1)
        {
          image = _down1;
        }
      if (_spliteNumber == 2)
        {
          image = _down2;
        }
    }
  else if ([_direction isEqualToString: @"left"])
    {
      if (_spliteNumber == 1)
        {
          image = _left1;
        }
      if (_spliteNumber == 2)
        {
          image = _left2;
        }
    }
  else if ([_direction isEqualToString: @"right"])
    {
      if (_spliteNumber == 1)
        {
          image = _right1;
        }
      if (_spliteNumber == 2)
        {
          image = _right2;
        }
    }
  if (image != nil)
    {
      [_view drawImage: image x: _screenLoc.x y: _screenLoc.y];
    }
  else
    {
      // error occurred fallback!!!
      NSRect bounds = NSMakeRect(_screenLoc.y, _screenLoc.y, TILE_SIZE, TILE_SIZE);
      [[NSColor whiteColor] set];
      NSRectFill(bounds);
    }
}
@end

// vim: filetype=objc ts=2 sw=2 expandtab
