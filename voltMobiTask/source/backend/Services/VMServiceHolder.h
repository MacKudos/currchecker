//
//  WFServiceHolder.h
//  С Другом
//
//  Created by Sergey on 29/10/15.
//  Copyright © 2015 ifree. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VMApplicationCoordinator.h"
#import "VWExchangeRatesDataService.h"

@interface VMServiceHolder : NSObject
@property(nonatomic, strong) VWExchangeRatesDataService *rateService;
@property(nonatomic, strong) VMApplicationCoordinator *appCoordinator;
+ (instancetype)sharedInstance;
@end
