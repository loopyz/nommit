//
//  RequestView.h
//  nommit
//
//  Created by Lucy Guo on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RequestView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *customer;
@property (nonatomic, strong) CLLocation *customerLocation;
@property (nonatomic, strong) UILabel *restaurant;
<<<<<<< HEAD
@property (nonatomic, strong) CLLocation *customerLocation;
=======
>>>>>>> bb4a38b80ab269805263aa105f95ce5b261b655a
@property (nonatomic, strong) CLLocation *restaurantLocation;
@property (nonatomic, strong) UITextField *food;
@property (nonatomic, strong) UITextField *restaurantSearchText;
@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, weak) id delegate;

@end
