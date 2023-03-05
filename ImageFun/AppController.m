/* 
   Project: ImageFun

   Author: Kenjiro Fukuda,,,

   Created: 2023-03-04 17:04:01 +0900 by kenjiro
   
   Application Controller
*/

#import "AppController.h"

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
  NSWindow *panel = [[NSApp mainMenu] window];
  NSRect bounds = [panel frame];
  NSLog(@"bounds = %@", NSStringFromRect(bounds));
  NSLog(@"[[NSScreen mainScreen] frame] = %@", NSStringFromRect([[NSScreen mainScreen] frame]));
  NSLog(@"[[NSScreen mainScreen] visibleFrame] = %@", NSStringFromRect([[NSScreen mainScreen] visibleFrame]));
  
  [panel setFrameOrigin: 
       NSMakePoint(bounds.origin.x + 100, 
                   bounds.origin.y - 100)];
  NSLog(@"menu panel = %@", panel);
  NSArray *allWindows = GSAllWindows();
  NSEnumerator *e = [allWindows objectEnumerator];
  NSWindow *each;
  while (each = [e nextObject])
    {
      NSLog(@"win = %@", each);
    }
  
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
}

@end
