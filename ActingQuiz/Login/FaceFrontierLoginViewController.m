//
//  FaceFrontierLoginViewController.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/11/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "FaceFrontierLoginViewController.h"
#import "FaceFrontierLoginSettings.h"

#import "AFNetworking.h"

@interface FaceFrontierLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *loginError;
@property (weak, nonatomic) IBOutlet UIButton *makeNewAccountButton;

@end

@implementation FaceFrontierLoginViewController

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
    

    
    self.username.delegate = self;
    self.password.delegate = self;
   }

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)loginPressed:(id)sender {
    
    self.loginError.text = @"login pressed";
    
    
    if([[self.username text] isEqualToString:@""] || [[self.password text] isEqualToString:@""] ) {
        
        [self alertStatus:@"Please enter Username and Password" :@"Sign in Failed!" :0];
        
    } else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"username": self.username.text, @"password": self.password.text};
        [manager POST:[NSString stringWithFormat:@"%@/iphone/login/", serverUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
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

- (IBAction)makeNewAccount:(id)sender {
    [self performSegueWithIdentifier:@"goto_tosc" sender:self];
}

@end