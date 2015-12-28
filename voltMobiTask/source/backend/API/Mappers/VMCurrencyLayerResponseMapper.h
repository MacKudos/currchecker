//
//  VMCurrencyLayerResponseMapper.h
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingProtocol.h"
#import "VMCurrencyLayerResponse.h"

@interface VMCurrencyLayerResponseMapper : NSObject <EKMappingProtocol>
- (VMCurrencyLayerResponse *)mappedEntity:(NSDictionary *)entityData;
@end
