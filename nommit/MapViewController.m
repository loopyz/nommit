//
//  MapViewController.m
//  nommit
//
//  Created by Gregory Rose on 9/30/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GlossyButton.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    GMSMapView *mapView_;
}

- (void)loadView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.3581
                                                            longitude:71.0636
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(42.3581, 71.0636);
    marker.title = @"Null Island";
    marker.snippet = @"Uninitialized";
    marker.map = mapView_;

}

- (id)init{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.mode = 0;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.navigationItem.title = @"nommit";
        
        UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nommit"]];
        titleImageView.frame = CGRectMake(18, -8, titleImageView.frame.size.width/4, titleImageView.frame.size.height/4);
        [logoView addSubview:titleImageView];
        
        self.navigationItem.titleView = logoView;
        [self initNewCourierButton];
    }
    return self;
}

- (id)initWithMode:(NSInteger)mode
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.mode = mode;
        NSLog(@"Initiating mode: %d", mode);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.mode == 0) {
        [self initMode0Buttons];
    } else if (self.mode == 1) {
        [self initMode1Buttons];
    } else if (self.mode == 2) {
        [self initMode2Buttons];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)estimatedWaitTime
{
    return @"5 min"; // TODO: generate formula for wait time
}

- (void)initMode1Buttons
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UILabel *waitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenRect.size.height-60, screenRect.size.width-40, 44)];
    NSString *waitTime = [self estimatedWaitTime];
    [waitingLabel setText:[@"   Delivery in progress.  ETA: " stringByAppendingString:waitTime]];
    [waitingLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:waitingLabel];
}

- (void)initMode2Buttons
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(10,screenHeight-50,screenWidth-20,44);
    UIColor *buttonColor = [[UIColor alloc] initWithRed:174.0/255 green:134.0/255 blue:191.0/255 alpha:1];
    GlossyButton *glossyBtn = [[GlossyButton alloc] initWithFrame:rect withBackgroundColor:buttonColor];
    [glossyBtn setTitle:@"Complete Delivery" forState:UIControlStateNormal];
    [glossyBtn addTarget:self action:@selector(didCompleteDelivery) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initMode0Buttons
{
    /*UIBarButtonItem *driverButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCourierRegView)];
    self.navigationItem.rightBarButtonItem = driverButton;*/
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(10,screenHeight-50,screenWidth-20,44);
    UIColor *buttonColor = [[UIColor alloc] initWithRed:174.0/255 green:134.0/255 blue:191.0/255 alpha:1];
    GlossyButton *glossyBtn = [[GlossyButton alloc] initWithFrame:rect withBackgroundColor:buttonColor];
    [glossyBtn setTitle:@"Request Food" forState:UIControlStateNormal];
    [glossyBtn addTarget:self action:@selector(openRequestView) forControlEvents:UIControlEventTouchUpInside];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, screenHeight - 100, screenWidth-20, 44)];
    [label setText:@"  Address"];
    [label setBackgroundColor:[UIColor whiteColor]];
    //[label setShadowColor:[UIColor blackColor]];
    
    //set selector or callback as openRequestView for UITouchUpInside
    [self.view addSubview:glossyBtn];
    [self.view addSubview:label];
}

- (void)initNewCourierButton
{
    UIImage *image = [UIImage imageNamed:@"courier"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setBackgroundImage: [image stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [button addTarget:self action:@selector(openCourierView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftbbi = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftbbi;
    //UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,
    //                                                    image.size.width, image.size.height)];
    //[v addSubview:button];
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://api.locu.com/v1_0/venue/search/api_key=2fde854b70bc2db996860115e60a89c3d68bd858&country=United+States&region=CA&name=Bollyhood&description=best&location=37.78,122.42"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    /*[NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingGroupsFailedWithError:error];
        } else {
            [self.delegate receivedGroupsJSON:data];
        }
    }];*/
    
    //UIBarButtonItem *courierRequestButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(openCourierView)];
    //self.navigationItem.leftBarButtonItem = courierRequestButton;
}

- (void)openRequestView
{
    RequestViewController *requestView = [[RequestViewController alloc] init];
    UINavigationController *requestNavController = [[UINavigationController alloc] initWithRootViewController:requestView];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:requestNavController animated:YES completion:nil];
}

- (void)openCourierRegView
{
    CourierRegistrationViewController *courierView = [[CourierRegistrationViewController alloc] init];
    [self presentViewController:courierView animated:YES completion:nil];
}

- (void)openCourierView
{
    CourierViewController *courierView = [[CourierViewController alloc] init];
    UINavigationController *courierViewNavController = [[UINavigationController alloc] initWithRootViewController:courierView];
    [self presentViewController:courierViewNavController animated:YES completion:nil];
}

- (void)didCompleteDelivery
{
    // Send text to customer
    NSString *urlAsString = [NSString stringWithFormat:@"http://twitterautomate.com/testapp/nommit_sms.php"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"Delivered food!");
    
    // Reset mode
    self.mode = 0;
    [self reloadInputViews];
}

@end
