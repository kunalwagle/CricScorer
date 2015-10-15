//
//  MatchSummaryViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 21/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "MatchSummaryViewController.h"
#import "MatchSummaryTableViewCell.h"
#import "MatchFactsTableViewCell.h"
#import "GamePlayViewController.h"
#import "Inning.h"
#import "Batsman.h"
#import "Bowler.h"
#import "Player.h"

@interface MatchSummaryViewController ()

@end

@implementation MatchSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGame:) name:@"updateGame" object:nil];
    UINib *nib = [UINib nibWithNibName:@"MatchFactsTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"matchFacts"];
    nib = [UINib nibWithNibName:@"MatchSummaryTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"matchSummary"];
    self.loadGame.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)updateGame:(NSNotification*)notification {
    self.loadGame.enabled = YES;
    self.game = [[notification userInfo] objectForKey:@"game"];
    [self.tableView reloadData];
    if (self.game.complete) {
        self.matchSituation.text = [self.game computeResult];
    } else {
        self.matchSituation.text = [self.game matchStatus];
    }
    self.navigationItem.title = [self.game title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.game) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.game) {
        return 0;
    }
    switch (section) {
        case 0:
            return 1;
            
        default:
            return [[[self game] innings] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0:
            return 150;
            
        default:
            return 250;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
            cell.type.text = [NSString stringWithFormat:@"%@, %@, %d innings", self.game.type, limited, self.game.inningsCount];
            cell.toss.text = [NSString stringWithFormat:@"%@ won the toss and chose to %@", tossTeam, choice];
            if (self.game.complete) {
                cell.matchResult.text = [self.game computeResult];
            } else {
                cell.matchResult.text = [self.game matchStatus];
            }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"loadGame"]) {
        GamePlayViewController *vc = (GamePlayViewController*)[segue destinationViewController];
        vc.game = self.game;
        vc.initialise = NO;
    }
}


- (IBAction)loadGame:(id)sender {
    [self performSegueWithIdentifier:@"loadGame" sender:self];
}

@end
