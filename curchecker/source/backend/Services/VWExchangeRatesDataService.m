//
//  VWExchangeRatesDataProvider.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VWExchangeRatesDataService.h"
#import "VWExchangeRatesDataServiceProtocol.h"
#import "VMhttpJSONTransport.h"
#import "VMCurrencyLayerResponseMapper.h"

static NSString * const VMBAboutViewControllerCompanyName = @"VWExchangeRatesDataServicedidChangeCurrentRate";

@interface VWExchangeRatesDataService ()
@property (strong, nonatomic) NSPointerArray *listeners;
@property (strong, nonatomic) VMExchangeRate *currentRate;
@property (strong, nonatomic) NSArray <VMExchangeRate *> *rates;
@end

@implementation VWExchangeRatesDataService

#pragma mark - Lifecycle

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _listeners = [NSPointerArray weakObjectsPointerArray];
        _rates = @[];
        _currentRate = nil;
    }
    return self;
}

#pragma mark Public

- (void)selectCurrentExchangeRates:(VMExchangeRate *)rate {
   
    if ([self.rates containsObject:rate]) {
        self.currentRate = rate;
        [self emitForChangeCurrentRate];
    }
}

- (VMExchangeRate *)obtainCurrentExchangeRate {
    
    return self.currentRate;
}

- (NSArray <VMExchangeRate *> *)obtainAllExchangeRatesList {
    
    return self.rates;
}

- (void)updateData:(WExchangeRatesDataServiceSuccessCallback)success
           failure:(WExchangeRatesDataServiceFailureCallback)failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [VMhttpJSONTransport performWithRequest:[self buildRequestForTodayDataRequest] success:^(NSURLResponse *response, NSDictionary *data) {
            
            VMCurrencyLayerResponse *todayRateResponse = [[VMCurrencyLayerResponseMapper new] mappedEntity:data];
            
            [VMhttpJSONTransport performWithRequest:[self buildRequestForDayBeforeDataRequest] success:^(NSURLResponse *response, NSDictionary *data) {
                
                VMCurrencyLayerResponse *dayBeforeRateResponse = [[VMCurrencyLayerResponseMapper new] mappedEntity:data];
                
                [self processResultWithTodayData:todayRateResponse dayBeforeData:dayBeforeRateResponse];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    success();
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }];
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }];
    });
}



#pragma mark Private

- (void)processResultWithTodayData:(VMCurrencyLayerResponse *)todayData dayBeforeData:(VMCurrencyLayerResponse *)beforeData {
    
    self.lastUpdateDate = [NSDate dateWithTimeIntervalSince1970:[todayData.timestamp doubleValue]];
    
    NSMutableArray <VMExchangeRate *> *rates = [NSMutableArray new];
    
    for (NSString *rateName in [todayData.quotes allKeys]) {
        VMExchangeRate *rate = [VMExchangeRate new];
        rate.rateID = rateName;
        rate.fristItemLabel = todayData.sourceCurrency;
        rate.secondItemLabel = [rateName stringByReplacingOccurrencesOfString:todayData.sourceCurrency withString:@""];
        if ([rate.secondItemLabel isEqualToString:@""]) {
            continue;
        }
        rate.todayValue = todayData.quotes[rateName];
        rate.dailyRatePercentDiff = [self percentageDiffBetweenFirstNumber:todayData.quotes[rateName] secondNumber:beforeData.quotes[rateName]];
        [rates addObject:rate];
    }
    
    self.rates = [rates copy];
    self.currentRate = [self.rates firstObject];
}



#pragma mark Request building
//needed extract to request builder entity

- (NSMutableURLRequest *)buildRequestForTodayDataRequest {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/live?access_key=%@&currencies=USD,RUB,EUR,ANG,AUD&format=1", kVMhttpJSONTransportApiServerBaseUrl, kVMhttpJSONTransportApiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    return request;
}

- (NSMutableURLRequest *)buildRequestForDayBeforeDataRequest {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/historical?access_key=%@&date=%@&currencies=USD,RUB,EUR,ANG,AUD&format=1", kVMhttpJSONTransportApiServerBaseUrl, kVMhttpJSONTransportApiKey, [self dayBeforeDateStringValue]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    return request;
}



#pragma mark helpers
//needed extract to helper builder entity

- (NSNumber *)percentageDiffBetweenFirstNumber:(NSNumber *)firstNumber secondNumber:(NSNumber *)secondNumber {
    
    NSDecimalNumber *firstDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[firstNumber decimalValue]];
    NSDecimalNumber *secondDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[secondNumber decimalValue]];
    NSDecimalNumber *total = [secondDecimalNumber decimalNumberBySubtracting:firstDecimalNumber];
    total = [total decimalNumberByDividingBy:secondDecimalNumber];
    total = [total decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    
    NSRoundingMode mode;
    if ([total compare:@(0)] == NSOrderedAscending) {
        mode = NSRoundDown;
    } else {
        mode = NSRoundUp;
    }
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                              scale:0
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    

    total = [total decimalNumberByRoundingAccordingToBehavior:behavior];
    return @([total integerValue]);
}

- (NSString *)dayBeforeDateStringValue {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:( NSCalendarUnitHour | NSCalendarUnitMinute| NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [calendar dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //полночь
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [calendar dateByAddingComponents:components toDate:today options:0];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * formattedDate = [dateFormatter stringFromDate:yesterday];
    return formattedDate;
}



#pragma mark - listener binding

- (void)emitForChangeCurrentRate {
    
    [_listeners compact];
    for (id <VWExchangeRatesDataServiceProtocol> listener in _listeners) {
        [listener VWExchangeRatesDataService:self didChangeCurrentRate:self.currentRate];
    }
}

- (void)bind:(id <VWExchangeRatesDataServiceProtocol>)listener {
    
    [_listeners compact];
    [_listeners addPointer:(__bridge void * _Nullable)(listener)];
}

- (void)unbind:(id <VWExchangeRatesDataServiceProtocol>)listener {
   
    [_listeners compact];
    for (NSUInteger i = 0; i < [_listeners count]; i ++) {
        if ([_listeners pointerAtIndex:i] == (__bridge void * _Nullable)(listener)) {
            [_listeners removePointerAtIndex:i];
            break;
        }
    }
}
@end
