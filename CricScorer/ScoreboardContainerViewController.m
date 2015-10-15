//
//  ScoreboardContainerViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 22/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "ScoreboardContainerViewController.h"
#import "ScoreboardTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ScoreboardContainerViewController ()

@end

@implementation ScoreboardContainerViewController

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNewGame:) name:@"receivedNewGame" object:nil];
    self.generatePDF.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedNewGame:(NSNotification*)notification {
    self.game = [[notification userInfo] objectForKey:@"game"];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.generatePDF.enabled = YES;
    if (self.game.complete) {
        self.matchSituation.text = [self.game computeResult];
    } else {
        self.matchSituation.text = [self.game matchStatus];
    }
    self.navigationItem.title = [self.game title];
    ScoreboardTableViewController *startingViewController = [self viewControllerAtIndex:0];
    startingViewController.index = -1;
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 130);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ScoreboardTableViewController*) viewController).index;
    
    if ((index == 0) || (index == NSNotFound)) {
        if (index == 0) {
            ScoreboardTableViewController *vc = [self viewControllerAtIndex:0];
            vc.index = -1;
            return vc;
        }
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index = ((ScoreboardTableViewController*) viewController).index;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.game.innings count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (ScoreboardTableViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.game.innings count] == 0) || (index >= [self.game.innings count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ScoreboardTableViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreboardTableViewController"];
    pageContentViewController.game = self.game;
    pageContentViewController.index = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.game.innings count]+1;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"test"]) {
        ScoreboardTableViewController *vc = [self viewControllerAtIndex:0];
        vc.index = -1;
        [vc viewDidLoad];
        [vc viewDidAppear:YES];
        UIView *view = [vc view];
        NSMutableArray *views = [[NSMutableArray alloc] initWithObjects:view, nil];
        for (int i=0; i<[[[self game] innings] count]; i++) {
            ScoreboardTableViewController *vc = [self viewControllerAtIndex:i];
            [vc viewDidLoad];
            [vc viewDidAppear:YES];
            UIView *view = [vc view];
            [views addObject:view];
        }
         [self createPDFfromUIView:views saveToDocumentsWithFileName:@"Test.pdf"];
    }
}

-(void)createPDFfromUIView:(NSMutableArray*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    NSInteger pageHeight = 792;
    NSInteger pageWidth = 612;
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    CGRect pdfPageBounds = CGRectMake(-30, 50, 1122, 792);
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    for (UIView *tableView in aView) {
//        UIGraphicsBeginPDFPageWithInfo(view.bounds, nil);
//        CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//        
//        
//        // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
//        
//        [view.layer renderInContext:pdfContext];
        NSLog(@"%f", tableView.bounds.size.height);
        NSLog(@"%f", pdfPageBounds.size.height);
        CGRect priorBounds = tableView.bounds;
        CGSize fittedSize = [tableView sizeThatFits:CGSizeMake(priorBounds.size.width, HUGE_VALF)];
        tableView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
        for (CGFloat pageOriginY = 0; pageOriginY < fittedSize.height; pageOriginY += pdfPageBounds.size.height) {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
            CGContextSaveGState(UIGraphicsGetCurrentContext()); {
                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY);
                [tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
            } CGContextRestoreGState(UIGraphicsGetCurrentContext());
        }
        tableView.bounds = priorBounds;
    }

    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
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
