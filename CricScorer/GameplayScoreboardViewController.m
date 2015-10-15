//
//  GameplayScoreboardViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 07/08/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "GameplayScoreboardViewController.h"

@interface GameplayScoreboardViewController ()

@end

@implementation GameplayScoreboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGPScoreboard:) name:@"updateGPScoreboard" object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(void)updateGPScoreboard:(NSNotification*)notification {
    NSDictionary *dict = notification.userInfo;
    self.teamName.text = [dict objectForKey:@"teamName"];
    self.score.text = [NSString stringWithFormat:@"%d-%d", [[dict objectForKey:@"runs"] intValue], [[dict objectForKey:@"wickets"] intValue]];
    self.matchSituation.text = [dict objectForKey:@"matchSituation"];
    self.b1name.text = [dict objectForKey:@"b1name"];
    self.b2name.text = [dict objectForKey:@"b2name"];
    self.bname.text = [dict objectForKey:@"bname"];
    self.b1score.text = [NSString stringWithFormat:@"%d (%d)", [[dict objectForKey:@"b1score"] intValue], [[dict objectForKey:@"b1balls"] intValue]];
    self.b2score.text = [NSString stringWithFormat:@"%d (%d)", [[dict objectForKey:@"b2score"] intValue], [[dict objectForKey:@"b2balls"] intValue]];
    self.bscore.text = [NSString stringWithFormat:@"%d-%d (%d.%d)", [[dict objectForKey:@"bwickets"] intValue], [[dict objectForKey:@"bruns"] intValue], [[dict objectForKey:@"bovers"] intValue], [[dict objectForKey:@"bballs"] intValue]];
    self.overs.text = [NSString stringWithFormat:@"%d.%d", [[dict objectForKey:@"overs"] intValue], [[dict objectForKey:@"balls"] intValue]];
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

@end
