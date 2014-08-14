//
//  AGELoginController.h
//  Aging
//
//  Created by Lukas Bischofberger on 7/7/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGESettings.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"

@interface AGELoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)loginAction:(id)sender;

@end
