/*
    Switch.m
    SpriteKit iOS Basic Controls

    Created by Nicolas Miari on 6/9/14.
    Copyright (c) 2014 Nicolás Miari. All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
 */

#import "Switch.h"


// .............................................................................

@implementation Switch
{
    /* Parent class's state variable gets overwritten during highlighting, so we
      need an extra bool to keep track of switch toggle.
     */
    BOOL     _toggle;
}

// .............................................................................

- (void) touchUpInside
{
    [super touchUpInside];
    
    
    // Toggle Switch's selection state:
    _toggle = !_toggle;

    
    // Display it using Control's "selected" state:
    [self setSelected:_toggle];
    
    
    // Value changed, notify the Control's delegate:
    [[self delegate] performSelector:@selector(controlValueChanged:)
                          withObject:self];
}

// .............................................................................


@end
