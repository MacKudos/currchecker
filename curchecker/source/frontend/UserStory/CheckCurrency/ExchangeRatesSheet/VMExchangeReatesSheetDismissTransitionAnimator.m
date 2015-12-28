//
//  VMExchangeReatesSheetTransitionAnimator.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMExchangeReatesSheetDismissTransitionAnimator.h"

@implementation VMExchangeReatesSheetDismissTransitionAnimator

- (NSTimeInterval)transitionDuration:(id)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // obtain state from the context
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // obtain the container view
    UIView *containerView = [transitionContext containerView];
    
    //toViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    
    // set the intial state
    toViewController.view.alpha = 0.0f;
    //toViewController.elementBottomPosition.constant -= 20.0f;
    [toViewController.view layoutIfNeeded];
    
    
    
    // add the view
    [containerView addSubview:toViewController.view];
    
    toViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views: @{@"view":toViewController.view}];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-0-|" options:0 metrics:nil views: @{@"view":toViewController.view}];
    [containerView addConstraints:constraintsH];
    [containerView addConstraints:constraintsV];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:toViewController.view
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:containerView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:-20]];
    [toViewController.view layoutIfNeeded];
    
    // animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toViewController.view.alpha = 1.0f;
                         [toViewController.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}
@end
