// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Checker.h"
#import "Entity.h"

@implementation Entity
- (instancetype) init
{
  if ((self = [super init]) != nil)
    {
      _solidArea = NSMakeRect(0, 0, TILE_SIZE, TILE_SIZE);
      _collisionOn = NO;
    }
  return self;
}

- (Direction) direction
{
  return _direction;
}

- (CGFloat) speed
{
  return _speed;
}

- (CGFloat) worldX
{
  return _worldLoc.x;
}

- (CGFloat) worldY
{
  return _worldLoc.y;
}

- (NSRect) solidArea
{
  return _solidArea;
}

- (void) setSolidArea: (NSRect)area
{
  _solidArea  = area;
}

- (NSRect) worldSolidArea
{
  return NSOffsetRect(_solidArea, _worldLoc.x, _worldLoc.y);
}

- (NSRect) peekStepedSolidArea
{
  NSRect area = [self worldSolidArea];
  DirectionEntry de = directions[_direction];
  CGFloat offsetX = _speed * de.vec.x;
  CGFloat offsetY = _speed * de.vec.y;
  return NSOffsetRect(area, offsetX, offsetY);
}

- (void) setCollisionOn: (BOOL)state;
{
  _collisionOn  = state;
}

- (BOOL) showsSolidArea
{
  return _showsSolidArea;
}

- (void) setShowsSolidArea: (BOOL)state
{
  _showsSolidArea = state;
}

@end

@implementation Player
- (instancetype) initWithView: (GameView *)view keyState: (BOOL [])keyState
{
  self = [super init];
  if (self != nil)
    {
      _view = view;
      _keyState = keyState;
      _screenLoc = NSMakePoint(SCREEN_WIDTH / 2 - TILE_SIZE / 2,
                               SCREEN_HEIGHT / 2 - TILE_SIZE / 2);
      _solidArea = NSMakeRect(8, 0, TILE_SIZE - (8 + 8), TILE_SIZE - (8 + 8));
      _hasKey = 0;
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
  _worldLoc = NSMakePoint(FLIPED_COL(23) * TILE_SIZE,
                          FLIPED_ROW(21) * TILE_SIZE);
  _speed = 4;
  _direction = Down;
  _spliteCounter = 0;
  _spliteNumber = 1;
}

- (NSImage *) _imageOfResource: (NSString *)name
{
  NSImage *original = [_view imageOfResource: name inDirectory: @"Walking-sprites"];
  NSImage *image = [_view scaledImage: original scale: SCALE];
  RELEASE(original);
  return image;
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

- (NSRect) visibleRect
{
  return NSMakeRect(-_screenLoc.x + _worldLoc.x,
                    -_screenLoc.y + _worldLoc.y,
                    SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (NSRect) visibleTileRect
{
  NSRect rect = [self visibleRect];
  CGFloat minX = ceil((NSMinX(rect) - TILE_SIZE) / TILE_SIZE);
  CGFloat minY = ceil((NSMinY(rect) - TILE_SIZE) / TILE_SIZE);
  CGFloat maxX = ceil((NSMaxX(rect) + TILE_SIZE) / TILE_SIZE);
  CGFloat maxY = ceil((NSMaxY(rect) + TILE_SIZE) / TILE_SIZE);
  return NSMakeRect(minX, minY, maxX - minX, maxY - minY);
}

- (void) update
{
  if ([_view anyKeyPressed] == YES)
    {
      for (int i = 0; i < 4; i++)
        {
          if (_keyState[i] == YES)
            {
              _direction = i;
              break;
            }
        }

      // CHECK TILE COLLISION
      _collisionOn = NO;
      [[_view collisionChecker] checkTile: self];

      // CHECK OBJECT COLLISION
      SuperObject* obj = [[_view collisionChecker] checkObject: self isPlayer: true];
      [self _pickupObject: obj];

      // IF COLLISION IS FALSE, PLAYER CAN MOVE
      if (_collisionOn == NO)
        {
          DirectionEntry de = directions[_direction];
          _worldLoc.x += _speed * de.vec.x;
          _worldLoc.y += _speed * de.vec.y;
        }

      _spliteCounter++;
      if (_spliteCounter > 10)
        {
          _spliteNumber = (_spliteNumber == 1) ? 2 : 1;
          _spliteCounter = 0;
        }
    }
}

- (void) _pickupObject: (SuperObject *)object
{
  if (object != nil)
    {
      if ([[object name] isEqualToString: @"Key"])
        {
          _hasKey++;
          [[_view objects] removeObject: object];
          NSDebugLog(@"Key: %d", _hasKey);
        }
      else if ([[object name] isEqualToString: @"Door"])
        {
          if (_hasKey > 0)
            {
              [[_view objects] removeObject: object];
              _hasKey--;
            }
          NSDebugLog(@"Key: %d", _hasKey);
        }
      else if ([[object name] isEqualToString: @"Boots"])
        {
          _speed += 2;
          [[_view objects] removeObject: object];
        }
    }
}

- (void) draw
{
  NSImage *image = nil;
  if (_direction == Up)
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
  else if (_direction == Down)
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
  else if (_direction == Left)
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
  else if (_direction == Right)
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
      [image compositeToPoint: _screenLoc
                    operation: NSCompositeSourceOver];

    }
  else
    {
      // error occurred fallback!!!
      NSRect rect = NSMakeRect(_screenLoc.y, _screenLoc.y, TILE_SIZE, TILE_SIZE);
      [[NSColor whiteColor] set];
      NSRectFill(rect);
    }
  if (_showsSolidArea)
    {
      [[NSColor redColor] set];
      NSFrameRect(NSOffsetRect(_solidArea, _screenLoc.x, _screenLoc.y));
    }
}
@end

// vim: filetype=objc ts=2 sw=2 expandtab
