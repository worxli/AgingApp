//
//  FaceFrontierToscViewController.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "FaceFrontierToscViewController.h"

@interface FaceFrontierToscViewController ()
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@end

@implementation FaceFrontierToscViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)launchToscBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facefrontier.com/privacy/"]];

}

- (IBAction)agreeToTerms:(id)sender {
    [self performSegueWithIdentifier:@"new_account" sender:self];
}

@end
