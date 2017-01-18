//
//  ModalAnimator.m
//  WithMe
//
//  Created by 한정욱 on 2016. 8. 18..
//  Copyright © 2016년 SMARTLY CO. All rights reserved.
//
@import QuartzCore;
@import UIKit;

#import "ModalAnimator.h"

#pragma mark - UIViewControllerAnimatedTransitioning

@implementation ModalAnimator

+ (instancetype) modalAnimatorPresenting:(BOOL)isPresenting
{
    CGFloat scale = 0.90f;
    
    ModalAnimator *animator = [ModalAnimator new];
    animator.presenting = isPresenting;
    animator.animationSpeed = 0.25f;
    animator.backgroundShadeColor = [UIColor blackColor];
    animator.scaleTransform = CGAffineTransformMakeScale(scale, scale);
    animator.springDamping = 0.88;
    animator.springVelocity = 0.5;
    animator.backgroundShadeAlpha = 0.1;
    return animator;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.animationSpeed;
}

- (UIView*)backgroundForView:(UIView*)container
{
    UIView* backgroundView = [container viewWithTag:1199];
    if(!backgroundView){
        backgroundView = [UIView new];
        backgroundView.frame = container.bounds;
        backgroundView.alpha = 0;
        backgroundView.tag = 1199;
        backgroundView.backgroundColor = _backgroundShadeColor;
    }
    return backgroundView;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    CGFloat toOffset = 0, fromOffset = 0;
    
    UIViewController <ModalDelegate> *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController <ModalDelegate> *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* container = transitionContext.containerView;
    container.backgroundColor = [UIColor redColor];

    fromOffset = toOffset = kOffsetFromTop;
    if ([toVC respondsToSelector:@selector(offsetHeight)]) {
        toOffset = toVC.offsetHeight;
    }
    else {
        toOffset = kOffsetFromTop;
    }

    if ([fromVC respondsToSelector:@selector(offsetHeight)]) {
        fromOffset = fromVC.offsetHeight;
    }
    else {
        fromOffset = kOffsetFromTop;
        fromOffset = 0;
    }

    CGRect finalFrame = CGRectMake(0,
                            toOffset,
                            CGRectGetWidth(toVC.view.bounds),
                            CGRectGetHeight(toVC.view.bounds)-toOffset);
    
    CGRect initialFrame = toVC.view.bounds;
    initialFrame.origin.y = container.frame.size.height;
    
    UIView *backgroundView = [self backgroundForView:container];
    
    if (self.presenting)
    {
        UIImage *image = [self rootImageRender];
        UIView *screenshot = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        screenshot.layer.cornerRadius = 4.0f;
        screenshot.layer.masksToBounds = YES;
        [screenshot.layer setContents:(id) image.CGImage];
        [container insertSubview:screenshot atIndex:0];
        
        fromVC.view.alpha = 0;
        fromVC.view.hidden = YES;
        
        [container insertSubview:backgroundView belowSubview:toVC.view];
        
        toVC.view.frame = initialFrame;
//        toVC.view.alpha = 0;
        [container addSubview:toVC.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             backgroundView.alpha = _backgroundShadeAlpha;
                             [screenshot setTransform:CGAffineTransformTranslate(_scaleTransform, 0 ,-fromOffset)];
                         } completion:nil];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.2
             usingSpringWithDamping:_springDamping
              initialSpringVelocity:_springVelocity
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toVC.view.frame = finalFrame;
//                             toVC.view.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             UIView *fsv = [container.subviews firstObject];
                             fsv.transform = CGAffineTransformIdentity;
                             
                             fromVC.view.frame = initialFrame;
//                             fromVC.view.alpha = 0;
                             toVC.view.alpha = 1;
                             toVC.view.layer.cornerRadius = 0.0f;
                             backgroundView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             toVC.view.hidden = NO;
                             [transitionContext completeTransition:YES];
                             [backgroundView removeFromSuperview];
                         }];
    }
}

- (UIImage*)rootImageRender
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, 0);
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:screenRect afterScreenUpdates:NO];
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screengrab;
}


@end


