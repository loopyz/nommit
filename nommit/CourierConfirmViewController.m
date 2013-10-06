//
//  CourierConfirmViewController.m
//  nommit
//
//  Created by Gregory Rose on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "CourierConfirmViewController.h"
#import "MapViewController.h"
#import "GlossyButton.h"
#import <Firebase/Firebase.h>
#import <VenmoAppSwitch/Venmo.h>

@interface CourierConfirmViewController ()

@end

@implementation CourierConfirmViewController{
    VenmoClient *_venmoClient;
}

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
    CGFloat screenHeight = screenRect.size.height;
    
    self.restaurantName = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, screenWidth-20, 44)];
    self.restaurantName.text = order[@"restaurant"][@"name"];
    self.restaurantName.textAlignment = NSTextAlignmentCenter;
    
    self.restaurantLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, screenWidth-20, 44)];
    self.restaurantLocation.text = order[@"restaurant"][@"location"];
    self.restaurantLocation.textAlignment = NSTextAlignmentCenter;
    
    self.customerName = [[UILabel alloc] initWithFrame:CGRectMake(10, screenHeight-160,
                                                                  screenWidth-20, 44)];
    self.customerName.text = [@"Deliver to: " stringByAppendingString:order[@"customer"][@"name"]];
    self.customerName.textAlignment = NSTextAlignmentCenter;
    
    self.customerLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, screenHeight-120,
                                                                      screenWidth-20, 44)];
    self.customerLocation.text = order[@"customer"][@"location"];
    self.customerLocation.textAlignment = NSTextAlignmentCenter;
    
    self.food = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, screenWidth-40, 44)];
    self.food.text = order[@"food"][@"name"];
    self.food.textAlignment = NSTextAlignmentLeft;
    
    self.foodDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, screenWidth-40, 200)];
    self.foodDescription.text = order[@"food"][@"description"];
    self.foodDescription.textAlignment = NSTextAlignmentLeft;
    self.foodDescription.lineBreakMode = NSLineBreakByWordWrapping;
    self.foodDescription.numberOfLines = 0;

    if (order[@"price"]) {
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, screenWidth-20, 44)];
        self.price.text = order[@"price"];
        self.price.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:self.price];
    }
        
    [self.view addSubview:self.restaurantName];
    [self.view addSubview:self.restaurantLocation];
    [self.view addSubview:self.customerName];
    [self.view addSubview:self.customerLocation];
    [self.view addSubview:self.food];
    [self.view addSubview:self.foodDescription];

    
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
            [self handleConfirmation];
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

- (void)handleConfirmation
{
    // Venmo
    _venmoClient = [VenmoClient clientWithAppId:@"1422" secret:@"s5z3FenAVb7YYFPNbNKcHfeby6ACZMrV"];
    
    VenmoTransaction *venmoTransaction = [[VenmoTransaction alloc] init];
    venmoTransaction.type = VenmoTransactionTypeCharge;
    venmoTransaction.amount = [NSDecimalNumber decimalNumberWithString:self.order[@"price"]];
    venmoTransaction.note = @"what does the fox say";
    venmoTransaction.toUserHandle = self.order[@"customer"][@"phone"];
    
    VenmoViewController *venmoViewController = [_venmoClient viewControllerWithTransaction:
                                                venmoTransaction];
    if (venmoViewController) {
        [self presentModalViewController:venmoViewController animated:YES];
    }

    /*if ([self.delegate respondsToSelector:@selector(courierConfirmViewController:didCompleteOrder:)]) {
        [self.delegate courierConfirmViewController:self didCompleteOrder:self.order];
        [self dismissViewControllerAnimated:YES completion:nil];
    }*/
    
    // TODO: Return to MapView and return order
    MapViewController *mvc = [[MapViewController alloc] initWithMode:2];
    UINavigationController *mvcNavController = [[UINavigationController alloc] initWithRootViewController:mvc];
    [self presentViewController:mvcNavController animated:YES completion:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"openURL: %@", url);
    return [_venmoClient openURL:url completionHandler:^(VenmoTransaction *transaction, NSError *error) {
        if (transaction) {
            NSString *success = (transaction.success ? @"Success" : @"Failure");
            NSString *title = [@"Transaction " stringByAppendingString:success];
            NSString *message = [@"payment_id: " stringByAppendingFormat:@"%@. %@ %@ %@ (%@) $%@ %@",
                                 transaction.transactionID,
                                 transaction.fromUserID,
                                 transaction.typeStringPast,
                                 transaction.toUserHandle,
                                 transaction.toUserID,
                                 transaction.amountString,
                                 transaction.note];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        } else { // error
            NSLog(@"transaction error code: %i", error.code);
        }
    }];
}

@end
