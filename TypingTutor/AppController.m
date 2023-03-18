/*
   Project: TypingTutor

   Author: Kenjiro Fukuda,,,

   Created: 2023-03-11 11:40:54 +0900 by kenjiro

   Application Controller
*/

#import "AppController.h"

#define TICKS 10

@implementation AppController

+ (void) initialize
{
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

  /*
   * Register your app's defaults here by adding objects to the
   * dictionary, eg
   *
   * [defaults setObject:anObject forKey:keyForThatObject];
   *
   */

  [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) init
{
  if ((self = [super init]))
    {
      letters = @[@"a", @"s", @"d", @"f", @"j", @"k", @"l", @";"];
      RETAIN(letters);
      lastIndex = 0;
      srandom(time(NULL));
    }
  return self;
}

- (void) dealloc
{
  RELEASE(letters);
  DEALLOC;
}

- (void) awakeFromNib
{
  [self showAnotherLetter];
}

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif
{
  NSLog(@"applicationDidFinishLaunching:");
}

- (NSApplicationTerminateReply) applicationShouldTerminate: (id)sender
{
  return YES;
}

- (void) applicationWillTerminate: (NSNotification *)aNotif
{
  NSLog(@"applicationWillTerminate:");
}

- (BOOL) application: (NSApplication *)application
            openFile: (NSString *)fileName
{
  return NO;
}


- (IBAction) stopGo: (id)sender
{
  NSLog(@"stopGo:");
  if ([sender state] == 1)
    {
      NSLog(@"Starting");
      timer = [NSTimer scheduledTimerWithTimeInterval: 0.2
                                               target: self
                                             selector: @selector(checkThem:)
                                             userInfo: nil
                                              repeats: YES];
      RETAIN(timer);
    }
  else
    {
      NSLog(@"Stopping");
      [timer invalidate];
      RELEASE(timer);
    }
}


- (void) checkThem: (NSTimer *)timer
{
  if ([[inLetterView string] isEqual: [outLetterView string]])
    {
      [self showAnotherLetter];
    }
  count++;
  if (count > TICKS)
    {
      NSBeep();
      count = 0;
    }
  [progressView setDoubleValue: (100.0 * count) / TICKS];
}


- (IBAction) showPrefPanel: (id)sender
{
  NSLog(@"showPrefPanel:");
}

- (void) showAnotherLetter
{
  int x;
  x = lastIndex;
  while (x == lastIndex)
    {
      x = random() % [letters count];
    }
  lastIndex = x;
  [outLetterView setString: [letters objectAtIndex: x]];
  [progressView setDoubleValue: 0.0];
}

@end
