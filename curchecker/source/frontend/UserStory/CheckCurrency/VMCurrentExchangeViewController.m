//
//  VMCurrentExchangeViewController.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VMCurrentExchangeViewController.h"
#import "VWExchangeRatesDataServiceProtocol.h"
#import "VMServiceholder.h"
#import "VMExchangeRatesSheetPresenter.h"
#import "HEXToRGBHelper.h"

@interface VMCurrentExchangeViewController () <VWExchangeRatesDataServiceProtocol, VMApplicationCoordinatorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentRateTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateDescription;
@property (weak, nonatomic) IBOutlet UILabel *currentRateUpdateLabel;

@property (strong)  UIActivityIndicatorView *activityView;
@property (strong)  UIView *activityHolderView;
@end

@implementation VMCurrentExchangeViewController



#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [VMServiceHolder sharedInstance].appCoordinator.delegate = self;
    [[VMServiceHolder sharedInstance].rateService bind:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self retrieveData];
}



#pragma mark - Private

- (void)retrieveData {
    
    [[VMServiceHolder sharedInstance].appCoordinator.delegate VMApplicationCoordinatorShowLoadingIndicator];
    [[VMServiceHolder sharedInstance].rateService updateData:^{
        
        [[VMServiceHolder sharedInstance].appCoordinator.delegate VMApplicationCoordinatorDismissLoadingIndicator];
        [self presentData:[[VMServiceHolder sharedInstance].rateService obtainCurrentExchangeRate]];
        
    } failure:^(NSError *error) {
        
        [[VMServiceHolder sharedInstance].appCoordinator.delegate VMApplicationCoordinatorDismissLoadingIndicator];
        [[VMServiceHolder sharedInstance].appCoordinator.delegate VMApplicationCoordinatorPresentError:error];
    }];
}

- (void)presentData:(VMExchangeRate *)rate {
    
    self.currentRateTypeLabel.text = [NSString stringWithFormat:@"%@ -> %@",rate.fristItemLabel, rate.secondItemLabel];
    [self presentCurrentRateUpdateTimeForRate:rate];
    [self presentCurrentRateValueForRate:rate];
    [self presentCurrentRateDescriptionForRate:rate];
}

- (void)presentCurrentRateUpdateTimeForRate:(VMExchangeRate *)rate {

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[VMServiceHolder sharedInstance].rateService.lastUpdateDate];
    self.currentRateUpdateLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ОБНОВЛЕНО В", @""), dateString];
}

- (void)presentCurrentRateValueForRate:(VMExchangeRate *)rate {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    numberFormatter.usesGroupingSeparator = YES;
    NSLocale *local =[NSLocale currentLocale];
    numberFormatter.locale = local;
    [numberFormatter setMaximumFractionDigits:3];
    [numberFormatter setMinimumFractionDigits:3];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:rate.todayValue];
    self.currentRateValueLabel.text = formattedNumberString;
}

- (void)presentCurrentRateDescriptionForRate:(VMExchangeRate *)rate {
    
    if ([rate.dailyRatePercentDiff integerValue] > 0) {
        
        self.rateDescription.text = [NSString stringWithFormat:@"%@ %@ %@",
                                     NSLocalizedString(@"Со вчерашнего дня валюта выросла на ", @""),
                                     rate.dailyRatePercentDiff,
                                     NSLocalizedString(@"процента", @"")];
        
        self.rateDescription.textColor = UIColorFromRGB(0x7ED321);
        return;
    }
    
    if ([rate.dailyRatePercentDiff integerValue] < 0) {
        
        NSInteger absPercent = labs([rate.dailyRatePercentDiff integerValue]);
        
        self.rateDescription.text = [NSString stringWithFormat:@"%@ %li %@",
                                     NSLocalizedString(@"Со вчерашнего дня валюта упала на ", @""),
                                     absPercent,
                                     NSLocalizedString(@"процента", @"")];
        
        self.rateDescription.textColor = UIColorFromRGB(0xDE4A39);
        return;
    }
    
    self.rateDescription.text = NSLocalizedString(@"Изменений по курсу нет", @"");
}

- (void)showMenu {
    
    [[VMExchangeRatesSheetPresenter new] showSheetWithPresentingViewControler:self];
}



#pragma mark - IBActions

- (IBAction)showMenuClick:(id)sender {
    
    [self showMenu];
}



#pragma mark VWExchangeRatesDataServiceProtocol

- (void)VWExchangeRatesDataService:(id)service didChangeCurrentRate:(VMExchangeRate *)rate {
    
    [self presentData:rate];
}



#pragma mark VMApplicationCoordinatorDelegate

- (void)VMApplicationCoordinatorShowLoadingIndicator {
    
    self.activityHolderView.hidden = NO;
    [_activityView startAnimating];
}

- (void)VMApplicationCoordinatorDismissLoadingIndicator {
    
    self.activityHolderView.hidden = YES;
    [_activityView stopAnimating];
}

- (void)VMApplicationCoordinatorPresentError:(NSError *)error {
    
    [[[UIAlertView alloc ] initWithTitle:@"Ошибка"
                                 message:error.localizedDescription
                                delegate:self
                       cancelButtonTitle:@"Закрыть"
                       otherButtonTitles:@"Повторить", nil] show];
}



#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.cancelButtonIndex != buttonIndex) {
        
        [self retrieveData];
    }
}



#pragma mark - UIViewController

- (void)awakeFromNib {
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.activityHolderView = [[UIView alloc] init];
    self.activityHolderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityHolderView addSubview:_activityView];
    self.activityHolderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:self.activityHolderView];
    
    [self.activityHolderView addConstraint:[NSLayoutConstraint constraintWithItem:_activityView
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.activityHolderView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0]];
    
    [self.activityHolderView addConstraint:[NSLayoutConstraint constraintWithItem:_activityView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.activityHolderView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0.0]];
    
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views: @{@"view":self.activityHolderView}];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views: @{@"view":self.activityHolderView}];
    [self.view addConstraints:constraintsH];
    [self.view addConstraints:constraintsV];
    self.activityHolderView.hidden = YES;
}

@end
