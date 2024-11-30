// -*- mode: ObjC -*-
#ifndef _ASSETSETTER_H_
#define _ASSETSETTER_H_

#import <Foundation/Foundation.h>

@class GameView;

@interface AssetSetter : NSObject
{
  GameView *_view;
}
- (instancetype) initWithView: (GameView *)view;
- (void) dealloc;

- (void) setObject;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
