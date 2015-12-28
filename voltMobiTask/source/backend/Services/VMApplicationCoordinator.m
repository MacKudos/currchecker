//
//  VMApplicationCoordinator.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMApplicationCoordinator.h"
#import "VMServiceHolder.h"

@implementation VMApplicationCoordinator

#pragma mark Public

- (void)setupApplicationCoordinator {
    
    [VMServiceHolder sharedInstance].rateService = [VWExchangeRatesDataService new];
    [VMServiceHolder sharedInstance].appCoordinator = self;
}
@end
