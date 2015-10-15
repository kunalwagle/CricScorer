//
//  StatisticsContainerViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 24/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "StatisticsContainerViewController.h"
#import "StatisticsTableViewController.h"

@interface StatisticsContainerViewController ()

@end

@implementation StatisticsContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsViewController"];
    self.pageViewController.dataSource = self;
    
    StatisticsTableViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 130);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((StatisticsTableViewController*) viewController).index;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    if (index == 0) {
        self.navigationItem.title = @"Statistics";
    } else {
        self.navigationItem.title = @"Statistics";
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index = ((StatisticsTableViewController*) viewController).index;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == 2) {
        return nil;
    }
    if (index == 0) {
        self.navigationItem.title = @"Statistics";
    } else {
        self.navigationItem.title = @"Statistics";
    }
    return [self viewControllerAtIndex:index];
}

- (StatisticsTableViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= 2) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    StatisticsTableViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsTableViewController"];
    pageContentViewController.index = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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
