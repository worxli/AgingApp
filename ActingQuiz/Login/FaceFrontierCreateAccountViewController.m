//
//  FaceFrontierCreateAccountViewController.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "FaceFrontierCreateAccountViewController.h"
#import "FaceFrontierLoginSettings.h"

#import "AFNetworking.h"

@interface FaceFrontierCreateAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation FaceFrontierCreateAccountViewController

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


- (IBAction)createAccount:(id)sender {
        
    if([[self.username text] isEqualToString:@""] || [[self.password text] isEqualToString:@""] || [[self.password2 text] isEqualToString:@""] ) {
        
        [self alertStatus:@"Please enter Username and Password" :@"Account Creation Failed!" :0];
        
    }
    else if (![[self.password text] isEqualToString:[self.password2 text]] ){
        
        [self alertStatus:@"Passwords must match" :@"Account Creation Failed!" :0];
    }
    else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"username": self.username.text, @"password": self.password.text, @"email": self.email.text};
        [manager POST:[NSString stringWithFormat:@"%@/iphone/make_account/", serverUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            int user_id = [responseObject[@"user_id"] intValue];
            
            if (user_id != 0){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"user_id"];
                [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"logged_in_user_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"defaults value for key %@",[defaults valueForKey:@"user_id"]);
                
                [self performSegueWithIdentifier:@"extra_info" sender:self];
            }
            else {
                NSLog(@"login failed");
                [self alertStatus:@"Username already exists" :@"Account Creation Failed!" :0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self alertStatus:@"Couldn't reach login server" :@"Account Creation Failed!" :0];
        }];
        
        
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.password2 resignFirstResponder];
    [self.email resignFirstResponder];
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
