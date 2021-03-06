//
//  ScoreboardListTableViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 22/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "ScoreboardListTableViewController.h"
#import "Game.h"

@interface ScoreboardListTableViewController ()

@property NSMutableArray *incomplete;
@property NSMutableArray *complete;

@end

@implementation ScoreboardListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Games/"];
    self.filePathsArray = [[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dataPath  error:nil] mutableCopy];
    self.complete = [[NSMutableArray alloc] initWithObjects: nil];
    self.incomplete = [[NSMutableArray alloc] initWithObjects: nil];
    for (NSString *gameString in self.filePathsArray) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Games/"];
        dataPath = [dataPath stringByAppendingPathComponent:gameString];
        Game *game = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
        if (game.complete) {
            [self.complete addObject:gameString];
        } else {
            [self.incomplete addObject:gameString];
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch  (section) {
        case 0:
            return [self.complete count];
        case 1:
            return [self.incomplete count];
        default:
            break;
    }
    return [self.filePathsArray count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Complete games";
        default:
            return @"Incomplete games";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog([NSString stringWithFormat:@"%d", [indexPath row]]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        // More initializations if needed.
    }
    // Configure the cell...
    if ([indexPath section]==0) {
        cell.textLabel.text = [self.complete objectAtIndex:[indexPath row]];
    } else {
        cell.textLabel.text = [self.incomplete objectAtIndex:[indexPath row]];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Games/"];
    if  ([indexPath section]==0) {
        dataPath = [dataPath stringByAppendingPathComponent:[self.complete objectAtIndex:[indexPath row]]];
    } else {
        dataPath = [dataPath stringByAppendingPathComponent:[self.incomplete objectAtIndex:[indexPath row]]];
    }
    Game *game = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[game] forKeys:@[@"game"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receivedNewGame" object:nil userInfo:dict];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Games/"];
        NSFileManager *manager = [NSFileManager defaultManager];
        if  ([indexPath section]==0) {
        dataPath = [dataPath stringByAppendingPathComponent:[self.complete objectAtIndex:[indexPath row]]];
        NSError *error;
        [manager removeItemAtPath:dataPath error:&error];
        [self.complete removeObjectAtIndex:[indexPath row]];
        } else {
            dataPath = [dataPath stringByAppendingPathComponent:[self.incomplete objectAtIndex:[indexPath row]]];
            NSError *error;
            [manager removeItemAtPath:dataPath error:&error];
            [self.incomplete removeObjectAtIndex:[indexPath row]];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

