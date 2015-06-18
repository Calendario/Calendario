//
//  customTabBarViewController.m
//  Calendario
//
//  Created by Larry B. King on 6/18/15.
//
//

#import "customTabBarViewController.h"

@interface customTabBarViewController ()

@end

@implementation customTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //center Tab button properties
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"tabBarCenterImage"];
    button.frame = CGRectMake(0, 0, buttonImage.size.width*2, buttonImage.size.height*2);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    //[button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height + 31;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];


    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setTranslucent:NO];
    [self.tabBar setOpaque:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
