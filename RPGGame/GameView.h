// -*- mode: ObjC -*-
#ifndef _GAMEVIEW_H_
#define _GAMEVIEW_H_

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface GameView : NSView
{
  NSString *_name;
}
- (instancetype) initWithFrame: (NSRect)frameRect
- (void) dealloc;
- (NSString *) name;
- (void) setName: (NSString *)name;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
