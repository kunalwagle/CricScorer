//
//  ScoreboardContainerViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 22/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ScoreboardContainerViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property Game *game;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *generatePDF;
@property (weak, nonatomic) IBOutlet UILabel *matchSituation;

@end
