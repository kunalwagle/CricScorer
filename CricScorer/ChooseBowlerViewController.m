//
//  ChooseBowlerViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 19/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "ChooseBowlerViewController.h"
#import "Inning.h"
#import "SelectPlayerViewController.h"
#import "Player.h"
#import "BowlingStatistics.h"


@interface ChooseBowlerViewController ()

@end

@implementation ChooseBowlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpView:) name:@"loadChangeBowler" object:nil];
}

-(void)setUpView:(NSNotification*)notification {
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    
    inning.currentBowler = (inning.currentBowler+1)%2;
    if ([inning.currentBowlers count]>1) {
        self.current = [inning.currentBowlers objectAtIndex:inning.currentBowler];
        self.bowlerName.text = [[self.current player] name];
        BowlingStatistics *stats = [[self.current player] bowling];
        UILabel *label = (UILabel*)[self.view viewWithTag:10];
        label.text = [NSString stringWithFormat:@"%d.%d", stats.balls/6, stats.balls%6];
        label = (UILabel*)[self.view viewWithTag:11];
        label.text = [NSString stringWithFormat:@"%d", stats.runs];
        label = (UILabel*)[self.view viewWithTag:12];
        label.text = [NSString stringWithFormat:@"%d", stats.wickets];
        label = (UILabel*)[self.view viewWithTag:13];
        label.text = [NSString stringWithFormat:@"%.2f", stats.average];
        label = (UILabel*)[self.view viewWithTag:14];
        label.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
        label = (UILabel*)[self.view viewWithTag:15];
        label.text = [NSString stringWithFormat:@"%d-%d", stats.bestWickets, stats.bestRuns];
        label = (UILabel*)[self.view viewWithTag:16];
        label.text = [NSString stringWithFormat:@"%d", stats.fiveWickets];
        label = (UILabel*)[self.view viewWithTag:20];
        label.text = [NSString stringWithFormat:@"%d", self.current.overs];
        label = (UILabel*)[self.view viewWithTag:21];
        label.text = [NSString stringWithFormat:@"%d", self.current.maidens];
        label = (UILabel*)[self.view viewWithTag:22];
        label.text = [NSString stringWithFormat:@"%d", self.current.runs];
        label = (UILabel*)[self.view viewWithTag:23];
        label.text = [NSString stringWithFormat:@"%d", self.current.wickets];
        label = (UILabel*)[self.view viewWithTag:24];
        float economy = (self.current.runs/((float)(self.current.overs*6+self.current.balls)/6));
        label.text = [NSString stringWithFormat:@"%.2f", economy];
        //self.bowlerFigures.text = [NSString stringWithFormat:@"%d - %d - %d - %d", self.current.overs, self.current.maidens, self.current.runs, self.current.wickets];
    } else {
        self.bowlerName.text = @"Not selected";
        self.submit.enabled = NO;
        //self.bowlerFigures.text = @"";
    }
    self.newBowler = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"changeBowler"]) {
        SelectPlayerViewController *vc = (SelectPlayerViewController*)[segue destinationViewController];
        Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
        vc.bowlers = inning.bowlers;
        if (inning.battingSide == 0) {
            vc.team = self.game.awayTeam;
        } else {
            vc.team = self.game.homeTeam;
        }
        vc.notificationName = [segue identifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickedBowler:) name:@"changeBowler" object:nil];
    }
}

- (void)pickedBowler:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    self.submit.enabled = YES;
    if ([[info objectForKey:@"type"] isEqualToString:@"bowler"]) {
        self.current = [info objectForKey:@"bowler"];
        self.newBowler = NO;
    } else if ([[info objectForKey:@"type"] isEqualToString:@"data"]) {
        Player *player = [info objectForKey:@"player"];
        self.current = [[Bowler alloc] initWithPlayer:player];
        self.newBowler = YES;
    } else {
        Player *player = [info objectForKey:@"player"];
        self.current = [[Bowler alloc] initWithPlayer:player];
        self.newBowler = YES;
    }
    self.bowlerName.text = [[self.current player] name];
//    self.bowlerFigures.text = [NSString stringWithFormat:@"%d - %d - %d - %d", self.current.overs, self.current.maidens, self.current.runs, self.current.wickets];
    BowlingStatistics *stats = [[self.current player] bowling];
    UILabel *label = (UILabel*)[self.view viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%d.%d", stats.balls/6, stats.balls%6];
    label = (UILabel*)[self.view viewWithTag:11];
    label.text = [NSString stringWithFormat:@"%d", stats.runs];
    label = (UILabel*)[self.view viewWithTag:12];
    label.text = [NSString stringWithFormat:@"%d", stats.wickets];
    label = (UILabel*)[self.view viewWithTag:13];
    label.text = [NSString stringWithFormat:@"%.2f", stats.average];
    label = (UILabel*)[self.view viewWithTag:14];
    label.text = [NSString stringWithFormat:@"%.2f", stats.strikeRate];
    label = (UILabel*)[self.view viewWithTag:15];
    label.text = [NSString stringWithFormat:@"%d-%d", stats.bestWickets, stats.bestRuns];
    label = (UILabel*)[self.view viewWithTag:16];
    label.text = [NSString stringWithFormat:@"%d", self.current.overs];
    label = (UILabel*)[self.view viewWithTag:20];
    label.text = [NSString stringWithFormat:@"%d", self.current.maidens];
    label = (UILabel*)[self.view viewWithTag:21];
    label.text = [NSString stringWithFormat:@"%d", self.current.runs];
    label = (UILabel*)[self.view viewWithTag:22];
    label.text = [NSString stringWithFormat:@"%d", self.current.wickets];
    label = (UILabel*)[self.view viewWithTag:23];
    float economy = (self.current.runs/((float)(self.current.overs*6+self.current.balls)/6));
    label.text = [NSString stringWithFormat:@"%.2f", economy];
}


- (IBAction)changeBowler:(id)sender {
    [self performSegueWithIdentifier:@"changeBowler" sender:self];
}


- (IBAction)submit:(id)sender {
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"player.name ==[c] %@", self.bowlerName.text];
    NSArray *searchArray = [inning.bowlers filteredArrayUsingPredicate:predicate];
    if ([searchArray count]==0) {
        [[inning bowlers] addObject:self.current];
    }
    if ([[inning currentBowlers] count]>1) {
        [[inning currentBowlers] removeObjectAtIndex:[inning currentBowler]];
    }
    [[inning currentBowlers] insertObject:self.current atIndex:[inning currentBowler]];
    if (inning.battingSide == 0) {
        if (![self.game inAwayTeam:[self.current player]]) {
            [self.game.awayTeam addObject:[self.current player]];
        } else {
            self.current.player = [self.game getAwayPlayer:[self.current player]];
        }
    } else {
        if (![self.game inHomeTeam:[self.current player]]) {
            [self.game.homeTeam addObject:[self.current player]];
        }  else {
            self.current.player = [self.game getHomePlayer:[self.current player]];
        }
    }
    NSDictionary *info = [[NSDictionary alloc] initWithObjects:@[self.current] forKeys:@[@"bowler"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newBowlerSelected" object:nil userInfo:info];
}
@end
