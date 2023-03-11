/* All rights reserved */

#import <AppKit/AppKit.h>
#import "BigLetterView.h"

@implementation BigLetterView

- (instancetype) initWithFrame: (NSRect)rect
{
  if (self = [super initWithFrame: rect])
    {
      [self setBgColor: [NSColor yellowColor]];
      [self setString: @" "];
    }
  return self;
}


- (void) drawRect: (NSRect)rect
{
  NSRect bounds = [self bounds];
  [bgColor set];
  [NSBezierPath fillRect: bounds];

  if ([[self window] firstResponder] == self)
    {
      [[NSColor blackColor] set];
      [NSBezierPath setDefaultLineWidth: 2.0];
      NSFrameRect(bounds);
    }
}


- (void) setBgColor: (NSColor *)c;
{
  ASSIGN(bgColor, c);
  [self setNeedsDisplay: YES];
}


- (NSColor *) bgColor
{
  return bgColor;
}


- (void) setString: (NSString *)s
{
  ASSIGN(string, s);
}


- (NSString *) string
{
  return string;
}


- (BOOL) acceptsFirstResponder
{
  NSLog(@"Accepting");
  return YES;
}


- (BOOL) resignFirstResponder
{
  NSLog(@"Resigning");
  [self setNeedsDisplay: YES];
  return YES;
}


- (BOOL) becomeFirstResponder
{
  NSLog(@"Becoming");
  [self setNeedsDisplay: YES];
  return YES;
}


@end
