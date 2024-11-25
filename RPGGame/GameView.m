// -*- mode: ObjC -*-
#import <Foundation/Foundation.h>
#import "GameView.h"

@implementation GameView
- (instancetype) init
{
  if ((self = [super init]) != nil)
    {
      // implement hear
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_name);
  [super dealloc];
}

- (NSString *)name
{
  return _name;
}

- (void) setName: (NSString *)name
{
  ASSIGNCOPY(_name, name);
}

@end

// vim: filetype=objc ts=2 sw=2 expandtab
