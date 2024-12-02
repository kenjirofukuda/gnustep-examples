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
      _messageOn = NO;
      _message = @"";
      _messageCounter = 0;
      _gameFinished = NO;
      _playTime = 0.0;
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_message);
  RELEASE(_monospace40);
  DEALLOC;
}

- (BOOL) gameFinished
{
  return _gameFinished;
}

- (void) setGameFinished: (BOOL) state
{
  _gameFinished = state;
}

- (void) showMessage: (NSString *) text
{
  _messageOn = YES;
  ASSIGNCOPY(_message, text);
}

- (void) draw
{
  if (_gameFinished == YES)
    [self _drawGameEnd];
  else
    [self _drawGameALive];
}

- (void) _drawGameEnd
{
  {
    NSFont *font = [NSFont systemFontOfSize: 40];
    NSDictionary *fontDict = @{ NSFontAttributeName: font,
                                NSForegroundColorAttributeName: [NSColor whiteColor] };

    NSString *text = @"You found the treasure!";
    NSSize textSize = [text sizeWithAttributes: fontDict];
    NSSize screenSize = NSMakeSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    NSPoint loc = NSMakePoint((screenSize.width - textSize.width) / 2,
                              (screenSize.height / 2) + TILE_SIZE * 3);

    NSRect drawBounds;
    drawBounds.origin = loc;
    drawBounds.size = textSize;

    [text drawInRect: drawBounds withAttributes: fontDict];
  }
  {
    NSFont *font = [NSFont systemFontOfSize: 40];
    NSDictionary *fontDict = @{ NSFontAttributeName: font,
                                NSForegroundColorAttributeName: [NSColor whiteColor] };

    NSString *text = [NSString stringWithFormat: @"Your Time is : %.2f", _playTime];
    NSSize textSize = [text sizeWithAttributes: fontDict];
    NSSize screenSize = NSMakeSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    NSPoint loc = NSMakePoint((screenSize.width - textSize.width) / 2,
                              (screenSize.height / 2) - TILE_SIZE * 4);

    NSRect drawBounds;
    drawBounds.origin = loc;
    drawBounds.size = textSize;

    [text drawInRect: drawBounds withAttributes: fontDict];
  }
  {
    NSFont *font = [NSFont boldSystemFontOfSize: 80];
    NSDictionary *fontDict = @{ NSFontAttributeName: font,
                                NSForegroundColorAttributeName: [NSColor yellowColor] };

    NSString *text = @"Congratulations!";
    NSSize textSize = [text sizeWithAttributes: fontDict];
    NSSize screenSize = NSMakeSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    NSPoint loc = NSMakePoint((screenSize.width - textSize.width) / 2,
                              (screenSize.height / 2) - TILE_SIZE * 3);

    NSRect drawBounds;
    drawBounds.origin = loc;
    drawBounds.size = textSize;

    [text drawInRect: drawBounds withAttributes: fontDict];
  }
}

- (void) _drawGameALive
{
  [_view drawImage: _keyImage
                 x: TILE_SIZE / 2
                 y: SCREEN_HEIGHT - TILE_SIZE - TILE_SIZE / 2
             width: TILE_SIZE
            height: TILE_SIZE];

  NSString *info = [NSString stringWithFormat: @"x %d", [[_view player] hasKey]];
  [_view drawString: info
                  x: 74
                  y: SCREEN_HEIGHT - 75
             height: 40
              color: [NSColor whiteColor]];

  _playTime += 1.0 / 60.0;
  NSString *time = [NSString stringWithFormat: @"Time: %.2f", _playTime];
  [_view drawString: time
                  x: TILE_SIZE * 11
                  y: SCREEN_HEIGHT - 75
             height: 40
              color: [NSColor whiteColor]];

  if (_messageOn == YES)
    {
      [_view drawString: _message
                      x: TILE_SIZE / 2
                      y: SCREEN_HEIGHT - TILE_SIZE * 5
                 height: 30
                  color: [NSColor whiteColor]];
      _messageCounter++;
      if (_messageCounter > 120) // 2 secs (FPS * 2)
        {
          _messageCounter = 0;
          _messageOn = NO;
        }
    }
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
