//
//  RequestView.m
//  nommit
//
//  Created by Lucy Guo on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "RequestView.h"

@implementation RequestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int width = frame.size.width;
        int height = frame.size.height;
        
        _restaurantSearchText = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, width-50, 44)];
        _searchButton = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(width-40, 0, 20, 44)];
        [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchForRestaurant) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)searchForRestaurant
{
    //Fill in
}

@end
