//
//  WFServiceHolder.m
//  С Другом
//
//  Created by Sergey on 29/10/15.
//  Copyright © 2015 ifree. All rights reserved.
//

#import "VMServiceHolder.h"

@implementation VMServiceHolder

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static VMServiceHolder *instance_FM;
    dispatch_once(&once, ^ { instance_FM = [[VMServiceHolder alloc] init]; });
    return instance_FM;
}
@end
