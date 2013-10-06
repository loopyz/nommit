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
        
        self.navigationItem.title = @"Loading Restaurants...";
        self.view.backgroundColor = [UIColor whiteColor];
        
        
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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissRequest)];
    self.navigationItem.leftBarButtonItem = backButton;
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
                                   stringWithFormat:@"http://api.locu.com/v1_0/venue/search/?api_key=bf748001618d2abadd62f21440b39f26cd89c515&category=restaurant&has_menu=true&description=best&location=%f%@%f",
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
                UINavigationController *restaurantViewNavController = [[UINavigationController alloc] initWithRootViewController:restaurantView];
                [self presentViewController:restaurantViewNavController animated:YES completion:nil];
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


@end
