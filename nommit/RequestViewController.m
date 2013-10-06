//
//  RequestViewController.m
//  nommit
//
//  Created by Gregory Rose on 9/30/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "RequestViewController.h"
#import <VenmoAppSwitch/Venmo.h>
#import "MapViewController.h"
#import "RequestView.h"
#import "DisplayRestaurantsViewController.h"

@interface RequestViewController ()

@property (nonatomic, strong) RequestView *reqView;

@end


@implementation RequestViewController {
    Firebase * _firebase;
    CLLocationManager *locationManager;
    bool done;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view = _reqView;
        _reqView.delegate = self;
        
        self.navigationItem.title = @"Request Food";
        // ADD: Search bar
        // TODO: Learn Yelp API
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(makeRequest)];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissRequest)];
        self.navigationItem.leftBarButtonItem = backButton;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        _firebase = [[Firebase alloc] initWithUrl:@"https://nommit.firebaseio.com/"];
        
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (id)init
{
    self = [self initWithNibName:nil bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil && !done) {
        done = true;
        //[locationManager stopUpdatingLocation];
        
        NSLog(@"%f %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        
        // NOTE: only gets restaurants with menus
        NSString *requestString = [NSString
                                   stringWithFormat:@"http://api.locu.com/v1_0/venue/search/?api_key=2fde854b70bc2db996860115e60a89c3d68bd858&category=restaurant&has_menu=true&description=best&location=%f%@%f",
                                   currentLocation.coordinate.latitude, @"%2C+", currentLocation.coordinate.longitude];
        
        NSURL *url = [[NSURL alloc] initWithString:requestString];
        NSLog(@"%@", requestString);
        
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                NSLog(@"Error %@; %@", error, [error localizedDescription]);
            } else {
                NSLog(@"success");
                NSError *localError = nil;
                NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
                
                NSArray *restaurants = parsedObject[@"objects"];
                // ADD: time estimating function
                
                DisplayRestaurantsViewController *restaurantView = [[DisplayRestaurantsViewController alloc] initWithRestaurants:restaurants];
                [self presentViewController:restaurantView animated:YES completion:nil];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissRequest
{
    MapViewController *mvc = [[MapViewController alloc] init];
    UINavigationController *mvcNavController = [[UINavigationController alloc] initWithRootViewController:mvc];
    [self.navigationController presentViewController:mvcNavController animated:YES completion:nil];
}

- (void)makeRequest
{
    // Make the food request! MOVE TO CourierConfirmViewController (courier charges customer)
    //DO something
    // TEST after UI implemented for choosing restaurants!
    /* Firebase* newOrderRef = [_firebase childByAutoId];
    [newOrderRef setValue:@{
                            @"customer" : @{@"name" : _reqView.customer,
                                            @"location": _reqView.customerLocation},
                            @"restaurant" : @{@"name" : _reqView.restaurant,
                                              @"location": _reqView.restaurantLocation},
                            @"food" : _reqView.food,
                            @"status" : @0
                            }]; */
}


@end
