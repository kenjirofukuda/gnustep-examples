// -*- mode: ObjC -*-
#ifndef _GAMEVIEW_H_
#define _GAMEVIEW_H_

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


// extern NSInteger ORIGINAL_TILE_SIZE;
// extern NSInteger SCALE;
// extern NSInteger TILE_SIZE;
// extern NSInteger MAX_SCREEN_COL;
// extern NSInteger MAX_SCREEN_ROW;
// extern NSInteger SCREEN_WIDTH;
// extern NSInteger SCREEN_HEIGHT;

@interface GameView : NSView
{
  NSString *_name;
  NSTimer *_timer;
}
- (instancetype) initWithFrame: (NSRect)frameRect;
- (void) dealloc;
- (NSString *) name;
- (void) setName: (NSString *)name;
- (BOOL) acceptsFirstResponder;
- (BOOL) acceptsFirstMouse: (NSEvent *)event;
- (void) drawRect: (NSRect)rect;
- (void) step: (NSTimer *)timer;

- (IBAction) startStepping: (id)sender;

@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
