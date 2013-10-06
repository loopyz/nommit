//
//  CourierConfirmViewController.h
//  nommit
//
//  Created by Gregory Rose on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourierConfirmViewController : UIViewController

@property (nonatomic, strong) NSDictionary *order;

- (id)initWithOrder:(NSDictionary *)order;

@end
