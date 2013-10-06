//
//  LoginViewController.m
//  nommit
//
//  Created by Lucy Guo on 10/6/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "LoginViewController.h"
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import "MapViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
        /*FBLoginView *loginView = [[FBLoginView alloc] init];
        // Align the button in the center horizontally
        loginView.frame = CGRectOffset(loginView.frame,
                                       (self.view.center.x - (loginView.frame.size.width / 2)),
                                       5);
        [self.view addSubview:loginView];
        [loginView sizeToFit];*/
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://nommit.firebaseio.com"];
    FirebaseSimpleLogin* authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
    NSLog(@"waddup");
    
    /*[authClient createUserWithEmail:@"luh@guo.com" password:@"fox"
                 andCompletionBlock:^(NSError* error, FAUser* user) {
                     
                     NSLog(@"ring dingding");
                     if (error != nil) {
                         // There was an error creating the account
                         NSLog(@"moo");
                         NSLog(@"%@",[error localizedDescription]);
                     } else {
                         // We created a new user account
                         NSLog(@"foxy");
                     }
                 }];*/
    
    /*[authClient loginWithEmail:@"lucy@guo.com" andPassword:@"fox"
           withCompletionBlock:^(NSError* error, FAUser* user) {
               
               if (error != nil) {
                   // There was an error logging in to this account
                   NSLog(@"booooom!");
               } else {
                   // We are now logged in
                   NSLog(@"winning");
               }
           }];*/
    
    [authClient loginToFacebookAppWithId:@"205557856291924" permissions:@[@"email"]
                                audience:ACFacebookAudienceOnlyMe
                     withCompletionBlock:^(NSError *error, FAUser *user) {
                         NSLog(@"at least I got called");
                         if (error != nil) {
                             // There was an error logging in
                             NSLog(@"there was an error :(");
                         } else if (user == nil) {
                             // No user is logged in
                             NSLog(@"didn't work");
                         } else  {
                             // We have a logged in facebook user
                             NSLog(@"Good job!");
                             NSLog(@"%@", user.thirdPartyUserData[@"displayName"]);
                             
                             MapViewController *mvc = [[MapViewController alloc] init];
                             UINavigationController *mvcNavController = [[UINavigationController alloc] initWithRootViewController:mvc];
                             [self.navigationController presentViewController:mvcNavController animated:YES completion:nil];
                         }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
