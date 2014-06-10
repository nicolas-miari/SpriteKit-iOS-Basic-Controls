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

#import "Control.h"


// .............................................................................

#define ControlDefaultFontName              @"Helvetica"

#define ControlDefaultNormalColor           [SKColor grayColor]
#define ControlDefaultHighlightedColor      [SKColor blueColor]
#define ControlDefaultSelectedColor         [SKColor redColor]
#define ControlDefaultDisabledColor         [SKColor lightGrayColor]

#define ControlDefaultNormalFontColor       [SKColor blackColor]
#define ControlDefaultHighlightedFontColor  [SKColor whiteColor]
#define ControlDefaultSelectedFontColor     [SKColor whiteColor]
#define ControlDefaultDisabledFontColor     [SKColor whiteColor]

#define ControlDefaultNormalFontSize        18.0f
#define ControlDefaultHighlightedFontSize   18.0f
#define ControlDefaultSelectedFontSize      18.0f
#define ControlDefaultDisabledFontSize      18.0f


// .............................................................................

static NSString* globalTouchDownSoundName     = nil;
static NSString* globalTouchUpInsideSoundName = nil;


// .............................................................................

@interface TargetActionInfo : NSObject

@property (nonatomic, readonly) id              target;

@property (nonatomic, readonly) SEL             action;

#if TARGET_OS_IPHONE
@property (nonatomic, readonly) UIControlEvents events;
#endif

@end


// .............................................................................

@implementation TargetActionInfo
{
    id __weak       _target;
    SEL             _action;
    
#if TARGET_OS_IPHONE
    UIControlEvents _events;
#endif
}

@synthesize target = _target;
@synthesize action = _action;
#if TARGET_OS_IPHONE
@synthesize events = _events;
#endif

// .............................................................................

- (instancetype) initWithTarget:(id) target
                         action:(SEL) action
{
    if ((self = [super init])) {
        
        _target = target;
        _action = action;
    }
    
    return self;
}

// .............................................................................

#if TARGET_OS_IPHONE

- (instancetype) initWithTarget:(id) target
                         action:(SEL) action
                  controlEvents:(UIControlEvents) events

{
    if ((self = [self initWithTarget:target action:action])) {
        
        _events = events;
    }
    
    return self;
}

#endif

@end

// .............................................................................

@implementation Control
{
    id<ControlDelegate> __weak _delegate;
    
    NSUInteger      _tag;
    
    ControlState    _state;
    BOOL            _selected;
    
    SKLabelNode*    _normalLabel;
    SKLabelNode*    _highlightedLabel;
    SKLabelNode*    _selectedLabel;
    SKLabelNode*    _disabledLabel;
    
    SKColor*        _normalColor;
    SKColor*        _highlightedColor;
    SKColor*        _selectedColor;
    
#if TARGET_OS_IPHONE
    UITouch*        _touch;
#endif
    CGPoint         _touchLocationLast;
    BOOL            _moved;
    
    NSMutableArray* _targetActions;
    
    NSString*       _touchDownSoundName;
    NSString*       _touchUpInsideSoundName;
    
    CGFloat         _boundsTolerance;
}

@synthesize delegate           = _delegate;
@synthesize tag                = _tag;
@synthesize normalColor        = _normalColor;
@synthesize highlightedColor   = _highlightedColor;
@synthesize selectedColor      = _selectedColor;
@synthesize disabledColor      = _disabledColor;
@synthesize boundsTolerance    = _boundsTolerance;


// .............................................................................

#pragma mark - Class Methods

+ (void) setTouchDownSoundName:(NSString*) soundName
{
    globalTouchDownSoundName = [soundName copy];
}

// .............................................................................

+ (void) setTouchUpInsideSoundName:(NSString*) soundName
{
    globalTouchUpInsideSoundName = soundName;
}

// .............................................................................

#pragma mark - Designated Initializer


- (instancetype) initWithSize:(CGSize)size
{
    if ((self = [super initWithColor:ControlDefaultNormalColor size:size])) {
        
        _targetActions = [NSMutableArray new];
        
        _boundsTolerance = 0.0f;
        
        [self setUserInteractionEnabled:YES];
        
        [self setColorBlendFactor:1.0f];
        
        _normalColor      = ControlDefaultNormalColor;
        _highlightedColor = ControlDefaultHighlightedColor;
        _selectedColor    = ControlDefaultSelectedColor;
        _disabledColor    = ControlDefaultDisabledColor;
        
        _normalLabel = [[SKLabelNode alloc] initWithFontNamed:ControlDefaultFontName];
        [_normalLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [_normalLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [_normalLabel setFontSize:ControlDefaultNormalFontSize];
        [_normalLabel setFontColor:ControlDefaultNormalFontColor];
        [self addChild:_normalLabel];
        
        _highlightedLabel = [[SKLabelNode alloc] initWithFontNamed:ControlDefaultFontName];
        [_highlightedLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [_highlightedLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [_highlightedLabel setFontSize:ControlDefaultHighlightedFontSize];
        [_highlightedLabel setFontColor:ControlDefaultHighlightedFontColor];
        [self addChild:_highlightedLabel];
        [_highlightedLabel setAlpha:0.0f];
        
        _selectedLabel = [[SKLabelNode alloc] initWithFontNamed:ControlDefaultFontName];
        [_selectedLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [_selectedLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [_selectedLabel setFontSize:ControlDefaultSelectedFontSize];
        [_selectedLabel setFontColor:ControlDefaultSelectedFontColor];
        [self addChild:_selectedLabel];
        [_selectedLabel setAlpha:0.0f];
        
        _disabledLabel = [[SKLabelNode alloc] initWithFontNamed:ControlDefaultFontName];
        [_disabledLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [_disabledLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [_disabledLabel setFontSize:ControlDefaultDisabledFontSize];
        [_disabledLabel setFontColor:ControlDefaultDisabledFontColor];
        [self addChild:_disabledLabel];
        [_disabledLabel setAlpha:0.0f];
    }
    
    return self;
}

// .............................................................................

#pragma mark - Operation


- (void) setHighlighted:(BOOL) highlighted
{
    if (highlighted) {
        // Set
        
        if (_state == ControlStateNormal) {
            [_highlightedLabel setText:[_normalLabel text]];
        }
        else if(_state == ControlStateSelected){
            [_highlightedLabel setText:[_selectedLabel text]];
        }
        
        _state = ControlStateHighlighted;
        
        [self setColor:_highlightedColor];
        
        [_normalLabel      setAlpha:0.0f];
        [_highlightedLabel setAlpha:1.0f];
        [_selectedLabel    setAlpha:0.0f];
        [_disabledLabel    setAlpha:0.0f];
    }
    else{
        // Unset
        
        _state = ControlStateNormal;
        
        [self setColor:_normalColor];
        
        [_normalLabel      setAlpha:1.0f];
        [_highlightedLabel setAlpha:0.0f];
        [_selectedLabel    setAlpha:0.0f];
        [_disabledLabel    setAlpha:0.0f];
    }
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (BOOL) isHighlighted
{
    return (_state == ControlStateHighlighted);
}

// .............................................................................

- (void) setSelected:(BOOL) selected
{
    if (selected) {
        // Set
        
        _state = ControlStateSelected;
        
        [self setColor:_selectedColor];
        
        [_normalLabel      setAlpha:0.0f];
        [_highlightedLabel setAlpha:0.0f];
        [_selectedLabel    setAlpha:1.0f];
        [_disabledLabel    setAlpha:0.0f];
    }
    else{
        // Unset
        
        _state = ControlStateNormal;
        
        [self setColor:_normalColor];
        
        [_normalLabel      setAlpha:1.0f];
        [_highlightedLabel setAlpha:0.0f];
        [_selectedLabel    setAlpha:0.0f];
        [_disabledLabel    setAlpha:0.0f];
    }
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (BOOL) isSelected
{
    return (_state == ControlStateSelected);
}

// .............................................................................

- (void) setEnabled:(BOOL) enabled
{
    if (enabled) {
        // Set
        
        _state = ControlStateNormal;
        
        [self setColor:_normalColor];
        
        [_normalLabel      setAlpha:1.0f];
        [_highlightedLabel setAlpha:0.0f];
        [_selectedLabel    setAlpha:0.0f];
        [_disabledLabel    setAlpha:0.0f];
    }
    else{
        // Unset
        
        _state = ControlStateDisabled;
        
        [self setColor:_disabledColor];
        
        [_normalLabel      setAlpha:0.0f];
        [_highlightedLabel setAlpha:0.0f];
        [_selectedLabel    setAlpha:0.0f];
        [_disabledLabel    setAlpha:1.0f];
    }
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (BOOL) isEnabled
{
    return (_state != ControlStateDisabled);
}

// .............................................................................

#if TARGET_OS_IPHONE

- (void) addTarget:(id) target
            action:(SEL) action
  forControlEvents:(UIControlEvents) events
{
    for (TargetActionInfo* info in _targetActions) {
        if ([info target] == target) {
            if ([info action] == action) {
                if ([info events] == events) {
                    return;
                }
            }
        }
    }
    
    
    TargetActionInfo* info = [[TargetActionInfo alloc] initWithTarget:target
                                                                action:action
                                                         controlEvents:events];
    [_targetActions addObject:info];
}

#else

- (void) addTarget:(id) target
            action:(SEL) action
{
    for (TargetActionInfo* info in _targetActions) {
        if ([info target] == target) {
            if ([info action] == action) {
                return;
            }
        }
    }
    
    
    TargetActionInfo* info = [[TargetActionInfo alloc] initWithTarget:target
                                                               action:action];
    [_targetActions addObject:info];
}

#endif

// .............................................................................

- (void) removeTarget:(id) target
{
    NSMutableArray* infosToRemove = [NSMutableArray new];
    
    for (TargetActionInfo* info in _targetActions) {
        
        if ([info target] == target) {
            [infosToRemove addObject:info];
        }
    }
    
    [_targetActions removeObjectsInArray:infosToRemove];
}

// .............................................................................

- (void) appearWithColor:(SKColor*) color afterDelay:(CGFloat) delay
{
    [self setUserInteractionEnabled:NO];
    
    SKSpriteNode* sprite = [[SKSpriteNode alloc] initWithColor:color size:self.size];
    [sprite setColorBlendFactor:1.0f];
    
    SKLabelNode* label = [_normalLabel copy];
    [label setFontColor:[SKColor whiteColor]];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    
    [sprite addChild:label];
    
    [sprite setAlpha:0.0f];
    
    [self addChild:sprite];
    
    
    [self setColor:[SKColor clearColor]];
    [_normalLabel setAlpha:0.0f];
    
    [self runAction:[SKAction waitForDuration:delay]
         completion:^(void){
             
             SKAction* action1 = [SKAction fadeAlphaTo:1.0f
                                              duration:0.0625f];
             
             [action1 setTimingMode:SKActionTimingEaseIn];
             
             [sprite runAction:action1
                    completion:^(void) {
                        
                        [self setUserInteractionEnabled:YES];
                        
                        [self setColor:_normalColor];
                        [_normalLabel setAlpha:1.0f];
                        
                        [self runAction:[SKAction waitForDuration:0.125f]
                             completion:^(void){
                                 
                                 
                                 SKAction* action2 = [SKAction fadeAlphaTo:0.0f
                                                                  duration:0.5f];
                                 
                                 [action2 setTimingMode:SKActionTimingEaseOut];
                                 
                                 [sprite runAction:action2
                                        completion:^(void){
                                            [sprite removeFromParent];
                                            
                                            
                                        }];
                             }];
                    }];
         }];
}

// .............................................................................

- (void) callMethodForTargetAction:(TargetActionInfo*) info
{
    id  target = [info target];
    SEL action = [info action];
    
    IMP imp = [target methodForSelector:action];
    
    void (*func)(id, SEL, id) = (void*) imp;
    
    func(target, action, self);
}

// .............................................................................

#pragma mark - Control Events 

// (in typical chronological order of occurrence)


- (void) touchDown
{
    for (TargetActionInfo* info in _targetActions) {
        
#if TARGET_OS_IPHONE
        
        if ([info events] & UIControlEventTouchDown) {
            
            [self callMethodForTargetAction:info];
        }
#endif
        
    }
    
    [self setHighlighted:YES];
}

// .............................................................................

- (void) drag
{
    
}

// .............................................................................

- (void) dragExit
{
    [self setHighlighted:NO];
    
#if TARGET_OS_IPHONE
    
    for (TargetActionInfo* info in _targetActions) {
    
        if ([info events] & UIControlEventTouchDragExit) {
            
            id  target = [info target];
            SEL action = [info action];
            
            IMP imp = [target methodForSelector:action];
            
            void (*func)(id, SEL, id) = (void*) imp;
            
            func(target, action, self);
        }
    }
    
#endif
    
}

// .............................................................................

- (void) dragOutside
{
    
#if TARGET_OS_IPHONE

    for (TargetActionInfo* info in _targetActions) {
        
        if ([info events] & UIControlEventTouchDragOutside) {
            
            [self callMethodForTargetAction:info];
        }
    }
    
#endif
    
}

// .............................................................................

- (void) dragEnter
{
    [self setHighlighted:YES];
    
#if TARGET_OS_IPHONE
    
    for (TargetActionInfo* info in _targetActions) {
    
        if ([info events] & UIControlEventTouchDragEnter) {
            
            [self callMethodForTargetAction:info];
        }
    }
    
#endif
    
}

// .............................................................................

- (void) dragInside
{
#if TARGET_OS_IPHONE
    
    for (TargetActionInfo* info in _targetActions) {
        
        if ([info events] & UIControlEventTouchDragInside) {
            
            [self callMethodForTargetAction:info];
        }
    }
    
#endif
    
}

// .............................................................................

- (void) touchUpInside
{
    [self setHighlighted:NO];
    
#if TARGET_OS_IPHONE
    
    for (TargetActionInfo* info in _targetActions) {
        
        if ([info events] & UIControlEventTouchUpInside) {
            
            [self callMethodForTargetAction:info];
        }
#else
        
        [self callMethodForTargetAction:info];
        
#endif
        
    }
}

// .............................................................................

- (void) touchUpOutside
{
    
#if TARGET_OS_IPHONE
    
    for (TargetActionInfo* info in _targetActions) {
        

        if ([info events] & UIControlEventTouchUpOutside) {
            
            [self callMethodForTargetAction:info];
        }
    }
    
#endif
    
}

// .............................................................................

#if TARGET_OS_IPHONE

#pragma mark - UIResponder methods


- (void) touchesBegan:(NSSet*) touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    
    if ([self containsPoint:touchPoint]) {
    
        _touch = touch;
        
        _touchLocationLast = touchPoint;
        
        return [self touchDown];
        
    }
}

// .............................................................................

- (void) touchesMoved:(NSSet*) touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    
    [self drag];
    
    
    _moved = YES;
    
    if ([self containsPoint:touchPoint]) {
        // Inside...
        
        if ([self containsPoint:_touchLocationLast]) {
            // ...all along:
            [self dragInside];
        }
        else{
            // ...since now:
            [self dragEnter];
        }
    }
    else{
        // Outside...
        
        if ([self containsPoint:_touchLocationLast]) {
            // ...since now:
            [self dragExit];
        }
        else{
            // ...all along:
            [self dragOutside];
        }
    }
    
    _touchLocationLast = touchPoint;
}

// .............................................................................

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    if (_moved) {
        if ([self containsPoint:touchPoint]){
            // Ended Inside
            [self touchUpInside];
        }
        else{
            // Ended Outside
            [self touchUpOutside];
        }
    }
    else{
        // Needed??
        [self touchUpInside];
    }
    
    _moved = NO;
}

// .............................................................................

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#else 

- (void) mouseDown:(NSEvent*) theEvent
{
    _touchLocationLast = [theEvent locationInNode:self];
    
    [self touchDown];
}

// .............................................................................

- (void) mouseUp:(NSEvent*) theEvent
{
    _touchLocationLast = CGPointMake(INFINITY, INFINITY);
    
    [self touchUpInside];
}

// .............................................................................

- (void) mouseEntered:(NSEvent *)theEvent
{
    [self dragEnter];
}

// .............................................................................

- (void) mouseDragged:(NSEvent*) theEvent
{
    if ([self containsPoint:_touchLocationLast]) {
        // Inside
        
        _touchLocationLast = [theEvent locationInNode:self];
        
        if ([self containsPoint:_touchLocationLast] == NO) {
            // Exited
            
            [self dragExit];
        }

    }
    else{
        // Outside
        
        _touchLocationLast = [theEvent locationInNode:self];
        
        if ([self containsPoint:_touchLocationLast] == YES) {
            // Entered
            
            [self dragEnter];
        }
    }
    
    [self drag];
}

// .............................................................................

- (void) mouseExited:(NSEvent *)theEvent
{
    [self dragExit];
}

// .............................................................................

#endif

// .............................................................................

#pragma mark - SKNode Methods


- (BOOL) containsPoint:(CGPoint) p
{
    CGPoint position = [self position];
    
    CGPoint local = CGPointMake(p.x - position.x,
                                p.y - position.y);
    
    CGSize size = [self size];
    
    CGFloat width  = size.width  + _boundsTolerance;
    CGFloat height = size.height + _boundsTolerance;
    
    if (fabsf(local.x) <= 0.5f*(width)) {
        if (fabsf(local.y) <= 0.5f*(height)) {
            return YES;
        }
        
    }
    
    return NO;

    //    return [super containsPoint:p];
}

// .............................................................................

#pragma mark - Custom Accessors


- (void) setNormalColor:(SKColor*) normalColor
{
    _normalColor = normalColor;
    if (_state == ControlStateNormal) {
        [self setColor:_normalColor];
    }
}
// (Getter is @synthesized)
// .............................................................................

- (void) setHighlightedColor:(SKColor*) highlightedColor
{
    _highlightedColor = highlightedColor;
    if (_state == ControlStateHighlighted) {
        [self setColor:_highlightedColor];
    }
}

// (Getter is @synthesized)

// .............................................................................

- (void) setSelectedColor:(SKColor*) selectedColor
{
    _selectedColor = selectedColor;
    if (_state == ControlStateSelected) {
        [self setColor:_selectedColor];
    }
}

// (Getter is @synthesized)

// .............................................................................

- (void) setDisabledColor:(SKColor*) disabledColor
{
    _disabledColor = disabledColor;
    if (_state ==ControlStateDisabled) {
        [self setColor:_disabledColor];
    }
}

// (Getter is @synthesized)

// .............................................................................

- (void) setFontColor:(SKColor*) fontColor
{
    // (sets all at once)
    
    [_normalLabel setFontColor:fontColor];
    [_highlightedLabel setFontColor:fontColor];
    [_selectedLabel setFontColor:fontColor];
    [_highlightedLabel setFontColor:fontColor];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (SKColor*) fontColor
{
    return [_normalLabel fontColor];
}

// .............................................................................

- (void) setNormalFontColor:(SKColor*) normalFontColor
{
    [_normalLabel setFontColor:normalFontColor];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (SKColor*) normalFontColor
{
    return [_normalLabel fontColor];
}

// .............................................................................

- (void) setHighlightedFontColor:(SKColor*) highlightedFontColor
{
    [_highlightedLabel setFontColor:highlightedFontColor];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (SKColor*) highlightedFontColor
{
    return [_highlightedLabel fontColor];
}

// .............................................................................

- (void) setSelectedFontColor:(SKColor*) selectedFontColor
{
    [_selectedLabel setFontColor:selectedFontColor];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (SKColor*) selectedFontColor
{
    return [_selectedLabel fontColor];
}

// .............................................................................

- (void) setDisabledFontColor:(SKColor*) disabledFontColor
{
    [_disabledLabel setFontColor:disabledFontColor];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (SKColor*) disabledFontColor
{
    return [_disabledLabel fontColor];
}

// .............................................................................

- (void) setLabelText:(NSString*) labelText
{
    // (sets all at once)
    
    [_normalLabel setText:labelText];
    [_highlightedLabel setText:labelText];
    [_selectedLabel setText:labelText];
    [_highlightedLabel setText:labelText];
}

// .............................................................................

- (NSString*) labelText
{
    return [_normalLabel text];
}

// .............................................................................

- (void) setNormalLabelText:(NSString*) normalLabelText
{
    [_normalLabel setText:normalLabelText];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (NSString*) normalLabelText
{
    return [_normalLabel text];
}

// .............................................................................

- (void) setHighlightedLabelText:(NSString*) highlightedLabelText
{
    [_highlightedLabel setText:highlightedLabelText];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (NSString*) highlightedLabelText
{
    return [_highlightedLabel text];
}

// .............................................................................

- (void) setSelectedLabelText:(NSString*) selectedLabelText
{
    [_selectedLabel setText:selectedLabelText];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (NSString*) selectedLabelText
{
    return [_selectedLabel text];
}

// .............................................................................

- (void) setDisabledLabelText:(NSString*) disabledLabelText
{
    [_disabledLabel setText:disabledLabelText];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (NSString*) disabledLabelText
{
    return [_disabledLabel text];
}

// .............................................................................

- (void) setFontSize:(CGFloat) fontSize
{
    // Set all
    
    [_normalLabel setFontSize:fontSize];
    [_highlightedLabel setFontSize:fontSize];
    [_selectedLabel setFontSize:fontSize];
    [_disabledLabel setFontSize:fontSize];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (CGFloat) fontSize
{
    return [_normalLabel fontSize];
}

// .............................................................................

- (void) setNormalFontSize:(CGFloat) normalFontSize
{
    [_normalLabel setFontSize:normalFontSize];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (CGFloat) normalFontSize
{
    return [_normalLabel fontSize];
}

// .............................................................................

- (void) setHighlightedFontSize:(CGFloat) highlightedFontSize
{
    [_normalLabel setFontSize:highlightedFontSize];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (CGFloat) highlightedFontSize
{
    return [_highlightedLabel fontSize];
}
// .............................................................................

- (void) setSelectedFontSize:(CGFloat) selectedFontSize
{
    [_normalLabel setFontSize:selectedFontSize];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (CGFloat) selectedFontSize
{
    return [_selectedLabel fontSize];
}

// .............................................................................

- (void) setDisabledFontSize:(CGFloat) disabledFontSize
{
    [_normalLabel setFontSize:disabledFontSize];
}

// . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

- (CGFloat) disabledFontSize
{
    return [_disabledLabel fontSize];
}

@end

// .............................................................................