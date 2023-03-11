/* All rights reserved */

#import <AppKit/AppKit.h>
#import "BigLetterView.h"

@implementation BigLetterView
- (void) setBgColor: (NSColor *)c;
{
  ASSIGN(bgColor, c);
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

@end
