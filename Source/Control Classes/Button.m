/*
    Button.m
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

#import "Button.h"


// .............................................................................

@implementation Button
{
    SKSpriteNode*   _icon;

    CGFloat         _frameMargin;
    CGRect          _enlargedFrame;
}

@synthesize icon = _icon;

// .............................................................................

- (id) initWithNormalColor:(SKColor*) normalColor
          highlightedColor:(SKColor*) highlightedColor
           normalTextColor:(SKColor*) normalTextColor
      highlightedTextColor:(SKColor*) highlightedTextColor
                      size:(CGSize)size
{
    if ((self = [super initWithSize:size])) {
        
        [self setNormalColor:normalColor];
        [self setHighlightedColor:highlightedColor];
        [self setNormalFontColor:normalTextColor];
        [self setHighlightedFontColor:highlightedTextColor];
        
        _frameMargin = 10.0f;
    }
    
    return self;
}

// .............................................................................

- (id) initWithNormalColor:(SKColor*) normalColor
          highlightedColor:(SKColor*) highlightedColor
                      size:(CGSize)size
{
    // Default to white text in both states
    
    return [self initWithNormalColor:normalColor
                    highlightedColor:highlightedColor
                     normalTextColor:[SKColor whiteColor]
                highlightedTextColor:[SKColor whiteColor]
                                size:size];
}

// .............................................................................

#pragma mark - Custom Accessors


- (void) setIcon:(SKSpriteNode*) icon
{
    if (_icon && [_icon parent] == self) {
        [_icon removeFromParent];
    }
    
    _icon = icon;
    
    [self addChild:_icon];
    
    [_icon setColorBlendFactor:1.0f];
    
    if ([self isHighlighted]) {
        [_icon setColor:[self highlightedFontColor]];
    }
    else{
        [_icon setColor:[self normalFontColor]];
    }
}

// .............................................................................

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        //DLog(@"HIGHLIGHTING BUTTON");
        [_icon setColor:[self highlightedFontColor]];
    }
    else{
        //DLog(@"DE-HIGHLIGHTING BUTTON");
        [_icon setColor:[self normalFontColor]];
    }
}

// .............................................................................

@end
