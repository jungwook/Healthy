//
//  YSLTransitionAnimator.m
//  CustomTransition_Sample
//
//  Created by yamaguchi on 2015/04/16.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "YSLTransitionAnimator.h"

@implementation YSLTransitionAnimator

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController<YSLTransitionAnimatorDataSource> *fromViewController =
    (UIViewController<YSLTransitionAnimatorDataSource> *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController<YSLTransitionAnimatorDataSource> *toViewController =
    (UIViewController<YSLTransitionAnimatorDataSource> *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // containerView from transitionContext
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIImageView *fromTransitionImageView = self.isForward ? [fromViewController pushTransitionImageView] : [fromViewController popTransitionImageView];
    
    // fromViewController Setting
    UIImageView *fromImageView = [[UIImageView alloc]initWithImage:fromTransitionImageView.image];
    fromImageView.frame = [containerView convertRect:fromTransitionImageView.frame fromView:fromTransitionImageView.superview];
    fromTransitionImageView.hidden = YES;
    
    // toViewController Setting
    UIImageView *toTransitionImageView = self.isForward ? [toViewController popTransitionImageView] : [toViewController pushTransitionImageView];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    if (self.isForward) {
        UIView *screenshot = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        screenshot.layer.cornerRadius = 4.0f;
        screenshot.layer.masksToBounds = YES;
        [screenshot.layer setContents:(id) [self rootImageRender].CGImage];
        [containerView addSubview:screenshot];

        CGRect frame = [containerView convertRect:toTransitionImageView.frame fromView:toViewController.view];
        CGFloat xScale = CGRectGetWidth(screenshot.frame)/CGRectGetWidth(fromImageView.frame);
        CGFloat xTrans = CGRectGetMidX(frame) - CGRectGetMidX(fromImageView.frame);
        CGFloat yTrans = CGRectGetMidY(frame) - CGRectGetMidY(fromImageView.frame);
        
        CGPoint anchorPoint = CGPointMake(CGRectGetMinX(fromImageView.frame)/CGRectGetWidth(screenshot.frame),
                                          CGRectGetMinY(fromImageView.frame)/CGRectGetHeight(screenshot.frame));
        
        CGRect toViewFrame = toViewController.view.frame;

        toViewController.view.alpha = 0;

        [self setAnchorPoint:CGPointZero forView:toViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(1/xScale, 1/xScale);
        toViewController.view.frame = fromImageView.frame;
        [containerView addSubview:toViewController.view];

        toTransitionImageView.hidden = YES;
        
        toTransitionImageView.image = fromTransitionImageView.image;

        [containerView addSubview:fromImageView];
        [self setAnchorPoint:anchorPoint forView:screenshot];
        
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.0;
            toViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.frame = toViewFrame;
            
            fromImageView.frame = frame;
            fromImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
            screenshot.transform = CGAffineTransformMakeTranslation(xTrans, yTrans);
            screenshot.transform = CGAffineTransformScale(screenshot.transform, xScale*0.95f, xScale*0.95f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                fromImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished)
            {
                // Remove all added Views from Superview
                [screenshot removeFromSuperview];
                [fromImageView removeFromSuperview];
                
                fromTransitionImageView.hidden = NO;
                toTransitionImageView.hidden = NO;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];

        }];
    } else
    {
        // destination cell frame
        CGRect destinationFrame = [containerView convertRect:toTransitionImageView.frame fromView:toTransitionImageView.superview];
        CGPoint anchorPoint = CGPointMake(CGRectGetMidX(destinationFrame)/CGRectGetWidth(toViewController.view.frame),
                                          CGRectGetMidY(destinationFrame)/CGRectGetHeight(toViewController.view.frame));
        
        CGFloat xScale = CGRectGetWidth(toViewController.view.frame) / CGRectGetWidth(destinationFrame);
        
        [self setAnchorPoint:anchorPoint forView:toViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(xScale,
                                                                     xScale);
        
        toTransitionImageView.hidden = YES;
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        [containerView addSubview:fromImageView];
        
        
//        [UIView animateWithDuration:5.0f animations:^{
        [UIView animateWithDuration:duration animations:^{
            // gradually hide original view (fromViewController.view) to show destination view.
            fromViewController.view.alpha = 0;
            fromViewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetMinX(destinationFrame),
                                                                                 CGRectGetMinY(destinationFrame));
            fromViewController.view.transform = CGAffineTransformScale(fromViewController.view.transform,
                                                                       1.f/xScale,
                                                                       1.f/xScale);
            
            // gradually shrink targetView to fill screen
            toViewController.view.transform = CGAffineTransformIdentity;
            
            // move ImageView to orginal cell position.
            fromImageView.frame = destinationFrame;
            
            
        } completion:^(BOOL finished) {
            // Remove all added Views from Superview
            [fromImageView removeFromSuperview];
            
            // Reset anchorPoint for target view
            [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:toViewController.view];

            fromTransitionImageView.hidden = NO;
            toTransitionImageView.hidden = NO;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
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

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

@end
