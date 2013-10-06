//
//  DisplayRestaurantsViewController.m
//  nommit
//
//  Created by Lucy Guo on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "DisplayRestaurantsViewController.h"
#import "MenuViewController.h"
#import "MapViewController.h"

@interface DisplayRestaurantsViewController ()

@end

@implementation DisplayRestaurantsViewController
{
    NSMutableArray* _restaurants;
    NSMutableArray* _restaurantsData;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRestaurants:(NSArray*)restaurants_master
{
    self = [super init];
    if (self){
        _restaurants = [[NSMutableArray alloc] init];
        _restaurantsData = [[NSMutableArray alloc] init];
        
        for (NSDictionary* myrestaurant in restaurants_master)
        {
            NSString *requestString = [NSString
                                       stringWithFormat:@"http://api.locu.com/v1_0/venue/%@/?api_key=bf748001618d2abadd62f21440b39f26cd89c515",
                                       myrestaurant[@"id"]];
            
            NSURL *url = [[NSURL alloc] initWithString:requestString];
            NSLog(@"%@", requestString);
            
            [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                
                if (error) {
                    NSLog(@"Error %@; %@", error, [error localizedDescription]);
                } else {
                    NSError *localError = nil;
                    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
                    
                    NSArray *restaurants = parsedObject[@"objects"];
                    NSDictionary *restaurant = restaurants[0];
                    NSArray *menus = restaurant[@"menus"];
                    
                    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *menu in menus)
                    {
                        NSArray *sections = menu[@"sections"];
                        for (NSDictionary *section in sections)
                        {
                            NSArray *subsections = section[@"subsections"];
                            for (NSDictionary *subsection in subsections)
                            {
                                NSArray *contents = subsection[@"contents"];
                                for (NSDictionary *item in contents)
                                {
                                    if ([item[@"type"] isEqualToString:@"ITEM"])
                                    {
                                        if ([item objectForKey:@"price"])
                                        {
                                            [menuItems addObject:item];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if ([menuItems count] > 0) {
                        [_restaurants addObject:myrestaurant];
                        [_restaurantsData addObject:menuItems];
                        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    }
                }
            }];
        }
        
        self.navigationItem.title = @"Restaurants";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissMenu)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_restaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary* restaurant = [_restaurants objectAtIndex:indexPath.row];
    
    cell.textLabel.text = restaurant[@"name"];
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    [[cell detailTextLabel] setText:restaurant[@"street_address"]];
    [[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"We selected something!");
    NSDictionary* restaurant = [_restaurants objectAtIndex:indexPath.row];
    NSMutableArray* menuItems = [_restaurantsData objectAtIndex:indexPath.row];
    NSLog(@"%@", [_restaurantsData objectAtIndex:indexPath.row]);
    
    MenuViewController *menuView = [[MenuViewController alloc] initWithMenuItems:menuItems andRestaurant:restaurant];
    UINavigationController *menuViewNavController = [[UINavigationController alloc] initWithRootViewController:menuView];
    [self presentViewController:menuViewNavController animated:YES completion:nil];
    
    return;
    
    NSString *requestString = [NSString
                               stringWithFormat:@"http://api.locu.com/v1_0/venue/%@/?api_key=bf748001618d2abadd62f21440b39f26cd89c515",
                               restaurant[@"id"]];
    
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
            NSDictionary *restaurant = restaurants[0];
            NSArray *menus = restaurant[@"menus"];
            
            NSMutableArray *menuItems = [[NSMutableArray alloc] init];
            
            for (NSDictionary *menu in menus)
            {
                NSArray *sections = menu[@"sections"];
                for (NSDictionary *section in sections)
                {
                    NSArray *subsections = section[@"subsections"];
                    for (NSDictionary *subsection in subsections)
                    {
                        NSArray *contents = subsection[@"contents"];
                        for (NSDictionary *item in contents)
                        {
                            if ([item[@"type"] isEqualToString:@"ITEM"])
                            {
                                if ([item objectForKey:@"price"])
                                {
                                    [menuItems addObject:item];
                                }
                            }
                        }
                    }
                }
            }
            
            // ADD: time estimating function
            
            MenuViewController *menuView = [[MenuViewController alloc] initWithMenuItems:menuItems andRestaurant:restaurant];
            UINavigationController *menuViewNavController = [[UINavigationController alloc] initWithRootViewController:menuView];
            [self presentViewController:menuViewNavController animated:YES completion:nil];
        }
    }];

    //MenuViewController *ccvc = [[MenuViewController alloc] initWithMenu:menu];
    //UINavigationController *ccvcNavController = [[UINavigationController alloc] initWithRootViewController:ccvc];
    //[self presentViewController:ccvcNavController animated:YES completion:nil];
}

- (void)dismissMenu
{
    MapViewController *mvc = [[MapViewController alloc] init];
    UINavigationController *mvcNavController = [[UINavigationController alloc] initWithRootViewController:mvc];
    [self presentViewController:mvcNavController animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
