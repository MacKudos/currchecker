//
//  VMExchangeRate.h
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMExchangeRate : NSObject
@property (assign, nonatomic) NSString *rateID;
@property (copy, nonatomic) NSString *fristItemLabel;
@property (copy, nonatomic) NSString *secondItemLabel;
@property (strong, nonatomic) NSNumber *dayBeforeValue;
@property (strong, nonatomic) NSNumber *todayValue;
@property (strong, nonatomic) NSNumber *dailyRatePercentDiff;
@end
