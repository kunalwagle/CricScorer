//
//  GamePlayViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "GamePlayViewController.h"
#import "Inning.h"
#import "Batsman.h"
#import "Bowler.h"
#import "ChooseBowlerViewController.h"
#import "DismissalViewController.h"
#import "InitialisationViewController.h"
#import "Player.h"
#import "Dismissal.h"
#import "BattingStatistics.h"
#import "BowlingStatistics.h"

@interface GamePlayViewController ()

@end

@implementation GamePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.initialise) {
        self.initialiseInnings.hidden = NO;
        self.chooseBowler.hidden = YES;
        self.wicketTaken.hidden = YES;
        self.standardDelivery.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialisedGame:) name:@"initialiseInning" object:nil];
    } else {
        [self updateScoreboard];
        self.initialiseInnings.hidden = YES;
        self.chooseBowler.hidden = YES;
        self.wicketTaken.hidden = YES;
        self.standardDelivery.hidden = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickedDelivery:) name:@"pickedDelivery" object:nil];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialisedGame:(NSNotification*)notification {
    NSDictionary *newInnings = notification.userInfo;
    Inning *innings = [[Inning alloc] initWithDict:newInnings];
    [self.game.innings addObject:innings];
    self.game.currentInning = [self.game.innings count]-1;
    if (self.game.currentInning % 2 == 0) {
        innings.battingSide = !self.game.homeBatFirst;
    } else {
        innings.battingSide = self.game.homeBatFirst;
    }
    self.initialiseInnings.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setUpStandardDelivery" object:nil userInfo:nil];
    self.standardDelivery.hidden = NO;
    self.b1Name.text = [[[[newInnings objectForKey:@"batsmen"] objectAtIndex:0
                        ] player] name];
    self.b2Name.text = [[[[newInnings objectForKey:@"batsmen"] objectAtIndex:1
                         ] player] name];
    self.bowlerName.text = [[[[newInnings objectForKey:@"bowlers"] objectAtIndex:0
                        ] player] name];
    if (innings.battingSide == 0) {
        [self.game.homeTeam addObjectsFromArray:@[[[[newInnings objectForKey:@"batsmen"] objectAtIndex:0
                                                   ] player], [[[newInnings objectForKey:@"batsmen"] objectAtIndex:1
                                                                ] player]]];
        [self.game.awayTeam addObject:[[[newInnings objectForKey:@"bowlers"] objectAtIndex:0
                                        ] player]];
    } else {
        [self.game.awayTeam addObjectsFromArray:@[[[[newInnings objectForKey:@"batsmen"] objectAtIndex:0
                                                    ] player], [[[newInnings objectForKey:@"batsmen"] objectAtIndex:1
                                                                 ] player]]];
        [self.game.homeTeam addObject:[[[newInnings objectForKey:@"bowlers"] objectAtIndex:0
                                        ] player]];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickedDelivery:) name:@"pickedDelivery" object:nil];
    [self updateScoreboard];
}

- (void)initialisedInnings:(NSNotification*)notification {
    NSDictionary *newInnings = notification.userInfo;
    Inning *innings = [[Inning alloc] initWithDict:newInnings];
    [self.game.innings addObject:innings];
    self.game.currentInning = [self.game.innings count]-1;
    Inning *prev = [self.game.innings objectAtIndex:self.game.currentInning-1];
//    if (self.game.currentInning % 2 == 0) {
//        innings.battingSide = !self.game.homeBatFirst;
//    } else {
//        innings.battingSide = self.game.homeBatFirst;
//    }
    innings.battingSide = !prev.battingSide;
    int lead = prev.lead;
    if ([[newInnings objectForKey:@"followOn"] intValue]) {
        innings.battingSide = !innings.battingSide;
        innings.lead = lead;
    } else {
        innings.lead = 0-lead;
    }
    if (innings.lead<0) {
        self.leadName.text = @"Trail by";
        if (self.game.currentInning+1 == self.game.inningsCount*2) {
            self.leadName.text = @"To win";
        }
    } else {
        self.leadName.text = @"Lead";
    }
    self.initialiseInnings.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setUpStandardDelivery" object:nil userInfo:nil];
    self.standardDelivery.hidden = NO;
    self.b1Name.text = [[[[newInnings objectForKey:@"batsmen"] objectAtIndex:0
                          ] player] name];
    self.b2Name.text = [[[[newInnings objectForKey:@"batsmen"] objectAtIndex:1
                          ] player] name];
    self.bowlerName.text = [[[[newInnings objectForKey:@"bowlers"] objectAtIndex:0
                              ] player] name];
    
    //START HERE. YOU NEED TO CHECK IF BATSMEN ALREADY IN TEAM
    Batsman *batsman = [[newInnings objectForKey:@"batsmen"] objectAtIndex:0];
    if (innings.battingSide == 1) {
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
    batsman = [[newInnings objectForKey:@"batsmen"] objectAtIndex:1];
    if (innings.battingSide == 1) {
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
    [self updateScoreboard];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickedDelivery:) name:@"pickedDelivery" object:nil];
}

- (void)pickedDelivery:(NSNotification*)notification {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Games"];
    dataPath = [dataPath stringByAppendingPathComponent:[self.game title]];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.game toFile:dataPath];
    if (success) {
        NSLog(@"Success");
    }
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    NSDictionary *details = notification.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setUpStandardDelivery" object:nil userInfo:nil];
    if ([[details objectForKey:@"declare"] isEqualToString:@"declare"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Clicking yes will end the inning. This action can't be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Declare", nil];
        alert.tag = 222;
        [alert show];
    } else if ([[details objectForKey:@"end"] isEqualToString:@"end"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Clicking yes will end the match. This action can't be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End match as a draw", nil];
        alert.tag = 333;
        [alert show];
    } else if ([details objectForKey:@"exit"]) {
        [self performSegueWithIdentifier:@"returnHome" sender:self];
    } else {
    [inning updateScores:details];
    [self updateScoreboard];
    //Add wicket fallen stuff here
    if ([[details objectForKey:@"dismissed"] intValue] == 1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wicketConfigured:) name:@"wicketConfigured" object:nil];
        self.standardDelivery.hidden = YES;
        self.wicketTaken.hidden = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadWicket" object:nil userInfo:nil];
    } else if ([inning balls]==0 && [[details objectForKey:@"delivery"] intValue] == 0) {
        if ([inning overs]!=self.game.overs) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBowlerSelected:) name:@"newBowlerSelected" object:nil];
            self.standardDelivery.hidden = YES;
            self.chooseBowler.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadChangeBowler" object:nil userInfo:nil];
        } else {
            [self tryNewInning];
        }

    }
    }
}

-(void)updateStats {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
    dataPath = [dataPath stringByAppendingPathComponent:@"players"];
    NSMutableArray *players = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    for (Inning *inning in self.game.innings) {
        for (Batsman *batsman in [inning batsmen]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", batsman.player.name];
            NSArray *tableSource = [players filteredArrayUsingPredicate:predicate];
            BattingStats *batting = [[tableSource objectAtIndex:0] batting];
            [batting updateBattingStats:batsman];
        }
        for (Bowler *bowler in [inning bowlers]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", bowler.player.name];
            NSArray *tableSource = [players filteredArrayUsingPredicate:predicate];
            BowlingStatistics *bowling = [[tableSource objectAtIndex:0] bowling];
            [bowling updateBowlingStats:bowler];
        }
    }
    BOOL success = [NSKeyedArchiver archiveRootObject:players toFile:dataPath];
}

-(void)gameOver {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[self.game computeResult] delegate:self cancelButtonTitle:@"Save and Exit" otherButtonTitles: nil];
    alert.tag = 555;
    [alert show];
}



-(void)tryNewInning {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Games"];
    dataPath = [dataPath stringByAppendingPathComponent:[self.game title]];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.game toFile:dataPath];
    if (success) {
        NSLog(@"Success");
    }
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    inning.complete = YES;
    if (self.game.currentInning+1!=self.game.inningsCount*2) {
        if (self.game.currentInning+1!=self.game.inningsCount*2-1) {
            self.initialiseInnings.hidden = NO;
            self.chooseBowler.hidden = YES;
            self.wicketTaken.hidden = YES;
            self.standardDelivery.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initialiseInn" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialisedInnings:) name:@"initialiseInning" object:nil];
        } else {
            Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
            if (inning.lead < 0) {
                [self gameOver];
            } else {
                self.initialiseInnings.hidden = NO;
                self.chooseBowler.hidden = YES;
                self.wicketTaken.hidden = YES;
                self.standardDelivery.hidden = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"initialiseInn" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialisedInnings:) name:@"initialiseInning" object:nil];
            }
        }
    } else {
        [self gameOver];
    }

}

-(void)wicketConfigured:(NSNotification*)notification {
    NSDictionary *dictionary = notification.userInfo;
    int manOut = [[dictionary objectForKey:@"whoOut"] intValue];
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    Batsman *batOut = [inning.currentBatsmen objectAtIndex:manOut];
    Bowler *currentBowler = [inning.currentBowlers objectAtIndex:inning.currentBowler];
    batOut.dismissal.bowler = currentBowler;
    batOut.dismissal.fow = inning.total;
    BOOL needStrike = NO;
    switch ([[dictionary objectForKey:@"howOut"] intValue]) {
        case 0:
            batOut.dismissal.howOut = @"Bowled";
            currentBowler.wickets++;
            break;
        case 1:
            batOut.dismissal.howOut = @"Hit Wicket";
            currentBowler.wickets++;
            break;
        case 2:
            batOut.dismissal.howOut = @"LBW";
            currentBowler.wickets++;
            break;
        case 3:
            batOut.dismissal.howOut = @"Caught";
            needStrike = YES;
            currentBowler.wickets++;
            break;
        case 4:
            batOut.dismissal.howOut = @"Timed Out";
            break;
        case 5:
            batOut.dismissal.howOut = @"Stumped";
            currentBowler.wickets++;
            break;
        case 6:
            batOut.dismissal.howOut = @"Run Out";
            needStrike = YES;
            break;
        case 7:
            batOut.dismissal.howOut = @"Handled the Ball";
            currentBowler.wickets++;
            break;
        case 8:
            batOut.dismissal.howOut = @"Retired";
            break;
        case 9:
            batOut.dismissal.howOut = @"Obstructing the Field";
            needStrike = YES;
            break;
        default:
            break;
    }
    if ([dictionary count]==4) {
        batOut.dismissal.fielder = [dictionary objectForKey:@"fielder"];
    }
    inning.wickets++;
    if (inning.wickets!=10) {
        [inning.currentBatsmen removeObjectAtIndex:manOut];
        [inning.currentBatsmen insertObject:[dictionary objectForKey:@"newBatsman"] atIndex:manOut];
        [inning.batsmen addObject:[dictionary objectForKey:@"newBatsman"]];
        UIAlertView *decideStrike = [[UIAlertView alloc] initWithTitle:@"Who's on strike" message:@"Select the batsman who is facing the next ball" delegate:self cancelButtonTitle:nil otherButtonTitles:[[[inning.currentBatsmen objectAtIndex:0] player] name], [[[inning.currentBatsmen objectAtIndex:1] player] name], nil];
        decideStrike.tag = 999;
        if (needStrike) {
            [decideStrike show];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setUpStandardDelivery" object:nil userInfo:nil];
        self.standardDelivery.hidden = NO;
        self.wicketTaken.hidden = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickedDelivery:) name:@"pickedDelivery" object:nil];
        if ([inning balls]==0) {
            if ([inning overs]!=self.game.overs) {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBowlerSelected:) name:@"newBowlerSelected" object:nil];
                self.standardDelivery.hidden = YES;
                self.chooseBowler.hidden = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadChangeBowler" object:nil userInfo:nil];
            } else {
                [self tryNewInning];
            }
        }
    } else {
        [self tryNewInning];
    }
    [self updateScoreboard];
}

-(void)updateScoreboard {
    Inning *inning = [self.game.innings objectAtIndex:self.game.currentInning];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (inning.battingSide == 0) {
        [dict setObject:self.game.homeName forKey:@"teamName"];
    } else {
        [dict setObject:self.game.awayName forKey:@"teamName"];
    }
    [dict setObject:[NSNumber numberWithInt:inning.total] forKey:@"runs"];
    Batsman *b1 =[inning.currentBatsmen objectAtIndex:0];
    Batsman *b2 = [inning.currentBatsmen objectAtIndex:1];
    if (inning.currentBowler<[inning.currentBowlers count]) {
        Bowler *b = [inning.currentBowlers objectAtIndex:inning.currentBowler];
        [dict setObject:[NSNumber numberWithInt:b.wickets] forKey:@"bwickets"];
        [dict setObject:[NSNumber numberWithInt:b.runs] forKey:@"bruns"];
        [dict setObject:[NSNumber numberWithInt:b.overs] forKey:@"bovers"];
        [dict setObject:[NSNumber numberWithInt:b.balls] forKey:@"bballs"];
        [dict setObject:b.player.name forKey:@"bname"];
        //self.bowler.text = [NSString stringWithFormat:@"%d-%d", b.wickets, b.runs];
        //self.bowlerName.text = b.player.name;
    }
    [dict setObject:[NSNumber numberWithInt:b1.score] forKey:@"b1score"];
    [dict setObject:[NSNumber numberWithInt:b2.score] forKey:@"b2score"];
    [dict setObject:[NSNumber numberWithInt:b1.balls] forKey:@"b1balls"];
    [dict setObject:[NSNumber numberWithInt:b2.balls] forKey:@"b2balls"];
    [dict setObject:[NSNumber numberWithInt:inning.wickets] forKey:@"wickets"];
//    self.b1.text = [NSString stringWithFormat:@"%d", b1.score];
//    self.b2.text = [NSString stringWithFormat:@"%d", b2.score];
//    self.wickets.text = [NSString stringWithFormat:@"%d", inning.wickets];
//    if (self.game.currentInning == self.game.inningsCount*2-1) {
//        self.leadName.text = @"To win";
//    }
//    self.lead.text = [NSString stringWithFormat:@"%d", abs(inning.lead)];
    [dict setObject:[NSNumber numberWithInt:inning.overs] forKey:@"overs"];
    [dict setObject:[NSNumber numberWithInt:inning.balls] forKey:@"balls"];
    //self.overs.text = [NSString stringWithFormat:@"%d.%d", inning.overs, inning.balls];
    [dict setObject:b1.player.name forKey:@"b1name"];
    [dict setObject:b2.player.name forKey:@"b2name"];
//    self.b1Name.text = b1.player.name;
//    self.b2Name.text = b2.player.name;
//    if ([self.leadName.text isEqualToString:@"To win"]) {
//        self.lead.text = [NSString stringWithFormat:@"%d", abs(inning.lead)+1];
//    }
    if (self.game.currentInning == self.game.inningsCount*2-1 && inning.lead>0) {
       // [self.leadName.text isEqualToString:@"Lead"];
        inning.complete = YES;
        [self gameOver];
    }
//    } else if (inning.lead > 0) {
//        self.leadName.text = @"Lead";
//    }
    [dict setObject:[self.game matchStatus]  forKey:@"matchSituation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGPScoreboard" object:nil userInfo:dict];
}

-(void)newBowlerSelected:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickedDelivery:) name:@"pickedDelivery" object:nil];
    [self updateScoreboard];
    //NSDictionary *dict = notification.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setUpStandardDelivery" object:nil userInfo:nil];
    self.chooseBowler.hidden = YES;
    self.standardDelivery.hidden = NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 999) {
        Inning *inn = [[self.game innings] objectAtIndex:self.game.currentInning];
        inn.onStrike = buttonIndex;
    } else if ([alertView tag] == 555) {
        [self updateStats];
        self.game.complete = YES;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Games"];
        dataPath = [dataPath stringByAppendingPathComponent:[self.game title]];
        BOOL success = [NSKeyedArchiver archiveRootObject:self.game toFile:dataPath];
        if (success) {
            NSLog(@"Success");
        }
        [self performSegueWithIdentifier:@"returnHome" sender:self];
    } else if ([alertView tag] == 222) {
        if  (buttonIndex == 1) {
            [self tryNewInning];
        }
    } else if ([alertView tag] == 333) {
        if  (buttonIndex == 1) {
            [self gameOver];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"changeBowler"]) {
        ChooseBowlerViewController *vc = (ChooseBowlerViewController*)[segue destinationViewController];
        vc.game = self.game;
    } else if ([[segue identifier] isEqualToString:@"wicket"])
    {
        DismissalViewController *vc = (DismissalViewController*)[segue destinationViewController];
        vc.game = self.game;
    } else if ([[segue identifier] isEqualToString:@"initialise"]) {
        InitialisationViewController *vc = (InitialisationViewController*)[segue destinationViewController];
        vc.game = self.game;
    }
}


@end
