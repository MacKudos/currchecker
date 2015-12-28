//
//  VMExchangeRateSheetHandler.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMExchangeRateSheetHandler.h"
#import "VMServiceHolder.h"
#import "VMExchangeRatesSheetCell.h"

@implementation VMExchangeRateSheetHandler



#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VMExchangeRatesSheetCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [[VMServiceHolder sharedInstance].rateService selectCurrentExchangeRates:selectedCell.rate];
    
    if (self.delegate) {
        [self.delegate VMExchangeRateSheetHandlerDidChangeState];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull VMExchangeRatesSheetCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([cell.rate isEqual:[[VMServiceHolder sharedInstance].rateService obtainCurrentExchangeRate]]) {
        
        [cell setSelected:YES animated:NO];
    }
}
@end
