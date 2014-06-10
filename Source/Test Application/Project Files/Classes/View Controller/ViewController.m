/*
    ViewController.m
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

#import "ViewController.h"
#import "TestScene.h"


// .............................................................................

@implementation ViewController
{
    
}


// .............................................................................

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView* skView = (SKView*) [self view];
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    CGRect bounds = [skView bounds];
    SKScene * scene = [TestScene sceneWithSize:bounds.size];
    [scene setScaleMode:SKSceneScaleModeAspectFill];
    
    
    // Present the scene.
    [skView presentScene:scene];
}

// .............................................................................

- (BOOL) shouldAutorotate
{
    return YES;
}

// .............................................................................

- (NSUInteger) supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

// .............................................................................

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

// .............................................................................