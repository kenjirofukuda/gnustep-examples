/*
   Project: ImageFun

   Author: Kenjiro Fukuda,,,

   Created: 2023-03-04 17:04:01 +0900 by kenjiro

   Application Controller
*/

#import "AppController.h"

@interface NSString(Repeat)

- (NSString *) repeatTimes: (NSUInteger)times;

@end

@implementation NSString(Repeat)

- (NSString *) repeatTimes: (NSUInteger)times
{
  return [@"" stringByPaddingToLength: times * [self length] withString: self startingAtIndex: 0];
}

@end

@interface AppController(Debug)
- (void) printWindows;
- (void) printMainScreenInfo;
@end

@implementation AppController(Debug)
- (void) printWindows
{
  NSArray *allWindows = GSAllWindows();
  NSEnumerator *e = [allWindows objectEnumerator];
  NSWindow *each;
  NSLog(@"%@", [@"-" repeatTimes: 80]);
  while (each = [e nextObject])
    {
      NSLog(@"win = %@", each);
    }
  NSLog(@"%@", [@"-" repeatTimes: 80]);

}

- (void) printMainScreenInfo
{
  NSLog(@"[[NSScreen mainScreen] frame] = %@",
        NSStringFromRect([[NSScreen mainScreen] frame]));
  NSLog(@"[[NSScreen mainScreen] visibleFrame] = %@",
        NSStringFromRect([[NSScreen mainScreen] visibleFrame]));
}


@end


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
    }
  return self;
}

- (void) dealloc
{
  [super dealloc];
}

- (void) awakeFromNib
{
}

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif
{
// Uncomment if your application is Renaissance-based
//  [NSBundle loadGSMarkupNamed: @"Main" owner: self];
  [self printMainScreenInfo];
}

- (NSApplicationTerminateReply) applicationShouldTerminate: (id)sender
{
  return NSTerminateNow;
}

- (void) applicationWillTerminate: (NSNotification *)aNotif
{
}

- (BOOL) application: (NSApplication *)application
            openFile: (NSString *)fileName
{
  return NO;
}

- (void) showPrefPanel: (id)sender
{
  [self printWindows];
}

@end
