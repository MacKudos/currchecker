//
//  VMExchangeRatesSheetPresenter.h
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VMExchangeRatesSheetPresenterProtocol;

@interface VMExchangeRatesSheetPresenter : NSObject
- (void)showSheetWithPresentingViewControler:(UIViewController *)presentingViewControler;
@end
