//
//  VMExchangeRateSheetDataSource.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMExchangeRateSheetDataSource.h"
#import "VMExchangeRate.h"
#import "VMExchangeRatesSheetCell.h"
#import "VMServiceHolder.h"

@interface VMExchangeRateSheetDataSource ()
@property (strong, nonatomic) NSArray <VMExchangeRate *> *data;
@property (strong, nonatomic) VMExchangeRate *currentRate;
@end

@implementation VMExchangeRateSheetDataSource



#pragma mark Lifecycle

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _data = [[VMServiceHolder sharedInstance].rateService obtainAllExchangeRatesList];
        _currentRate = [[VMServiceHolder sharedInstance].rateService obtainCurrentExchangeRate];
    }
    return self;
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"VMExchangeRatesSheetCell";
    VMExchangeRatesSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.rate = self.data[indexPath.row];
    return cell;
}
@end
