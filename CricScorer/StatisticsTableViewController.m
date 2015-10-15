//
//  StatisticsTableViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 23/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "StatisticsTableViewController.h"
#import "StatisticsTableViewCell.h"
#import "Player.h"
#import "BattingStatistics.h"
#import "BowlingStatistics.h"

@interface StatisticsTableViewController ()

@end

@implementation StatisticsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib = [UINib nibWithNibName:@"BowlingStatisticsTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"cell"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
    dataPath = [dataPath stringByAppendingPathComponent:@"players"];
    self.properPlayers = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    self.tableView.allowsSelection = NO;
    
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.index == 0) {
        self.currentTag = 20;
        self.navigationItem.title = @"Batting Statistics";
        self.players = [self.properPlayers mutableCopy];
        for (Player *player in self.properPlayers) {
            if (player.batting.innings == 0) {
                [self.players removeObject:player];
            }
        }
    } else {
        self.currentTag = 40;
        self.navigationItem.title = @"Bowling Statistics";
        self.players = [self.properPlayers mutableCopy];
        for (Player *player in self.properPlayers) {
            if (player.bowling.balls == 0) {
                [self.players removeObject:player];
            }
        }
    }
    
    [self sort];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.players count]+1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    self.currentTag = sender.view.tag;
    [self sort];
    [self.tableView reloadData];
}

-(void)sort {
    NSSortDescriptor *sortDescriptor;
    if (self.index==0) {
        switch (self.currentTag) {
            case 10:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.innings"
                                                             ascending:NO];
                break;
            case 20:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.runs"
                                                             ascending:NO];
                break;
            case 30:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.balls"
                                                             ascending:NO];
                break;
            case 40:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.notOuts"
                                                             ascending:NO];
                break;
            case 50:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.average"
                                                             ascending:NO];
                break;
            case 60:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.highScore"
                                                             ascending:NO];
                break;
            case 70:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.strikeRate"
                                                             ascending:NO];
                break;
            case 80:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.fifties"
                                                             ascending:NO];
                break;
            case 90:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"batting.hundreds"
                                                             ascending:NO];
                break;
            default:
                break;
        }
    } else {
        switch (self.currentTag) {
            case 10:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.balls"
                                                             ascending:NO];
                break;
            case 20:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.maidens"
                                                             ascending:NO];
                break;
            case 30:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.runs"
                                                             ascending:YES];
                break;
            case 40:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.wickets"
                                                             ascending:NO];
                break;
            case 50:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.average"
                                                             ascending:YES];
                break;
            case 60:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.strikeRate"
                                                             ascending:YES];
                break;
            case 70:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.economy"
                                                             ascending:YES];
                break;
            case 80:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.bestWickets"
                                                             ascending:NO];
                break;
            case 90:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bowling.fiveWickets"
                                                             ascending:NO];
                break;
            default:
                break;
        }
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    if (self.index==1 && self.currentTag==80) {
        NSSortDescriptor *extraOne = [[NSSortDescriptor alloc] initWithKey:@"bestRuns" ascending:YES];
        sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, extraOne, nil];
    }
    NSArray *sortedArray;
    sortedArray = [self.players sortedArrayUsingDescriptors:sortDescriptors];
    self.players = [sortedArray mutableCopy];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[StatisticsTableViewCell alloc] init];
    }
    if (self.index==0) {
        if ([indexPath row]==0) {
            cell.stat1.text = @"Inns";
            cell.stat2.text = @"Runs";
            cell.stat3.text = @"B";
            cell.stat4.text = @"NO";
            cell.stat5.text = @"Avg";
            cell.stat6.text = @"HS";
            cell.stat7.text = @"SR";
            cell.stat8.text = @"50";
            cell.stat9.text = @"100";
            for (int i=10; i<=100; i+=10) {
                UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                UILabel *label = (UILabel*)[self.view viewWithTag:i];
                if (i==self.currentTag) {
                    [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]];
                } else {
                    [label setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:19.0]];
                }
                [label setUserInteractionEnabled:YES];
                [label addGestureRecognizer:singleTapGestureRecognizer];
            }
            cell.name.text = [NSString stringWithFormat:@"Currently sorted by: %@", ((UILabel*)[self.view viewWithTag:self.currentTag]).text];
            [cell.name setFont:[UIFont boldSystemFontOfSize:16]];
            return cell;
        }
        Player *player = [self.players objectAtIndex:[indexPath row]-1];
        BattingStats *stats = [player batting];
        cell.name.text = [player name];
        cell.stat1.text = [NSString stringWithFormat:@"%d", stats.innings];
        cell.stat2.text = [NSString stringWithFormat:@"%d", stats.runs];
        cell.stat4.text = [NSString stringWithFormat:@"%d", stats.notOuts];
        cell.stat6.text = [NSString stringWithFormat:@"%d", stats.highScore];
        cell.stat5.text = [NSString stringWithFormat:@"%.2f", stats.average];
        cell.stat3.text = [NSString stringWithFormat:@"%d", stats.balls];
        cell.stat7.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        cell.stat8.text = [NSString stringWithFormat:@"%d", stats.fifties];
        cell.stat9.text = [NSString stringWithFormat:@"%d", stats.hundreds];
        for (int i=10; i<=100; i+=10) {
            UILabel *label = (UILabel*)[self.view viewWithTag:i];
            [label setFont:[UIFont systemFontOfSize:14]];
        }
    } else {
        if ([indexPath row]==0) {
            cell.name.text = @"";
            for (int i=10; i<=100; i+=10) {
                UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                UILabel *label = (UILabel*)[self.view viewWithTag:i];
                if (i==self.currentTag) {
                    [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]];
                } else {
                    [label setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:19.0]];
                }
                [label setUserInteractionEnabled:YES];
                [label addGestureRecognizer:singleTapGestureRecognizer];
            }
            cell.name.text = [NSString stringWithFormat:@"Currently sorted by: %@", ((UILabel*)[self.view viewWithTag:self.currentTag]).text];
            [cell.name setFont:[UIFont boldSystemFontOfSize:16]];
            return cell;
        }
        Player *player = [self.players objectAtIndex:[indexPath row]-1];
        BowlingStatistics *stats = [player bowling];
        cell.name.text = [player name];
        cell.stat1.text = [NSString stringWithFormat:@"%d.%d", stats.balls/6, stats.balls%6];
        cell.stat2.text = [NSString stringWithFormat:@"%d", stats.maidens];
        cell.stat3.text = [NSString stringWithFormat:@"%d", stats.runs];
        cell.stat4.text = [NSString stringWithFormat:@"%d", stats.wickets];
        cell.stat5.text = [NSString stringWithFormat:@"%.2f", stats.average];
        cell.stat6.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        cell.stat7.text = [NSString stringWithFormat:@"%.2f", stats.economy];
        cell.stat8.text = [NSString stringWithFormat:@"%d-%d", stats.bestWickets, stats.bestRuns];
        cell.stat9.text = [NSString stringWithFormat:@"%d", stats.fiveWickets];
        for (int i=10; i<=100; i+=10) {
            UILabel *label = (UILabel*)[self.view viewWithTag:i];
            [label setFont:[UIFont systemFontOfSize:14]];
        }
    }
    // Configure the cell...
    
    return cell;
}


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
