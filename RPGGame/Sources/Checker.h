// -*- mode: ObjC -*-
#ifndef _CHECKER_H_
#define _CHECKER_H_

#import <Foundation/Foundation.h>

@class GameView;
@class Entity;
@class SuperObject;

@interface CollisionChecker : NSObject
{
  GameView *_view;
}
- (instancetype) initWithView: (GameView *) view;
- (void) dealloc;
- (void) checkTile: (Entity *) entity;
- (SuperObject *) checkObject: (Entity *) entity isPlayer: (BOOL) isPlayer;
- (Entity *) checkEntity: (Entity *) entity entities: (NSArray *) targets;
- (void) checkPlayer: (Entity *) entity;

@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
