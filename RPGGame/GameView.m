// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"

const NSInteger ORIGINAL_TILE_SIZE = 16;
const NSInteger SCALE = 3;
const NSInteger TILE_SIZE = ORIGINAL_TILE_SIZE * SCALE;
const NSInteger MAX_SCREEN_COL = 16;
const NSInteger MAX_SCREEN_ROW = 12;
const NSInteger SCREEN_WIDTH = TILE_SIZE * MAX_SCREEN_COL;
const NSInteger SCREEN_HEIGHT = TILE_SIZE * MAX_SCREEN_ROW;


@implementation GameView
- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  if (self != nil)
    {
      NSDebugLog(@"- (instancetype) initWithFrame: (NSRect)frameRect");
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_timer);
  RELEASE(_name);
  [super dealloc];
}

- (NSString *) name
{
  return _name;
}

- (void) setName: (NSString *)name
{
  ASSIGNCOPY(_name, name);
}

- (BOOL) acceptsFirstResponder
{
  return YES;
}

- (BOOL) acceptsFirstMouse: (NSEvent *)event
{
  return YES;
}

- (void) drawRect: (NSRect)rect
{
  [[NSColor blackColor] set];
  NSRectFill(rect);
}

- (void) step: (NSTimer *)timer
{
  NSDate *currentDate = [NSDate date];

  NSDebugLog(@"step: %@", currentDate);
}

- (IBAction) startStepping: (id)sender
{
  NSDebugLog(@"startStepping: %@", sender);  
  [self setFrameSize: NSMakeSize(SCREEN_WIDTH, SCREEN_HEIGHT)];
  _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                            target: self
                                          selector: @selector(step:)
                                          userInfo: nil
                                           repeats: YES];
  RETAIN(_timer);
  
  // [[NSRunLoop mainRunLoop] addTimer: _timer forMode: NSRunLoopCommonModes];
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
