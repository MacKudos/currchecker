//
//  VWExchangeRatesSheetViewController.m
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import "VWExchangeRatesSheetViewController.h"
#import "VMExchangeRateSheetDataSource.h"
#import "VMExchangeRateSheetHandler.h"

@interface VWExchangeRatesSheetViewController () <VMExchangeRateSheetHandlerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) VMExchangeRateSheetDataSource *dataSource;
@property (strong, nonatomic) VMExchangeRateSheetHandler *sheetHandler;
@end

@implementation VWExchangeRatesSheetViewController



#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:(NSCoder *)aDecoder];
    
    if (self) {
        _dataSource = [VMExchangeRateSheetDataSource new];
        _sheetHandler = [VMExchangeRateSheetHandler new];
        _sheetHandler.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.tableView.delegate = self.sheetHandler;
    self.tableView.dataSource = self.dataSource;
    
    [self.tableView reloadData];
}


- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark VMExchangeRateSheetHandlerDelegate

- (void)VMExchangeRateSheetHandlerDidChangeState {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
