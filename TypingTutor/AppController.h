/*
   Project: TypingTutor

   Author: Kenjiro Fukuda,,,

   Created: 2023-03-11 11:40:54 +0900 by kenjiro

   Application Controller
*/

#ifndef _PCAPPPROJ_APPCONTROLLER_H
#define _PCAPPPROJ_APPCONTROLLER_H

#import <AppKit/AppKit.h>
// Uncomment if your application is Renaissance-based
//#import <Renaissance/Renaissance.h>

@interface AppController : NSObject
{
}

+ (void) initialize;

- (id) init;
- (void) dealloc;

- (void) awakeFromNib;

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif;
- (NSApplicationTerminateReply) applicationShouldTerminate: (id)sender;
- (void) applicationWillTerminate: (NSNotification *)aNotif;
- (BOOL) application: (NSApplication *)application
            openFile: (NSString *)fileName;

- (void) showPrefPanel: (id)sender;

@end

#endif
