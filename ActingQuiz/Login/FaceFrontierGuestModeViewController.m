//
//  FaceFrontierGuestModeViewController.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 5/21/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "AFNetworking.h"
#import "FaceFrontierGuestModeViewController.h"
#import "FaceFrontierLoginSettings.h"

@interface FaceFrontierGuestModeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *agePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker;

@property (strong, nonatomic) NSArray *ageArray;
@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) NSArray *countryArray;

@property (weak, nonatomic) IBOutlet UIButton *continueAsGuestButton;
@property (weak, nonatomic) IBOutlet UIButton *continueAsMeButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation FaceFrontierGuestModeViewController

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
    
    [self setupDropdownPickers];
}

- (void)setupDropdownPickers
{
    
    //self.ageArray  = [[NSArray alloc] initWithObjects:@"13-15", @"16-19", @"20-29", @"30-39", @"40-49", @"50-59", @"60-69", @"70-79", @"80-89", @"90-99", @"100-110", @"over 110", nil];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 100; i++) {
        [array addObject: [NSString stringWithFormat:@"%ld",(long)i]];
    }
    
    self.ageArray = [[NSArray alloc] initWithArray:array];
    
    self.genderArray  = [[NSArray alloc] initWithObjects: @"female", @"male", nil];
    
    self.countryArray = [[NSArray alloc] initWithObjects:
                         @"United States of America",
                         @"Afghanistan",
                         @"Albania",
                         @"Algeria",
                         @"American Samoa",
                         @"Andorra",
                         @"Angola",
                         @"Anguilla",
                         @"Antarctica",
                         @"Antigua & Barbuda",
                         @"Argentina",
                         @"Armenia",
                         @"Aruba",
                         @"Australia",
                         @"Austria",
                         @"Azerbaijan",
                         @"Bahama",
                         @"Bahrain",
                         @"Bangladesh",
                         @"Barbados",
                         @"Belarus",
                         @"Belgium",
                         @"Belize",
                         @"Benin",
                         @"Bermuda",
                         @"Bhutan",
                         @"Bolivia",
                         @"Bosnia and Herzegovina",
                         @"Botswana",
                         @"Bouvet Island",
                         @"Brazil",
                         @"British Indian Ocean Territory",
                         @"British Virgin Islands",
                         @"Brunei Darussalam",
                         @"Bulgaria",
                         @"Burkina Faso",
                         @"Burundi",
                         @"Cambodia",
                         @"Cameroon",
                         @"Canada",
                         @"Cape Verde",
                         @"Cayman Islands",
                         @"Central African Republic",
                         @"Chad",
                         @"Chile",
                         @"China",
                         @"Christmas Island",
                         @"Cocos (Keeling) Islands",
                         @"Colombia",
                         @"Comoros",
                         @"Congo",
                         @"Cook Iislands",
                         @"Costa Rica",
                         @"Croatia",
                         @"Cuba",
                         @"Cyprus",
                         @"Czech Republic",
                         @"Denmark",
                         @"Djibouti",
                         @"Dominica",
                         @"Dominican Republic",
                         @"East Timor",
                         @"Ecuador",
                         @"Egypt",
                         @"El Salvador",
                         @"Equatorial Guinea",
                         @"Eritrea",
                         @"Estonia",
                         @"Ethiopia",
                         @"Falkland Islands (Malvinas)",
                         @"Faroe Islands",
                         @"Fiji",
                         @"Finland",
                         @"France",
                         @"France, Metropolitan",
                         @"French Guiana",
                         @"French Polynesia",
                         @"French Southern Territories",
                         @"Gabon",
                         @"Gambia",
                         @"Georgia",
                         @"Germany",
                         @"Ghana",
                         @"Gibraltar",
                         @"Greece",
                         @"Greenland",
                         @"Grenada",
                         @"Guadeloupe",
                         @"Guam",
                         @"Guatemala",
                         @"Guinea",
                         @"Guinea-Bissau",
                         @"Guyana",
                         @"Haiti",
                         @"Heard & McDonald Islands",
                         @"Honduras",
                         @"Hong Kong",
                         @"Hungary",
                         @"Iceland",
                         @"India",
                         @"Indonesia",
                         @"Iraq",
                         @"Ireland",
                         @"Islamic Republic of Iran",
                         @"Israel",
                         @"Italy",
                         @"Ivory Coast",
                         @"Jamaica",
                         @"Japan",
                         @"Jordan",
                         @"Kazakhstan",
                         @"Kenya",
                         @"Kiribati",
                         @"Korea, Democratic People's Republic of",
                         @"Korea, Republic of",
                         @"Kuwait",
                         @"Kyrgyzstan",
                         @"Lao People's Democratic Republic",
                         @"Latvia",
                         @"Lebanon",
                         @"Lesotho",
                         @"Liberia",
                         @"Libyan Arab Jamahiriya",
                         @"Liechtenstein",
                         @"Lithuania",
                         @"Luxembourg",
                         @"Macau",
                         @"Madagascar",
                         @"Malawi",
                         @"Malaysia",
                         @"Maldives",
                         @"Mali",
                         @"Malta",
                         @"Marshall Islands",
                         @"Martinique",
                         @"Mauritania",
                         @"Mauritius",
                         @"Mayotte",
                         @"Mexico",
                         @"Micronesia",
                         @"Moldova, Republic of",
                         @"Monaco",
                         @"Mongolia",
                         @"Monserrat",
                         @"Morocco",
                         @"Mozambique",
                         @"Myanmar",
                         @"Namibia",
                         @"Nauru",
                         @"Nepal",
                         @"Netherlands",
                         @"Netherlands Antilles",
                         @"New Caledonia",
                         @"New Zealand",
                         @"Nicaragua",
                         @"Niger",
                         @"Nigeria",
                         @"Niue",
                         @"Norfolk Island",
                         @"Northern Mariana Islands",
                         @"Norway",
                         @"Oman",
                         @"Pakistan",
                         @"Palau",
                         @"Panama",
                         @"Papua New Guinea",
                         @"Paraguay",
                         @"Peru",
                         @"Philippines",
                         @"Pitcairn",
                         @"Poland",
                         @"Portugal",
                         @"Puerto Rico",
                         @"Qatar",
                         @"Reunion",
                         @"Romania",
                         @"Russian Federation",
                         @"Rwanda",
                         @"Saint Lucia",
                         @"Samoa",
                         @"San Marino",
                         @"Sao Tome & Principe",
                         @"Saudi Arabia",
                         @"Senegal",
                         @"Seychelles",
                         @"Sierra Leone",
                         @"Singapore",
                         @"Slovakia",
                         @"Slovenia",
                         @"Solomon Islands",
                         @"Somalia",
                         @"South Africa",
                         @"South Georgia and the South Sandwich Islands",
                         @"Spain",
                         @"Sri Lanka",
                         @"St. Helena",
                         @"St. Kitts and Nevis",
                         @"St. Pierre & Miquelon",
                         @"St. Vincent & the Grenadines",
                         @"Sudan",
                         @"Suriname",
                         @"Svalbard & Jan Mayen Islands",
                         @"Swaziland",
                         @"Sweden",
                         @"Switzerland",
                         @"Syrian Arab Republic",
                         @"Taiwan",
                         @"Tajikistan",
                         @"Tanzania, United Republic of",
                         @"Thailand",
                         @"Togo",
                         @"Tokelau",
                         @"Tonga",
                         @"Trinidad & Tobago",
                         @"Tunisia",
                         @"Turkey",
                         @"Turkmenistan",
                         @"Turks & Caicos Islands",
                         @"Tuvalu",
                         @"Uganda",
                         @"Ukraine",
                         @"United Arab Emirates",
                         @"United Kingdom (Great Britain)",
                         @"United States Minor Outlying Islands",
                         @"United States Virgin Islands",
                         @"Uruguay",
                         @"Uzbekistan",
                         @"Vanuatu",
                         @"Vatican City State (Holy See)",
                         @"Venezuela",
                         @"Viet Nam",
                         @"Wallis & Futuna Islands",
                         @"Western Sahara",
                         @"Yemen",
                         @"Yugoslavia",
                         @"Zaire",
                         @"Zambia",
                         @"Zimbabwe", nil];
    
    self.agePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.genderPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.countryPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    [self attachPickerToTextField:self.ageTextField :self.agePicker];
    [self attachPickerToTextField:self.genderTextField :self.genderPicker];
    [self attachPickerToTextField:self.countryTextField :self.countryPicker];
    
}

- (void)attachPickerToTextField: (UITextField*) textField :(UIPickerView*) picker{
    picker.delegate = self;
    picker.dataSource = self;
    textField.delegate = self;
    textField.inputView = picker;
    
}

#pragma mark - Keyboard delegate stuff

// let tapping on the background (off the input field) close the thing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.ageTextField resignFirstResponder];
    [self.genderTextField resignFirstResponder];
    [self.countryTextField resignFirstResponder];
}

#pragma mark - Picker delegate stuff

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        return self.ageArray.count;
    }
    else if (pickerView == self.genderPicker){
        return self.genderArray.count;
    }
    else if (pickerView == self.countryPicker){
        return self.countryArray.count;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        return [self.ageArray objectAtIndex:row];
    }
    else if (pickerView == self.genderPicker){
        return [self.genderArray objectAtIndex:row];
    }
    else if (pickerView == self.countryPicker){
        return [self.countryArray objectAtIndex:row];
    }
    
    return @"???";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        self.ageTextField.text = [self.ageArray objectAtIndex:row];
    }
    else if (pickerView == self.genderPicker){
        self.genderTextField.text = [self.genderArray objectAtIndex:row];
    }
    else if (pickerView == self.countryPicker){
        self.countryTextField.text = [self.countryArray objectAtIndex:row];
    }
}

#pragma mark - App and server user logic


- (IBAction)continueAsMe:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int logged_in_user_id = (int)[defaults integerForKey:@"logged_in_user_id"];
    if (logged_in_user_id == 0){
        logged_in_user_id = (int)[defaults integerForKey:@"user_id"];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:logged_in_user_id forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    [self performSegueWithIdentifier:@"show_camera" sender:self];
}



- (IBAction)continueAsGuest:(id)sender {
    
    if ([self.ageTextField.text length] == 0 || [self.genderTextField.text length] == 0 || [self.countryTextField.text length] == 0) {
        [self alertStatus:@"Please provide us some information about you!" :@"Fields not set" :0];
        return;
    }
    
    [self agreeAlert:@"By pressing agree, you agree to our terms and to have your face become part of an extremely useful public reserach database of facial expressions." :@"Terms of Service" :10];
    
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

- (void) agreeAlert:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Agree", nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 10) {    // it's the Error alert
        if (buttonIndex == 1) {     // and they clicked OK.
            NSLog(@"they clicked agree");
            [self makeGuestAccount];
            
        }
    }
}

-(void)makeGuestAccount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int host_user_id = (int)[defaults integerForKey:@"logged_in_user_id"];
    if (host_user_id == 0){
        // somehow this isn't set, maybe because it wasn't set in an old version of the app
        host_user_id = (int)[defaults integerForKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] setInteger:host_user_id forKey:@"logged_in_user_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[self spinner] startAnimating];
    [[self continueAsGuestButton] setEnabled:NO];
    [[self continueAsMeButton] setEnabled:NO];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"age": self.ageTextField.text, @"gender": self.genderTextField.text, @"country": self.countryTextField.text, @"host_user_id": [NSNumber numberWithInt:host_user_id]};
    [manager POST:[NSString stringWithFormat:@"%@/iphone/make_guest_account/", serverUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        int user_id = [responseObject[@"user_id"] intValue];
        
        if (user_id != 0){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"defaults value for key %@",[defaults valueForKey:@"user_id"]);
            
            [self performSegueWithIdentifier:@"show_camera" sender:self];
        }
        else {
            NSLog(@"login failed");
            [self alertStatus:@"Problem making guest account" :@"Account Creation Failed!" :0];
        }
        
        [[self spinner] stopAnimating];
        [[self continueAsGuestButton] setEnabled:YES];
        [[self continueAsMeButton] setEnabled:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self alertStatus:@"Couldn't reach login server" :@"Account Creation Failed!" :0];
        
        [[self spinner] stopAnimating];
        [[self continueAsGuestButton] setEnabled:YES];
        [[self continueAsMeButton] setEnabled:YES];
    }];

}

@end
