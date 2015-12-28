//
//  VMCurrencyLayerResponseMapper.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMCurrencyLayerResponseMapper.h"
#import "EKMapper.h"

@implementation VMCurrencyLayerResponseMapper

#pragma mark Public

- (VMCurrencyLayerResponse *)mappedEntity:(NSDictionary *)entityData {
    
    return [self map:entityData];
}

#pragma mark Private

- (VMCurrencyLayerResponse *)map:(NSDictionary *)dictionaryRepresentation {
    
    VMCurrencyLayerResponse *mappedData = [EKMapper objectFromExternalRepresentation:dictionaryRepresentation
                                                                         withMapping:[VMCurrencyLayerResponseMapper objectMapping]];
    return mappedData;
}

+ (EKObjectMapping *)objectMapping {
    
    EKObjectMapping *mapping = [[EKObjectMapping alloc] initWithObjectClass:[VMCurrencyLayerResponse class]];
    [mapping mapPropertiesFromDictionary:@{ @"terms" : @"terms",
                                            @"privacy" : @"privacy",
                                            @"timestamp" : @"timestamp",
                                            @"source" : @"sourceCurrency",
                                            @"quotes" : @"quotes"
                                            }];
    
    return mapping;
}
@end
