//
//  ScoreboardTableViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 22/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "ScoreboardTableViewController.h"
#import "ScoreboardBatsmanTableViewCell.h"
#import "ScoreboardBowlerTableViewCell.h"
#import "MatchFactsTableViewCell.h"
#import "MatchSummaryTableViewCell.h"

@interface ScoreboardTableViewController ()

@end

@implementation ScoreboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib = [UINib nibWithNibName:@"ScorecardBatsmanTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"batsman"];
    nib = [UINib nibWithNibName:@"ScorecardBowlerTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"bowler"];
    nib = [UINib nibWithNibName:@"MatchFactsTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"matchFacts"];
    nib = [UINib nibWithNibName:@"MatchSummaryTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"matchSummary"];
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.index!=-1) {
        self.inning = [self.game.innings objectAtIndex:self.index];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.index == -1) {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.index == -1) {
        switch (section) {
            case 0:
                return 1;
                
            default:
                return [[[self game] innings] count];
        }
    }
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [self.inning.batsmen count]+1;
        default:
            return [self.inning.bowlers count]+2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == -1) {
        switch ([indexPath section]) {
            case 0: {
                MatchFactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchFacts"];
                cell.teamNames.text = [NSString stringWithFormat:@"%@ vs %@", self.game.homeName, self.game.awayName];
                cell.ground.text = self.game.ground;
                NSString *tossTeam;
                if (self.game.homeToss) {
                    tossTeam = self.game.homeName;
                } else {
                    tossTeam = self.game.awayName;
                }
                NSString *choice;
                Inning *inning = [self.game.innings objectAtIndex:0];
                if ([inning battingSide] != self.game.homeToss) {
                    choice = @"bat";
                } else {
                    choice = @"field";
                }
                NSString *limited;
                if (self.game.limited == 1) {
                    limited = [NSString stringWithFormat:@"%d overs", self.game.overs];
                } else {
                    limited = @"declaration";
                }
                if (self.game.complete) {
                    cell.matchResult.text = [self.game computeResult];
                } else {
                    cell.matchResult.text = [self.game matchStatus];
                }
                cell.type.text = [NSString stringWithFormat:@"%@, %@, %d innings", self.game.type, limited, self.game.inningsCount];
                cell.toss.text = [NSString stringWithFormat:@"%@ won the toss and chose to %@", tossTeam, choice];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
                NSString *formattedDate = [dateFormatter stringFromDate:self.game.date];
                cell.date.text = formattedDate;
                return cell;
            }
                
            default: {
                MatchSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchSummary"];
                Inning *inning = [self.game.innings objectAtIndex:[indexPath row]];
                cell.colour.layer.cornerRadius = 30;
                cell.colour.layer.masksToBounds = YES;
                cell.colour.layer.shouldRasterize = YES;
                cell.colour.layer.rasterizationScale = [UIScreen mainScreen].scale;
                cell.overs.text = [NSString stringWithFormat:@"%d.%d Overs", inning.overs, inning.balls];
                if (inning.battingSide) {
                    cell.battingTeam.text = self.game.awayName;
                    cell.colour.backgroundColor = [UIColor blueColor];
                } else {
                    cell.battingTeam.text = self.game.homeName;
                    cell.colour.backgroundColor = [UIColor redColor];
                }
                if ([indexPath row] / 2 == 0) {
                    cell.inningsNumber.text = @"First Innings";
                } else {
                    cell.inningsNumber.text = @"Second Innings";
                }
                cell.score.text = [NSString stringWithFormat:@"%d-%d", inning.total, inning.wickets];
                NSSortDescriptor *scoreDescriptor = [NSSortDescriptor
                                                     sortDescriptorWithKey:@"score"
                                                     ascending:NO];
                NSSortDescriptor *ballsDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"balls" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObjects:scoreDescriptor, ballsDescriptor, nil];
                NSArray *sortedBatsmen = [inning.batsmen
                                          sortedArrayUsingDescriptors:sortDescriptors];
                
                Batsman *bat = [sortedBatsmen objectAtIndex:0];
                cell.bat1name.text = [[bat player] name];
                cell.bat1score.text = [NSString stringWithFormat:@"%d (%d)", [bat score], [bat balls]];
                bat = [sortedBatsmen objectAtIndex:1];
                cell.bat2name.text = [[bat player] name];
                cell.bat2score.text = [NSString stringWithFormat:@"%d (%d)", [bat score], [bat balls]];
                if ([sortedBatsmen count]>2) {
                    cell.bat3name.hidden = NO;
                    cell.bat3score.hidden = NO;
                    bat = [sortedBatsmen objectAtIndex:2];
                    cell.bat3name.text = [[bat player] name];
                    cell.bat3score.text = [NSString stringWithFormat:@"%d (%d)", [bat score], [bat balls]];
                } else {
                    cell.bat3name.hidden = YES;
                    cell.bat3score.hidden = YES;
                }
                NSSortDescriptor *wicketDescriptor = [NSSortDescriptor
                                                      sortDescriptorWithKey:@"wickets"
                                                      ascending:NO];
                NSSortDescriptor *runsDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"runs" ascending:YES];
                sortDescriptors = [NSArray arrayWithObjects:wicketDescriptor, runsDescriptor, nil];
                NSArray *sortedBowlers = [inning.bowlers
                                          sortedArrayUsingDescriptors:sortDescriptors];
                Bowler *bowl = [sortedBowlers objectAtIndex:0];
                cell.bowl1name.text = [[bowl player] name];
                cell.bowl1score.text = [NSString stringWithFormat:@"%d-%d", [bowl wickets], [bowl runs]];
                if ([sortedBowlers count]>1) {
                    cell.bowl2name.hidden = NO;
                    cell.bowl2score.hidden = NO;
                    bowl = [sortedBowlers objectAtIndex:1];
                    cell.bowl2name.text = [[bowl player] name];
                    cell.bowl2score.text = [NSString stringWithFormat:@"%d-%d", [bowl wickets], [bowl runs]];
                } else {
                    cell.bowl2name.hidden = YES;
                    cell.bowl2score.hidden = YES;
                }
                
                if ([sortedBowlers count]>2) {
                    cell.bowl3name.hidden = NO;
                    cell.bowl3score.hidden = NO;
                    bowl = [sortedBowlers objectAtIndex:2];
                    cell.bowl3name.text = [[bowl player] name];
                    cell.bowl3score.text = [NSString stringWithFormat:@"%d-%d", [bowl wickets], [bowl runs]];
                } else {
                    cell.bowl3name.hidden = YES;
                    cell.bowl3score.hidden = YES;
                }
                
                return cell;
            }
        }
    }
    switch ([indexPath section]) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:25 weight:10];
            if (self.inning.battingSide) {
                cell.textLabel.text = self.game.awayName;
            } else {
                cell.textLabel.text = self.game.homeName;
            }
            if ([indexPath row] / 2 == 0) {
                cell.detailTextLabel.text = @"First Innings";
            } else {
                cell.detailTextLabel.text = @"Second Innings";
            }
            return cell;
        }
        case 1: {
            ScoreboardBatsmanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"batsman"];
            if (cell == nil) {
                cell = [[ScoreboardBatsmanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"batsman"];
            }

            if ([self.inning.batsmen count]==[indexPath row]) {
                cell.score.text = [NSString stringWithFormat:@"%d-%d", self.inning.total, self.inning.wickets];
                cell.score.font = [UIFont systemFontOfSize:25 weight:10];
                cell.bowler.text = [NSString stringWithFormat:@"Overs: %d.%d", self.inning.overs, self.inning.balls];
                cell.fielder.text = [NSString stringWithFormat:@"Extras: %d", self.inning.legByes+self.inning.byes+self.inning.wides+self.inning.noBalls];
                cell.name.text = @"";
                return cell;
            }
            cell.score.font = [UIFont systemFontOfSize:17];
            Batsman *batsman = [self.inning.batsmen objectAtIndex:[indexPath row]];
            cell.name.text = [[batsman player] name];
            cell.score.text = [NSString stringWithFormat:@"%d (%d)", batsman.score, batsman.balls];
            Dismissal *dismissal = [batsman dismissal];
            if ([dismissal.howOut isEqualToString:@"Not Out"]) {
                cell.fielder.text = @"Not Out";
                cell.bowler.text = @"";
            } else if ([[dismissal howOut] isEqualToString:@"Bowled"]) {
                cell.fielder.text = @"";
                cell.bowler.text = [NSString stringWithFormat:@"b.%@", dismissal.bowler.player.name];
            } else if ([[dismissal howOut] isEqualToString:@"Hit Wicket"]) {
                cell.fielder.text = @"Hit Wicket";
                cell.bowler.text = [NSString stringWithFormat:@"b.%@", dismissal.bowler.player.name];
            } else if ([[dismissal howOut] isEqualToString:@"LBW"]) {
                cell.fielder.text = @"LBW";
                cell.bowler.text = [NSString stringWithFormat:@"b.%@", dismissal.bowler.player.name];
            } else if ([[dismissal howOut] isEqualToString:@"Caught"]) {
                if (dismissal.fielder) {
                    cell.fielder.text = [NSString stringWithFormat:@"c.%@", dismissal.fielder.name];
                } else {
                    cell.fielder.text = @"Caught";
                }
                cell.bowler.text = [NSString stringWithFormat:@"b.%@", dismissal.bowler.player.name];
            } else if ([[dismissal howOut] isEqualToString:@"Timed Out"]) {
                cell.fielder.text = @"Timed Out";
                cell.bowler.text = @"";
            } else if ([[dismissal howOut] isEqualToString:@"Stumped"]) {
                if (dismissal.fielder) {
                    cell.fielder.text = [NSString stringWithFormat:@"st.%@", dismissal.fielder.name];
                } else {
                    cell.fielder.text = @"Stumped";
                }
                cell.bowler.text = [NSString stringWithFormat:@"b.%@", dismissal.bowler.player.name];
            } else if ([[dismissal howOut] isEqualToString:@"Run Out"]) {
                if (dismissal.fielder) {
                    cell.fielder.text = [NSString stringWithFormat:@"Run Out (%@)", dismissal.fielder.name];
                } else {
                    cell.fielder.text = @"Run Out";
                }
                cell.bowler.text = @"";
            } else if ([[dismissal howOut] isEqualToString:@"Handled the Ball"]) {
                cell.fielder.text = @"Handled the Ball";
                cell.bowler.text = [NSString stringWithFormat:@"b.%@", dismissal.bowler.player.name];
            } else if ([[dismissal howOut] isEqualToString:@"Retired"]) {
                cell.fielder.text = @"Retired";
                cell.bowler.text = @"";
            } else if ([[dismissal howOut] isEqualToString:@"Obstructing the Field"]) {
                cell.fielder.text = @"Obstructing the Field";
                cell.bowler.text = @"";
            }
            return cell;
        }
        default: {
            ScoreboardBowlerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bowler"];
            if (cell == nil) {
                cell = [[ScoreboardBowlerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bowler"];
            }

            if ([indexPath row]==0) {
                cell.name.text = @"";
                return cell;
            } else if ([indexPath row]==[self.inning.bowlers count]+1) {
                cell.overs.text = @"";
                cell.maidens.text = @"";
                cell.runs.text = @"";
                cell.wickets.text = @"";
                NSMutableArray *fows = [[NSMutableArray alloc] initWithObjects: nil];
                int count = 1;
                for (Batsman *batsman in self.inning.batsmen) {
                    Dismissal *dismissal = batsman.dismissal;
                    if (![dismissal.howOut isEqualToString:@"Not Out"]) {
                        [fows addObject:[NSNumber numberWithInt:dismissal.fow]];
                    }
                }
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(compare:)];
                NSArray* sortedNumbers = [fows sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSString *fowString = @"FOW:    ";
                for (NSNumber *number in sortedNumbers) {
                    fowString = [fowString stringByAppendingString:[NSString stringWithFormat:@"%d-%@   ", count, number]];
                    count++;
                }
                cell.name.text = fowString;
                return cell;
            }
            Bowler *bowler = [self.inning.bowlers objectAtIndex:[indexPath row]-1];
            cell.name.text = [[bowler player] name];
            cell.overs.text = [NSString stringWithFormat:@"%d.%d", bowler.overs, bowler.balls];
            cell.maidens.text = [NSString stringWithFormat:@"%d", bowler.maidens];
            cell.runs.text = [NSString stringWithFormat:@"%d", bowler.runs];
            cell.wickets.text = [NSString stringWithFormat:@"%d", bowler.wickets];
            return cell;
        }
    }
    
    // Configure the cell...
    
    return NULL;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.index == -1) {
        return nil;
    }
    switch (section) {
        case 0:
            return @"";
        case 1:
            return @"Batting";
        default:
            return @"Bowling";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.index == -1) {
        return 0;
    }
    switch (section) {
        case 0:
            return 0;
        case 1:
            return 25;
        default:
            return 25;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == -1) {
        switch ([indexPath section]) {
            case 0:
                return 150;
                
            default:
                return 250;
        }
    }
    return 50;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
