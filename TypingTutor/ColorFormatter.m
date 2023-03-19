/*
   Project: TypingTutor

   Copyright (C) 2023 Free Software Foundation

   Author: Kenjiro Fukuda,,,

   Created: 2023-03-19 08:25:49 +0900 by kenjiro

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import <AppKit/AppKit.h>
#import "ColorFormatter.h"

@implementation ColorFormatter

- (instancetype) init
{
  if (self = [super init])
    {
      colorList = RETAIN([NSColorList colorListNamed: @"System"]);
    }
  return self;
}


- (NSString *) firstColorKeyForPartialString: (NSString *)string
{
  NSArray *keys = [colorList allKeys];
  int keyCount = [keys count];
  NSString *key;
  NSRange whereFound;
  int i;

  for (i = 0; i < keyCount; i++)
    {
      key = [keys objectAtIndex: i];
      whereFound = [key rangeOfString: string options: NSCaseInsensitiveSearch];
      if ((whereFound.location == 0) && (whereFound.length > 0))
        {
          return key;
        }
    }
  return nil;
}

- (NSString *) stringForObjectValue: (id)obj
{
  CGFloat red, green, blue, alpha;
  NSString *closetKey;
  int i, keyCount;
  NSArray *keys;
  float howClose;

  if (! [obj isKindOfClass: [NSColor class]])
    return nil;

  [obj getRed: &red green: &green blue: &blue alpha: &alpha];
  keys = [colorList allKeys];
  keyCount = [keys count];
  howClose = 3;

  closetKey = nil;

  for (i = 0; i < keyCount; i++)
    {
      CGFloat red2, green2, blue2, alpha2;
      NSColor *color2;
      NSString *key;
      float distance;

      key = [keys objectAtIndex: i];
      color2 = [colorList colorWithKey: key];

      [color2 getRed: &red2 green: &green2 blue: &blue2 alpha: &alpha2];
      distance = fabs(red2 - red) +
                 fabs(green2 - green) +
                 fabs(blue2 - blue);
      if (distance < howClose)
        {
          howClose = distance;
          closetKey = key;
        }
    }
  return closetKey;
}


- (BOOL) getObjectValue: (id *)obj
              forString: (NSString *)string
       errorDescription: (NSString **)errorString
{
  NSString *matchingKey = [self firstColorKeyForPartialString: string];
  if (matchingKey)
    {
      *obj = [colorList colorWithKey: matchingKey];
      return YES;
    }

  if (errorString != NULL)
    {
      *errorString = @"No such color";
    }
  return NO;
}


- (void)dealloc {
  RELEASE(colorList);
  DEALLOC;
}
@end
