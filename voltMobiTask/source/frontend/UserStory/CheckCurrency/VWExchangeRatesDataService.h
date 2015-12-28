//
//  VWExchangeRatesDataProvider.h
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VMExchangeRate.h"

@protocol VWExchangeRatesDataServiceProtocol;

typedef void (^WExchangeRatesDataServiceSuccessCallback)();
typedef void (^WExchangeRatesDataServiceFailureCallback)(NSError *error);

@interface VWExchangeRatesDataService : NSObject
@property (strong, nonatomic) NSDate *lastUpdateDate;

- (void)updateData:(WExchangeRatesDataServiceSuccessCallback)success
           failure:(WExchangeRatesDataServiceFailureCallback)failure;

- (NSArray <VMExchangeRate *> *)obtainAllExchangeRatesList;
- (void)selectCurrentExchangeRates:(VMExchangeRate *)rate;
- (VMExchangeRate *)obtainCurrentExchangeRate;

- (void)bind:(id <VWExchangeRatesDataServiceProtocol>)listener;
- (void)unbind:(id <VWExchangeRatesDataServiceProtocol>)listener;

@end
