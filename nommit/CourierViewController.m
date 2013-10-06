//
//  CourierViewController.m
//  nommit
//
//  Created by Gregory Rose on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//



#import "CourierViewController.h"
#import "CourierConfirmViewController.h"

@interface CourierViewController ()

@end

@implementation CourierViewController
{
    NSMutableArray* orderKeys; // TODO: global variable
    NSMutableDictionary* orders;
    Firebase* firebase;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        firebase = [[Firebase alloc] initWithUrl:@"https://nommit.firebaseio.com/"];
        
        // Initialize orders data
        orderKeys = [[NSMutableArray alloc] init];
        orders = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadAndUpdateOrders];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// Loads stored orders from Firebase
- (void)loadAndUpdateOrders {
        Firebase* openOrdersRef = [firebase childByAppendingPath:@"orders"];
    
    [openOrdersRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Order added: %@", snapshot.value);
        [orders setObject:snapshot.value forKey:snapshot.name];
        if ([snapshot.value[@"status"] intValue] == 0)
        {
            [orderKeys addObject:snapshot.name];
        }
        
        [self.tableView reloadData];
    }];
    
    [openOrdersRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Order changed: %@", snapshot.name);
        
        NSInteger newVal = [snapshot.value[@"status"] intValue];
        if (newVal == 1)
        {
            [orderKeys removeObject:snapshot.name];
        } else if (newVal == 0)
        {
            NSInteger oldVal = [orders[snapshot.name][@"status"] intValue];
            if (oldVal == 1) {
                [orderKeys addObject:snapshot.name];
            }
        }
        
        [self.tableView reloadData];
    }];
    
    [openOrdersRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Order deleted: %@", snapshot.value);
        
        [orders removeObjectForKey:snapshot.name];
        [orderKeys removeObject:snapshot.name];
        
        [self.tableView reloadData];
    }];
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
    return [orderKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString* orderKey = [orderKeys objectAtIndex:indexPath.row];
    NSMutableDictionary *order = orders[orderKey];
    
    cell.textLabel.text = order[@"restaurant"][@"name"];
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    [[cell detailTextLabel] setText:order[@"food"][@"name"]];
    [[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* orderKey = [orderKeys objectAtIndex:indexPath.row];
    NSMutableDictionary *order = orders[orderKey];
    CourierConfirmViewController *ccvc = [[CourierConfirmViewController alloc] initWithOrder:order andKey:orderKey];
    UINavigationController *ccvcNavController = [[UINavigationController alloc] initWithRootViewController:ccvc];
    [self presentViewController:ccvcNavController animated:YES completion:nil];
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
