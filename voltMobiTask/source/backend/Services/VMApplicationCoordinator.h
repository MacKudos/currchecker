//
//  VMApplicationCoordinator.h
//  voltMobiTask
//
//  Created by Sergey on 27/12/15.
//  Copyright © 2015 me. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VMApplicationCoordinatorDelegate <NSObject>

- (void)VMApplicationCoordinatorShowLoadingIndicator;
- (void)VMApplicationCoordinatorDismissLoadingIndicator;
- (void)VMApplicationCoordinatorPresentError:(NSError *)error;

@end

@interface VMApplicationCoordinator : NSObject

@property (weak, nonatomic) id <VMApplicationCoordinatorDelegate> delegate;
- (void)setupApplicationCoordinator;
@end
