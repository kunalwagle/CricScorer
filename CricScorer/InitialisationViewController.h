//
//  InitialisationViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 05/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface InitialisationViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstBatsman;
@property (weak, nonatomic) IBOutlet UILabel *secondBatsman;
@property (weak, nonatomic) IBOutlet UILabel *openingBowler;
@property Game *game;
@property BOOL followOn;
- (IBAction)chooseb1:(id)sender;
- (IBAction)chooseb2:(id)sender;
- (IBAction)chooseb:(id)sender;
- (IBAction)startGame:(id)sender;

@end
