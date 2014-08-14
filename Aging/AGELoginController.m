//
//  AGELoginController.m
//  Aging
//
//  Created by Lukas Bischofberger on 7/7/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import "AGELoginController.h"

@implementation AGELoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.passwordField.secureTextEntry = YES;
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"login page view did load... user id: %@",[defaults valueForKey:@"user_id"]);
    if([defaults integerForKey:@"user_id"]){
        NSLog(@"knows my user");
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }
     
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    
    
    if([[self.usernameField text] isEqualToString:@""] || [[self.passwordField text] isEqualToString:@""] ) {
        
        [self alertStatus:@"Please enter Username and Password" :@"Sign in Failed!" :0];
        
    } else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"username": self.usernameField.text, @"password": self.passwordField.text};
        [manager POST:[NSString stringWithFormat:@"%@/iphone/login/", loginUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            int user_id = [responseObject[@"user_id"] intValue];
            
            if (user_id != 0){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"user_id"];
                [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"logged_in_user_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"defaults value for key %@",[defaults valueForKey:@"user_id"]);
                NSLog(@"defaults saved");
                
                [self performSegueWithIdentifier:@"login_success" sender:self];
            }
            else {
                NSLog(@"login failed");
                [self alertStatus:@"Couldn't find username/password" :@"Sign in Failed!" :0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self alertStatus:@"Couldn't reach login server" :@"Sign in Failed!" :0];
        }];
        
    }
    
}



- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

@end
