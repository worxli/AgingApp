//
//  AGERegisterController.h
//  Aging
//
//  Created by Lukas Bischofberger on 7/7/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGESettings.h"

@interface AGERegisterController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

//tosc view
- (IBAction)toscAction:(id)sender;

//create account view
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)nextRegisterAction:(id)sender;

//optional information view
@property (weak, nonatomic) IBOutlet UIPickerView *agePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;

@property (strong, nonatomic) NSArray *ageArray;
@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) NSArray *countryArray;

@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *gender;

- (IBAction)registerAction:(id)sender;

@end
