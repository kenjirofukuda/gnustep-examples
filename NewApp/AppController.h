/* 
   Project: NewApp

   Author: Kenjiro Fukuda

   Created: 2024-11-22 16:55:30 +0900 by kenjiro
   
   Application Controller
*/
 
#ifndef _PCAPPPROJ_APPCONTROLLER_H
#define _PCAPPPROJ_APPCONTROLLER_H

#import <AppKit/AppKit.h>
// Uncomment if your application is Renaissance-based
//#import <Renaissance/Renaissance.h>

#import "MyView.h"

@interface AppController : NSObject
{
  IBOutlet NSWindow *myWindow;
  IBOutlet MyView *myView; 
}

+ (void)  initialize;

- (id) init;
- (void) dealloc;

- (void) awakeFromNib;

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif;
- (NSApplicationTerminateReply) applicationShouldTerminate: (id)sender;
- (void) applicationWillTerminate: (NSNotification *)aNotif;
- (BOOL) application: (NSApplication *)application
	    openFile: (NSString *)fileName;

- (void) showPrefPanel: (id)sender;
- (void) showMainWIndow: (id)sender;
- (void) hideMainWIndow: (id)sender;
@end

#endif
