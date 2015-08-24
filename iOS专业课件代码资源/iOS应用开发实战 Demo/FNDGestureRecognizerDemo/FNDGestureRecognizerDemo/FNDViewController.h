//
//  FNDViewController.h
//  FNDGestureRecognizerDemo
//
//  Created by duan song on 12-9-29.
//  Copyright (c) 2012年 duan song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNDViewController : UIViewController
{
    UIImageView                     *_imageView;
    
    UISwipeGestureRecognizer        *_swipeGestureRecognizer;       // 划屏
    UIRotationGestureRecognizer     *_rotationGestureRecongnizer;   // 旋转
    UIPanGestureRecognizer          *_panGestureRecognizer;         // 拖拽
    UILongPressGestureRecognizer    *_longPressGestureRecognizer;   // 长按
    UITapGestureRecognizer          *_tapGestureRecognizer;         // 轻击
    UIPinchGestureRecognizer        *_pinchGestureRecognizer;       // 捏合（放大缩小）
    
    CGFloat                         _rotationAngleInRadians;
    CGFloat                         _currentScale;
}

@property (nonatomic, retain) UISwipeGestureRecognizer      *swipeGestureRecognizer;
@property (nonatomic, retain) UIRotationGestureRecognizer   *rotationGestureRecongnizer;
@property (nonatomic, retain) UIPanGestureRecognizer        *panGestureRecognizer;
@property (nonatomic, retain) UILongPressGestureRecognizer  *longPressGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer        *tapGestureRecognizer;
@property (nonatomic, retain) UIPinchGestureRecognizer      *pinchGestureRecognizer;
@property (nonatomic, assign) CGFloat rotationAngleInRadians;
@property (nonatomic, assign) CGFloat currentScale;

@end
