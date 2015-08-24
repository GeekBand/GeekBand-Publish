//
//  FNDViewController.m
//  FNDGestureRecognizerDemo
//
//  Created by duan song on 12-9-29.
//  Copyright (c) 2012年 duan song. All rights reserved.
//

#import "FNDViewController.h"

@implementation FNDViewController

@synthesize swipeGestureRecognizer = _swipeGestureRecognizer;
@synthesize rotationGestureRecongnizer = _rotationGestureRecongnizer;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize longPressGestureRecognizer = _longPressGestureRecognizer;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize pinchGestureRecognizer = _pinchGestureRecognizer;
@synthesize rotationAngleInRadians = _rotationAngleInRadians;
@synthesize currentScale = _currentScale;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.userInteractionEnabled = YES;
    _imageView.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:_imageView];
    [_imageView release];
    
    self.swipeGestureRecognizer
    = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)] autorelease];
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    self.swipeGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:self.swipeGestureRecognizer];
    
    self.rotationGestureRecongnizer
    = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] autorelease];
    [self.view addGestureRecognizer:self.rotationGestureRecongnizer];
    
    self.panGestureRecognizer
    = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)] autorelease];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [_imageView addGestureRecognizer:self.panGestureRecognizer];
    
    self.longPressGestureRecognizer
    = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongpress:)] autorelease];
    self.longPressGestureRecognizer.numberOfTouchesRequired = 2;
    self.longPressGestureRecognizer.allowableMovement = 100.0f;
    self.longPressGestureRecognizer.minimumPressDuration = 1.0f;
    [self.view addGestureRecognizer:self.longPressGestureRecognizer];
    
    self.tapGestureRecognizer
    = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
    self.tapGestureRecognizer.numberOfTouchesRequired = 2;
    self.tapGestureRecognizer.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    self.pinchGestureRecognizer
    = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)] autorelease];
    [_imageView addGestureRecognizer:self.pinchGestureRecognizer];
    
    [super viewDidLoad];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"Swiped Down!");
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swiped Up!");
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swiped Left!");
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swiped Right!");
    }
}

- (void)handleRotation:(UIRotationGestureRecognizer *)sender
{
    _imageView.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians + sender.rotation);
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.rotationAngleInRadians += sender.rotation;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateEnded && sender.state != UIGestureRecognizerStateFailed) {
        CGPoint location = [sender locationInView:sender.view.superview];
        sender.view.center = location;
    }
}

- (void)handleLongpress:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.longPressGestureRecognizer]) {
        if (sender.numberOfTouchesRequired == 2) {
            CGPoint touchPoint1 = [sender locationOfTouch:0 inView:sender.view];
            CGPoint touchPoint2 = [sender locationOfTouch:1 inView:sender.view];
            CGFloat midPointX = (touchPoint1.x + touchPoint2.x) / 2;
            CGFloat midPointY = (touchPoint1.y + touchPoint2.y) / 2;
            CGPoint midPoint = CGPointMake(midPointX, midPointY);
            _imageView.center = midPoint;
        }else {
            NSLog(@"this is a long press gesture recognizer with more or less than 2 fingers");
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    NSUInteger touchCounter = 0;
    for (touchCounter = 0; touchCounter < sender.numberOfTouchesRequired; touchCounter++) {
        CGPoint touchPoint = [sender locationOfTouch:touchCounter inView:sender.view];
        NSLog(@"Touch #%lu:%@", (unsigned long)touchCounter + 1, NSStringFromCGPoint(touchPoint));
    }
}

- (void)handlePinches:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.currentScale = sender.scale;
    }else if (sender.state == UIGestureRecognizerStateBegan && self.currentScale !=0.0f) {
        sender.scale = self.currentScale;
    }
    if (sender.scale != NAN && sender.scale != 0.0) {
        sender.view.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.swipeGestureRecognizer = nil;
    self.rotationGestureRecongnizer = nil;
    self.panGestureRecognizer = nil;
    self.longPressGestureRecognizer = nil;
    self.tapGestureRecognizer = nil;
    self.pinchGestureRecognizer = nil;
    [super dealloc];
}

@end
