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
#import "TipViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    GMSMapView *mapView_;
    
    GlossyButton *_glossyBtn;
    UILabel *_uiLabel;
}
@synthesize gs;

- (void)loadView {
    mapView_.myLocationEnabled = YES;
    
    CLLocation *myLocation = mapView_.myLocation;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    marker.title = @"Current Location";
    marker.map = mapView_;
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.44169 //myLocation.coordinate.latitude
                                                            longitude:-79.94628 //myLocation.coordinate.longitude
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(40.44169, -79.94628);
    GMSMarker *marker2 = [GMSMarker markerWithPosition:position];
    marker2.title = @"Courier Location";
    marker2.map = mapView_;
    
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


- (id)initWithMode:(NSInteger)mode andOrderKey:(NSString *)orderKey
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.mode = mode;
        self.orderKey = orderKey;
        NSLog(@"Initiating mode: %d", mode);
        NSLog(@"Order key: %@", orderKey);
    }
    
    [self checkOrderStatus];
    return self;
}

- (void)checkOrderStatus
{
    Firebase *orderRef = [[Firebase alloc] initWithUrl:[@"https://nommit.firebaseio.com/orders/" stringByAppendingString:_orderKey]];
    [orderRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (self.mode == 1 && [snapshot.value[@"status"] intValue] == 1) {
            self.mode = 2;
            [self refresh];
            NSLog(@"Order accepted!"); // TODO: text customer
        } else if (self.mode == 2 && [snapshot.value[@"status"] intValue] == 2) {
            self.mode = 0;
            [self refresh];
            NSLog(@"Order complete!"); // TODO: pop up rate courier
            
            /*TipViewController *tvc = [[TipViewController alloc] initWithCompletedOrder:self.orderKey];
            UINavigationController *tvcNavController = [[UINavigationController alloc] initWithRootViewController:tvc];
            [self presentViewController:tvcNavController animated:YES completion:nil];*/
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order Complete"
                                                           message:@"Your order has been completed! Don't forget to leave a tip. :)"
                                                          delegate:self
                                                 cancelButtonTitle:@"Dismiss"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    
    [self refresh];
}

- (void)refresh
{
    if (_uiLabel != nil) {
        [_uiLabel removeFromSuperview];
    }
    if (_glossyBtn != nil) {
        [_glossyBtn removeFromSuperview];
    }
    
    if (self.mode == 0) {
        [self initMode0Buttons];
    } else if (self.mode == 1) {
        [self initMode1Buttons];
    } else if (self.mode == 2) {
        [self initMode2Buttons];
    } else if (self.mode == 3) {
        [self initMode3Buttons];
    }
    [self reloadInputViews];
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
    _uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenRect.size.height-50, screenRect.size.width-76, 44)];
    [_uiLabel setText:@"   Contacting couriers..."];
    [_uiLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_uiLabel];
}

- (void)initMode2Buttons
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenRect.size.height-50, screenRect.size.width-76, 44)];
    NSString *waitTime = [self estimatedWaitTime];
    [_uiLabel setText:[@"  Delivery in progress. ETA: " stringByAppendingString:waitTime]];
    [_uiLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_uiLabel];
}

- (void)initMode3Buttons
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(10,screenHeight-50,screenWidth-76,44);
    UIColor *buttonColor = [[UIColor alloc] initWithRed:174.0/255 green:134.0/255 blue:191.0/255 alpha:1];
    _glossyBtn = [[GlossyButton alloc] initWithFrame:rect withBackgroundColor:buttonColor];
    [_glossyBtn setTitle:@"Complete Delivery" forState:UIControlStateNormal];
    [_glossyBtn addTarget:self action:@selector(didCompleteDelivery) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_glossyBtn];
}

- (void)initMode0Buttons
{
    /*UIBarButtonItem *driverButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCourierRegView)];
    self.navigationItem.rightBarButtonItem = driverButton;*/
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(10,screenHeight-47,screenWidth-76,40);
    UIColor *buttonColor = [[UIColor alloc] initWithRed:174.0/255 green:134.0/255 blue:191.0/255 alpha:1];
    _glossyBtn = [[GlossyButton alloc] initWithFrame:rect withBackgroundColor:buttonColor];
    [_glossyBtn setTitle:@"Request Food" forState:UIControlStateNormal];
    [_glossyBtn addTarget:self action:@selector(openRequestView) forControlEvents:UIControlEventTouchUpInside];

    /*UIImage *normal = [UIImage imageNamed:@"button_unpressed"];
    UIImage *pressed = [UIImage imageNamed:@"button_pressed"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button addTarget:self action:@selector(openRequestView) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:pressed forState:UIControlStateSelected];
    [button setImage:normal forState:UIControlStateNormal];
    [button setTitle:@"Request Food" forState:UIControlStateNormal];
    
    [self.view addSubview:button]; */
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, screenHeight - 100, screenWidth-20, 44)];
    
    // This sets the border style of the text field
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [textField setFont:[UIFont boldSystemFontOfSize:12]];
    
    //Placeholder text is displayed when no text is typed
    textField.placeholder = @"      Carnegie Mellon ....... 1 courier available";
    
    
    //It set when the left prefixLabel to be displayed
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // Adds the textField to the view.
    [self.view setUserInteractionEnabled:YES];
    [self.view addSubview:textField];
    
    // sets the delegate to the current class
    textField.delegate = self;
    
    //[label setText:@"  Address"];
    //[label setBackgroundColor:[UIColor whiteColor]];
    //[label setShadowColor:[UIColor blackColor]];
    
    //set selector or callback as openRequestView for UITouchUpInside
    [self.view addSubview:_glossyBtn];
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
    
    //NSString *urlAsString = [NSString stringWithFormat:@"http://api.locu.com/v1_0/venue/search/api_key=bf748001618d2abadd62f21440b39f26cd89c515&country=United+States&region=CA&name=Bollyhood&description=best&location=37.78,122.42"];
    //NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    //NSLog(@"%@", urlAsString);
    
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
    // Complete order
    Firebase *orderRef = [[Firebase alloc] initWithUrl:[@"https://nommit.firebaseio.com/orders/" stringByAppendingString:_orderKey]];
    [[orderRef childByAppendingPath:@"status"] setValue:@2];
    
    // Send text to customer
    // TODO: de-hardcode this url zomg
    NSString *urlAsString = [NSString stringWithFormat:@"http://twitterautomate.com/testapp/nommit_sms.php"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"Delivered food!");
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"Error %@; %@", error, [error localizedDescription]);
        } else {
            NSLog(@"Twilio'd");
        }
    }];
    
    
    // TODO: uialertview
    
    // Reset mode
    self.mode = 0;
    [self refresh];
}

@end
