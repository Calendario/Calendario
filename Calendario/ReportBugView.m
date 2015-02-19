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
}

@end

@implementation ReportBugView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the tableview delegate and source.
    self.reportBugTableView.delegate = self;
    self.reportBugTableView.dataSource = self;
    
    bugItems = [[NSArray alloc] initWithObjects:@"Bug Level", @"Description", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

// Create custom view for header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create custom header for section title
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 30.0)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, sectionHeaderView.frame.size.width, 25.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft + 20;
    [headerLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:17.0]];
    headerLabel.textColor = [UIColor darkGrayColor];
    [sectionHeaderView addSubview:headerLabel];
    
    switch (section) {
        case 0:
            headerLabel.text = @"Bug Level";
            return sectionHeaderView;
            break;
        case 1:
            headerLabel.text = @"Description";
            return sectionHeaderView;
            break;
        default:
            break;
    }
    
    return sectionHeaderView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell identifier - as set in the prototype cell in interface builder.
    NSString *cellIdentifier = @"bugCell";
    
    // Create your default cell that will act as the cell you add elements to
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Create variables to access the labels. Already specified their tags in storyboard
    UITextView *bugLevel = (UITextView *)[myCell.contentView viewWithTag:1];
    UITextView *bugDesc = (UITextView *)[myCell.contentView viewWithTag:2];
    
    if (indexPath.section == 0) {
        bugLevel.text = @"Enter bug level...";
    }
    
    else if (indexPath.section == 1) {
        bugDesc.text = [NSString stringWithFormat:@"Enter bug description..."];
    }
    
    return myCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    else if (section == 1) {
        return 1;
    }
    
    else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
