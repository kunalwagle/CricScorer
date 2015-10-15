//
//  SelectPlayerViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 05/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "SelectPlayerViewController.h"
#import "Player.h"
#import "Bowler.h"
#import "BattingStatistics.h"
#import "BowlingStatistics.h"

@interface SelectPlayerViewController ()

@end

@implementation SelectPlayerViewController

NSMutableArray *players;
@synthesize tableSource;

NSMutableArray *tsbowl;
NSMutableArray *tsteam;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
    dataPath = [dataPath stringByAppendingPathComponent:@"players"];
    players = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    tableSource = players;
    tsbowl = self.bowlers;
    tsteam = self.team;
    self.selected = 0;
    [self.textField addTarget:self
                       action:@selector(textChanged:)
            forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    if ([self.notificationName isEqualToString:@"changeBowler"] && [tsbowl count]>0) {
        self.segmentedControl.selectedSegmentIndex=0;
    } else {
        [self.segmentedControl removeSegmentAtIndex:0 animated:YES];
        self.segmentedControl.selectedSegmentIndex = 0;
        if ([tsteam count]==0) {
            self.segmentedControl.selectedSegmentIndex = 1;
        }
    };
    self.selected = self.segmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (IBAction)textChanged:(id)sender {
    if ([self.textField.text isEqualToString:@""]) {
        tableSource = players;
        tsbowl = self.bowlers;
        tsteam = self.team;
        [self.tableView reloadData];
    } else {
        [self searchText:self.textField.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([self.notificationName isEqualToString:@"changeBowler"]) {
//        return 3;
//    }
//    return 2;
    return 1;
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            if ([self.notificationName isEqualToString:@"changeBowler"]) {
//                return @"Bowlers Used";
//            } else {
//                return @"Current Team";
//            }
//            break;
//        case 1:
//            if ([self.notificationName isEqualToString:@"changeBowler"]) {
//                return @"Current Team";
//            } else {
//                return @"Player Database";
//            }
//            break;
//        default:
//            return @"Player Database";
//            break;
//    }
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.selected) {
        case 0:
            if ([self.notificationName isEqualToString:@"changeBowler"]) {
                return [tsbowl count];
            } else {
                return [tsteam count];
            }
        case 1:
            if ([self.notificationName isEqualToString:@"changeBowler"]) {
                return [tsteam count];
            } else {
                return [tableSource count];
            }
        default:
            return [tableSource count];
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (self.selected) {
        case 0:
            if ([self.notificationName isEqualToString:@"changeBowler"]) {
                Player *player = [[tsbowl objectAtIndex:[indexPath row]] player];
                cell.textLabel.text = [player name];
            } else {
                Player *player = [tsteam objectAtIndex:[indexPath row]];
                cell.textLabel.text = [player name];
            }
            break;
        case 1:
            if ([self.notificationName isEqualToString:@"changeBowler"]) {
                Player *player = [tsteam objectAtIndex:[indexPath row]];
                cell.textLabel.text = [player name];
            } else {
                Player *player = [tableSource objectAtIndex:[indexPath row]];
                cell.textLabel.text = [player name];
            }
            break;
        default: {
            Player *player = [tableSource objectAtIndex:[indexPath row]];
            cell.textLabel.text = [player name];
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selected == 0 && [self.notificationName isEqualToString:@"changeBowler"]) {
        NSData *bowler = [tsbowl objectAtIndex:[indexPath row]];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[bowler, @"bowler"] forKeys:@[@"bowler", @"type"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil userInfo:dict]
        ;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ((self.selected == 1 && [self.notificationName isEqualToString:@"changeBowler"]) || self.selected==0) {
        NSData *player = [tsteam objectAtIndex:[indexPath row]];
        
        NSDictionary *dict;
        if (self.selected==1) {
            dict = [[NSDictionary alloc] initWithObjects:@[player, @"data"] forKeys:@[@"player", @"type"]];
        } else {
            dict = [[NSDictionary alloc] initWithObjects:@[player, @"player"] forKeys:@[@"player", @"type"]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil userInfo:dict]
        ;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSString *name = [[[tableView cellForRowAtIndexPath:indexPath ] textLabel] text];
        self.textField.text = name;
    }
}



-(void)searchText:(NSString*)searchString {
    if ([searchString isEqualToString:@""]) {
        tableSource = players;
        tsbowl = self.bowlers;
        tsteam = self.team;
    } else {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchString];
    tableSource = [players filteredArrayUsingPredicate:predicate];
    //tsbowl = [self.bowlers filteredArrayUsingPredicate:predicate];
    tsteam = [self.team filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Text Field Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    tableSource = players;
    tsbowl = self.bowlers;
    tsteam = self.team;
    [self.tableView reloadData];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    tableSource = players;
    tsbowl = self.bowlers;
    tsteam = self.team;
    [self.tableView reloadData];
    return YES;
}

- (IBAction)submit:(id)sender {
    Player *player;
    if (![self.textField.text isEqualToString:@""]) {

    if (players != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", self.textField.text];
        tableSource = [players filteredArrayUsingPredicate:predicate];
        if ([tableSource count]==0) {
            player = [[Player alloc] init];
            player.batting = [[BattingStats alloc] init];
            player.bowling = [[BowlingStatistics alloc] init];
            player.name = self.textField.text;
            [players addObject:player];
        } else {
            player = [[players filteredArrayUsingPredicate:predicate] objectAtIndex:0];
        }
    } else {
        player = [[Player alloc] init];
        player.batting = [[BattingStats alloc] init];
        player.bowling = [[BowlingStatistics alloc] init];
        player.name = self.textField.text;
        players = [[NSMutableArray alloc] initWithObjects:player, nil];
    }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
        dataPath = [dataPath stringByAppendingPathComponent:@"players"];
        BOOL success = [NSKeyedArchiver archiveRootObject:players toFile:dataPath];
        if (success) {
            NSLog(@"Success");
        } else {
            NSLog(@"Unsuccessful");
        }
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[self.textField.text] forKeys:@[@"name"]];
    //if ([self.notificationName isEqualToString:@"changeBowler"]) {
        dict = [[NSDictionary alloc] initWithObjects:@[player, @"player"] forKeys:@[@"player", @"type"]];
    //}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeSection:(id)sender {
    self.selected = self.segmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

@end
