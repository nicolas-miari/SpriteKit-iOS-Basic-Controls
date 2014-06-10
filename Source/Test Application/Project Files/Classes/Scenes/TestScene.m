/*
    TestScene.m
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

#import "TestScene.h"

#import "Button.h"
#import "Switch.h"


// .............................................................................

@implementation TestScene
{
    
}


// .............................................................................

-(id) initWithSize:(CGSize) size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];
        
        [self setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        [self setBackgroundColor:[SKColor whiteColor]];
        
        
        Button* testButton = [[Button alloc] initWithSize:CGSizeMake(200.0f, 70.0f)];
        
        [testButton setLabelText:@"Button"];
        
        [testButton setPosition:CGPointMake(0.0f, +100.0f)];
        
        [self addChild:testButton];
        
        
        [testButton addTarget:self
                       action:@selector(controlAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
        
        Switch* testSwitch = [[Switch alloc] initWithSize:CGSizeMake(200.0f, 70.0f)];
        
        [testSwitch setNormalLabelText:@"Switch (OFF)"];
        [testSwitch setSelectedLabelText:@"Switch (ON)"];
        
        [testSwitch setPosition:CGPointMake(0.0f, -100.0f)];
        
        [self addChild:testSwitch];
    }
    
    return self;
}

// .............................................................................

- (void) controlAction:(id) sender
{
    NSLog(@"Button Action!");
}

@end

// .............................................................................