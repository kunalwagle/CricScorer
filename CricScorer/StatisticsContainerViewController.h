//
//  StatisticsContainerViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 24/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsContainerViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
