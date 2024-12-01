// -*- mode: ObjC -*-
#ifndef _SOUND_H_
#define _SOUND_H_

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface Sound : NSObject
{
  NSMutableArray *_soundPaths;
  NSSound *_sound;
}
- (instancetype) init;
- (void) dealloc;
- (void) setFileIndex: (NSInteger)soundIndex;
- (void) play;
- (void) loop;
- (void) stop;

@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
