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
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/cuttree.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/cursor.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/Dungeon.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/coin.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/gameover.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/FinalBattle.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/hitmonster.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/chipwall.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/burning.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/stairs.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/BlueBoyAdventure.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/levelup.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/sleep.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/dooropen.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/unlock.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/Merchant.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/speak.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/parry.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/fanfare.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/powerup.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/receivedamage.wav
// /home/kenjiro/Documents/github/kenjirofukuda/gnustep-examples/RPGGame/Resources/Sounds/blocked.wav
