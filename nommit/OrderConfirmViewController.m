//
//  OrderConfirmViewController.m
//  nommit
//
//  Created by Gregory Rose on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "OrderConfirmViewController.h"
#import "MapViewController.h"
#import "GlossyButton.h"
#import <Firebase/Firebase.h>

@interface OrderConfirmViewController ()

@end

@implementation OrderConfirmViewController{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initButtons];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        // Initialize labels
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        self.restaurantName = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, screenWidth-20, 44)];
        self.restaurantName.text = @"";
        self.restaurantLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, screenWidth-20, 44)];
        self.restaurantLocation.text = @"";
        self.food = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, screenWidth-40, 44)];
        self.food.text = @"";
        self.foodDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, screenWidth-40, 200)];
        self.foodDescription.text = @"";
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, screenWidth-20, 44)];
        self.price.text = @"";
        
    }
    return self;
}

- (id)initWithMenu:(NSDictionary *)menu andRestaurant:(NSDictionary *)restaurant
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (restaurant[@"name"]) {
        self.restaurantName.text = restaurant[@"name"];
        self.restaurantName.textAlignment = NSTextAlignmentCenter;
    }
    
    if (restaurant[@"street_address"]) {
        self.restaurantLocation.text = restaurant[@"street_address"];
        self.restaurantLocation.textAlignment = NSTextAlignmentCenter;
    }
    
    if (menu[@"name"]) {
        self.food.text = menu[@"name"];
        self.food.textAlignment = NSTextAlignmentLeft;
    }
    
    if (menu[@"description"]) {
        self.foodDescription.text = menu[@"description"];
        self.foodDescription.textAlignment = NSTextAlignmentLeft;
        self.foodDescription.lineBreakMode = NSLineBreakByWordWrapping;
        self.foodDescription.numberOfLines = 0;
    }
    
    if (menu[@"price"]) {
        self.price.text = [@"$" stringByAppendingString:menu[@"price"]];
        self.price.textAlignment = NSTextAlignmentRight;
    }
    
    [self.view addSubview:self.restaurantName];
    [self.view addSubview:self.restaurantLocation];
    [self.view addSubview:self.food];
    [self.view addSubview:self.foodDescription];
    [self.view addSubview:self.price];
    
    return self;
}

- (void)initButtons
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat buttonWidth = screenWidth/2-15;
    CGFloat buttonY = screenHeight-55;
    
    CGRect rect = CGRectMake(10,buttonY,buttonWidth,44);
    UIColor *buttonColor = [[UIColor alloc] initWithRed:174.0/255 green:134.0/255 blue:191.0/255 alpha:1];
    GlossyButton *confirmButton = [[GlossyButton alloc] initWithFrame:rect withBackgroundColor:buttonColor];
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(customerDidConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    GlossyButton *cancelButton = [[GlossyButton alloc] initWithFrame:CGRectMake(screenWidth/2+5, buttonY, buttonWidth, 44) withBackgroundColor:buttonColor];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(customerDidCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    [self.view addSubview:cancelButton];
    
}

- (void)customerDidConfirm
{
    // Confirm customer order
    Firebase *orderRef = [[Firebase alloc] initWithUrl:@"https://nommit.firebaseio.com/orders/"];
    Firebase *newOrderRef = [orderRef childByAutoId];
    
    [newOrderRef setValue:@{
                            @"customer" : @{@"name" : @"Angela Zhang",
                                            @"location": @"Krieger Stadium"},
                            @"restaurant" : @{@"name" : self.restaurantName.text,
                                              @"location": self.restaurantLocation.text},
                            @"food" : @{@"name" : self.food.text,
                                        @"description" : self.foodDescription.text},
                            @"price" : self.price.text,
                            @"status" : @0
     }];

    NSLog(@"Order confirmed!");
    self.orderKey = newOrderRef.name;
    [self handleConfirmation];
}

- (void)customerDidCancel
{
    NSLog(@"Customer cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleConfirmation
{
    /*if ([self.delegate respondsToSelector:@selector(orderConfirmViewController:didCompleteOrder:)]) {
        [self.delegate orderConfirmViewController:self didCompleteOrder:self.order];
        [self dismissViewControllerAnimated:YES completion:nil];
    }*/
    
    // TODO: Return to MapView and return order
    MapViewController *mvc = [[MapViewController alloc] initWithMode: 1 andOrderKey:self.orderKey];
    UINavigationController *mvcNavController = [[UINavigationController alloc] initWithRootViewController:mvc];
    [self presentViewController:mvcNavController animated:YES completion:nil];
}

@end
