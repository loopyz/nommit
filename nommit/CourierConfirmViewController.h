//
//  CourierConfirmViewController.h
//  nommit
//
//  Created by Gregory Rose on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourierConfirmViewControllerDelegate;


@interface CourierConfirmViewController : UIViewController

@property (nonatomic, strong) NSDictionary *order;
@property (nonatomic, strong) NSString *orderKey;

@property (nonatomic, strong) UILabel *restaurantName;
@property (nonatomic, strong) UILabel *restaurantLocation;
@property (nonatomic, strong) UILabel *customerName;
@property (nonatomic, strong) UILabel *customerLocation;
@property (nonatomic, strong) UILabel *food;
@property (nonatomic, strong) UILabel *foodDescription;
@property (nonatomic, strong) UILabel *price;

- (id)initWithOrder:(NSDictionary *)order andKey:(NSString *)orderKey;

@property (nonatomic, weak) id <CourierConfirmViewControllerDelegate> delegate;

@end


@protocol CourierConfirmViewControllerDelegate <NSObject>

- (void)courierConfirmViewController:(CourierConfirmViewController *)viewController didCompleteOrder:(NSDictionary *)order;

@end
