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
@synthesize gs;

- (void)loadView {
    mapView_.myLocationEnabled = YES;
    
    CLLocation *myLocation = mapView_.myLocation;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    marker.title = @"Current Location";
    marker.map = mapView_;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                                            longitude:myLocation.coordinate.longitude
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    self.view = mapView_;

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
        self.navigationItem.title = @"nommit";
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
    mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    
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

- (void)initMode1Buttons
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UILabel *waitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenRect.size.height-60, screenRect.size.width-40, 44)];
    [waitingLabel setText:@"   Waiting for food..."];
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
    UIBarButtonItem *driverButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCourierRegView)];
    self.navigationItem.rightBarButtonItem = driverButton;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(10,screenHeight-50,screenWidth-20,44);
    UIColor *buttonColor = [[UIColor alloc] initWithRed:174.0/255 green:134.0/255 blue:191.0/255 alpha:1];
    GlossyButton *glossyBtn = [[GlossyButton alloc] initWithFrame:rect withBackgroundColor:buttonColor];
    [glossyBtn setTitle:@"Request Food" forState:UIControlStateNormal];
    [glossyBtn addTarget:self action:@selector(openRequestView) forControlEvents:UIControlEventTouchUpInside];

    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, screenHeight - 100, screenWidth-20, 44)];
    
    // This sets the border style of the text field
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [textField setFont:[UIFont boldSystemFontOfSize:12]];
    
    //Placeholder text is displayed when no text is typed
    textField.placeholder = @"Address";
    
    
    //It set when the left prefixLabel to be displayed
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    // Adds the textField to the view.
    [self.view setUserInteractionEnabled:YES];
    [self.view addSubview:textField];
    
    // sets the delegate to the current class
    textField.delegate = self;
    
    //[label setText:@"  Address"];
    //[label setBackgroundColor:[UIColor whiteColor]];
    //[label setShadowColor:[UIColor blackColor]];
    
    //set selector or callback as openRequestView for UITouchUpInside
    [self.view addSubview:glossyBtn];
    //[self.view addSubview:label];
    
    
}

// pragma mark is used for easy access of code in Xcode
#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (void)initNewCourierButton
{
    //If we want a custom button image
    //UIImage *image = [UIImage imageNamed:@"IMAGENAME"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[button setBackgroundImage: [image stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
    //button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    //[button addTarget:self action:@selector(SELECTOR)    forControlEvents:UIControlEventTouchUpInside];
    
    //UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
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
    
    UIBarButtonItem *courierRequestButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(openCourierView)];
    self.navigationItem.leftBarButtonItem = courierRequestButton;
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
    NSLog(@"Delivered food!");
}

@end
