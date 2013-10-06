//
//  TipViewController.m
//  nommit
//
//  Created by Gregory Rose on 10/6/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "TipViewController.h"
#import "GlossyButton.h"
#import <VenmoAppSwitch/Venmo.h>

@interface TipViewController ()

@end

@implementation TipViewController {
    VenmoClient *_venmoClient;
    int r;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        UILabel *suggested = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/2-110, screenWidth-40, 40)];
        suggested.font = [UIFont fontWithName:@"Helvetica-Light" size:34];
        suggested.text = @"Suggested Tip:";
        suggested.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:suggested];
        
        r = arc4random()%100;
        
        
        UILabel *tipAmt = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/2-20, screenWidth-40, 80)];
        tipAmt.font = [UIFont fontWithName:@"Helvetica-Light" size:68];
        tipAmt.textAlignment = NSTextAlignmentCenter;
        tipAmt.text = [NSString stringWithFormat:@"$%d", r/9];
        [self.view addSubview:tipAmt];
        
        UIColor *buttonColor = [[UIColor alloc] initWithRed:174.0/255 green:134.0/255 blue:191.0/255 alpha:1];
        GlossyButton *button = [[GlossyButton alloc] initWithFrame:CGRectMake(20, screenHeight-60, screenWidth-40, 40)
                                               withBackgroundColor:buttonColor];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        [button setTitle:@"Tip" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leaveTip) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    return self;
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

- (void)leaveTip
{
    _venmoClient = [VenmoClient clientWithAppId:@"1422" secret:@"s5z3FenAVb7YYFPNbNKcHfeby6ACZMrV"];
    
    VenmoTransaction *venmoTransaction = [[VenmoTransaction alloc] init];
    venmoTransaction.type = VenmoTransactionTypeCharge;
    
    NSString *price_raw = [NSString stringWithFormat:@"$%d", r];
    venmoTransaction.amount = [NSDecimalNumber decimalNumberWithString:price_raw];
    venmoTransaction.note = @"Tip for my nommit order!";
    // TODO: remove hardcoded recipient
    venmoTransaction.toUserHandle = @"7047267873"; //self.order[@"customer"][@"phone"];
    
    VenmoViewController *venmoViewController = [_venmoClient viewControllerWithTransaction:
                                                venmoTransaction];
    if (venmoViewController) {
        [self presentModalViewController:venmoViewController animated:YES];
    }
}

@end
