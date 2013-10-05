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
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"nommit";
        [self initNewFoodRequestButton];
        
        
        //UIButton *curAddress = [[UIButton alloc] initWithFrame:CGRectMake(0, screenHeight - 50, screenWidth, 40)];
        //[curAddress setTitle:@"Request Food" forState:UIControlStateNormal];
        //[self.view addSubview:curAddress];
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

- (void)initNewFoodRequestButton
{
    UIBarButtonItem *driverButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCourierRegView)];
    self.navigationItem.rightBarButtonItem = driverButton;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(10,screenHeight-50,screenWidth-20,44);
    GlossyButton *glossyBtn = [[GlossyButton alloc] initWithFrame:rect withBackgroundColor:[UIColor redColor]];
    [glossyBtn setTitle:@"Request Food" forState:UIControlStateNormal];
    //set selector or callback as openRequestView for UITouchUpInside
    [self.view addSubview:glossyBtn];
}

- (void)openRequestView
{
    RequestViewController *requestView = [[RequestViewController alloc] init];
    [self presentViewController:requestView animated:YES completion:nil];
}

- (void)openCourierRegView
{
    CourierRegistrationViewController *courierView = [[CourierRegistrationViewController alloc] init];
    [self presentViewController:courierView animated:YES completion:nil];
}

@end
