//
//  ReportBugView.m
//  Calendario
//
//  Created by Daniel Sadjadian on 19/02/2015.
//
//

#import "ReportBugView.h"

@interface ReportBugView () {
    
    NSArray *bugItems;
    UITextView *bugLevel;
    UITextView *bugDesc;
}

@end

@implementation ReportBugView

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the tableview delegate and source.
    self.reportBugTableView.delegate = self;
    self.reportBugTableView.dataSource = self;
    
    bugItems = [[NSArray alloc] initWithObjects:@"Bug Level", @"Description", nil];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Report bug method

-(void)submitBugReport {
    
    // Submit the bug report to the server, this feature
    // cant be completed yet because the report bug PHP
    // script has not been made and stored on the server.
    
    NSLog(@"\n\n");
    NSLog(@"THIS IS A TEST:\n");
    NSLog(@"\n As the PHP script for the Report Bug has not been made, we will not be submitting any data yet. Once the PHP script is complete, this section of the app can be completed.\n\n");
    NSLog(@"Thanks - Daniel\n");
    NSLog(@"Bug Level: %@\n", bugLevel.text);
    NSLog(@"Bug description: %@\n\n", bugDesc.text);
}

#pragma mark - Other methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

// Create custom view for header.
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // Create custom header for section title.
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 30.0)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, sectionHeaderView.frame.size.width, 25.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft + 20;
    [headerLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:17.0]];
    headerLabel.textColor = [UIColor darkGrayColor];
    [sectionHeaderView addSubview:headerLabel];
    
    switch (section) {
            
        case 0: headerLabel.text = @"Bug Level"; break;
        case 1: headerLabel.text = @"Description"; break;
        default: break;
    }
    
    return sectionHeaderView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Cell identifier - as set in the prototype cell in interface builder.
    NSString *cellIdentifier = @"bugCell";
    
    // Create your default cell that will act as the cell you add elements to.
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Create variables to access the labels. Already specified their tags in storyboard.
    bugLevel = (UITextView *)[myCell.contentView viewWithTag:1];
    bugDesc = (UITextView *)[myCell.contentView viewWithTag:2];
    
    if (indexPath.section == 0) {
        bugLevel.text = @"Enter bug level...";
    }
    
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            bugDesc.text = [NSString stringWithFormat:@"Enter bug description..."];
        }
        
        else {
            [myCell setBackgroundColor:[UIColor clearColor]];
            
            UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake((myCell.bounds.size.width / 2), 0, 100.0, 50.0)];
            [submitButton setBackgroundImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
            [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
            [submitButton addTarget:self action:@selector(submitBugReport) forControlEvents:UIControlEventTouchUpInside];
            [myCell addSubview:submitButton];
            
            submitButton.clipsToBounds = YES;
        }
    }
    
    return myCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    else {
        return 2;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        NSObject *selectedObject = [bugItems objectAtIndex:indexPath.row];
        
        if ([selectedObject isEqual:@"Bug Level"]) {
            //[self performSegueWithIdentifier:@"bugLevelSegue" sender:self];
        }
        
        else if ([selectedObject isEqual:@"Description"]) {
            //[self performSegueWithIdentifier:@"descriptionSegue" sender:self];
        }
    }
}


@end
