/* -*- mode: objc; coding: utf-8 -*- */
/*
   Project: TypingTutor

   Author: Kenjiro Fukuda,,,

   Created: 2023-03-11 11:40:54 +0900 by kenjiro

   Application Controller
*/

#ifndef _PCAPPPROJ_APPCONTROLLER_H
#define _PCAPPPROJ_APPCONTROLLER_H

#import <AppKit/AppKit.h>

@class BigLetterView;

@interface AppController : NSObject
{
  IBOutlet BigLetterView *inLetterView;
  IBOutlet BigLetterView *outLetterView;
  IBOutlet NSProgressIndicator *progressView;
  IBOutlet NSWindow *speedWindow;
  IBOutlet NSSlider *speedSlider;
  IBOutlet NSColorWell *colorWell;
  IBOutlet NSTextField *textField;
  int count;
  int ticks;
  NSTimer *timer;
  NSArray *letters;
  int lastIndex;
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

- (IBAction) showPrefPanel: (id)sender;
- (IBAction) stopGo: (id)sender;
- (IBAction) raiseSpeedWindow: (id)sender;
- (IBAction) endSpeedWindow: (id)sender;
- (IBAction) tackeColorFromTextField: (id)sender;
- (IBAction) tackeColorFromColorWell: (id)sender;

- (void) checkThem: (NSTimer *)timer;
- (void) showAnotherLetter;
- (void) sheetDidEnd: (NSWindow *)sheet
          returnCode: (int)returnCode
         contextInfo: (void *)contextInfo;

@end

#endif
