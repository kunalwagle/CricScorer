//
//  FirstNewGamePageSheetViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 28/06/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "FirstNewGamePageSheetViewController.h"
#import "SecondNewGamePageSheetViewController.h"

@interface FirstNewGamePageSheetViewController ()

@end

@implementation FirstNewGamePageSheetViewController

NSMutableArray *teams;
NSMutableArray *grounds;
NSMutableArray *fixtureTypes;
NSMutableArray *tableSource;
int textFieldSelected;
BOOL editing;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
    NSString *path = [dataPath stringByAppendingPathComponent:@"teams"];
    teams = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    path = [dataPath stringByAppendingPathComponent:@"grounds"];
    grounds = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    path = [dataPath stringByAppendingPathComponent:@"fixtureTypes"];
    fixtureTypes = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    tableSource = [[NSMutableArray alloc] initWithObjects: nil];
    self.homeTeam.delegate = self;
    self.awayTeam.delegate = self;
    self.fixtureType.delegate = self;
    self.ground.delegate = self;
    [self.homeTeam addTarget:self
                    action:@selector(homeChanged:)
          forControlEvents:UIControlEventEditingChanged];
    [self.awayTeam addTarget:self
                      action:@selector(awayChanged:)
            forControlEvents:UIControlEventEditingChanged];
    [self.fixtureType addTarget:self
                         action:@selector(fixtureChanged:)
            forControlEvents:UIControlEventEditingChanged];
    [self.ground addTarget:self
                      action:@selector(groundChanged:)
            forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view.
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

#pragma Text Field Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch ([textField tag]) {
        case 11:
        case 12:
            tableSource = teams;
            break;
        case 13:
            tableSource = fixtureTypes;
            break;
        default:
            tableSource = grounds;
            break;
    }
    textFieldSelected = [textField tag];
    self.tableView.hidden = NO;
    self.explanationLabel.hidden = YES;
    editing = YES;
    [self.tableView reloadData];
    return YES;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!editing) {
        self.tableView.hidden = YES;
        self.explanationLabel.hidden = NO;
    }
    [textField resignFirstResponder];
    editing = NO;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (!editing) {
        self.tableView.hidden = YES;
        self.explanationLabel.hidden = NO;
    }
    [textField resignFirstResponder];
    editing = NO;
    return YES;
}

#pragma Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [tableSource objectAtIndex:[indexPath row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITextField *textField = (UITextField*)[self.view viewWithTag:textFieldSelected];
    textField.text = [tableSource objectAtIndex:[indexPath row]];
    self.tableView.hidden = YES;
    self.explanationLabel.hidden = NO;
    [textField resignFirstResponder];
}

- (IBAction)next:(id)sender {
    BOOL allFilled = YES;
    for (int i=11; i<15; i++) {
        UITextField *textField = (UITextField*)[self.view viewWithTag:i];
        if ([textField.text isEqualToString:@""]) {
            allFilled = NO;
            break;
        }
    }
    if (!allFilled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not all text fields filled" message:@"Please make sure all text fields are filled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } else {
        [self performSegueWithIdentifier:@"nextScreen" sender:self];
    }
}

- (IBAction)limitedSelected:(id)sender {
    if ([self.limitedBoolean selectedSegmentIndex]==1) {
        [self.overCounter setHidden:YES];
        [self.overLabel setHidden:YES];
        [self.overText setHidden:YES];
    } else {
        [self.overCounter setHidden:NO];
        [self.overLabel setHidden:NO];
        [self.overText setHidden:NO];
    }
}

-(void)searchText:(NSString*)searchString array:(NSMutableArray*)array {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchString];
    tableSource = [[array filteredArrayUsingPredicate:predicate] mutableCopy];
    [self.tableView reloadData];
}

- (IBAction)overCounterChanged:(id)sender {
    self.overText.text = [NSString stringWithFormat:@"%d", (int)self.overCounter.value];
}

- (IBAction)homeChanged:(id)sender {
    if ([self.homeTeam.text isEqualToString:@""]) {
        tableSource = teams;
        [self.tableView reloadData];
    } else {
        [self searchText:self.homeTeam.text array:teams];
    }
}

- (IBAction)fixtureChanged:(id)sender {
    if ([self.fixtureType.text isEqualToString:@""]) {
        tableSource = fixtureTypes;
        [self.tableView reloadData];
    } else {
        [self searchText:self.fixtureType.text array:fixtureTypes];
    }
}

- (IBAction)awayChanged:(id)sender {
    if ([self.awayTeam.text isEqualToString:@""]) {
        tableSource = teams;
        [self.tableView reloadData];
    } else {
        [self searchText:self.awayTeam.text array:teams];
    }
}

- (IBAction)groundChanged:(id)sender {
    if ([self.ground.text isEqualToString:@""]) {
        tableSource = grounds;
        [self.tableView reloadData];
    } else {
        [self searchText:self.ground.text array:grounds];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"nextScreen"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.homeTeam.text forKey:@"homeTeam"];
        [dict setObject:self.awayTeam.text forKey:@"awayTeam"];
        [dict setObject:self.fixtureType.text forKey:@"fixtureType"];
        [dict setObject:self.ground.text forKey:@"ground"];
        [dict setObject:[NSNumber numberWithLong:[self.inningsCount selectedSegmentIndex]+1] forKey:@"inningsCount"];
        [dict setObject:[NSNumber numberWithLong:[self.limitedBoolean selectedSegmentIndex]] forKey:@"declaration"];
        if (self.limitedBoolean.selectedSegmentIndex == 0) {
            [dict setObject:[NSNumber numberWithDouble:self.overCounter.value] forKey:@"overCount"];
        }
        SecondNewGamePageSheetViewController *vc = (SecondNewGamePageSheetViewController*)[segue destinationViewController];
        vc.info = dict;
        if (![self inArray:self.homeTeam.text array:teams]) {
            if (!teams) {
                teams = [[NSMutableArray alloc] initWithObjects: nil];
            }
            [teams addObject:self.homeTeam.text];
        }
        if (![self inArray:self.awayTeam.text array:teams]) {
            if (!teams) {
                teams = [[NSMutableArray alloc] initWithObjects: nil];
            }
            [teams addObject:self.awayTeam.text];
        }
        if (![self inArray:self.ground.text array:grounds]) {
            if (!grounds) {
                grounds = [[NSMutableArray alloc] initWithObjects: nil];
            }
            [grounds addObject:self.ground.text];
        }
        if (![self inArray:self.fixtureType.text array:fixtureTypes]) {
            if (!fixtureTypes) {
                fixtureTypes = [[NSMutableArray alloc] initWithObjects: nil];
            }
            [fixtureTypes addObject:self.fixtureType.text];
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Database/"];
        NSString *path = [dataPath stringByAppendingPathComponent:@"teams"];
        [NSKeyedArchiver archiveRootObject:teams toFile:path];
        path = [dataPath stringByAppendingPathComponent:@"grounds"];
        [NSKeyedArchiver archiveRootObject:grounds toFile:path];
        path = [dataPath stringByAppendingPathComponent:@"fixtureTypes"];
        [NSKeyedArchiver archiveRootObject:fixtureTypes toFile:path];
    }
}

-(BOOL)inArray:(NSString*)string array:(NSMutableArray*)array {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self ==[c] %@", string];
    NSArray *searchArray = [array filteredArrayUsingPredicate:predicate];
    return [searchArray count]>0;
}

@end
