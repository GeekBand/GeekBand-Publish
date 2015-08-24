//
//  BLThreeViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLThreeViewController.h"

@interface BLThreeViewController ()

@end

@implementation BLThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Three";
    self.bgImageView.image = [UIImage imageNamed:@"bg3"];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGFloat scrollViewWidth = width - 20;
    CGFloat scrollViewHeight = height - 64 - 49 - 37;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 64, scrollViewWidth, scrollViewHeight)];
    _scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(scrollViewWidth * 5, scrollViewHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.maximumZoomScale = 3;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.delegate = self;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth * 5, scrollViewHeight)];
    _contentView.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:_contentView];

    for (int i = 0; i < 5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * scrollViewWidth , 0, scrollViewWidth, scrollViewHeight)];
        if (i % 2 ==0) {
            view.backgroundColor = [UIColor blackColor];
        }else {
            view.backgroundColor = [UIColor whiteColor];
        }
        [_contentView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
        imageView.backgroundColor = [UIColor clearColor];
        NSString *imageName = [NSString stringWithFormat:@"bg%i.png", i+1];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
//
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
        label.font = [UIFont boldSystemFontOfSize:100];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%i", i + 1];
        [view addSubview:label];
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, _scrollView.frame.origin.y + scrollViewHeight, scrollViewWidth, 37)];
    _pageControl.numberOfPages = 5;
    [_pageControl addTarget:self
                     action:@selector(pageControlClicked:)
           forControlEvents:UIControlEventValueChanged];
//    _pageControl.backgroundColor = [UIColor redColor];
    [self.view addSubview:_pageControl];
}

#pragma mark - Custom event methods

- (void)pageControlClicked:(UIPageControl *)pageControl
{
    CGFloat width = self.view.frame.size.width;
    CGFloat scrollViewWidth = width - 20;

    [_scrollView setContentOffset:CGPointMake(pageControl.currentPage * scrollViewWidth, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _contentView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = self.view.frame.size.width;
    CGFloat scrollViewWidth = width - 20;
    _pageControl.currentPage = scrollView.contentOffset.x / scrollViewWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
