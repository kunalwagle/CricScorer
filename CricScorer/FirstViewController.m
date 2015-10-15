//
//  FirstViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 22/06/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "FirstViewController.h"
#import "Game.h"
#import "GamePlayViewController.h"

@interface FirstViewController ()

//@property (nonatomic, strong) UIPopoverController *itemSelectionPopover;

@end

@implementation FirstViewController

Game *game;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNewGame:) name:@"createNewGame" object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)createNewGame:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    game = [[Game alloc] initWithDict:notification.userInfo];
    [self performSegueWithIdentifier:@"createNewGame" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"createNewGame"]) {
        GamePlayViewController *vc = (GamePlayViewController*)[segue destinationViewController];
        vc.game = game;
        vc.initialise = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
