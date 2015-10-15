//
//  StandardDeliveryViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 18/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "StandardDeliveryViewController.h"

@interface StandardDeliveryViewController ()

@end

@implementation StandardDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedView:) name:@"setUpStandardDelivery" object:nil];
    NSArray *items = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6"];
    self.numberOfRuns = [[StandardSegmentedControl alloc] initWithItems:items];
    self.numberOfRuns.frame = CGRectMake(29, 50, self.view.frame.size.width-70, self.numberOfRuns.frame.size.height);
    self.numberOfRuns.selectedSegmentIndex = 0;
    [self.numberOfRuns setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0],
                                                NSForegroundColorAttributeName:[UIColor blackColor]}
                                     forState:UIControlStateNormal];
    [self.numberOfRuns setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0],
                                                NSForegroundColorAttributeName:[UIColor blackColor]}
                                     forState:UIControlStateSelected];
    [self.view addSubview:self.numberOfRuns];
    items = @[@"Legal", @"No Ball", @"Wide"];
    self.typeOfDelivery = [[StandardSegmentedControl alloc] initWithItems:items];
    self.typeOfDelivery.frame = CGRectMake(29, 170, self.view.frame.size.width-330, self.typeOfDelivery.frame.size.height);
    self.typeOfDelivery.selectedSegmentIndex = 0;
    [self.typeOfDelivery setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0],
                                                NSForegroundColorAttributeName:[UIColor blackColor]}
                                     forState:UIControlStateNormal];
    [self.typeOfDelivery setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0],
                                                NSForegroundColorAttributeName:[UIColor blackColor]}
                                     forState:UIControlStateSelected];
    [self.view addSubview:self.typeOfDelivery];
    items = @[@"Bat", @"Leg Byes", @"Byes", @"Wides"];
    self.typeOfRun = [[StandardSegmentedControl alloc] initWithItems:items];
    self.typeOfRun.frame = CGRectMake(29, 290, self.view.frame.size.width-330, self.typeOfRun.frame.size.height);
    self.typeOfRun.selectedSegmentIndex = 0;
    [self.typeOfRun setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0],
                                                NSForegroundColorAttributeName:[UIColor blackColor]}
                                     forState:UIControlStateNormal];
    [self.typeOfRun setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0],
                                                NSForegroundColorAttributeName:[UIColor blackColor]}
                                     forState:UIControlStateSelected];
    [self.view addSubview:self.typeOfRun];
    items = @[@"Not Out", @"Out"];
    self.outOrNot = [[StandardSegmentedControl alloc] initWithItems:items];
    self.outOrNot.frame = CGRectMake(29, 410, self.view.frame.size.width-330, self.outOrNot.frame.size.height);
    self.outOrNot.selectedSegmentIndex = 0;
    [self.outOrNot setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0],
                                                 NSForegroundColorAttributeName:[UIColor blackColor]}
                                      forState:UIControlStateNormal];
     [self.outOrNot setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0],
                                                 NSForegroundColorAttributeName:[UIColor blackColor]}
                                      forState:UIControlStateSelected];
    [self.view addSubview:self.outOrNot];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadedView:(NSNotification*)info {
    self.numberOfRuns.selectedSegmentIndex = 0;
    self.typeOfDelivery.selectedSegmentIndex = 0;
    self.typeOfRun.selectedSegmentIndex = 0;
    self.outOrNot.selectedSegmentIndex = 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitDelivery:(id)sender {
    NSNumber *runs = [NSNumber numberWithInt:[self.numberOfRuns selectedSegmentIndex]];
    NSNumber *delivery = [NSNumber numberWithInt:[self.typeOfDelivery selectedSegmentIndex]];
    NSNumber *typeOfRuns = [NSNumber numberWithInt:[self.typeOfRun selectedSegmentIndex]];
    NSNumber *dismissed = [NSNumber numberWithInt:[self.outOrNot selectedSegmentIndex]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[runs, delivery, typeOfRuns, dismissed] forKeys:@[@"runs", @"delivery", @"typeOfRuns", @"dismissed"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pickedDelivery" object:nil userInfo:dict];
}

- (IBAction)declare:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[@"declare"] forKeys:@[@"declare"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pickedDelivery" object:nil userInfo:dict];
}

- (IBAction)endMatch:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[@"end"] forKeys:@[@"end"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pickedDelivery" object:nil userInfo:dict];
}

- (IBAction)exit:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[@"exit"] forKeys:@[@"exit"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pickedDelivery" object:nil userInfo:dict];
}

@end
