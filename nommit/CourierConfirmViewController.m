//
//  CourierConfirmViewController.m
//  nommit
//
//  Created by Gregory Rose on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "CourierConfirmViewController.h"
#import "GlossyButton.h"

@interface CourierConfirmViewController ()

@end

@implementation CourierConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithOrder:(NSDictionary *)order
{
    self = [self initWithNibName:nil bundle:nil];
    self.order = order;
    NSLog(@"%@", self.order);
    return self;
}

- (void)initConfirmButton
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(10,screenHeight-100,screenWidth-20,44);
    UIColor *buttonColor = [[UIColor alloc] initWithRed:174.0/255 green:134.0/255 blue:191.0/255 alpha:1];
    GlossyButton *glossyBtn = [[GlossyButton alloc] initWithFrame:rect withBackgroundColor:buttonColor];
    [glossyBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [glossyBtn addTarget:self action:@selector(courierDidConfirm) forControlEvents:UIControlEventTouchUpInside];

}

- (void)courierDidConfirm
{
    NSLog(@"Courier hit confirm button");
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
