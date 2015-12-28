//
//  VMExchangeRatesSheetCell.m
//  voltMobiTask
//
//  Created by Sergey on 28/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMExchangeRatesSheetCell.h"
#import "HEXToRGBHelper.h"

@interface VMExchangeRatesSheetCell ()
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end

@implementation VMExchangeRatesSheetCell

- (void)setRate:(VMExchangeRate *)rate {
    
    _rate = rate;
    self.rateLabel.text = [NSString stringWithFormat:@"%@ -> %@", self.rate.fristItemLabel, self.rate.secondItemLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (selected) {

        [self.rateLabel setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        [self.rateLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    } else {
        
        [self.rateLabel setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:.7f]];
        [self.rateLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
    }
}

@end
