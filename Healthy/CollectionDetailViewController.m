//
//  CollectionDetailViewController.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/20.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "CollectionDetailViewController.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

@interface CollectionDetailViewController () <YSLTransitionAnimatorDataSource>
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@end

@implementation CollectionDetailViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self ysl_addTransitionDelegate:self];
    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
                                    cancelAnimationPointY:0
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // custom navigation left item
    __weak CollectionDetailViewController *weakself = self;
    [self ysl_setUpReturnBtnWithColor:[UIColor lightGrayColor]
                      callBackHandler:^{
                          [weakself.navigationController popViewControllerAnimated:YES];
                      }];
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIView *)popTransitionImageView
{
    return self.iconImageView;
}

- (UIView *)pushTransitionImageView
{
    return nil;
}

@end
