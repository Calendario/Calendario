//
//  WebpageView.h
//  Calendario
//
//  Created by Daniel Sadjadian on 11/06/2015.
//
//

#import <UIKit/UIKit.h>

@interface WebpageView : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webpage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *active;
@property (nonatomic, retain) NSString *pass_URL;
@property (weak, nonatomic) IBOutlet UIButton *openBrowserButton;

- (IBAction)done:(id)sender;
- (IBAction)openInBrowser:(id)sender;

@end
