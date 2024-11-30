// -*- mode: ObjC -*-
#ifndef _TILE_H_
#define _TILE_H_

#import <Foundation/Foundation.h>

@interface Tile : NSObject
{
  NSImage *_image;
  BOOL _collision;
}
- (instancetype) init;
- (void) dealloc;
- (void) setCollision:(BOOL)state;
- (BOOL) collision;
- (void) setImage: (NSImage *)image;
- (NSImage *) image;

@end

@class GameView;
@interface TileManager : NSObject
{
  GameView *_view;
  NSMutableArray *_tiles;
  int *_mapTileNumbers;
  BOOL _showsTileAddress;
}
- (instancetype) initWithView: (GameView *)view;
- (void) dellaoc;
- (NSArray *) tiles;
- (int) tileNumberOfCol: (int)col row: (int)row;
- (BOOL) showsTileAddress;
- (void) setShowsTileAddress: (BOOL) state;
- (void) draw;
@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
