/* -*- mode: objc; coding: utf-8 -*- */
/* All rights reserved */

#import <AppKit/AppKit.h>
#import "BigLetterView.h"
#import "FirstLetter.h"

@implementation BigLetterView

- (instancetype) initWithFrame: (NSRect)rect
{
  if (self = [super initWithFrame: rect])
    {
      highlighted = NO;
      [self prepareAttributes];
      [self setBgColor: [NSColor yellowColor]];
      [self setString: @" "];
      [self registerForDraggedTypes: @[NSPasteboardTypeString]];
    }

  return self;
}


- (void) drawRect: (NSRect)rect
{
  NSRect bounds = [self bounds];
  if (highlighted)
    {
      [[NSColor whiteColor] set];
    }
  else
    {
      [bgColor set];
    }
  [NSBezierPath fillRect: bounds];
  [self drawStringCenteredIn: bounds];

  if ([[self window] firstResponder] == self)
    {
      [[NSColor blackColor] set];
      [NSBezierPath setDefaultLineWidth: 2.0];
      NSFrameRect(bounds);
    }
}


#if GNUSTEP
- (void) setFrameSize: (NSSize)newSize
{
  [super setFrameSize: newSize];
//  NSLog(@"setFrameSize: %@", NSStringFromSize(newSize));
  [self prepareAttributes];
}


- (void) setFrame: (NSRect)newRect
{
  [super setFrame: newRect];
//  NSLog(@"setFrame: %@", NSStringFromRect(newRect));
  [self prepareAttributes];
}


#else
- (void) viewDidEndLiveResize
{
  NSLog(@"viewDidEndLiveResize");
  [self prepareAttributes];
  [self setNeedsDisplay: YES];
}


#endif

- (void) prepareAttributes
{
  ASSIGN(attributes, [[NSMutableDictionary alloc] init]);
  NSRect bounds = [self bounds];
  CGFloat minSize = MIN(bounds.size.width, bounds.size.height);
  // *INDENT-OFF*
  [attributes setObject: [NSFont userFontOfSize: minSize]
                 forKey: NSFontAttributeName];
  [attributes setObject: [NSColor redColor]
                 forKey: NSForegroundColorAttributeName];
  // *INDENT-ON*
}

- (void) drawStringCenteredIn: (NSRect)r
{
  NSPoint stringOrigin;
  NSSize stringSize;
  stringSize = [string sizeWithAttributes: attributes];
  // NSLog(@"stringSize = %@", NSStringFromSize(stringSize));
  stringOrigin.x = r.origin.x + (r.size.width - stringSize.width) / 2;
  stringOrigin.y = r.origin.y + (r.size.height - stringSize.height) / 2;
  // NSLog(@"stringOrigin = %@", NSStringFromPoint(stringOrigin));
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


- (IBAction) savePDF: (id)sender
{
  NSSavePanel *panel = [NSSavePanel savePanel];
  [panel setRequiredFileType: @"pdf"];
  [panel beginSheetForDirectory: nil
                           file: nil
                 modalForWindow: [self window]
                  modalDelegate: self
                 didEndSelector:
               @selector(didEnd:returnCode:contextInfo:)
                    contextInfo: nil];
}


- (void) didEnd: (NSSavePanel *)sheet
     returnCode: (int)code
    contextInfo: (void *)contextInfo
{
  NSLog(@"didEnd:returnCode:contextInfo:");
  NSRect r;
  NSData *data;

  if (code == NSOKButton)
    {
      r = [self bounds];
      data = [self dataWithPDFInsideRect: r];
      [data writeToFile: [sheet filename] atomically: YES];
    }
}


- (void) writeStringToPasteboard: (NSPasteboard *)pb
{
  [pb declareTypes: @[NSPasteboardTypeString] owner: self];
  [pb setString: string forType: NSPasteboardTypeString];
}


- (BOOL) readStringFromPasteboard: (NSPasteboard *)pb
{
  NSString *value;
  NSString *type;
  type = [pb availableTypeFromArray: @[NSPasteboardTypeString]];

  if (type)
    {
      value = [pb stringForType: NSPasteboardTypeString];
      [self setString: [value firstLetter]];
      return YES;
    }
  return NO;
}


- (NSDragOperation) draggingSourceOperationMaskForLocal: (BOOL)flag
{
  return NSDragOperationCopy;
}


- (void) mouseDragged: (NSEvent *)event
{
  NSRect imageBounds;
  NSPasteboard *pb;
  NSImage *anImage;
  NSSize s;
  NSPoint p;

  anImage = [[NSImage alloc] init];

  s = [string sizeWithAttributes: attributes];

  imageBounds.origin = NSMakePoint(0, 0);
  imageBounds.size = s;
  [anImage setSize: s];

  [anImage lockFocus];
  [self drawStringCenteredIn: imageBounds];
  [anImage unlockFocus];

  p = [self convertPoint: [event locationInWindow] fromView: nil];

  p.x = p.x - s.width / 2;
  p.y = p.y - s.height / 2;

  pb = [NSPasteboard pasteboardWithName: NSDragPboard];

  [self writeStringToPasteboard: pb];
  [self dragImage: anImage
               at: p
           offset: NSMakeSize(0, 0)
            event: event
       pasteboard: pb
           source: self
        slideBack: YES];
  RELEASE(anImage);
}

- (NSDragOperation) draggingEntered: (id <NSDraggingInfo>)sender
{
  NSLog(@"draggingEntered:");
  if ([sender draggingSource] != self)
    {
      NSPasteboard *pb = [sender draggingPasteboard];
      NSString *type = [pb availableTypeFromArray: @[NSPasteboardTypeString]];
      if (type != nil)
        {
          highlighted = YES;
          [self setNeedsDisplay: YES];
          return NSDragOperationCopy;
        }
    }
  return NSDragOperationNone;
}


- (void) draggingExited: (id <NSDraggingInfo>)sender
{
  NSLog(@"draggingExited:");
  highlighted = NO;
  [self setNeedsDisplay: YES];
}


- (BOOL) prepareForDragOperation: (id <NSDraggingInfo>)sender
{
  return YES;
}


- (BOOL) performDragOperation: (id <NSDraggingInfo>)sender
{
  NSPasteboard *pb = [sender draggingPasteboard];
  if (![self readStringFromPasteboard: pb])
    {
      NSLog(@"Error: COuld not read from dragging pasteboard");
      return NO;
    }
  return YES;
}


- (void) concludeDragOperation: (id <NSDraggingInfo>)sender
{
  NSLog(@"concludeDragOperation:");
  highlighted = NO;
  [self setNeedsDisplay: YES];
}


- (IBAction) cut: (id)sender
{
  [self copy: sender];
  [self setString: @" "];
}


- (IBAction) copy: (id)sender
{
  NSPasteboard *pb = [NSPasteboard generalPasteboard];
  [self writeStringToPasteboard: pb];
}


- (IBAction) paste: (id)sender
{
  NSPasteboard *pb = [NSPasteboard generalPasteboard];
  if (! [self readStringFromPasteboard: pb])
    {
      NSBeep();
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
