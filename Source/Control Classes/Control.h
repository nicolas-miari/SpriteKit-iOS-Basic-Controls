/*
    Control.h
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

@import SpriteKit;


// .............................................................................

typedef NS_ENUM(NSInteger, ControlState)
{
    ControlStateNormal = 0,
    ControlStateHighlighted,
    ControlStateSelected,
    ControlStateDisabled,
    
    ControlStateMax
};

// .............................................................................

@class Control;

@protocol ControlDelegate <NSObject>

- (void) controlValueChanged:(Control*) control;

@end

// .............................................................................

@interface Control : SKSpriteNode

///
@property (nonatomic, weak) id <ControlDelegate>  delegate;

///
@property (nonatomic, readwrite) NSUInteger       tag;

///
@property (nonatomic, readwrite, strong) SKColor* normalColor;

///
@property (nonatomic, readwrite, strong) SKColor* highlightedColor;

///
@property (nonatomic, readwrite, strong) SKColor* selectedColor;

///
@property (nonatomic, readwrite, strong) SKColor* disabledColor;

///
@property (nonatomic, readwrite) CGFloat fontSize;

///
@property (nonatomic, readwrite) CGFloat normalFontSize;

///
@property (nonatomic, readwrite) CGFloat highlightedFontSize;

///
@property (nonatomic, readwrite) CGFloat selectedFontSize;

///
@property (nonatomic, readwrite) CGFloat disabledFontSize;

///
@property (nonatomic, readwrite) CGFloat boundsTolerance;

///
@property (nonatomic, readwrite, copy) NSString* labelText;

///
@property (nonatomic, readwrite, copy) NSString* normalLabelText;

///
@property (nonatomic, readwrite, copy) NSString* highlightedLabelText;

///
@property (nonatomic, readwrite, copy) NSString* selectedLabelText;

///
@property (nonatomic, readwrite, copy) NSString* disabledLabelText;

///
@property (nonatomic, readwrite, strong) UIColor* fontColor;

///
@property (nonatomic, readwrite, strong) UIColor* normalFontColor;

///
@property (nonatomic, readwrite, strong) UIColor* highlightedFontColor;

///
@property (nonatomic, readwrite, strong) UIColor* selectedFontColor;

///
@property (nonatomic, readwrite, strong) UIColor* disabledFontColor;

///
@property (nonatomic, readwrite, getter = isEnabled    ) BOOL enabled;

///
@property (nonatomic, readwrite, getter = isSelected   ) BOOL selected;

///
@property (nonatomic, readwrite, getter = isHighlighted) BOOL highlighted;



/**
 */
- (instancetype) initWithSize:(CGSize) size;


/**
 */
- (void) addTarget:(id) target
            action:(SEL) action
  forControlEvents:(UIControlEvents) events;


/**
 */
- (void) removeTarget:(id) target;


/**
 */
- (void) touchDown NS_REQUIRES_SUPER;


/**
 */
- (void) drag NS_REQUIRES_SUPER;


/**
 */
- (void) dragEnter NS_REQUIRES_SUPER;


/**
 */
- (void) dragInside NS_REQUIRES_SUPER;


/**
 */
- (void) dragExit NS_REQUIRES_SUPER;


/**
 */
- (void) dragOutside NS_REQUIRES_SUPER;


/**
 */
- (void) touchUpInside NS_REQUIRES_SUPER;


/**
 */
- (void) touchUpOutside NS_REQUIRES_SUPER;


/**
 */
- (void) appearWithColor:(SKColor*) color
              afterDelay:(CGFloat) delay;


// .............................................................................

@end
