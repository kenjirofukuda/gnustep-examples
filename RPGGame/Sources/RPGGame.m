// @see https://www.gnustep.org/nicola/Tutorials/Renaissance/node7.html

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include <Renaissance/Renaissance.h>

#import "GameView.h"

@interface MyDelegate : NSObject
{
  IBOutlet NSWindow* window;
  IBOutlet GameView *gameView;

}
- (void) printHello: (id)sender;
- (void) applicationDidFinishLaunching: (NSNotification *)not;
// - (IBAction) startStepping: (id)sender;

@end

@implementation MyDelegate : NSObject

- (void) printHello: (id)sender
{
  printf ("Hello!\n");
}

- (void) applicationDidFinishLaunching: (NSNotification *)not;
{
  NSDebugLog(@"#applicationDidFinishLaunching: %@", not);
  [NSBundle loadGSMarkupNamed: @"Window"  owner: self];
}

- (BOOL) applicationShouldOpenUntitledFile: (NSApplication *)sender
{
  return NO;
}

/**
 * Invoked on notification that application will become active.
 */
- (void) applicationWillFinishLaunching: (NSNotification *)aNotification
{
  NSDebugLog(@"#applicationWillFinishLaunching: %@", aNotification);
}

- (void) awakeFromGSMarkup
{
  NSDebugLog(@"#awakeFromGSMarkup");
}

- (void) bundleDidLoadGSMarkup: (NSNotification *)aNotification
{
  NSDebugLog(@"#bundleDidLoadGSMarkup: %@", aNotification);
  NSDebugLog(@"subViews[0]: %@", [[aNotification userInfo] valueForKey: @"NSTopLevelObjects"]);
  NSDebugLog(@"window: %@", window);
  NSDebugLog(@"gameView: %@", gameView);
  [gameView startStepping: self];
}

// - (IBAction) startStepping: (id)sender
// {
//   NSDebugLog(@"startStepping: %@", sender);  
// }


@end

int main (int argc, const char **argv)
{
  ENTER_POOL;
  MyDelegate *delegate;
  [NSApplication sharedApplication];

  delegate = [MyDelegate new];
  [NSApp setDelegate: delegate];

#ifdef GNUSTEP
  [NSBundle loadGSMarkupNamed: @"Menu-GNUstep"  owner: delegate];
#else
  [NSBundle loadGSMarkupNamed: @"Menu-OSX"  owner: delegate];
#endif

  LEAVE_POOL;
  return NSApplicationMain (argc, argv);
}
