// -*- mode: ObjC -*-
#ifndef _OBJECT_H_
#define _OBJECT_H_

#import <Foundation/Foundation.h>

@class GameView;

@interface SuperObject : NSObject
{
  GameView *_view;
  NSImage *_image;
  NSString *_name;
  BOOL _collision;
  NSPoint _worldLoc;
}
- (instancetype) initWithView: (GameView *)view;
- (void) dealloc;

- (CGFloat) worldX;
- (void) setWorldX: (CGFloat)value;
- (CGFloat) worldY;
- (void) setWorldY: (CGFloat)value;

- (void) draw;
@end

@interface ObjKey : SuperObject
{
}
- (instancetype) initWithView: (GameView *)view;
- (void) dealloc;
@end

@interface ObjDoor : SuperObject
{
}
- (instancetype) initWithView: (GameView *)view;
- (void) dealloc;
@end

@interface ObjChest : SuperObject
{
}
- (instancetype) initWithView: (GameView *)view;
- (void) dealloc;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
