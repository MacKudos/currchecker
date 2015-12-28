//
//  VWExchangeRatesDataServiceProtocol.h
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VWExchangeRatesDataService;
@class VMExchangeRate;

@protocol VWExchangeRatesDataServiceProtocol <NSObject>

- (void)VWExchangeRatesDataService:(VWExchangeRatesDataService *)service
              didChangeCurrentRate:(VMExchangeRate *)rate;
@end