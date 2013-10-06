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
#import "Geocoding.h"

@interface MapViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) Geocoding *gs;

@property (nonatomic, assign) NSInteger mode;

@property (strong, nonatomic) IBOutlet UITextField *myTextField;




- (id)initWithMode:(NSInteger) mode;

@end
