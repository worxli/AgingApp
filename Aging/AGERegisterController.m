//
//  AGERegisterController.m
//  Aging
//
//  Created by Lukas Bischofberger on 7/7/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import "AGERegisterController.h"
#import "AFNetworking/AFNetworking.h"

@implementation AGERegisterController

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
    
    self.passwordField.secureTextEntry = YES;
    self.confirmField.secureTextEntry = YES;
    
    self.age = @"";
    self.gender = @"";
    self.country = @"";
    
    self.ageArray  = [[NSArray alloc] initWithObjects:@"Age?", @"13-15", @"16-19", @"20-29", @"30-39", @"40-49", @"50-59", @"60-69", @"70-79", @"80-89", @"90-99", @"100-110", @"over 110", nil];
    
    self.genderArray  = [[NSArray alloc] initWithObjects:@"Gender?", @"female", @"male", @"it's complicated", nil];
    
    self.countryArray = [[NSArray alloc] initWithObjects:@"Country?",
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

- (IBAction)nextRegisterAction:(id)sender {
    
    if([[self.usernameField text] isEqualToString:@""] || [[self.passwordField text] isEqualToString:@""] || [[self.confirmField text] isEqualToString:@""] ) {
        
        [self alertStatus:@"Please enter Username and Password" :@"Account Creation Failed!" :0];
        
    }
    else if (![[self.passwordField text] isEqualToString:[self.confirmField text]] ){
        
        [self alertStatus:@"Passwords must match" :@"Account Creation Failed!" :0];
    }
    else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"username": self.usernameField.text, @"password": self.passwordField.text, @"email": self.emailField.text};
        [manager POST:[NSString stringWithFormat:@"%@/iphone/make_account/", loginUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            int user_id = [responseObject[@"user_id"] intValue];
            int age = [responseObject[@"age"] intValue];
            NSString *gender = responseObject[@"age"];
            
            if (user_id != 0){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"user_id"];
                //[[NSUserDefaults standardUserDefaults] setInteger:age forKey:@"age"];
               // [[NSUserDefaults standardUserDefaults] setValue:gender forKey:@"gender"];
                [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"logged_in_user_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"defaults value for key %@",[defaults valueForKey:@"user_id"]);
                
                [self performSegueWithIdentifier:@"next_register" sender:self];
            }
            else {
                NSLog(@"login failed");
                [self alertStatus:@"Username already exists" :@"Account Creation Failed!" :0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self alertStatus:@"Couldn't reach login server" :@"Account Creation Failed!" :0];
        }];
        
        //[self performSegueWithIdentifier:@"next_register" sender:self];
        
    }
    
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
        self.age = [self.ageArray objectAtIndex:row];
    }
    else if (pickerView == self.genderPicker){
        self.gender = [self.genderArray objectAtIndex:row];
    }
    else if (pickerView == self.countryPicker){
        self.country = [self.countryArray objectAtIndex:row];
    }
}


- (IBAction)registerAction:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"defaults value for key %@",[defaults valueForKey:@"user_id"]);NSLog(@"%@, %@, %@", self.age, self.gender, self.country);
    
    int user_id = (int)[defaults integerForKey:@"user_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"user_id": [NSNumber numberWithInt:user_id], @"age": self.age, @"gender": self.gender, @"country": self.country};
    [manager POST:[NSString stringWithFormat:@"%@/iphone/amend_account/", loginUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [self performSegueWithIdentifier:@"register" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self alertStatus:@"Couldn't reach login server" :@"Account Creation Failed!" :0];
    }];
    
}

- (IBAction)toscAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facefrontier.com/privacy/"]];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

@end
