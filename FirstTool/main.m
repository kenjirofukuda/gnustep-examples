/*
   Project: FirstTool

   Author: kenjiro,,,

   Created: 2024-10-26 10:37:11 +0900 by kenjiro
*/

#import <Foundation/Foundation.h>

#import "NSFileHandle+readLine.h"

void print_args()
{
  NSArray *args = [[NSProcessInfo processInfo] arguments];

  for (NSString * arg in args)
    {
      NSLog(@"%@", arg);
    }
}


void print_args_enumerator()
{
  NSArray *args = [[NSProcessInfo processInfo] arguments];

  NSEnumerator *enumerator = [args objectEnumerator];
  NSString *arg;
  while ((arg = [enumerator nextObject]) != nil)
    {
      NSLog(@"%@", arg);
    }
}


void print_args_indexed()
{
  NSArray *args = [[NSProcessInfo processInfo] arguments];

  for (int i = 0; i < [args count]; i++)
    {
      NSString *arg = [args objectAtIndex: i];
      NSLog(@"%@", arg);
    }
}

void print_text(NSFileHandle *fh)
{
  NSData *lineData = nil;
  while ((lineData = [fh readLineWithDelimiter: @"\n"]))
    {
      NSString *lineString =
        [[NSString alloc] initWithData: lineData
                              encoding: NSUTF8StringEncoding];

      GSPrintf(stdout,  @"%@", lineString);
    }
}


NSString *FNgetInput()
{
  return [[[NSString alloc]
                initWithData:
              [[NSFileHandle fileHandleWithStandardInput] availableData]
                    encoding: NSUTF8StringEncoding]
               stringByTrimmingCharactersInSet: [NSCharacterSet newlineCharacterSet]];
}


void example_print_text_lines()
{
  NSArray *args = [[NSProcessInfo processInfo] arguments];
  NSFileManager *fm = [NSFileManager defaultManager];
  NSFileHandle *fh = nil;

  if ([args count] <= 1)
    {
      NSLog(@"Read form stdin");
      // fh = [NSFileHandle fileHandleWithStandardInput];
      // print_text(fh);
      NSString  *lineData = nil;
      while ((lineData = FNgetInput()) != nil) {
        // TODO: trap CNTL + D
        if ([lineData isEqualToString: @ ""]) {
          break;
        }
        NSLog(@"%@", lineData);
        GSPrintf(stdout,  @"%@", lineData);
      }
      return;
    }

  NSUInteger argIndex = 0;
  for (NSString * arg in args)
    {
      NSLog(@"%@", arg);
      if (argIndex > 0 && [fm fileExistsAtPath: arg])
        {
          fh = [NSFileHandle fileHandleForReadingAtPath: arg];
          print_text(fh);
        }
      argIndex++;
    }
}



int main(int argc, const char *argv[])
{
  ENTER_POOL;

  NSLog(@"Hello World!");
  example_print_text_lines();
  
  LEAVE_POOL;
  return 0;
}

