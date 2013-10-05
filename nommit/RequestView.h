//
//  RequestView.h
//  nommit
//
//  Created by Lucy Guo on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *customer;
@property (nonatomic, strong) UILabel *restaurant;
@property (nonatomic, strong) UITextField *food;
@property (nonatomic, strong) UITextField *restaurantSearchText;
@property (nonatomic, strong) UIButton *searchButton;

@end
