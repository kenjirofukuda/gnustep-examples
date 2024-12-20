/*
   Project: TypingTutor

   Author: Kenjiro Fukuda,,,

   Created: 2023-03-11 11:40:54 +0900 by kenjiro

   Application Controller
*/

#import "AppController.h"
#import "ColorFormatter.h"
#import "BigLetterView.h"

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
      ticks = 10;
#if defined(__OBJC2__)
      letters = @[@"a", @"s", @"d", @"f", @"j", @"k", @"l", @";"];
      RETAIN(letters);
#else
      letters = [[NSArray alloc] initWithObjects:
				   @"a", @"s", @"d", @"f", @"j", @"k", @"l", @";", nil];
#endif
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
  NSLog(@"awakeFromNib:");
  ColorFormatter *colorFormatter = [[ColorFormatter alloc] init];
  [textField setFormatter: colorFormatter];
  RELEASE(colorFormatter);
  [textField setObjectValue: [inLetterView bgColor]];
  [colorWell setColor: [inLetterView bgColor]];
  [self showAnotherLetter];
}


- (void) applicationDidFinishLaunching: (NSNotification *)aNotif
{
  NSLog(@"applicationDidFinishLaunching:");
  NSWindow *mainWindow = [NSApp mainWindow];
  if (mainWindow)
    {
      [mainWindow center];
      [mainWindow makeKeyAndOrderFront: self];
    }
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
  if (count > ticks)
    {
      NSBeep();
      count = 0;
    }
  [progressView setDoubleValue: (100.0 * count) / ticks];
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
  count = 0;
}


- (IBAction) raiseSpeedWindow: (id)sender
{
  NSLog(@"raiseSpeedWindow");
  [speedSlider setIntValue: ticks];
  [NSApp beginSheet: speedWindow
     modalForWindow: [inLetterView window]
      modalDelegate: self
     didEndSelector: @selector(sheetDidEnd: returnCode: contextInfo:)
        contextInfo: nil];
}


- (IBAction) endSpeedWindow: (id)sender
{
  [speedWindow orderOut: sender];
  [NSApp endSheet: speedWindow returnCode: 1];
}


- (void) sheetDidEnd: (NSWindow *)sheet
          returnCode: (int)returnCode
         contextInfo: (void *)contextInfo
{
  ticks = [speedSlider intValue];
  count = 0;
  NSLog(@"sheetDidEnd: return code = %d", returnCode);
}


- (IBAction) takeColorFromTextField: (id)sender
{
  NSLog(@"tackeColorFromTextField: %@", sender);
  NSColor *c = [sender objectValue];
  NSLog(@"taking color form text field");
  [inLetterView setBgColor: c];
  [colorWell setColor: c];
}


- (IBAction) takeColorFromColorWell: (id)sender
{
  NSColor *c = [sender color];
  NSLog(@"taking color form color well");
  [inLetterView setBgColor: c];
  [colorWell setColor: c];
}


@end
