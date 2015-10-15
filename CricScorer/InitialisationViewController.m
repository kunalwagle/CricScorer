//
//  InitialisationViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 05/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "InitialisationViewController.h"
#import "SelectPlayerViewController.h"

#import "Player.h"
#import "Batsman.h"
#import "Bowler.h"
#import "Inning.h"
#import "BattingStatistics.h"
#import "BowlingStatistics.h"

@interface InitialisationViewController ()


@end

@implementation InitialisationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpView:) name:@"initialiseInn" object:nil];
}

-(void)setUpView:(NSNotification*)notification {
    self.firstBatsman.text = @"First Batsman";
    self.secondBatsman.text = @"Second Batsman";
    self.openingBowler.text = @"First Bowler";
    self.followOn = NO;
    UILabel *label = (UILabel*)[self.view viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:11];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:12];
    label.text = [NSString stringWithFormat:@"%.2f", 0.00];
    label = (UILabel*)[self.view viewWithTag:13];
    label.text = [NSString stringWithFormat:@"%.2f", 0.00];
    label = (UILabel*)[self.view viewWithTag:14];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:15];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:16];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:20];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:21];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:22];
    label.text = [NSString stringWithFormat:@"%.2f", 0.00];
    label = (UILabel*)[self.view viewWithTag:23];
    label.text = [NSString stringWithFormat:@"%.2f", 0.00];
    label = (UILabel*)[self.view viewWithTag:24];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:25];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:26];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:30];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:31];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:32];
    label.text = [NSString stringWithFormat:@"%.2f", 0.00];
    label = (UILabel*)[self.view viewWithTag:33];
    label.text = [NSString stringWithFormat:@"%.2f", 0.00];
    label = (UILabel*)[self.view viewWithTag:34];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:35];
    label.text = [NSString stringWithFormat:@"%d", 0];
    label = (UILabel*)[self.view viewWithTag:36];
    label.text = [NSString stringWithFormat:@"%d", 0];
    if ([self.game.innings count] == 2) {
        Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
        if (inning.lead < 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow On" message:@"Has a follow on been enforced?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        self.followOn = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseb1:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedB1:) name:@"b1" object:nil];
    [self performSegueWithIdentifier:@"b1" sender:self];
}

- (IBAction)chooseb2:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedB2:) name:@"b2" object:nil];
    [self performSegueWithIdentifier:@"b2" sender:self];
}

- (IBAction)chooseb:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedB:) name:@"b" object:nil];
    [self performSegueWithIdentifier:@"b" sender:self];
}

- (void)receivedB1:(NSNotification*)notification {
    if ([[[notification userInfo] objectForKey:@"type"] isEqualToString:@"player"]) {
        Player *player = [[notification userInfo] objectForKey:@"player"];
        self.firstBatsman.text = [player name];
        BattingStats *stats = [player batting];
        UILabel *label = (UILabel*)[self.view viewWithTag:10];
        label.text = [NSString stringWithFormat:@"%d", stats.innings];
        label = (UILabel*)[self.view viewWithTag:11];
        label.text = [NSString stringWithFormat:@"%d", stats.runs];
        label = (UILabel*)[self.view viewWithTag:12];
        label.text = [NSString stringWithFormat:@"%.2f", stats.average];
        label = (UILabel*)[self.view viewWithTag:13];
        label.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        label = (UILabel*)[self.view viewWithTag:14];
        label.text = [NSString stringWithFormat:@"%d", stats.highScore];
        label = (UILabel*)[self.view viewWithTag:15];
        label.text = [NSString stringWithFormat:@"%d", stats.fifties];
        label = (UILabel*)[self.view viewWithTag:16];
        label.text = [NSString stringWithFormat:@"%d", stats.hundreds];
    } else if ([[[notification userInfo] objectForKey:@"type"] isEqualToString:@"data"]) {
        Player *player = [[notification userInfo] objectForKey:@"player"];
        self.firstBatsman.text = [player name];
        BattingStats *stats = [player batting];
        UILabel *label = (UILabel*)[self.view viewWithTag:10];
        label.text = [NSString stringWithFormat:@"%d", stats.innings];
        label = (UILabel*)[self.view viewWithTag:11];
        label.text = [NSString stringWithFormat:@"%d", stats.runs];
        label = (UILabel*)[self.view viewWithTag:12];
        label.text = [NSString stringWithFormat:@"%.2f", stats.average];
        label = (UILabel*)[self.view viewWithTag:13];
        label.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        label = (UILabel*)[self.view viewWithTag:14];
        label.text = [NSString stringWithFormat:@"%d", stats.highScore];
        label = (UILabel*)[self.view viewWithTag:15];
        label.text = [NSString stringWithFormat:@"%d", stats.fifties];
        label = (UILabel*)[self.view viewWithTag:16];
        label.text = [NSString stringWithFormat:@"%d", stats.hundreds];
    } else {
        self.firstBatsman.text = [[notification userInfo] objectForKey:@"name"];
    }
}

- (void)receivedB2:(NSNotification*)notification {
    if ([[[notification userInfo] objectForKey:@"type"] isEqualToString:@"data"]) {
        Player *player = [[notification userInfo] objectForKey:@"player"];
        self.secondBatsman.text = [player name];
        BattingStats *stats = [player batting];
        UILabel *label = (UILabel*)[self.view viewWithTag:20];
        label.text = [NSString stringWithFormat:@"%d", stats.innings];
        label = (UILabel*)[self.view viewWithTag:21];
        label.text = [NSString stringWithFormat:@"%d", stats.runs];
        label = (UILabel*)[self.view viewWithTag:22];
        label.text = [NSString stringWithFormat:@"%.2f", stats.average];
        label = (UILabel*)[self.view viewWithTag:23];
        label.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        label = (UILabel*)[self.view viewWithTag:24];
        label.text = [NSString stringWithFormat:@"%d", stats.highScore];
        label = (UILabel*)[self.view viewWithTag:25];
        label.text = [NSString stringWithFormat:@"%d", stats.fifties];
        label = (UILabel*)[self.view viewWithTag:26];
        label.text = [NSString stringWithFormat:@"%d", stats.hundreds];
    } else if ([[[notification userInfo] objectForKey:@"type"] isEqualToString:@"player"]) {
        Player *player = [[notification userInfo] objectForKey:@"player"];
        self.secondBatsman.text = [player name];
        BattingStats *stats = [player batting];
        UILabel *label = (UILabel*)[self.view viewWithTag:20];
        label.text = [NSString stringWithFormat:@"%d", stats.innings];
        label = (UILabel*)[self.view viewWithTag:21];
        label.text = [NSString stringWithFormat:@"%d", stats.runs];
        label = (UILabel*)[self.view viewWithTag:22];
        label.text = [NSString stringWithFormat:@"%.2f", stats.average];
        label = (UILabel*)[self.view viewWithTag:23];
        label.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        label = (UILabel*)[self.view viewWithTag:24];
        label.text = [NSString stringWithFormat:@"%d", stats.highScore];
        label = (UILabel*)[self.view viewWithTag:25];
        label.text = [NSString stringWithFormat:@"%d", stats.fifties];
        label = (UILabel*)[self.view viewWithTag:26];
        label.text = [NSString stringWithFormat:@"%d", stats.hundreds];

    } else {
        self.secondBatsman.text = [[notification userInfo] objectForKey:@"name"];
    }
}

- (void)receivedB:(NSNotification*)notification {
    if ([[[notification userInfo] objectForKey:@"type"] isEqualToString:@"data"]) {
        Player *player = [[notification userInfo] objectForKey:@"player"];
        self.openingBowler.text = [player name];
        BowlingStatistics *stats = [player bowling];
        UILabel *label = (UILabel*)[self.view viewWithTag:30];
        label.text = [NSString stringWithFormat:@"%d.%d", stats.balls/6, stats.balls%6];
        label = (UILabel*)[self.view viewWithTag:31];
        label.text = [NSString stringWithFormat:@"%d", stats.runs];
        label = (UILabel*)[self.view viewWithTag:32];
        label.text = [NSString stringWithFormat:@"%d", stats.wickets];
        label = (UILabel*)[self.view viewWithTag:33];
        label.text = [NSString stringWithFormat:@"%.2f", stats.average];
        label = (UILabel*)[self.view viewWithTag:34];
        label.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        label = (UILabel*)[self.view viewWithTag:35];
        label.text = [NSString stringWithFormat:@"%d-%d", stats.bestWickets, stats.bestRuns];
        label = (UILabel*)[self.view viewWithTag:36];
        label.text = [NSString stringWithFormat:@"%d", stats.fiveWickets];
    } else if ([[[notification userInfo] objectForKey:@"type"] isEqualToString:@"player"]) {
        Player *player = [[notification userInfo] objectForKey:@"player"];
        self.openingBowler.text = [player name];
        BowlingStatistics *stats = [player bowling];
        UILabel *label = (UILabel*)[self.view viewWithTag:30];
        label.text = [NSString stringWithFormat:@"%d.%d", stats.balls/6, stats.balls%6];
        label = (UILabel*)[self.view viewWithTag:31];
        label.text = [NSString stringWithFormat:@"%d", stats.runs];
        label = (UILabel*)[self.view viewWithTag:32];
        label.text = [NSString stringWithFormat:@"%d", stats.wickets];
        label = (UILabel*)[self.view viewWithTag:33];
        label.text = [NSString stringWithFormat:@"%.2f", stats.average];
        label = (UILabel*)[self.view viewWithTag:34];
        label.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        label = (UILabel*)[self.view viewWithTag:35];
        label.text = [NSString stringWithFormat:@"%d-%d", stats.bestWickets, stats.bestRuns];
        label = (UILabel*)[self.view viewWithTag:36];
        label.text = [NSString stringWithFormat:@"%d", stats.fiveWickets];
    } else {
        self.openingBowler.text = [[notification userInfo] objectForKey:@"name"];
    }
}

- (IBAction)startGame:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
    dataPath = [dataPath stringByAppendingPathComponent:@"players"];
    NSMutableArray *players = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", self.firstBatsman.text];
    NSArray *searchArray = [players filteredArrayUsingPredicate:predicate];
    Batsman *batsman = [[Batsman alloc] initWithPlayer:[searchArray objectAtIndex:0]];
    NSMutableArray *batsmen = [[NSMutableArray alloc] initWithObjects:batsman, nil];
    predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", self.secondBatsman.text];
    searchArray = [players filteredArrayUsingPredicate:predicate];
    batsman = [[Batsman alloc] initWithPlayer:[searchArray objectAtIndex:0]];
    [batsmen addObject:batsman];
    predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", self.openingBowler.text];
    searchArray = [players filteredArrayUsingPredicate:predicate];
    Bowler *bowler = [[Bowler alloc] initWithPlayer:[searchArray objectAtIndex:0]];
    NSMutableArray *bowlers = [[NSMutableArray alloc] initWithObjects:bowler, nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[batsmen, bowlers, [NSNumber numberWithInt:self.followOn]] forKeys:@[@"batsmen", @"bowlers", @"followOn"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initialiseInning" object:nil userInfo:dict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"b1"] ||
        [[segue identifier] isEqualToString:@"b2"] ||
        [[segue identifier] isEqualToString:@"b"]) {
        SelectPlayerViewController *vc = (SelectPlayerViewController*)[segue destinationViewController];
        vc.notificationName = [segue identifier];
        if ([self.game.innings count]>0) {
            Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
            int battingSide = !inning.battingSide;
            if (self.followOn) {
                battingSide = inning.battingSide;
            }
            
            if ([[segue identifier] isEqualToString:@"b1"] ||
                [[segue identifier] isEqualToString:@"b2"]) {
                if (battingSide == 0) {
                    vc.team = self.game.homeTeam;
                } else {
                    vc.team = self.game.awayTeam;
                }
            } else {
                if (battingSide == 0) {
                    vc.team = self.game.awayTeam;
                } else {
                    vc.team = self.game.homeTeam;
                }
            }
        }

        
    }
}

@end
