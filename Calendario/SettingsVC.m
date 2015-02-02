//
//  SettingsVC.m
//  Calendario
//
//  Created by Larry B. King on 1/25/15.
//
//

#import "SettingsVC.h"

@interface SettingsVC ()
{
    NSArray *services;
}

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //declare tableview datasource and delegate
    self.settingsTableView.delegate = self;
    self.settingsTableView.dataSource = self;
    
    services = [[NSArray alloc] initWithObjects:@"Privacy Policy", @"Terms of Service", @"Report Bug", @"About This App", nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : Delegate and DataSource Methods for TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

//create custom view for header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //create custom header for section title
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 30.0)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(5, 5, sectionHeaderView.frame.size.width, 25.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft + 20;
    [headerLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:17.0]];
    headerLabel.textColor = [UIColor darkGrayColor];
    [sectionHeaderView addSubview:headerLabel];
    
    switch (section) {
        case 0:
            headerLabel.text = @"";
            return sectionHeaderView;
            break;
        case 1:
            headerLabel.text = @"SERVICES";
            return sectionHeaderView;
            break;
        case 2:
            headerLabel.text = @"";
            return sectionHeaderView;
            break;
               default:
            break;
    }
    
    return sectionHeaderView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create the cellidentifier.. drag "prototype cell" on tableview and name it as the cellIdentifier name
    NSString *cellIdentifier = @"settingsCell";
    
    //create your default cell that will act as the cell you add elements to
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //create variables to access the labels. Already specified their tags in storyboard
    UILabel *labelTitle = (UILabel*)[myCell.contentView viewWithTag:1];
    
    
    if (indexPath.section == 0)
    {
        labelTitle.text = @"Find Friends";
    }
    else if (indexPath.section == 1)
    {
        labelTitle.text = services[indexPath.row];
    }
    else
    {
     labelTitle.text = @"Enable Private Post";
    }
    
    return myCell;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 4;
        
    }
    else
    {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSObject *selectedObject = [services objectAtIndex:indexPath.row];
        if ([selectedObject isEqual:@"Privacy Policy"])
        {
            [self performSegueWithIdentifier:@"privacyPolicySegue" sender:self];
        }
        else if ([selectedObject isEqual:@"Terms of Service"])
        {
            [self performSegueWithIdentifier:@"termsOfServiceSegue" sender:self]; 
        }
    }
    
}

@end
