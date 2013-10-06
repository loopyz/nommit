//
//  MapViewController.h
//  nommit
//
//  Created by Gregory Rose on 9/30/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourierRegistrationViewController.h"
#import "RatingViewController.h"
#import "RequestViewController.h"
#import "CourierViewController.h"

@interface MapViewController : UIViewController

@property (nonatomic, assign) NSInteger mode;

- (id)initWithMode:(NSInteger) mode;

@end
