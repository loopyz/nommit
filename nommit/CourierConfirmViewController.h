//
//  CourierConfirmViewController.h
//  nommit
//
//  Created by Gregory Rose on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourierConfirmViewController : UIViewController

@property (nonatomic, strong) NSDictionary *order;
@property (nonatomic, strong) UILabel *restaurantName;
@property (nonatomic, strong) UILabel *restaurantLocation;
@property (nonatomic, strong) UILabel *customerName;
@property (nonatomic, strong) UILabel *customerLocation;
@property (nonatomic, strong) UILabel *food;
@property (nonatomic, strong) UILabel *price;

- (id)initWithOrder:(NSDictionary *)order;

@end
