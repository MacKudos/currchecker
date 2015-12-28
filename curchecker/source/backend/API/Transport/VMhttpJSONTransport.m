//
//  VMhttpJSONTransport.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMhttpJSONTransport.h"

const NSString *kVMhttpJSONTransportApiServerBaseUrl = @"http://apilayer.net/api";
const NSString *kVMhttpJSONTransportApiKey = @"7924b1720b5ffc959374148a574f182f";

@implementation VMhttpJSONTransport

+ (void)performWithRequest:(NSMutableURLRequest *)request
                   success:(void (^)(NSURLResponse *response, NSDictionary *data))success
                   failure:(void (^)(NSError *error))failure {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    void (^handler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            
            NSLog(@"%@", error.description);
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSError *JSONParseError;
        NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONParseError];
        if (JSONParseError) {
            
            NSLog(@"%@", JSONParseError.description);
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(JSONParseError);
            });
            return;
        }
        
        NSError *currencylayerError = [self checkCURRENCYLAYERError:parsedData];
        if (currencylayerError) {
            
            NSLog(@"%@", currencylayerError.description);
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(currencylayerError);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(response, parsedData);
        });
    };
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:handler];
    [dataTask resume];
}

/* CURRENCYLAYER api error
 404	User requested a resource which does not exist.
 101	User did not supply an Access Key.
 101	User entered an invalid Access Key.
 103	User requested a non-existent API Function.
 104	User has reached or exceeded his Subscription Plan's monthly API Request Allowance.
 105	The user's current Subscription Plan does not support the requested API Function.
 106	The user's query did not return any results. Api blocked in USA In this Case need to Change local to Russian.
 */

+ (NSError *)checkCURRENCYLAYERError:(NSDictionary *)response {
    
    NSError *error = nil;
    NSDictionary *dictionaryRepresentation = response;
    
    if ([dictionaryRepresentation isKindOfClass:[NSDictionary class]] && [dictionaryRepresentation[@"success"] boolValue] == NO) {
        
        return [NSError errorWithDomain:@"apilayer error"
                                   code:[dictionaryRepresentation[@"error"][@"code"] longValue]
                               userInfo:@{NSLocalizedDescriptionKey:dictionaryRepresentation[@"error"][@"info"]}];
    }
    
    return error;
}

@end
