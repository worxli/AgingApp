//
//  FaceFrontierHomeViewController.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/15/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "FaceFrontierHomeViewController.h"
#import "FaceFrontierGalleryViewController.h"
#import "FaceFrontierLoginSettings.h"

@interface FaceFrontierHomeViewController ()

@end

@implementation FaceFrontierHomeViewController

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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int user_id = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"logged_in_user_id"];
    if (user_id == 0){
        user_id = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"user_id"];
    }
   
    
    if ([[segue identifier] isEqualToString:@"show_news"])
    {
        // Get reference to the destination view controller
        FaceFrontierGalleryViewController *vc = (FaceFrontierGalleryViewController*)(segue.destinationViewController);
        
        vc.url = [NSString stringWithFormat:@"%@/iphone/acting_news_feed/%d", serverUrl, user_id ];
        vc.navbarTitle.title = @"News Feed";
    }
    else if ([[segue identifier] isEqualToString:@"show_stats"])
    {
        FaceFrontierGalleryViewController *vc = (FaceFrontierGalleryViewController*)(segue.destinationViewController);
        
        vc.url = [NSString stringWithFormat:@"%@/iphone/acting_stats/%d", serverUrl, user_id ];
        vc.navbarTitle.title = @"Stats";
    }

}



- (IBAction)logOut:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
    [self performSegueWithIdentifier:@"exit_to_login_screen" sender:self];
}


@end
