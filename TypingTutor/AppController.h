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
  int count;
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

- (void) checkThem: (NSTimer *)timer;
- (void) showAnotherLetter;

@end

#endif
