/* All rights reserved */

#import <AppKit/AppKit.h>
#import "BigLetterView.h"

@implementation BigLetterView

- (instancetype) initWithFrame: (NSRect)rect
{
  if (self = [super initWithFrame: rect])
    {
      [self prepareAttributes];
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

  [self drawStringCenteredIn: bounds];
  if ([[self window] firstResponder] == self)
    {
      [[NSColor blackColor] set];
      [NSBezierPath setDefaultLineWidth: 2.0];
      NSFrameRect(bounds);
    }
}


- (void) prepareAttributes
{
  attributes = [[NSMutableDictionary alloc] init];

  [attributes setObject: [NSFont fontWithName: @"IPAGothic"
                   size: [self bounds].size.height * 0.9]
                 forKey: NSFontAttributeName];

  [attributes setObject: [NSColor redColor]
                 forKey: NSForegroundColorAttributeName];
}


- (void) drawStringCenteredIn: (NSRect)r
{
  NSPoint stringOrigin;
  NSSize stringSize;

  stringSize = [string sizeWithAttributes: attributes];
  NSLog(@"stringSize = %@", NSStringFromSize(stringSize));
  stringOrigin.x = r.origin.x + (r.size.width - stringSize.width) / 2;
  stringOrigin.y = r.origin.y + (r.size.height - stringSize.height) / 2;
  NSLog(@"stringOrigin = %@", NSStringFromPoint(stringOrigin));
  [string drawAtPoint: stringOrigin withAttributes: attributes];
}


- (void) keyDown: (NSEvent *)event
{
  NSString *input = [event characters];
  // Tab ?
  if ([input isEqual: @"\t"])
    {
      [[self window] selectNextKeyView: nil];
      return;
    }
  // Shift + Tab ?
  if ([input isEqual: @"\031"])
    {
      [[self window] selectPreviousKeyView: nil];
      return;
    }
  [self setString: input];
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
  [self setNeedsDisplay: YES];
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

- (void) dealloc
{
  RELEASE(bgColor);
  RELEASE(string);
  RELEASE(attributes);
  DEALLOC;
}



@end
