//
//  Geocoding.m
//  nommit
//
//  Created by Lucy Guo on 10/6/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//


#import "Geocoding.h"


@implementation Geocoding
{
    NSData *_data;
    
}

@synthesize geocode;


- (id)init{
    self = [super init];
    geocode = [[NSDictionary alloc]initWithObjectsAndKeys:@"0.0",@"lat",@"0.0",@"lng",@"Null Island",@"address",nil];
    return self;
}


- (id)initWithCurLocation:(NSDictionary *)curLocation {
    self = [super init];
    geocode = curLocation;
    return self;
}


- (void)geocodeAddress:(NSString *)address withCallback:(SEL)sel withDelegate:(id)delegate {
    
    
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,address];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
        [self fetchedData:data withCallback:sel withDelegate:delegate];
    });
}

- (void)fetchedData:(NSData *)data withCallback:(SEL)sel withDelegate:(id)delegate{
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    
    NSArray* results = [json objectForKey:@"results"];
    
    if (results == nil || [results count] == 0) { //Check if the results array is empty (can't find location)
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Location"
                                                          message:@"Please enter an address."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    } else {
        NSDictionary *result = [results objectAtIndex:0];
        NSString *address = [result objectForKey:@"formatted_address"];
        NSDictionary *geometry = [result objectForKey:@"geometry"];
        NSDictionary *location = [geometry objectForKey:@"location"];
        NSString *lat = [location objectForKey:@"lat"];
        NSString *lng = [location objectForKey:@"lng"];
        NSDictionary *gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address",nil];
        geocode = gc;   //Only update geocoded location if we found what the user was looking for
        }
    [delegate performSelector:sel];    
}

@end