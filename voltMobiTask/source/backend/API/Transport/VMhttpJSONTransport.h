//
//  VMhttpJSONTransport.h
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN const NSString *kVMhttpJSONTransportApiServerBaseUrl;
FOUNDATION_EXTERN const NSString *kVMhttpJSONTransportApiKey;

@interface VMhttpJSONTransport : NSObject

+ (void)performWithRequest:(NSMutableURLRequest *)request
                   success:(void (^)(NSURLResponse *response, NSDictionary *data))success
                   failure:(void (^)(NSError *error))failure;
@end
