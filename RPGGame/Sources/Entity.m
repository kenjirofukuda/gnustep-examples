// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Checker.h"
#import "UI.h"
#import "Entity.h"

@implementation Entity
- (instancetype) initWithView: (GameView *)view
{
  if ((self = [super init]) != nil)
    {
      _view = view;
      _solidArea = NSMakeRect(0, 0, TILE_SIZE, TILE_SIZE);
      _collisionOn = NO;
      _worldLoc = NSMakePoint(FLIPED_COL(0) * TILE_SIZE,
                              FLIPED_ROW(0) * TILE_SIZE);
      _screenLoc = NSMakePoint(SCREEN_WIDTH / 2 - TILE_SIZE / 2,
                               SCREEN_HEIGHT / 2 - TILE_SIZE / 2);
      _speed = 1;
      _direction = Down;
      _spliteCounter = 0;
      _spliteNumber = 1;
      _up1 = _up2 = _down1 = _down2 = _left1 = _left2 = _right1 = _right2 = nil;
      _dialogs = [[NSMutableArray alloc] init];
      [self _setupDialog];
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_dialogs);
  TEST_RELEASE(_up1);
  TEST_RELEASE(_up2);
  TEST_RELEASE(_down1);
  TEST_RELEASE(_down2);
  TEST_RELEASE(_left1);
  TEST_RELEASE(_left2);
  TEST_RELEASE(_right1);
  TEST_RELEASE(_right2);
  DEALLOC;
}

- (Direction) direction
{
  return _direction;
}

- (CGFloat) speed
{
  return _speed;
}

- (void) setWorldX: (CGFloat)value
{
  _worldLoc.x = value;
}

- (void) setWorldY: (CGFloat)value
{
  _worldLoc.y = value;
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

- (void) speak
{

}

- (void) action
{
}

- (void) update // Entity
{
}

- (void) drawAt: (NSPoint) pos
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
      [image compositeToPoint: pos
                    operation: NSCompositeSourceOver];

    }
  else
    {
      // error occurred fallback!!!
      NSRect rect = NSMakeRect(pos.y, pos.y, TILE_SIZE, TILE_SIZE);
      [[NSColor whiteColor] set];
      NSRectFill(rect);
    }
  if (_showsSolidArea)
    {
      [[NSColor redColor] set];
      NSFrameRect(NSOffsetRect(_solidArea, pos.x, pos.y));
    }
}

- (void) draw
{
  [self drawAt: _screenLoc];
}

- (void) _setupDialog
{
  [_dialogs addObject: @"Hellow led."];

}


- (NSImage *) _imageOfResource: (NSString *)name inDirectory: (NSString *)subDirectory
{
  NSImage *original = [_view imageOfResource: name inDirectory: subDirectory];
  NSImage *image = [_view scaledImage: original scale: SCALE];
  RELEASE(original);
  return image;
}


@end // Entiry

@implementation Player
- (instancetype) initWithView: (GameView *)view keyState: (BOOL [])keyState
{
  self = [super initWithView: view];
  if (self != nil)
    {
      _keyState = keyState;
      _solidArea = NSMakeRect(8, 0, TILE_SIZE - (8 + 8), TILE_SIZE - (8 + 8));
      _hasKey = 0;
      [self _setDefaultValues];
      [self _loadImages];
    }
  return self;
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
  return [self _imageOfResource: name inDirectory: @"Walking-sprites"];
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

- (int) hasKey
{
  return _hasKey;
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

- (void) update // Player
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

      // CHECK NPC or MONSTER COLLISION
      Entity* ent = [[_view collisionChecker] checkEntity: self entities: [_view npcs]];
      [self _interactNPC: ent];


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
          [_view playSoundIndex: 1];
          [[_view objects] removeObject: object];
          [[_view ui] showMessage: @"You got a key!"];
        }
      else if ([[object name] isEqualToString: @"Door"])
        {
          if (_hasKey > 0)
            {
              [_view playSoundIndex: 3];
              [[_view objects] removeObject: object];
              [[_view ui] showMessage: @"You opend the door!"];
              _hasKey--;
            }
          else
            {
              [[_view ui] showMessage: @"You need a key!"];
            }
        }
      else if ([[object name] isEqualToString: @"Boots"])
        {
          [_view playSoundIndex: 2];
          [[_view objects] removeObject: object];
          [[_view ui] showMessage: @"Speed up!"];
          _speed += 2;
        }
      else if ([[object name] isEqualToString: @"Chest"])
        {
          [[_view ui] setGameFinished: YES];
          [_view stopMusic];
          [_view playSoundIndex: 4];
        }
      else
        {
          NSLog(@"Error Pickup = %@", [object name]);
        }

    }
}

- (void) _interactNPC: (Entity *) entity
{
  if (entity == nil)
    return;
  if ([_view enterKeyPressed] == YES)
    {
      [_view setGameState: dialogState];
      [entity speak];
      [_view resetEnterKeyPressed];
    }
}


@end // Player


@implementation NPCOldMan
- (instancetype) initWithView: (GameView *)view
{
  self = [super initWithView: view];
  if (self != nil)
    {
      _worldLoc = NSMakePoint(FLIPED_COL(21) * TILE_SIZE,
                              FLIPED_ROW(21) * TILE_SIZE);
      _direction = Down;
      _speed = 1.0;
      _actionLockCounter = 0;
      [self _loadImages];
      [self _setupDialog];
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_dialogs);
  DEALLOC;
}

- (NSImage *) _imageOfResource: (NSString *)name
{
  return [self _imageOfResource: name inDirectory: @"NPC"];
}

- (void) _loadImages
{
  _up1 = [self _imageOfResource: @"oldman_up_1"];
  _up2 = [self _imageOfResource: @"oldman_up_2"];
  _down1 = [self _imageOfResource: @"oldman_down_1"];
  _down2 = [self _imageOfResource: @"oldman_down_2"];
  _left1 = [self _imageOfResource: @"oldman_left_1"];
  _left2 = [self _imageOfResource: @"oldman_left_2"];
  _right1 = [self _imageOfResource: @"oldman_right_1"];
  _right2 = [self _imageOfResource: @"oldman_right_2"];
}

- (void) action
{
  _actionLockCounter++;
  if (_actionLockCounter == 120)
    {
      uint32_t i = arc4random() % 101;
      if (i <= 25)
        _direction = Up;
      if (i > 25 && i <= 50)
        _direction = Down;
      if (i > 50 && i <= 75)
        _direction = Left;
      if (i > 75 && i <= 100)
        _direction = Right;
      _actionLockCounter = 0;
    }
}

- (void) update // NPCPldMan
{
  [self action];

  // CHECK TILE COLLISION
  _collisionOn = NO;
  [[_view collisionChecker] checkTile: self];
  [[_view collisionChecker] checkObject: self isPlayer: NO];
  [[_view collisionChecker] checkPlayer: self];


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

- (void) draw
{
  CGFloat screenX =
    _worldLoc.x - [[_view player] worldX] + [[_view player] screenX];
  CGFloat screenY =
    _worldLoc.y - [[_view player] worldY] + [[_view player] screenY];
  [self drawAt: NSMakePoint(screenX, screenY)];
}

- (void) speak
{
  if ([_dialogs count] == 0)
    return;
  if (_dialogIndex > [_dialogs count])
    {
      _dialogIndex = 0;
    }
  [[_view ui] setDialog: [_dialogs objectAtIndex: _dialogIndex]];
  _dialogIndex++;
  _direction = ReverseDirection([[_view player] direction]);
}

- (void) _setupDialog
{
  [_dialogs addObject: @"Hellow led."];
  [_dialogs addObject: @"So you've come to this island to find the tresure?"];
  [_dialogs addObject: @"I used to be a great wizard but now... I'm a bit too old for taking an adventure."];
  [_dialogs addObject: @"Well, good luck on you."];
}

@end // NPCOldMan


// vim: filetype=objc ts=2 sw=2 expandtab
