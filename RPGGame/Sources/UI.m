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
      ASSIGN(_system40, [NSFont systemFontOfSize: 40]);
      // ObjKey *key = AUTORELEASE([[ObjKey alloc] initWithView: view]);
      // ASSIGN(_keyImage, [key image]);
      _messageOn = NO;
      _message = @"";
      _dialogue = @"";
      _messageCounter = 0;
      _gameFinished = NO;
      _playTime = 0.0;
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_dialogue);
  RELEASE(_message);
  RELEASE(_system40);
  DEALLOC;
}

- (BOOL) gameFinished
{
  return _gameFinished;
}

- (void) setGameFinished: (BOOL)state
{
  _gameFinished = state;
}

- (void) showMessage: (NSString *)text
{
  _messageOn = YES;
  ASSIGNCOPY(_message, text);
}

- (void) setDialogue: (NSString *)text
{
  ASSIGNCOPY(_dialogue, text);
  NSLog(@"_dialogue = %@", _dialogue);
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
  NSDictionary *fontDict = @{ NSFontAttributeName: _system40,
                              NSForegroundColorAttributeName: [NSColor whiteColor] };
  CGFloat y;

  {
    NSString *text = @"You found the treasure!";
#ifdef TOPLEFT_ORIGIN
    y = (SCREEN_HEIGHT / 2.0) - TILE_SIZE * 3;
#else
    y = (SCREEN_HEIGHT / 2.0) + TILE_SIZE * 3;
#endif
    NSRect drawBounds = [self _boundsForCenteredText: text
                                                   y: y
                                          attributes: fontDict];

    [text drawInRect: drawBounds withAttributes: fontDict];
  }
  {
    NSString *text = [NSString stringWithFormat: @"Your Time is : %.2f", _playTime];
#ifdef TOPLEFT_ORIGIN
    y = (SCREEN_HEIGHT / 2.0) + TILE_SIZE * 4;
#else
    y = (SCREEN_HEIGHT / 2.0) - TILE_SIZE * 4;
#endif
    NSRect drawBounds = [self _boundsForCenteredText: text
                                                   y: y
                                          attributes: fontDict];
    [text drawInRect: drawBounds withAttributes: fontDict];
  }
  {
    NSFont *font = [NSFont boldSystemFontOfSize: 80];
    NSDictionary *fontDict = @{ NSFontAttributeName: font,
                                NSForegroundColorAttributeName: [NSColor yellowColor] };

    NSString *text = @"Congratulations!";
#ifdef TOPLEFT_ORIGIN
    y = (SCREEN_HEIGHT / 2.0) + TILE_SIZE * 2;
#else
    y = (SCREEN_HEIGHT / 2.0) - TILE_SIZE * 3;
#endif
    NSRect drawBounds = [self _boundsForCenteredText: text
                                                   y: y
                                          attributes: fontDict];
    [text drawInRect: drawBounds withAttributes: fontDict];
  }
}

- (void) _drawGameALive
{
  CGFloat y;
  if ([_view gameState] == playState)
    {
      // Do playState stuff later
    }

  if ([_view gameState] == pauseState)
    {
      [self _drawPauseScreen];
    }

  if ([_view gameState] == dialogueState)
    {
      [self _drawDialogueScreen];
    }

  _playTime += 1.0 / 60.0;
  NSString *time = [NSString stringWithFormat:@"Time: %.2f", _playTime];
#ifdef TOPLEFT_ORIGIN
  y = 75;
#else
  y = SCREEN_HEIGHT - 75;
#endif
  [_view drawString: time
                  x: TILE_SIZE * 11
                  y: y
             height: 40
              color: [NSColor whiteColor]];

  if (_messageOn == YES)
    {
#ifdef TOPLEFT_ORIGIN
      y = TILE_SIZE * 5;
#else
      y = SCREEN_HEIGHT - TILE_SIZE * 5;
#endif
      [_view drawString: _message
                      x: TILE_SIZE / 2.0
                      y: y
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

- (void) _drawPauseScreen
{
  NSDictionary *fontDict = @{ NSFontAttributeName: [NSFont systemFontOfSize: 80],
                              NSForegroundColorAttributeName: [NSColor whiteColor] };

  NSString *text = @"PAUSED";
  CGFloat y;

  y = SCREEN_HEIGHT / 2.0;
  NSRect drawBounds = [self _boundsForCenteredText: text
                                                 y: y
                                        attributes: fontDict];
  [text drawInRect: drawBounds withAttributes: fontDict];
}

- (NSRect) _boundsForCenteredText: (NSString *)text y: (CGFloat)y attributes: (NSDictionary *)attributes
{
  NSSize textSize = [text sizeWithAttributes: attributes];
  NSPoint loc = NSMakePoint((SCREEN_WIDTH - textSize.width) / 2, y);

  NSRect drawBounds;
  drawBounds.origin = loc;
  drawBounds.size = textSize;
  return drawBounds;
}

- (void) _drawDialogueScreen
{
  NSRect bounds;
  bounds.origin.x = TILE_SIZE * 2;
#ifdef TOPLEFT_ORIGIN
  bounds.origin.y = TILE_SIZE / 2.0;
#else
  bounds.origin.y = SCREEN_HEIGHT - TILE_SIZE / 2.0;
  bounds.origin.y -= bounds.size.height;
#endif
  bounds.size.width = SCREEN_WIDTH - (TILE_SIZE * 4);
  bounds.size.height = TILE_SIZE * 4;

  [self _drawSubWindow: bounds];
  bounds.origin.x += TILE_SIZE;
#ifdef TOPLEFT_ORIGIN
  bounds.origin.y = (TILE_SIZE / 2.0) + TILE_SIZE;
#else
  bounds.origin.y = SCREEN_HEIGHT - ((TILE_SIZE / 2.0) + TILE_SIZE);
#endif
  [_view drawString: _dialogue
                  x: bounds.origin.x
                  y: bounds.origin.y
             height: 32
              color: [NSColor whiteColor]];

}

- (void) _drawSubWindow: (NSRect)bounds
{
  [[[NSColor blackColor] colorWithAlphaComponent: (210.0 / 255.0)] set];
  id path1 = [NSBezierPath bezierPathWithRoundedRect: bounds
                                            xRadius: 35.0
                                            yRadius: 35.0];
  [path1 closePath];
  [path1 fill];

  [[NSColor whiteColor] set];
  id path2 = [NSBezierPath bezierPathWithRoundedRect: NSInsetRect(bounds, 5, 5)
                                             xRadius: 30.0
                                             yRadius: 30.0];
  [path2 setLineWidth: 5.0];
  [path2 closePath];
  [path2 stroke];
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
