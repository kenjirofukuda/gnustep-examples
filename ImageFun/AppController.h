/*
   Project: ImageFun

   Author: Kenjiro Fukuda,,,

   Created: 2023-03-04 17:04:01 +0900 by kenjiro

   Application Controller
*/

#ifndef _PCAPPPROJ_APPCONTROLLER_H
#define _PCAPPPROJ_APPCONTROLLER_H

#import <AppKit/AppKit.h>
#import "StretchView.h"
// Uncomment if your application is Renaissance-based
//#import <Renaissance/Renaissance.h>

@interface AppController : NSObject
{
  IBOutlet NSSlider *slider;
  IBOutlet StretchView *stretchView;
}

+ (void) initialize;

- (id) init;
- (void) dealloc;

- (void) awakeFromNib;

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif;
- (NSApplicationTerminateReply) applicationShouldTerminate: (id)sender
  ;
- (void) applicationWillTerminate: (NSNotification *)aNotif;
- (BOOL) application: (NSApplication *)application
            openFile: (NSString *)fileName;

- (IBAction) showPrefPanel: (id)sender;
- (IBAction) fade: (id)sender;
- (IBAction) open: (id)sender;

- (void) openPanelDidEnd: (NSWindow *)sheet
              returnCode: (int)returnCode
             contextInfo: (void *)contextInfo;
@end

#endif
