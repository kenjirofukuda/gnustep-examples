// -*- mode: ObjC -*-
#ifndef _GAMEVIEW_H_
#define _GAMEVIEW_H_

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


extern const NSInteger ORIGINAL_TILE_SIZE;
extern const NSInteger SCALE;
extern const NSInteger TILE_SIZE;
extern const NSInteger MAX_SCREEN_COL;
extern const NSInteger MAX_SCREEN_ROW;
extern const NSInteger SCREEN_WIDTH;
extern const NSInteger SCREEN_HEIGHT;
extern const NSInteger MAX_WORLD_COL;
extern const NSInteger MAX_WORLD_ROW;
extern const NSInteger FPS;

#define FLIPED_COL(x) ((x))
#define FLIPED_ROW(x) (MAX_WORLD_ROW - (x) - 1)

typedef enum
{
  playState = 1,
  pauseState = 2,
  dialogState = 3
} GameState;

typedef enum
{
  Up = 0,
  Down = 1,
  Left = 2,
  Right = 3,
  Enter = 4
} Direction;

typedef struct
{
  Direction direction;
  NSString *name;
  NSPoint   vec;
} DirectionEntry;

typedef BOOL KeyState[5];

typedef struct
{
  CGFloat xmin;
  CGFloat ymin;
  CGFloat xmax;
  CGFloat ymax;
} Bounds;

extern NSRect NSRectFromBounds(Bounds bounds);
extern Bounds BoundsFromNSRect(NSRect rect);
extern Bounds BoundsDiv(Bounds bounds, CGFloat value);
extern Direction ReverseDirection(Direction direction);

extern DirectionEntry directions[4];

@class Player;
@class TileManager;
@class CollisionChecker;
@class AssetSetter;
@class SuperObject;
@class Entity;
@class Sound;
@class UI;

@interface GameView : NSView
{
  NSTimer *_timer;
  Player *_player;
  KeyState _keyState;
  NSUInteger _drawCount;
  TileManager *_tileManager;
  CollisionChecker *_collisionChecker;
  UI *_ui;
  NSDictionary *_directionKeyTable;
  NSMutableArray *_objects;
  NSMutableArray *_npcs;
  AssetSetter *_assetSetter;
  Sound *_sound;
  Sound *_music;
  GameState _gameState;
}
- (instancetype) initWithFrame: (NSRect)frameRect;
- (void) dealloc;
- (BOOL) acceptsFirstResponder;
- (BOOL) acceptsFirstMouse: (NSEvent *)event;
- (void) drawRect: (NSRect)rect;
- (void) step: (NSTimer *)timer;
- (void) keyDown: (NSEvent *)theEvent;
- (void) keyUp: (NSEvent *)theEvent;

- (void) setupGame;
- (NSMutableArray *) objects;
- (NSMutableArray *) npcs;
- (void) addSuperObject: (SuperObject *)object;
- (void) addNPCObject: (Entity *)object;

- (Sound *) music;
- (void) playMusic;
- (void) stopMusic;

- (Sound *) sound;
- (void) playSoundIndex: (NSInteger) index;
- (void) stopSound;

- (GameState) gameState;
- (void) setGameState: (GameState) newState;
- (Player *) player;
- (TileManager *) tileManager;
- (CollisionChecker *) collisionChecker;
- (UI *) ui;
- (BOOL) anyKeyPressed;
- (BOOL) enterKeyPressed;
- (void) resetEnterKeyPressed;

- (NSImage *) imageOfResource: (NSString *)name inDirectory: (NSString *)subpath;
- (NSImage *) scaledImage: (NSImage *)image scale: (CGFloat)scale;
- (void) drawImage: image x: (CGFloat)x y: (CGFloat)y width: (CGFloat)width height: (CGFloat)height;
- (void) drawImage: image x: (CGFloat)x y: (CGFloat)y;
- (void) drawString: (NSString *)string
                  x: (CGFloat)x
                  y: (CGFloat)y
             height: (CGFloat)height
              color: (NSColor *)color;

- (IBAction) startStepping: (id)sender;

@end

#endif
// vim: filetype=objc ts=2 sw=2 expandtab
