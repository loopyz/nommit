//
//  CourierConfirmViewController.m
//  nommit
//
//  Created by Gregory Rose on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "CourierConfirmViewController.h"
#import "GlossyButton.h"
#import <Firebase/Firebase.h>

@interface CourierConfirmViewController ()

@end

@implementation CourierConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initButtons];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        // Custom initialization
    }
    return self;
}

- (id)initWithOrder:(NSDictionary *)order andKey:(NSString *)orderKey
{
    self = [self initWithNibName:nil bundle:nil];
    self.order = order;
    self.orderKey = orderKey;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.restaurantName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenWidth, 44)];
    self.restaurantName.text = order[@"restaurant"][@"name"];
    
    self.restaurantLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, screenWidth, 44)];
    self.restaurantLocation.text = order[@"restaurant"][@"location"];
    
    self.customerName = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, screenWidth, 44)];
    self.customerName.text = order[@"customer"][@"name"];
    
    self.customerLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, screenWidth, 44)];
    self.customerLocation.text = order[@"customer"][@"location"];
    
    self.food = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, screenWidth, 44)];
    self.food.text = order[@"food"];
//    self.price=order[@"price"];
    
    [self.view addSubview:self.restaurantName];
    [self.view addSubview:self.restaurantLocation];
    [self.view addSubview:self.customerName];
    [self.view addSubview:self.customerLocation];
    [self.view addSubview:self.food];
    
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
    [confirmButton addTarget:self action:@selector(courierDidConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    GlossyButton *cancelButton = [[GlossyButton alloc] initWithFrame:CGRectMake(screenWidth/2+5, buttonY, buttonWidth, 44) withBackgroundColor:buttonColor];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(courierDidCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    [self.view addSubview:cancelButton];

}

- (void)courierDidConfirm
{
    //Try to confirm the order (ensure order still exists and is still open)
    Firebase *orderRef = [[Firebase alloc] initWithUrl:[@"https://nommit.firebaseio.com/orders/" stringByAppendingString:_orderKey]];
    [orderRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [orderRef removeAllObservers];
        
        if (snapshot.value == [NSNull null] || [snapshot.value[@"status"] intValue] == 1) {
            NSLog(@"Order already filled or cancelled!");
            [self courierDidCancel];
        } else {
            NSLog(@"Order confirmed!");
            [[orderRef childByAppendingPath:@"status"] setValue:@1];
            // Return to MapView
        }
    }];
}

- (void)courierDidCancel
{
    NSLog(@"Courier cancelled");
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

@end
