// -*- mode: ObjC -*-
#ifndef _UI_H_
#define _UI_H_

#import <Foundation/Foundation.h>
#import <AppKit/NSFont.h>

@class GameView;

@interface UI : NSObject
{
  GameView *_view;
  NSFont *_monospace40;
  NSImage *_keyImage;
  BOOL _messageOn;
  NSString *_message;
  NSInteger _messageCounter;
  BOOL _gameFinished;
  double _playTime;
}
- (instancetype) initWithView: (GameView *)view;
- (void) dealloc;

- (BOOL) gameFinished;
- (void) setGameFinished: (BOOL) state;

- (void) showMessage: (NSString *) text;
- (void) draw;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
