//
//  MapViewController.m
//  nommit
//
//  Created by Gregory Rose on 9/30/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

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
    //If we want a custom button image
    //UIImage *image = [UIImage imageNamed:@"IMAGENAME"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[button setBackgroundImage: [image stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
    //button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    //[button addTarget:self action:@selector(SELECTOR)    forControlEvents:UIControlEventTouchUpInside];
    
    //UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
    //[v addSubview:button];
    
    UIBarButtonItem *foodRequestButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(openRequestView)];
    self.navigationItem.rightBarButtonItem = foodRequestButton;
}

- (void)openRequestView
{
    RequestViewController *requestView = [[RequestViewController alloc] init];
    [self presentViewController:requestView animated:YES completion:nil];
}

@end
