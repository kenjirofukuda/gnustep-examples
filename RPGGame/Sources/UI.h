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
}
- (instancetype) initWithView: (GameView *)view;
- (void) dealloc;

- (void) draw;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
