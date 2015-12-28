//
//  VMExchangeReatesSheetTransitionAnimator.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMExchangeRatesSheetPresentTransitionAnimator.h"

@implementation VMExchangeRatesSheetPresentTransitionAnimator

- (NSTimeInterval)transitionDuration:(id)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    CGFloat height = CGRectGetHeight(containerView.frame);
    
    toViewController.view.alpha = 0.1;
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [toViewController.view layoutIfNeeded];
    
    [containerView addSubview:toViewController.view];
    
    toViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views: @{@"view":toViewController.view}];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-0-|" options:0 metrics:nil views: @{@"view":toViewController.view}];
    [containerView addConstraints:constraintsH];
    [containerView addConstraints:constraintsV];
    
    NSLayoutConstraint *constrain = [NSLayoutConstraint constraintWithItem:toViewController.view
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:containerView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];
    
    [containerView addConstraint:constrain];
    [toViewController.view setNeedsLayout];
    [toViewController.view layoutIfNeeded];
    constrain.constant = -(NSInteger) height*0.3;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.2
                        options:UIViewAnimationOptionTransitionCurlUp animations:^{
                                     
        toViewController.view.alpha = 1;
        [toViewController.view layoutIfNeeded];
                                     
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
@end
