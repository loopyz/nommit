//
//  OrderConfirmViewController.h
//  nommit
//
//  Created by Gregory Rose on 10/6/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmViewController : UIViewController

@property (nonatomic, strong) UILabel *restaurantName;
@property (nonatomic, strong) UILabel *restaurantLocation;
@property (nonatomic, strong) UILabel *customerName;
@property (nonatomic, strong) UILabel *customerLocation;
@property (nonatomic, strong) UILabel *food;
@property (nonatomic, strong) UILabel *foodDescription;
@property (nonatomic, strong) UILabel *price;

- (id)initWithMenu:(NSDictionary *)menu andRestaurant:(NSDictionary *)restaurant;

@end
