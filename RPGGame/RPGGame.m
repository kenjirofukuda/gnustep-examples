// @see https://www.gnustep.org/nicola/Tutorials/Renaissance/node7.html

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include <Renaissance/Renaissance.h>

@interface MyDelegate : NSObject
{}
- (void) printHello: (id)sender;
- (void) applicationDidFinishLaunching: (NSNotification *)not;
@end

@implementation MyDelegate : NSObject

- (void) printHello: (id)sender
{
  printf ("Hello!\n");
}

- (void) applicationDidFinishLaunching: (NSNotification *)not;
{
  [NSBundle loadGSMarkupNamed: @"Window"  owner: self];
}
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
