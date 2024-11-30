// -*- mode: ObjC -*-
#ifndef _CHECKER_H_
#define _CHECKER_H_

#import <Foundation/Foundation.h>

@class GameView;
@class Entity;

@interface CollisionChecker : NSObject
{
  GameView *_view;
}
- (instancetype) initWithView: (GameView *) view;
- (void) dealloc;
- (void) checkTile: (Entity *) entity;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
