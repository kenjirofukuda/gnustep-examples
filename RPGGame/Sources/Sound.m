// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "Sound.h"

@implementation Sound
- (instancetype) init
{
  if ((self = [super init]) != nil)
    {
      _soundPaths = [[NSMutableArray alloc] init];
      [_soundPaths addObject: [self _soundPathOfResource: @"BlueBoyAdventure"]];
      [_soundPaths addObject: [self _soundPathOfResource: @"coin"]];
      [_soundPaths addObject: [self _soundPathOfResource: @"powerup"]];
      [_soundPaths addObject: [self _soundPathOfResource: @"unlock"]];
      [_soundPaths addObject: [self _soundPathOfResource: @"fanfare"]];
      _sound = nil;
    }
  return self;
}

- (void) dealloc
{
  TEST_RELEASE(_sound);
  RELEASE(_soundPaths);
  DEALLOC;
}

- (NSString *) _soundPathOfResource: (NSString *)name
{
  return  [[NSBundle mainBundle] pathForResource: name
                                          ofType: @"wav"
                                     inDirectory: @"Sounds"];

}

- (void) setFileIndex: (NSInteger)soundIndex
{
  NSAssert(soundIndex >= 0 && soundIndex < [_soundPaths count] , NSInvalidArgumentException);
  ASSIGN(_sound,  [[NSSound alloc] initWithContentsOfFile: [_soundPaths objectAtIndex: soundIndex]
                                              byReference: NO]);
  [_sound setVolume: 0.5];
}

- (void) play
{
  [_sound play];
}

- (void) loop
{
  [_sound setLoops: YES];
}

- (void) stop
{
  [_sound stop];
}


@end


// vim: filetype=objc ts=2 sw=2 expandtab
