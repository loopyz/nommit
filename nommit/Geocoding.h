//
//  Geocoding.h
//  nommit
//
//  Created by Lucy Guo on 10/6/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Geocoding : NSObject

- (id)init;

- (void)geocodeAddress:(NSString *)address
          withCallback:(SEL)callback
          withDelegate:(id)delegate;

@property (nonatomic, strong) NSDictionary *geocode;

- (id)initWithCurLocation:(NSDictionary *)curLocation;

@end