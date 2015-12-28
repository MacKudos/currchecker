//
//  VMExchangeRateSheetHandler.h
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VMExchangeRateSheetHandlerDelegate <NSObject>

- (void)VMExchangeRateSheetHandlerDidChangeState;

@end

@interface VMExchangeRateSheetHandler : NSObject <UITableViewDelegate>
@property (weak, nonatomic) id <VMExchangeRateSheetHandlerDelegate> delegate;
@end
