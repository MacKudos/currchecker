//
//  VMExchangeRatesSheetPresenter.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMExchangeRatesSheetPresenter.h"
#import "VMExchangeReatesSheetPresentTransitionAnimator.h"
#import "VMExchangeReatesSheetDismissTransitionAnimator.h"
#import "VWExchangeRatesSheetViewController.h"

@interface VMExchangeRatesSheetPresenter () <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) VMExchangeReatesSheetPresentTransitionAnimator *presentTranstionAnimator;
@property (strong, nonatomic) VMExchangeReatesSheetDismissTransitionAnimator *dismissTranstionAnimator;
@end

@implementation VMExchangeRatesSheetPresenter



#pragma mark - Lifecycle

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _presentTranstionAnimator = [VMExchangeReatesSheetPresentTransitionAnimator new];
        _dismissTranstionAnimator = [VMExchangeReatesSheetDismissTransitionAnimator new];
    }
    return self;
}



#pragma mark Public methods

- (void)showSheetWithPresentingViewControler:(UIViewController *)presentingViewControler {
    
    VWExchangeRatesSheetViewController *sheet = [[UIStoryboard storyboardWithName:@"CheckCurrency" bundle:nil] instantiateViewControllerWithIdentifier:@"VWExchangeRatesSheetViewController"];
    sheet.modalPresentationStyle = UIModalPresentationCustom;
    sheet.transitioningDelegate = self;
    [presentingViewControler presentViewController:sheet animated:YES completion:nil];
}



#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return self.presentTranstionAnimator;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return nil;//self.dismissTranstionAnimator;
}


@end
