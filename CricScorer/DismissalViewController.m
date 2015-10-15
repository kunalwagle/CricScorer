//
//  DismissalViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 19/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "DismissalViewController.h"
#import "Inning.h"
#import "Batsman.h"
#import "Player.h"
#import "Bowler.h"
#import "SelectPlayerViewController.h"

@interface DismissalViewController ()

@property NSArray *dismissals;

@end

@implementation DismissalViewController

Bowler *wicketBowler;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dismissals = @[@"Bowled", @"Hit Wicket", @"LBW", @"Caught", @"Timed Out", @"Stumped", @"Run Out", @"Handled the Ball", @"Retired", @"Obstructing the field" ];
    NSArray *items = @[@"Batsman 0", @"Batsman 1"];
    self.batsmenNames = [[StandardSegmentedControl alloc] initWithItems:items];
    self.batsmenNames.frame = CGRectMake(320, 40, 500, self.batsmenNames.frame.size.height);
    self.batsmenNames.selectedSegmentIndex = 0;
    [self.batsmenNames setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0],
                                                NSForegroundColorAttributeName:[UIColor blackColor]}
                                     forState:UIControlStateNormal];
    [self.batsmenNames setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0],
                                                NSForegroundColorAttributeName:[UIColor blackColor]}
                                     forState:UIControlStateSelected];
    [self.batsmenNames addTarget:self action:@selector(batsmanChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.batsmenNames];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpView:) name:@"loadWicket" object:nil];
}

-(void)setUpView:(NSNotification*)notification {
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    [self.batsmenNames setTitle:[[[inning.currentBatsmen objectAtIndex:0] player] name] forSegmentAtIndex:0];
    [self.batsmenNames setTitle:[[[inning.currentBatsmen objectAtIndex:1] player] name] forSegmentAtIndex:1];
    self.batsmenNames.selectedSegmentIndex = inning.onStrike;
    //self.howOut.selectedSegmentIndex = 0;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    self.batsmanName.text = [[[inning.currentBatsmen objectAtIndex:inning.onStrike] player] name];
    self.dismissal.text = [NSString stringWithFormat:@"b. %@", [[[inning.currentBowlers objectAtIndex:inning.currentBowler] player] name]];
    Batsman *batsman = [inning.currentBatsmen objectAtIndex:inning.onStrike];
    self.score.text = [NSString stringWithFormat:@"%d", [batsman score]];
    self.balls.text = [NSString stringWithFormat:@"%d", [batsman balls]];
    self.sr.text = [NSString stringWithFormat:@"%.2f", ((float)[batsman score]/[batsman balls]) * 100];
    self.fow.text = [NSString stringWithFormat:@"%d", [inning total]];
    self.fielderActualName.text = @"Not Specified";
    self.fielderName.hidden = YES;
    self.fielderActualName.hidden = YES;
    self.fielderLabel.hidden = YES;
    self.changeFielder.hidden = YES;
    wicketBowler = [inning.currentBowlers objectAtIndex:inning.currentBowler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"changeFielder"]) {
        SelectPlayerViewController *vc = (SelectPlayerViewController*)[segue destinationViewController];
        Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
        if (inning.battingSide == 0) {
            vc.team = self.game.awayTeam;
        } else {
            vc.team = self.game.homeTeam;
        }
        vc.notificationName = [segue identifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickedFielder:) name:@"changeFielder" object:nil];
    } else if ([[segue identifier] isEqualToString:@"newBatsman"]){
        SelectPlayerViewController *vc = (SelectPlayerViewController*)[segue destinationViewController];
        Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
        if (inning.battingSide == 0) {
            vc.team = self.game.homeTeam;
        } else {
            vc.team = self.game.awayTeam;
        }
        vc.notificationName = [segue identifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickedNewBatsman:) name:@"newBatsman" object:nil];
    }
}

-(void)pickedFielder:(NSNotification*)notification {
    NSDictionary *dict = notification.userInfo;
    if ([dict objectForKey:@"name"]) {
        self.fielderActualName.text = [dict objectForKey:@"name"];
    } else {
        Player *player = [dict objectForKey:@"player"];
        self.fielderActualName.text = [player name];
    }
    
    [self update];
}

//START HERE AND ADJUST FROM SEGMENTED CONTROL TO TABLEVIEW

-(void)pickedNewBatsman:(NSNotification*)notification {
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    NSDictionary *dict = notification.userInfo;
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
    dataPath = [dataPath stringByAppendingPathComponent:@"players"];
    NSMutableArray *players = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    NSPredicate *predicate;
    NSArray *searchArray;
    Batsman *batsman;
    if ([dict objectForKey:@"name"]) {
        predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", [dict objectForKey:@"name"]];
        searchArray = [players filteredArrayUsingPredicate:predicate];
        batsman = [[Batsman alloc] initWithPlayer:[searchArray objectAtIndex:0]];
    } else {
        Player *player = [dict objectForKey:@"player"];
        batsman = [[Batsman alloc] initWithPlayer:player];
    }

    if (inning.battingSide == 1) {
        if (![self.game inAwayTeam:[batsman player]]) {
            [self.game.awayTeam addObject:[batsman player]];
        } else {
            batsman.player = [self.game getAwayPlayer:[batsman player]];
        }
    } else {
        if (![self.game inHomeTeam:[batsman player]]) {
            [self.game.homeTeam addObject:[batsman player]];
        } else {
            batsman.player = [self.game getHomePlayer:[batsman player]];
        }
    }
    NSDictionary *info;
    if (self.fielderActualName.hidden == NO && ![self.fielderActualName.text isEqualToString:@"Not Specified"]) {
        predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", self.fielderActualName.text];
        searchArray = [players filteredArrayUsingPredicate:predicate];
        if (inning.battingSide == 1) {
            if (![self.game inHomeTeam:[searchArray objectAtIndex:0]]) {
                [self.game.homeTeam addObject:[searchArray objectAtIndex:0]];
            }
        } else {
            if (![self.game inAwayTeam:[searchArray objectAtIndex:0]]) {
                [self.game.awayTeam addObject:[searchArray objectAtIndex:0]];
            }
        }
        info = [[NSDictionary alloc] initWithObjects:@[batsman, [NSNumber numberWithInt:self.batsmenNames.selectedSegmentIndex], [NSNumber numberWithInt:[[self.tableView indexPathForSelectedRow] row]], [searchArray objectAtIndex:0]] forKeys:@[@"newBatsman", @"whoOut", @"howOut", @"fielder"]];
    } else {
        info = [[NSDictionary alloc] initWithObjects:@[batsman, [NSNumber numberWithInt:self.batsmenNames.selectedSegmentIndex], [NSNumber numberWithInt:[[self.tableView indexPathForSelectedRow] row]]] forKeys:@[@"newBatsman", @"whoOut", @"howOut"]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wicketConfigured" object:nil userInfo:info];
    
}

-(void)update {
    switch ([[self.tableView indexPathForSelectedRow] row]) {
        case 0: {
            self.dismissal.text = [NSString stringWithFormat:@"b. %@", [[wicketBowler player] name]];
            self.fielderName.hidden = YES;
            self.fielderLabel.hidden = YES;
            self.fielderActualName.hidden = YES;
            self.changeFielder.hidden = YES;
            break;
        }
        case 1: {
            self.dismissal.text = [NSString stringWithFormat:@"Hit Wicket b. %@", [[wicketBowler player] name]];
            self.fielderName.hidden = YES;
            self.fielderLabel.hidden = YES;
            self.fielderActualName.hidden = YES;
            self.changeFielder.hidden = YES;
            break;
        }
        case 2: {
            self.dismissal.text = [NSString stringWithFormat:@"LBW b. %@", [[wicketBowler player] name]];
            self.fielderName.hidden = YES;
            self.fielderLabel.hidden = YES;
            self.fielderActualName.hidden = YES;
            self.changeFielder.hidden = YES;
            break;
        }
        case 3: {
            if ([self.fielderActualName.text isEqualToString:@"Not Specified"]) {
                self.dismissal.text = [NSString stringWithFormat:@"Caught b. %@", [[wicketBowler player] name]];
            } else {
                self.dismissal.text = [NSString stringWithFormat:@"c. %@ b. %@", self.fielderActualName.text, [[wicketBowler player] name]];
            }
            self.fielderName.hidden = NO;
            self.fielderLabel.hidden = NO;
            self.fielderActualName.hidden = NO;
            self.changeFielder.hidden = NO;
            break;
        }
        case 4: {
            self.dismissal.text = [NSString stringWithFormat:@"Timed Out b. %@", [[wicketBowler player] name]];
            self.fielderName.hidden = YES;
            self.fielderLabel.hidden = YES;
            self.fielderActualName.hidden = YES;
            self.changeFielder.hidden = YES;
            break;
        }
        case 5: {
            if ([self.fielderActualName.text isEqualToString:@"Not Specified"]) {
                self.dismissal.text = [NSString stringWithFormat:@"Stumped b. %@", [[wicketBowler player] name]];
            } else {
                self.dismissal.text = [NSString stringWithFormat:@"st. %@ b. %@", self.fielderActualName.text, [[wicketBowler player] name]];
            }
            self.fielderName.hidden = NO;
            self.fielderLabel.hidden = NO;
            self.fielderActualName.hidden = NO;
            self.changeFielder.hidden = NO;
            break;
        }
        case 6: {
            if ([self.fielderActualName.text isEqualToString:@"Not Specified"]) {
                self.dismissal.text = @"Run Out";
            } else {
                self.dismissal.text = [NSString stringWithFormat:@"Run Out (%@)", self.fielderActualName.text];
            }
            self.fielderName.hidden = NO;
            self.fielderLabel.hidden = NO;
            self.fielderActualName.hidden = NO;
            self.changeFielder.hidden = NO;
            break;
        }
        case 7: {
            self.dismissal.text = [NSString stringWithFormat:@"Handled the Ball b. %@", [[wicketBowler player] name]];
            self.fielderName.hidden = YES;
            self.fielderLabel.hidden = YES;
            self.fielderActualName.hidden = YES;
            self.changeFielder.hidden = YES;
            break;
        }
        case 8: {
            self.dismissal.text = @"Retired";
            self.fielderName.hidden = YES;
            self.fielderLabel.hidden = YES;
            self.fielderActualName.hidden = YES;
            self.changeFielder.hidden = YES;
            break;
        }
        case 9: {
            self.dismissal.text = @"Obstructing the Field";
            self.fielderName.hidden = YES;
            self.fielderLabel.hidden = YES;
            self.fielderActualName.hidden = YES;
            self.changeFielder.hidden = YES;
            break;
        }
        default:
            break;
    }
}


- (IBAction)submit:(id)sender {
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    if (inning.wickets!=9 && (inning.overs != self.game.overs || !self.game.limited)) {
        [self performSegueWithIdentifier:@"newBatsman" sender:self];
    } else {
        //[[NSNotificationCenter defaultCenter] removeObserver:self];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
        dataPath = [dataPath stringByAppendingPathComponent:@"players"];
        NSMutableArray *players = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
        NSDictionary *info;
        if (self.fielderActualName.hidden == NO && ![self.fielderActualName.text isEqualToString:@"Not Specified"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", self.fielderActualName.text];
            NSArray *searchArray = [players filteredArrayUsingPredicate:predicate];
            if (inning.battingSide == 1) {
                if (![self.game inHomeTeam:[searchArray objectAtIndex:0]]) {
                    [self.game.homeTeam addObject:[searchArray objectAtIndex:0]];
                }
            } else {
                if (![self.game inAwayTeam:[searchArray objectAtIndex:0]]) {
                    [self.game.awayTeam addObject:[searchArray objectAtIndex:0]];
                }
            }
            info = [[NSDictionary alloc] initWithObjects:@[@"None", [NSNumber numberWithInt:self.batsmenNames.selectedSegmentIndex], [NSNumber numberWithInt:self.howOut.selectedSegmentIndex], [searchArray objectAtIndex:0]] forKeys:@[@"newBatsman", @"whoOut", @"howOut", @"fielder"]];
        } else {
            info = [[NSDictionary alloc] initWithObjects:@[@"None", [NSNumber numberWithInt:self.batsmenNames.selectedSegmentIndex], [NSNumber numberWithInt:self.howOut.selectedSegmentIndex]] forKeys:@[@"newBatsman", @"whoOut", @"howOut"]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wicketConfigured" object:nil userInfo:info];
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dismissals count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.dismissals objectAtIndex:[indexPath row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self update];
}

- (IBAction)change:(id)sender {
    
}


- (IBAction)dismissalChanged:(id)sender {
    [self update];
}

- (IBAction)batsmanChanged:(id)sender {
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    Batsman *batsman = [inning.currentBatsmen objectAtIndex:self.batsmenNames.selectedSegmentIndex];
    self.batsmanName.text = [[batsman player] name];
    self.score.text = [NSString stringWithFormat:@"%d", batsman.score];
    self.balls.text = [NSString stringWithFormat:@"%d", batsman.balls];
    self.sr.text = [NSString stringWithFormat:@"%.2f", (((float)batsman.score/batsman.balls)*100)];
    self.fow.text = [NSString stringWithFormat:@"%d", inning.total];
}

@end
